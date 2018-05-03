#!/bin/bash -ex

DIR=`dirname $0`
source $DIR/utils.sh

# Generate a macaddr
log "Generating a new macaddress"

log "Starting qemu"
# # Emulate raspberry pi
$QEMU \
  -kernel $RPI_KERNEL \
  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
  -cpu arm1176 -m 256 \
  -M versatilepb -dtb $DIR/../images/versatile-pb.dtb \
  -no-reboot \
  -drive "file=$IMG,index=0,media=disk,format=raw" \
  -serial stdio \
  -net nic,macaddr="$MACADDR",netdev=mynet0 \
  -netdev user,id=mynet0,hostfwd=tcp::5022-:22

echo <<-EOS
Login to the pi:

ssh -p 5022 pi@localhost

EOS
