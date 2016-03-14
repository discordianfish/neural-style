FROM ubuntu
ENV BUILD_DEPS libprotobuf-dev protobuf-compiler git \
    software-properties-common libssl-dev

RUN apt-get -qy update && apt-get -qy install $BUILD_DEPS ca-certificates wget \
    && curl -s https://raw.githubusercontent.com/torch/distro/master/install-deps | bash \
    && git clone https://github.com/torch/distro.git /usr/src/torch --recursive \
    && /usr/src/torch && ./install.sh \
    && mv /usr/src/torch/install /opt/torch \
    && /opt/torch/bin/luarocks install loadcaffe \
    && apt-get purge $BUILD_DEPS && apt-get autoremove && apt-get clean \
    && rm -rf /usr/src/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /neural-style
WORKDIR /neural-style
RUN sh models/download_models.sh
