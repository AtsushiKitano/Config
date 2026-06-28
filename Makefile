REPO_DIR := $(shell pwd)

# Homebrew prefix を Apple Silicon / Intel 両対応にする。
# `brew --prefix` が動く場合はそれを採用、なければ AS 既定の /opt/homebrew にフォールバック。
HOMEBREW_PREFIX := $(shell brew --prefix 2>/dev/null || echo /opt/homebrew)

# Make は /bin/sh で各レシピを実行するため、.zshenv 等を読まない。
# Homebrew (emacs / mise / brew 等) のパスを通しておく。
export PATH := $(HOMEBREW_PREFIX)/bin:/usr/local/bin:$(PATH)

.PHONY: all setup bootstrap sync link link-pre link-dotfiles link-emacs link-yabai \
        link-karabiner link-kitty link-mise link-aquaskk link-claude \
        link-launchd link-hammerspoon macos-defaults install homebrew services setup-slack org-sync-setup \
        emacs-install emacs-daemon-setup doctor

# --------------------------------------------------------------------------
# Top-level targets
# --------------------------------------------------------------------------

# 新規 Mac: Homebrew インストールからサービス起動まで一括セットアップ。
# `install` で emacs / mise を入れる前に link-pre で .Brewfile と mise 設定を
# symlink しておく必要がある。emacs インストール後に link で残りを張り、
# emacs-install で leaf 管理パッケージを batch で事前ダウンロードする。
bootstrap: homebrew link-pre install link emacs-install emacs-daemon-setup macos-defaults services

# 既存 Mac: 設定・パッケージ・サービスを最新状態に同期
sync: link install emacs-install emacs-daemon-setup macos-defaults services

# Symlinks only (safe to re-run any time)
setup: link

# Full setup for a freshly-cloned machine (legacy)
all: bootstrap

# --------------------------------------------------------------------------
# Symlink targets
# --------------------------------------------------------------------------

link: link-dotfiles link-emacs link-yabai \
      link-karabiner link-kitty link-mise link-aquaskk link-claude \
      link-launchd link-hammerspoon

# install 前に必要な最小限のリンク (Brewfile と mise 設定)
link-pre: link-dotfiles link-mise

# dotfiles/.??* → $HOME  (skip directories, .Brewfile is Mac-only)
link-dotfiles:
	@echo "[dotfiles] Linking to $$HOME"
	@for f in $(REPO_DIR)/dotfiles/.??*; do \
		[ -d "$$f" ] && continue; \
		[ "$$(basename $$f)" = ".Brewfile" ] && [ "$$(uname)" != "Darwin" ] && continue; \
		ln -fnsv "$$f" "$$HOME/"; \
	done

# Emacs: init.org をタングルして ~/.emacs.d/ に配置（テンポラリディレクトリ経由）
link-emacs:
	@echo "[emacs] Tangling init.org → $$HOME/.emacs.d"
	@mkdir -p "$$HOME/.emacs.d"
	@tmpdir=$$(mktemp -d) && \
		cp "$(REPO_DIR)/Emacs/init.org" "$$tmpdir/" && \
		emacs --batch -l org \
			--eval "(org-babel-tangle-file \"$$tmpdir/init.org\")" 2>&1 | grep -v "^$$" && \
		rm -f "$$HOME/.emacs.d/init.el" "$$HOME/.emacs.d/early-init.el" && \
		cp "$$tmpdir/init.el"       "$$HOME/.emacs.d/init.el" && \
		cp "$$tmpdir/early-init.el" "$$HOME/.emacs.d/early-init.el" && \
		rm -rf "$$tmpdir"
	@echo "[emacs] Done"

