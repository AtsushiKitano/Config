#/bin/bash

if !(type pip > /dev/null 2>&1); then
	curl https://bootstrap.pypa.io/get-pip.py | python -
fi

pip install numpy \
	pandas \
	pip \
	python-dateutil \
	pytz \
	six \
	tzdata \
