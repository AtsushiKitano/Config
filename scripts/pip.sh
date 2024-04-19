#/bin/bash

if !(type pip > /dev/null 2>&1); then
	curl https://bootstrap.pypa.io/get-pip.py -o $HOME/tmp/get-pip.py
	python $HOME/tmp/get-pip.py
	rm -rf $HOME/tmp/get-pip.py
fi

pip install numpy \
	pandas \
	pip \
	python-dateutil \
	pytz \
	six \
	tzdata \