# Emacs: leaf 管理パッケージを batch で事前インストール + init.el を native-compile。
# `link-emacs` で init.el を配置済みである必要がある。
# init.org の早期 (early-init.el) で `debug-on-error t` が立っているため、
# -Q で起動し early-init を手動 load → debug を切ってから init.el を load する。
# 初回は MELPA から数十 MB をダウンロードするため数分かかる。
# 最後に init.el / early-init.el を native-compile して GUI 起動の初回ラグを抑える。
emacs-install: link-emacs
	@echo "[emacs] Pre-installing leaf-managed packages + native-compiling init (this can take several minutes)..."
	@emacs --batch -Q \
		--eval "(load \"$$HOME/.emacs.d/early-init.el\" nil t)" \
		--eval '(setq debug-on-error nil)' \
		--eval "(load \"$$HOME/.emacs.d/init.el\" nil t)" \
		--eval "(progn (require 'comp) (native-compile \"$$HOME/.emacs.d/init.el\") (native-compile \"$$HOME/.emacs.d/early-init.el\"))" \
		--eval '(message "[emacs] Package install + native-compile complete")' 2>&1 | tail -5
	@echo "[emacs] Pre-install done"

# yabai / skhd: dotfiles/.yabairc → ~/.yabairc, dotfiles/.skhdrc → ~/.skhdrc
link-yabai:
	@echo "[yabai/skhd] Linking dotfiles to $$HOME"
	@ln -fnsv "$(REPO_DIR)/dotfiles/.yabairc" "$$HOME/.yabairc"
	@ln -fnsv "$(REPO_DIR)/dotfiles/.skhdrc"  "$$HOME/.skhdrc"

# Karabiner: karabiner.json → ~/.config/karabiner/
link-karabiner:
	@echo "[karabiner] Linking to $$HOME/.config/karabiner"
	@mkdir -p "$$HOME/.config/karabiner"
	@ln -fnsv "$(REPO_DIR)/macos/Karabiner/karabiner.json"  "$$HOME/.config/karabiner/karabiner.json"

# kitty: kitty.conf → ~/.config/kitty/
link-kitty:
	@echo "[kitty] Linking to $$HOME/.config/kitty"
	@mkdir -p "$$HOME/.config/kitty"
	@ln -fnsv "$(REPO_DIR)/macos/kitty.conf"  "$$HOME/.config/kitty/kitty.conf"

# mise: config.toml → ~/.config/mise/
link-mise:
	@echo "[mise] Linking to $$HOME/.config/mise"
	@mkdir -p "$$HOME/.config/mise"
	@ln -fnsv "$(REPO_DIR)/dotfiles/mise/config.toml"  "$$HOME/.config/mise/config.toml"

# Claude Code: settings.json → ~/.claude/
link-claude:
	@echo "[claude] Linking to $$HOME/.claude"
	@mkdir -p "$$HOME/.claude"
	@ln -fnsv "$(REPO_DIR)/.claude/settings.json"  "$$HOME/.claude/settings.json"

