Usage: volatizer
   or: volatizer command 
   or: volatizer command [option]

Volatizer is a collection of modules, multitude of scipts that have been added
over long development and testing. This script fuses them together.
A single command: "volatizer"! This is all a user has to remember to use them!

commands:
  autosave - backup (if enabled) and save user home folder periodically
  backup - backup user home folder from hard drive to backup location
  cleanup - clean after updates, old linux images, tmp files, unused packages
  mode - returns current mode (Normal/Volatile)
  reboot - make backup (if enabled), save user home folder and reboot
  recover - recover backup (Admin only)
  reswap - clear swap after programs are closed or coming back from sleep
  save - make backup (if enabled) and save user home folder
  shutdown - make backup (if enabled), save user home folder and shutdown
  sleep - make backup (if enabled), save user home folder and suspend
  nboot - forces Normal mode. (Normal boot via SSH) (Persistent)
  vboot - sets boot mode to volatile mode. (Volatile boot via SSH) (Persistent)
  bootmode - returns boot mode settings. (Normal/Volatile)
  sudoers - make script(s) run as root without password by user (Admin only)

options:
      --help                  display this help file and exit
      --version               display version and license and exit

You can also call help for each commad like this: volatizer save --help

Don't bother updating/installing/removing programs in Volatile mode unless
you're experimenting... Changes done to the system partition outside user home
folder will only persist until reboot/shutdown! This allows users to experiment
and learn by making mistakes and go back in time to a working system by simply
rebooting.
