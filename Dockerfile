FROM ubuntu

RUN apt-get update && apt-get install -y \
  rsync \
  wget \
  qemu-user-static \
  qemu-utils \
  parted \
  curl

ENV WORKSPACE /workspace

ENTRYPOINT ["/workspace/scripts/build.sh"]
