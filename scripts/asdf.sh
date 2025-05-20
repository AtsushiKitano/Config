#!/bin/bash

APPS=( \
	python \
	terraform \
	yarn \
	nodejs \
	java
)

declare -A PLUGINS=(
	["python"]="https://github.com/danhper/asdf-python.git"
	["yarn"]="https://github.com/twuni/asdf-yarn.git"
	["terraform"]="https://github.com/asdf-community/asdf-hashicorp.git"
	["nodejs"]="https://github.com/asdf-vm/asdf-nodejs.git"
	["java"]="https://github.com/halcyon/asdf-java.git"
)

if !(type asdf > /dev/null 2>&1); then
	echo "Asdf is not installed"
	exit 1
fi

for APP in ${APPS[@]}; do
	asdf plugin add $APP ${PLUGINS[$APP]}

	if [ $APP == "java" ]; then
		break
	fi

	VERSION=$(asdf latest $APP)

	asdf install $APP $VERSION
	asdf global $APP $VERSION
	
	if [ $APP = "python" ];then
		bash scripts/pip.sh
	fi
done
