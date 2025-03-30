FROM ubuntu:22.04

RUN apt update \
    && apt install -y git nano python3 python3-setuptools python3-dev cmake xterm subversion libfltk1.3-dev libtiff5-dev  \
    && mkdir git \
    && cd git \
    && git clone https://github.com/mit2680/moos-ivp-2680.git \
    && git clone https://github.com/moos-ivp/moos-ivp.git \
    && cd moos-ivp \
    && ./build.sh

ENV PATH="$PATH:/git/moos-ivp/bin:/git/moos-ivp/scripts"

RUN cd git \
    && git clone https://github.com/msis/python-moos \
    && cd python-moos \
    && python3 setup.py build \
    && python3 setup.py install