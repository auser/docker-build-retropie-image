#!/bin/bash

DIR=`dirname $0`

export QEMU=$(which qemu-system-arm)
export RPI_KERNEL=$DIR/../images/kernel-qemu
export IMG=$DIR/../images/retropie-4.4-rpi2_rpi3.img

# colours
GREENB="\033[1;32m"
RESET="\033[0m"

log() { echo -e "${GREENB}LOG:${RESET} $1"; }
