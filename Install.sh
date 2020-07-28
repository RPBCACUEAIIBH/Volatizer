#! /bin/bash

################################################################################
# Volatizer                                                                    #
################################################################################
#                                                                              #
# Version 1.2                                                                  #
# Written by: Tibor Áser Veres                                                 #
# Source: https://github.com/RPBCACUEAIIBH/Volatizer                           #
# License: BSD License 2.0 (see LICENSE.md file)                               #
#                                                                              #
################################################################################

# Constants
Command="/usr/local/bin"
Files="/usr/share/Volatizer"

# Finding roots
ScriptPath="$(cd "$(dirname "$0")"; pwd -P)"
cd $ScriptPath

if ! Scripts/check-compatibility.sh
then
  exit
fi

if ! Scripts/uninstall.sh # Check for previous installation, and uninstall, if found.
then
  exit
fi

if [[ -f ./LICENSE.md ]]
then
  echo "Please read the license, and the disclaimer:"
  echo ''
  cat ./LICENSE.md
  echo ''
  echo ''
  echo 'Disclaimer'
  echo "Volatizer is an unsafe software! It was not intended to be harmful, but it's not without risks as it modifies the way the operating system supposed to boot, and may cause data loss in case of power failure or even when you just press shut down/reboot forgetting to run the save command! It was intended for experimental purpose, although it's extreme responsiveness can be very addictive. :) It may also pose additional security risks due to the extra set of commands that can be executed as root witout password. Use it at your own risk!"
  echo ''
  echo ''
  read -p 'Do you agree to this license?(type "Yes" and press enter if so.): ' Yy
  echo ''
else
  echo 'Error: License agreement not found!'
  echo ''
  Yy="No"
fi

if [[ $Yy != "Yes" ]]
then
  echo 'Agreement >> Failed!'
  echo ''
  exit
else
  echo 'Agreement >> OK'
  echo ''
  echo 'All requirements are met!'
  echo ''
  echo ''
fi

echo ''
echo 'Transforming... Please wait!'
echo ''
echo "Forcing GRUB, and Volatizer prompt to appear"
cp /etc/default/grub /etc/default/grub.old
sed -i '/GRUB_HIDDEN_TIMEOUT=0/ c\#GRUB_HIDDEN_TIMEOUT=0' /etc/default/grub
sed -i '/GRUB_HIDDEN_TIMEOUT_QUIET=true/ c\#GRUB_HIDDEN_TIMEOUT_QUIET=true' /etc/default/grub
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/ c\GRUB_CMDLINE_LINUX_DEFAULT=""' /etc/default/grub
echo ''
echo ''
echo "Setting swappines to 0! Swapping would make volatizer nearly pointless..."
sysctl vm.swappiness=0
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Making changes to initramfs'
Scripts/modify-initramfs.sh

echo ''
echo 'Copying shared files' ################################################################# This is a danger zone #######################################################################
mkdir $Files
cp -R ./HelpFiles $Files
cp -R ./Scripts $Files
cp -R ./UserFiles $Files # templates that will be copied to each user, (Needs to be kept just in case any new users are created...)
cp ./LICENSE.md $Files
chown -R root:root $Files
chmod -R 755 $Files
cp ./Commands/* $Command
chown -R root:root $Command
chmod -R 755 $Command
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Creating /etc/sudoers.d/Volatizer-sudoers file'
touch /tmp/Volatizer-sudoers
echo "%sudo ALL = (ALL:ALL) PASSWD: $Command/volatizer-recover" | tee -a /tmp/Volatizer-sudoers
echo "%sudo ALL = (ALL:ALL) PASSWD: $Command/volatizer-sudoers" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-backup" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-cleanup" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-reswap" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-save" | tee -a /tmp/Volatizer-sudoers
echo "ALL ALL = (ALL) NOPASSWD: $Command/volatizer-bootmode" | tee -a /tmp/Volatizer-sudoers
cp /tmp/Volatizer-sudoers /etc/sudoers.d/Volatizer-sudoers
chown root:root /etc/sudoers.d/Volatizer-sudoers
chmod 0440 /etc/sudoers.d/Volatizer-sudoers
echo ''
echo 'Done!'
echo ''
echo 'For adding custom scripts easily to sudoers use the /usr/share/Volatizer/sudoscript-nopw.sh. for more information use "--help" option.'
echo 'If for some reason sudoers can not be parsed, and sudo command does not work, you can use "pkexec nano /etc/sudoers.d/volatizer-sudoers" command to correct it.'
echo ''

echo ''
echo 'Copying files for users'
echo ''
for i in $(ls /home)
do
  if [[ -f /home/$i/.bashrc ]] # For now this is how it identifies existing human users...
  then
    volatizer-newuser $i
  fi
done
echo ''
echo 'Done!'
echo ''

echo ''
echo 'Finalizing modification...'
update-grub
update-initramfs -u
echo ''
echo 'Done!'
echo ''

echo ''
echo '-> You will only be able to update your system, install and remove programs permanently when the system is running in normal mode! (You will be able to choose mode after the grub scren.)'
echo '-> Note that every user can individually edit their own config file at /home/$USER/.Volatizer/Config, so you may want to set it for them and make it owned by root and read only, to protect solid state drives from agressive write configs...'
echo '-> Use "--help" option with any of the volatizer commands for more.'
echo ''
echo 'You can add keyboard shortcuts for certain Volatizer features for better productivity...'
echo ''
