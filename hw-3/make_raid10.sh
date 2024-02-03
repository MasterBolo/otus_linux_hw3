#!/bin/bash
sudo mdadm --create --verbose /dev/md1 -l 10 -n 4 /dev/sd{b,c,d,e}
sudo mkdir /mdadm
sudo echo "DEVICE partitions" > /mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /mdadm/mdadm.conf
sudo parted -s /dev/md1 mklabel gpt
sudo parted /dev/md1 mkpart primary ext4 0% 20%
sudo parted /dev/md1 mkpart primary ext4 20% 40%
sudo parted /dev/md1 mkpart primary ext4 40% 60%
sudo parted /dev/md1 mkpart primary ext4 60% 80%
sudo parted /dev/md1 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md1p$i; done
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md1p$i /raid/part$i; done
