REPO_DIR := $(shell pwd)

.PHONY: all setup bootstrap sync link link-dotfiles link-emacs link-yabai \
        link-karabiner link-kitty link-wezterm link-mise link-aquaskk link-claude \
        macos-defaults install homebrew services setup-slack

# --------------------------------------------------------------------------
# Top-level targets
# --------------------------------------------------------------------------

# 新規 Mac: Homebrew インストールからサービス起動まで一括セットアップ
bootstrap: homebrew link macos-defaults install services

# 既存 Mac: 設定・パッケージ・サービスを最新状態に同期
sync: link macos-defaults install services

# Symlinks only (safe to re-run any time)
setup: link

# Full setup for a freshly-cloned machine (legacy)
all: link macos-defaults install

# --------------------------------------------------------------------------
# Symlink targets
# --------------------------------------------------------------------------

link: link-dotfiles link-emacs link-yabai \
      link-karabiner link-kitty link-wezterm link-mise link-aquaskk link-claude

# dotfiles/.??* → $HOME  (skip directories, .Brewfile is Mac-only)
link-dotfiles:
	@echo "[dotfiles] Linking to $$HOME"
	@for f in $(REPO_DIR)/dotfiles/.??*; do \
		[ -d "$$f" ] && continue; \
		[ "$$(basename $$f)" = ".Brewfile" ] && [ "$$(uname)" != "Darwin" ] && continue; \
		ln -fnsv "$$f" "$$HOME/"; \
	done

# Emacs: init.el + early-init.el → ~/.emacs.d/
link-emacs:
	@echo "[emacs] Linking to $$HOME/.emacs.d"
	@mkdir -p "$$HOME/.emacs.d"
	@ln -fnsv "$(REPO_DIR)/Emacs/init.el"        "$$HOME/.emacs.d/init.el"
	@ln -fnsv "$(REPO_DIR)/Emacs/early-init.el"  "$$HOME/.emacs.d/early-init.el"

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

# AquaSKK: sub-rule.desc / arrow.rule → ~/Library/Application Support/AquaSKK/
link-aquaskk:
	@echo "[aquaskk] Linking to ~/Library/Application Support/AquaSKK"
	@mkdir -p "$$HOME/Library/Application Support/AquaSKK"
	@ln -fnsv "$(REPO_DIR)/macos/AquaSKK/sub-rule.desc"  "$$HOME/Library/Application Support/AquaSKK/sub-rule.desc"
	@ln -fnsv "$(REPO_DIR)/macos/AquaSKK/arrow.rule"     "$$HOME/Library/Application Support/AquaSKK/arrow.rule"

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