# LaunchAgents: launchd/*.plist のテンプレートを @HOME@ / @HOMEBREW_PREFIX@ で
# 置換して ~/Library/LaunchAgents/ に書き出す (端末ごとの絶対パス差異を吸収)。
link-launchd:
	@echo "[launchd] Installing plists to $$HOME/Library/LaunchAgents"
	@mkdir -p "$$HOME/Library/LaunchAgents"
	@for f in $(REPO_DIR)/launchd/*.plist; do \
		name="$$(basename $$f)"; \
		out="$$HOME/Library/LaunchAgents/$$name"; \
		[ -L "$$out" ] && rm -f "$$out"; \
		sed -e "s|@HOME@|$$HOME|g" \
		    -e "s|@HOMEBREW_PREFIX@|$(HOMEBREW_PREFIX)|g" "$$f" > "$$out"; \
		echo "  installed $$out"; \
	done

# Emacs daemon: launchd エージェントを登録して即時起動。
# 既に daemon が動いていれば bootout 後に再起動する (新しい init.el を反映するため)。
emacs-daemon-setup: link-launchd
	@mkdir -p "$$HOME/.local/log"
	@launchctl bootout "gui/$$(id -u)/com.user.emacs-daemon" 2>/dev/null || true
	@launchctl bootstrap "gui/$$(id -u)" \
		"$$HOME/Library/LaunchAgents/com.user.emacs-daemon.plist"
	@echo "[emacs-daemon] Registered and started. Use 'emacsclient -nc' to open a frame."

# org-sync: launchd エージェントを登録して即時起動
org-sync-setup:
	@chmod +x "$(REPO_DIR)/scripts/org-sync.sh"
	@mkdir -p "$$HOME/.local/log"
	@ln -fnsv "$(REPO_DIR)/launchd/com.user.org-sync.plist" \
		"$$HOME/Library/LaunchAgents/com.user.org-sync.plist"
	@launchctl bootout "gui/$$(id -u)/com.user.org-sync" 2>/dev/null || true
	@launchctl bootstrap "gui/$$(id -u)" \
		"$$HOME/Library/LaunchAgents/com.user.org-sync.plist"
	@echo "[org-sync] Registered and started"

# AquaSKK: sub-rule.desc / arrow.rule → ~/Library/Application Support/AquaSKK/
link-aquaskk:
	@echo "[aquaskk] Linking to ~/Library/Application Support/AquaSKK"
	@mkdir -p "$$HOME/Library/Application Support/AquaSKK"
	@ln -fnsv "$(REPO_DIR)/macos/AquaSKK/sub-rule.desc"  "$$HOME/Library/Application Support/AquaSKK/sub-rule.desc"
	@ln -fnsv "$(REPO_DIR)/macos/AquaSKK/arrow.rule"     "$$HOME/Library/Application Support/AquaSKK/arrow.rule"

# Hammerspoon: Hammerspoon/ → ~/.hammerspoon
link-hammerspoon:
	@echo "[hammerspoon] Linking to $$HOME/.hammerspoon"
	@ln -fnsv "$(REPO_DIR)/Hammerspoon" "$$HOME/.hammerspoon"

# --------------------------------------------------------------------------
# macOS system defaults
# --------------------------------------------------------------------------

macos-defaults:
	@echo "[macos] Applying system defaults"
	@bash "$(REPO_DIR)/macos/init.sh"

# --------------------------------------------------------------------------
# Package installation
# --------------------------------------------------------------------------

install:
	@echo "[install] Homebrew packages"
	@bash "$(REPO_DIR)/scripts/brew.sh"
	@echo "[install] mise runtimes"
	@bash "$(REPO_DIR)/scripts/mise.sh"

# --------------------------------------------------------------------------
# Bootstrap helpers
# --------------------------------------------------------------------------

# Homebrew 未インストール時のみインストール
homebrew:
	@which brew >/dev/null 2>&1 && echo "[homebrew] Already installed" || \
		(echo "[homebrew] Installing Homebrew..." && \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

# Slack: ~/.authinfo に認証情報を書き込む
setup-slack:
	@bash "$(REPO_DIR)/scripts/setup-slack.sh"

# 環境ヘルスチェック: dotfiles ドリフト、Brewfile 同期状態、launchd 状態、
# init.org / init.el の鮮度を一覧表示する。終了コードは常に 0 (情報出力)。
doctor:
	@echo "==> Broken symlinks under \$$HOME"
	@find "$$HOME" -maxdepth 3 -type l 2>/dev/null | \
		while read -r l; do [ ! -e "$$l" ] && echo "  BROKEN: $$l"; done; \
		echo "  (none if no output above)"
	@echo
	@echo "==> Brewfile drift (vs $(REPO_DIR)/dotfiles/.Brewfile)"
	@brew bundle check --file="$(REPO_DIR)/dotfiles/.Brewfile" --verbose 2>&1 | \
		grep -E "(needs to|Warning|complete)" || echo "  in sync"
	@echo
	@echo "==> launchd agents (com.user.*)"
	@launchctl list 2>/dev/null | awk 'NR==1 || /com\.user\./'
	@echo
	@echo "==> Emacs init freshness"
	@if [ -f "$$HOME/.emacs.d/init.el" ] && [ "$(REPO_DIR)/Emacs/init.org" -nt "$$HOME/.emacs.d/init.el" ]; then \
		echo "  STALE: init.org is newer than ~/.emacs.d/init.el → run 'make link-emacs'"; \
	else \
		echo "  init.el is up-to-date with init.org"; \
	fi
	@echo
	@echo "==> Homebrew prefix detected: $(HOMEBREW_PREFIX)"

# yabai / skhd サービスを起動（既に起動中なら再起動）
services:
	@echo "[services] Starting yabai and skhd"
	@yabai --restart-service
	@skhd --restart-service
