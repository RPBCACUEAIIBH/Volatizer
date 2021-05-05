#! /bin/bash

# This script is not meant to be ran as a stand alone script, it's called by the Install.sh and volatizer-repair. (not standalone)

### Execution ###
echo ""
echo "Disabling update-grub in volatile mode..."
# It causes some updates to fail, and apt stops working ater such error. Updating grub in volatile mode is pointless, as grub only runs at next boot, at which point the modification gets discarded.

# Postinst
if [[ -f "/etc/kernel/postinst.d/zz-update-grub" ]]
then
  if [[ -z $(grep "olatizer" "/etc/kernel/postinst.d/zz-update-grub") ]]
  then
    cp "/etc/kernel/postinst.d/zz-update-grub" "/etc/kernel/postinst.d/zz-update-grub.old"
    sed -i "/#\! \/bin\/sh/ c\#\! \/bin\/sh\nif [ \$(volatizer mode) = \"Normal\" ]\nthen\n" "/etc/kernel/postinst.d/zz-update-grub"
    echo "" >> "/etc/kernel/postinst.d/zz-update-grub"
    echo "else" >> "/etc/kernel/postinst.d/zz-update-grub"
    echo 'echo "Volatizer: update-grub is disabled in volatile mode!"' >> "/etc/kernel/postinst.d/zz-update-grub"
    echo "exit 0" >> "/etc/kernel/postinst.d/zz-update-grub"
    echo "fi" >> "/etc/kernel/postinst.d/zz-update-grub"
  fi
else
  echo "Warning: Can't find /etc/kernel/postinst.d/zz-update-grub. This will not prevent volatizer from working, but you may have issues installing/removing stuff with apt in volatile mode."
fi

# Postrm
if [[ -f "/etc/kernel/postrm.d/zz-update-grub" ]]
then
  if [[ -z $(grep "olatizer" "/etc/kernel/postrm.d/zz-update-grub") ]]
  then
    cp "/etc/kernel/postrm.d/zz-update-grub" "/etc/kernel/postrm.d/zz-update-grub.old"
    sed -i "/#\! \/bin\/sh/ c\#\! \/bin\/sh\nif [ \$(volatizer mode) = \"Normal\" ]\nthen\n" "/etc/kernel/postrm.d/zz-update-grub"
    echo "" >> "/etc/kernel/postrm.d/zz-update-grub"
    echo "else" >> "/etc/kernel/postrm.d/zz-update-grub"
    echo 'echo "Volatizer: update-grub is disabled in volatile mode!"' >> "/etc/kernel/postrm.d/zz-update-grub"
    echo "exit 0" >> "/etc/kernel/postrm.d/zz-update-grub"
    echo "fi" >> "/etc/kernel/postrm.d/zz-update-grub"
  fi
else
  echo "Warning: Can't find /etc/kernel/postrm.d/zz-update-grub. This will not prevent volatizer from working, but you may have issues installing/removing stuff with apt in volatile mode."
fi

echo ""
echo "Done!"
echo ""
