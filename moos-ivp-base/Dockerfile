FROM ubuntu:22.04

RUN apt update \
    && apt install -y git nano python3 python3-setuptools python3-dev cmake xterm subversion libfltk1.3-dev libtiff5-dev  \
    && mkdir git \
    && cd git \
    && git clone https://github.com/moos-ivp/moos-ivp.git \
    && cd /git/moos-ivp \
    && ./build.sh \
    && cd /git \
    && git clone https://github.com/mit2680/moos-ivp-2680.git \
    && cd /git/moos-ivp-2680 \
    && ./build.sh \
    && cd ../.. \
    && mkdir missions

ENV PATH="$PATH:/git/moos-ivp/bin:/git/moos-ivp/scripts:/git/moos-ivp-2680/bin"

RUN cd git \
    && git clone https://github.com/msis/python-moos \
    && cd python-moos \
    && mkdir build \
    && cd build \
    && cmake .. -DPYBIND11_PYTHON_VERSION=3 \
    && cmake --build . --parallel 2 \
    && cmake --install .
