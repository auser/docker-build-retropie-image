#!/bin/bash -ex

if [[ ! -f "/workspace/images/kernel-qemu" ]]; then
  curl -o /workspace/images/kernel-qemu -OL https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.9.59-stretch
fi

if [[ ! -f "/workspace/images/versatile-pb.dtb" ]]; then
  echo "downlodading..."
  curl -o /workspace/images/versatile-pb.dtb -OL https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb.dtb
fi
