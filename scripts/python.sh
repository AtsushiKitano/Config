#!/bin/bash

VERSION=$(asdf latest python)

asdf install python $VERSION
asdf global python $VERSION

bash scripts/pip.sh
