#/bin/bash

if [ $(uname) != "Darwin" ]; then
	echo "OS is not MacOS"
	exit 1
fi

# Macの起動音Off
sudo nvram StartupMute=%01

# キーリピート速度設定
defaults write -g KeyRepeat -float 1.8
defaults write -g InitialKeyRepeat -int 20

# キーを長押ししたときの動作
defaults write -g ApplePressAndHoldEnabled -bool false

# 最初の文字を大文字にしない
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# 軌跡速度変更
defaults write -g com.apple.mouse.scaling 2

# スクロール速度変更
defaults write -g com.apple.scrollwheel.scaling 4

# ナチュラルスクロールを無効
defaults write -g com.apple.swipescrolldirection -bool false

# ウィンドウのリサイズと移動を高速化
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# ネットワークドライブに .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# USBドライブに .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# スクリーンショットに影をつけない:
defaults write com.apple.screencapture disable-shadow -bool true

# スクリーンショット保存場所設定
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# ダークモード
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# 自動で隠す
defaults write com.apple.dock autohide -bool true

# 非表示/表示の速度を変更
defaults write com.apple.dock autohide-time-modifier -float 0.3

# アイコンのサイズを変更
defaults write com.apple.dock tilesize -int 48

# アプリケーションの起動中アニメーションを無効
defaults write com.apple.dock launchanim -bool false

# アプリケーション最小化アニメーションを設定
defaults write com.apple.dock mineffect -string "scale"

# 最近使用したスペースに基づく自動的なスペース切り替えを無効
defaults write com.apple.dock mru-spaces -bool "false"

# 最近起動したアプリを非表示
defaults write com.apple.dock show-recents -bool false

# ホットコーナー: 右下 → Quick Note
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# Finder: デフォルトビューをカラム表示に設定
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# org-mode LaTeX プレビュー用パッケージ (basictex インストール後に実行)
if [ -x /Library/TeX/texbin/tlmgr ]; then
	sudo /Library/TeX/texbin/tlmgr update --self
	sudo /Library/TeX/texbin/tlmgr install dvipng dvisvgm collection-fontsrecommended
fi

# Ctrl-Space の入力ソース切り替えショートカットを無効化 (Emacs の C-SPC Mark set を有効にするため)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# TouchID for sudo (Apple 推奨の sudo_local を使うと macOS update で消えない)
SUDO_LOCAL=/etc/pam.d/sudo_local
if [ ! -f "$SUDO_LOCAL" ] || ! grep -q "pam_tid.so" "$SUDO_LOCAL"; then
	echo "[macos] Enabling TouchID for sudo via $SUDO_LOCAL"
	sudo tee "$SUDO_LOCAL" >/dev/null <<'EOF'
# Managed by ~/.conf/macos/init.sh - TouchID for sudo
auth       sufficient     pam_tid.so
EOF
	sudo chmod 444 "$SUDO_LOCAL"
fi
