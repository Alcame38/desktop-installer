#!bin/bash

echo "welcome on the arch installer" 
iwctl station wlan0 scan
iwctl station wlan0 get-networks
echo "which hotspot would you like to connect ?" && read hotspot
iwctl station wlan0 connect "$hotspot"
lsblk
echo "on which disk do you want to set your linux partition ? (please enter only the disk not the path)" && read disk
echo "please tell me how many partition already exist on your disk" && read partitionNumber
fdisk /dev/$disk
for i in {1. .$partitionNumber}
do
	d
	$i
done
n
1
1250000
n
1
1251328
echo
w
echo
mkfs.vfat -F32 /dev/$disk+="1"
mkfs.ext4 /dev/$disk+="2"
mkdir /mnt/home
mount /dev/$disk+="1" /boot && mount /dev/$disk+="2" /mnt
sudo pacstrap /mnt base base-devel linux linux-firmware dhcpcd
genfstab -L /mnt >> /mnt/etc/fstab && arch-chroot /mnt
locale-gen
echo "which language do you want your computer to be ? (write the initial of the language)" && read language
echo "LANG=$language_${language^^}.UTF-8" >> /etc/locale.conf
export LANG="$language"_${language^^}.UTF-8
echo "What's your name ?" && read userName
echo -e "127.0.0.1 localhost\n127.0.1.1 localhost.localdomain $userName" >> /etc/hostname
echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 localhost.localdomain $userName" >> /etc/hosts
echo "define your password for the root user:" && read userPassword
passwd
$userPassword
pacman -S os-prober ntfs-3g
pacman -S grub efibootmgr
grub-install /dev/$disk+="1"
grub-mkconfig -o /boot/grub/grub.cfg
echo "[Match] name=en* [Network] DHCP=yes" >> /etc/systemd/network/wlan0.network
systemctl restart systemd-networkd && systemctl enable systemd-networkd
echo "nameserver 8.8.8.8 nameserver 8.8.4.4" >> /etc/resolv.conf
pacman -S xorg xorg-server gnome gnome-extra networkmanager 
Systemctl start gdm.service && Systemctl enable gdm.service

