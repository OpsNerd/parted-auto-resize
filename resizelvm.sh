#!/bin/bash
# resizelvm.sh | useful for resizing volumes to their maxium size
# when creating vms from templates with smaller disks
# usage | resizelvm.sh /dev/sda 1 /dev/mapper/vg0-root
set -e

if [[ $# -ne 3 ]] ; then
    echo 'to run this script, you must provide 3 parameters
    >a physical disk, a partion number
    > and a target volume group and logical volume.
    > exmaple, if you you have resized /dev/sda1 from 20GB
    > to 40GB and you want to add that 20GB of space to
    > your root partion at /dev/mapper/vg0-root
    > you would issue:
    > resizelvm.sh /dev/sda 1 /dev/mapper/vg0-root'
    exit 1
fi

DEVICE=$1
PARTNR=$2
VG=$3
fdisk -l $DEVICE$PARTNR >> /dev/null 2>&1 || (echo "could not find device $DEVICE$PARTNR - please check the name" && exit 1)

CURRENTSIZEB=`fdisk -l $DEVICE$PARTNR | grep "Disk $DEVICE$PARTNR" | cut -d' ' -f5`
CURRENTSIZE=`expr $CURRENTSIZEB / 1024 / 1024`
# So get the disk-informations of our device in question printf %s\\n 'unit MB print list' | parted | grep "Disk /dev/sda we use printf %s\\n 'unit MB print list' to ensure the units are displayed as MB, since otherwise it will vary by disk size ( MB, G, T ) and there is no better way to do this with parted 3 or 4 yet
# then use the 3rd column of the output (disk size) cut -d' ' -f3 (divided by space)
# and finally cut off the unit 'MB' with blanc using tr -d MB
MAXSIZEMB=`printf %s\\n 'unit MB print list' | parted | grep "Disk ${DEVICE}" | cut -d' ' -f3 | tr -d MB`
echo "[ok] applying partiton resize operation.."
parted ${DEVICE} resizepart ${PARTNR} ${MAXSIZEMB}
echo "[ok] resized $DEVICE/$PARTNR from ${CURRENTSIZE}MB to ${MAXSIZEMB}MB "
echo "[ok] now extending and resizing logical volume"
pvresize $1$2 && lvextend -r $3 -l +100%FREE
echo "[ok] resized $VG to from ${CURRENTSIZE}MB to ${MAXSIZEMB}MB "
echo "[done]"
