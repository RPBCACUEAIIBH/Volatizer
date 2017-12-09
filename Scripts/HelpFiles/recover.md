Usage: sudo volatizer-recover [backup_file]
   or: sudo volatizer-recover [option] [backup_file]

It will recover user data from a Backup.tar.gz file.
This is a tool for admins, not for users... User breaks it, admins fix it...

      --help                  display this help file and exit
  -t                          temporary recovery, will not overwrite user data
                              on hard drive

Example: sudo volatizer-recover /media/backup/userBackup.tar.gz

  - In case of moving or restoring your user space, or if you lost your data
for whatever reason run this script.
  - In case of power failure, or overclock instability issues it can happen
that save-changes.sh can not finish, your data is gone and/or you can not log
in to the GUI. Press Crtl+Alt+F1, log in, then run this script to recover your
backup, then Crtl+Alt+F7 or Crtl+Alt+F8 will take you back to the login
screen, where you can log in. No reboot required.
