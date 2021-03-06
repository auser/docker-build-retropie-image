#!/bin/bash

DIR=`dirname $0`
source $DIR/utils.sh

# # Generate a macaddr
log "Generating a new macaddress"
# # Generate a macaddr
printf -v macaddr "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))

# if [[ ! -z $(qemu-system-arm -machine help | grep raspi2) ]]; then
  # log "Booting!"
  # qemu-system-arm -kernel ./qemu-rpi-kernel/kernel-qemu-4.4.34-jessie -cpu arm1176 -m 256 -M raspi2 -serial stdio -append "fsck.repair=yes rootwait root=/dev/sda2 rootfstype=ext4 rw" -hda ./raspbian_latest.expanded.qcow2 -no-reboot

log "Starting qemu"
# # Emulate raspberry pi
# IMG=$DIR/../images/2018-04-18-raspbian-stretch.img
IMG=$DIR/../images/retropie-4.4-rpi2_rpi3.img

  # -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
$QEMU \
  -kernel $DIR/../images/raspbian-boot/kernel7.img \
  -M raspi2 \
  -m 1024 \
  -append "loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 panic=1 rootfstype=ext4 rw" \
  -dtb $DIR/../images/raspbian-boot/bcm2709-rpi-2-b.dtb \
  -drive "file=$IMG,index=0,media=disk,format=raw" \
  -net nic,macaddr="$macaddr",netdev=mynet0 \
  -netdev user,id=mynet0,hostfwd=tcp::5022-:22 \
  -serial stdio

echo <<EOS
Login to the pi:

ssh -p 5022 pi@localhost

EOS
