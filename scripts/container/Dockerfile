FROM ubuntu

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y \
  cmake \
  gcc-arm-none-eabi \
  gdb-arm-none-eabi \
  libnewlib-arm-none-eabi \
  ninja-build \
  qemu-system-arm \
  gosu \
  sudo \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]