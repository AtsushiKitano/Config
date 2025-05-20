#/bin/bash

PACKAGES=(
	numpy \
	pandas \
	pip \
	python-dateutil \
	pytz \
	six \
	tzdata \
	powerline-status \
	setuptools \
	powerline-shell \
	fastapi \
	uvicorn[standard] \
	flask
)

if !(type pip > /dev/null 2>&1); then
	curl https://bootstrap.pypa.io/get-pip.py -o $HOME/tmp/get-pip.py
	python $HOME/tmp/get-pip.py
	rm -rf $HOME/tmp/get-pip.py
fi

for PACKAGE in ${PACKAGES[@]} ; do
	pip install -U $PACKAGE
done
