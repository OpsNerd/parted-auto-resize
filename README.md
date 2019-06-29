# resizelvm.sh
**This script is pretty specific to my internal vm setup, however it can be easily modified to fit your own setup.**


**Crafted from an original script by EugenMayer [https://github.com/EugenMayer/parted-auto-resize](https://github.com/EugenMayer/parted-auto-resize)**

## currently tested using proxmox 5.2 as a VM host & ubuntu 18.04/centos 7 as guests


resizelvm.sh takes 3 parameters, a physical disk, a partition number and a volume group/logical volume  
If you have resized /dev/sda1 from 20GB to 40GB   
and you want to make that new space available on your root partition (located at ' /dev/vg0/root ' )   
you'd issue :


` resizelvm /dev/sda 1 /dev/mapper/vg0-root `


I adapted the original script to help in automating VM deploys in my home lab
so that I could use a template VM with a tiny disk attached to it
and automatically resize that volume after spinning up a new VM
