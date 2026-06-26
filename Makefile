REPO_DIR := $(shell pwd)

# Make は /bin/sh で各レシピを実行するため、.zshenv 等を読まない。
# Homebrew (emacs / mise / brew 等) のパスを通しておく。
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)

.PHONY: all setup bootstrap sync link link-pre link-dotfiles link-emacs link-yabai \
        link-karabiner link-kitty link-wezterm link-mise link-aquaskk link-claude \
        link-launchd link-hammerspoon macos-defaults install homebrew services setup-slack org-sync-setup \
        emacs-install

# --------------------------------------------------------------------------
# Top-level targets
# --------------------------------------------------------------------------

# 新規 Mac: Homebrew インストールからサービス起動まで一括セットアップ。
# `install` で emacs / mise を入れる前に link-pre で .Brewfile と mise 設定を
# symlink しておく必要がある。emacs インストール後に link で残りを張り、
# emacs-install で leaf 管理パッケージを batch で事前ダウンロードする。
bootstrap: homebrew link-pre install link emacs-install macos-defaults services

# 既存 Mac: 設定・パッケージ・サービスを最新状態に同期
sync: link install emacs-install macos-defaults services

# Symlinks only (safe to re-run any time)
setup: link

# Full setup for a freshly-cloned machine (legacy)
all: bootstrap

# --------------------------------------------------------------------------
# Symlink targets
# --------------------------------------------------------------------------

link: link-dotfiles link-emacs link-yabai \
      link-karabiner link-kitty link-wezterm link-mise link-aquaskk link-claude \
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

# Emacs: leaf 管理パッケージを batch で事前インストールする。
# `link-emacs` で init.el を配置済みである必要がある。
# init.org の早期 (early-init.el) で `debug-on-error t` が立っているため、
# -Q で起動し early-init を手動 load → debug を切ってから init.el を load する。
# 初回は MELPA から数十 MB をダウンロードするため数分かかる。
emacs-install: link-emacs
	@echo "[emacs] Pre-installing leaf-managed packages (this can take several minutes)..."
	@emacs --batch -Q \
		--eval "(load \"$$HOME/.emacs.d/early-init.el\" nil t)" \
		--eval '(setq debug-on-error nil)' \
		--eval "(load \"$$HOME/.emacs.d/init.el\" nil t)" \
		--eval '(message "[emacs] Package install complete")' 2>&1 | tail -5
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

# WezTerm: wezterm.lua + keybinds → ~/.config/wezterm/
link-wezterm:
	@echo "[wezterm] Linking to $$HOME/.config/wezterm"
	@mkdir -p "$$HOME/.config/wezterm"
	@ln -fnsv "$(REPO_DIR)/dotfiles/wezterm.lua"           "$$HOME/.config/wezterm/wezterm.lua"
	@ln -fnsv "$(REPO_DIR)/dotfiles/wezterm_keybinds.lua"  "$$HOME/.config/wezterm/wezterm_keybinds.lua"

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

# LaunchAgents: launchd/*.plist → ~/Library/LaunchAgents/
link-launchd:
	@echo "[launchd] Linking to $$HOME/Library/LaunchAgents"
	@mkdir -p "$$HOME/Library/LaunchAgents"
	@for f in $(REPO_DIR)/launchd/*.plist; do \
		ln -fnsv "$$f" "$$HOME/Library/LaunchAgents/"; \
	done

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

# yabai / skhd サービスを起動（既に起動中なら再起動）
services:
	@echo "[services] Starting yabai and skhd"
	@brew services restart yabai
	@brew services restart skhd
