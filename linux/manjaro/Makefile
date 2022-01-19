install:
	sudo pacman -S \
	cryptsetup \
	docker \
	docker-compose \
	dmenu \
	emacs \
	i3 \
	powerline-fonts \
	iptables \
	tmux \
	uim \
	virtualbox \
	vagrant \
	compton \
	lxappearance \
	wget \
	xorg-xev \
	zsh \
	zsh-completions \
	sysstat \
	typescript \
	npm \
	zathura-pdf-poppler \
	awesome-terminal-fonts \
	ttf-font-awesome \

yay-install: #yay install
	cd $HOME/src/github.com
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

install-yay:
	yay -S \
	packer \
	slack-desktop \
	tfenv \
	fast \
	jq \
	pyenv \
	lm-sensors \

tmux: #configurate tmux

urxvt:
	sudo pacman -S rxvt-unicode urxvt-perls

uninstall:
	sudo pacman -S j

kubectl:
	cd $HOME/src/github.com
	git clone https://arc.archlinux.org/kubernetes.git
	cd kubernetes
	makepkg -si

npm-install:
	sudo npm install -g \
		yarn \
		@marp-team/marp-cli

yarn-install:
	yarn global add \
	create-react-app \
	parcel-bundler \
	react \
	react-dom \

pip-install:
	sudo pip3 install \
	speedtest-cli \
	ansible

oh-my-zsh:
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
