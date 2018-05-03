#!/bin/bash

set -e

DIR=$(dirname $0)

source $DIR/utils.sh

if [[ ! -f "$DIR/../images/kernel-qemu" || ! -f "$DIR/../images/versatile-pb.dtb" ]]; then
  source $DIR/build_kernel.sh
fi

if [[ ! -f "$DIR/../images/retropie-4.1-rpi2_rpi3.img" ]]; then
  source $DIR/create_image.sh
fi
