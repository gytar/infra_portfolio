#!/usr/bin/env bash

# create a VM from an iso file
sudo virt-install \
    --name rocky-linux \
    --os-variant rocky9.0 \
    --ram 2048 \
    --disk /kvm/disk/rocky-linux.img,device=disk,bus=virtio,size=10,format=qcow2 \
    --graphics vnc,listen=0.0.0.0 \
    --noautoconsole \
    --hvm \
    --cdrom /var/lib/libvirt/images/Rocky-9.3-x86_64-minimal.iso \
    --boot cdrom,hd

sudo virsh net-list --all # get a list of all running VM
sudo virsh start rocky-linux --console # start the VM and open it inside the console

: '
To get the console running inside debian based distibutions, edit the following vars to this in /etc/default/grub

    GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0"
    GRUB_TERMINAL="serial"
    GRUB_SERIAL_COMMAND="serial -unit=0 -unit=0 -speed=115200 -word=8 -parity=no -stop=1"


Then reboot grub 

    sudo update-grub
    reboot
'

# start serial-getty 
# source code of getty https://github.com/openembedded/openembedded-core/blob/master/meta/recipes-core/systemd/systemd-serialgetty/serial-getty%40.service
# some informations from arch wiki https://wiki.archlinux.org/title/Getty 
# infos on another website http://0pointer.de/blog/projects/serial-console.html 
sudo systemctl enable --now serial-getty@ttyS0.service
sudo systemctl start serial-getty@ttyS0.service

# useful command to know which port is being used in your server
sudo netstat -tnl # to get only active ethernet connections that are server