install:
	sudo pacman -S \
	emacs \
	docker \
	cryptsetup \
	dmenu \
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

yay-install: #yay install
	cd $HOME/src/github.com
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

install-yay:
	yay -S \
	packer \
	slack-desktop \
	zoom

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
	sudo npm install -g yarn

yarn-install:
	yarn global add \
	create-react-app \
	parcel-bundler \
	react \
	react-dom
