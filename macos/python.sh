#!/bin/bash


curl https://bootstrap.pypa.io/get-pip.py | python -

pip install certifi \
	charset-normalizer \
	idna \
	mysql-connector-python \
	numpy \
	pandas \
	pip \
	python-dateutil \
	pytz \
	requests \
	setuptools \
	six \
	tzdata \
	urllib3 \
	wheel
