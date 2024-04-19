init:
	bash scripts/init.sh
	bash scripts/dotfile_links.sh
	bash scripts/brew.sh

dotfile:
	bash scripts/dotfile_links.sh

install:
	bash scripts/brew.sh
	bash scripts/asdf.sh
