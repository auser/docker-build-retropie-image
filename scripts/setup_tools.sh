#!/bin/bash

set -e

# local directory
WORKSPACE=/workspace
IMAGES=$WORKSPACE/images
MOUNT_DIR=$WORKSPACE/mount
DIR=`dirname $0`

# source utils script
source $DIR/utils.sh

setup() {
  tee $MOUNT_DIR/boot/config.txt >/dev/null <<EOF
  gpu_mem=32
  hdmi_force_hotplug=1
  hdmi_drive=2
  hdmi_group=1
  config_hdmi_boost=4
  #set 720p with no overscan
  hdmi_mode=4
  disable_overscan=1
EOF

tee $MOUNT_DIR/etc/udev/rules.d/90-qemu.rules >/dev/null <<EOF
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n"
KERNEL=="sda2", SYMLINK+="root"
EOF

  tee $MOUNT_DIR/boot/cmdline.txt >/dev/null <<EOF
  dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet loglevel=3 consoleblank=0 plymouth.enable=0 quiet init=/usr/lib/raspi-config/init_resize.sh
EOF
tee $MOUNT_DIR/etc/ld.so.preload >/dev/null <<EOF
  #/usr/lib/arm-linux-gnueabihf/libarmmem.so
EOF

tee $MOUNT_DIR/etc/ld.so.preload.qemu >/dev/null <<EOF
  #/usr/lib/arm-linux-gnueabihf/libarmmem.so
EOF

tee $MOUNT_DIR/etc/ld.so.preload.card >/dev/null <<EOF
/usr/lib/arm-linux-gnueabihf/libarmmem.so
EOF

tee $MOUNT_DIR/etc/fstab.card >/dev/null <<EOF
proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults,noatime  0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
#/dev/sda2  /               ext4    defaults,noatime  0       1
EOF

tee $MOUNT_DIR/etc/fstab.qemu >/dev/null <<EOF
proc             /proc           proc    defaults          0       0
#/dev/mmcblk0p1  /boot           vfat    defaults,noatime  0       2
#/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
/dev/sda2  /               ext4    defaults,noatime  0       1
EOF

tee $MOUNT_DIR/etc/modules >/dev/null <<EOF
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
#snd-bcm2835
#uinput
EOF

tee $MOUNT_DIR/etc/asound.conf >/dev/null <<EOF
pcm.usb
{
    type hw
    card Device
}
pcm.internal
{
    type hw
    card ALSA
}
pcm.!default
{
    type asym
    playback.pcm
    {
        type plug
        slave.pcm "internal"
    }
    capture.pcm
    {
        type plug
        slave.pcm "usb"
    }
}
ctl.!default
{
    type asym
    playback.pcm
    {
        type plug
        slave.pcm "internal"
    }
    capture.pcm
    {
        type plug
        slave.pcm "usb"
    }
}
EOF

tee $MOUNT_DIR/etc/rc.local >/dev/null <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

service ssh start
exit 0
EOF

tee $MOUNT/etc/resolv.conf > /dev/null <<EOF
nameserver 10.0.2.3
nameserver 8.8.8.8
EOF

# tee $MOUNT_DIR/etc/fstab.card >/dev/null <<EOF
# proc            /proc           proc    defaults          0       0
# /dev/mmcblk0p1  /boot           vfat    defaults,noatime  0       2
# /dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
# tmpfs            /tmp           tmpfs   defaults,noatime,nosuid,size=64m    0 0
# tmpfs            /var/lib/dhcp  tmpfs   defaults,noatime,nosuid,size=64m    0 0
# tmpfs            /var/spool     tmpfs   defaults,noatime,nosuid,size=64m    0 0
# tmpfs            /var/lock      tmpfs   defaults,noatime,nosuid,size=64m    0 0
# #/dev/sda2  /               ext4    defaults,noatime  0       1
# EOF
}

main() {
  local CMD="$1"
  shift || true

  case "$CMD" in
    # Global Commands
    "setup")          setup "$@" ;;
    *)                 echo "Usage: setup" ;;
  esac
}

main "$@"
