Readme for Volatizer

A breief story:
Long story short: My hard drive is old, slow, and it's dieing a slow death... I was looking for ways to minimize it's usage while also speeding up the system, and having no money to just buy an SSD...
So I've searched the internet to find out if I could load the system entirely into RAM, then spin down the old hard drive to preserve it as long as possible, and I found this article:
http://www.elettronicaopensource.com/index.php?f1=mostra_articolo.php&rw=1&art=32 but it was for debian, and I'm using ubuntu(which is debian based but a bit different), and I managed to do it in a few hours, then I wanted to be able to switch back and fort between normal and volatile mode, then to save user data, and I've done it, then after a bit I've lost the system partition agan... so I wanted backups, and so on... :D I figured that others may be interested for whatever reason, so I've cleaned up the code, wrote help files, and this is the result.

Feature decription:
- Loads a fully installed operating system into RAM not only Ubuntu 16.04, I've sucessfuly tested it on various flavors of Ubuntu and on Linux Mint as well as on Debian(v1.1+).
- You can choose mode after the grub screen, or by runing volatizer nmode/vmode commands(as of v1.2+) and use it in normal mode if you want...(which is faster to start when you'r in a hurry but less responsive)
- You can do updates, install, and remove programs, in normal mode, then restart to Volatile mode, with the changes you've made in normal mode.
- You can save user data there's even an autosave feature built in, you just have to launch it!
- You can make backup of user data either automatically or manually.
- It's easy to use: The only extra command you really have to remember is "volatizer" the rest is pretty much self explanatory, assuming you have a minimal experience in shell.
- You can use it for learning, and experimenting with dangerous settings in volatile mode, since restroing a broken system is as easy as pressing reset and waiting for it to reboot.
- Works via SSH(v1.2+)

Advantages:
- RAM is the fastest type of memory, it's faster then a RAID0 array of high speed SSDs! This makes the system extremely responsive.(It won't make your processor work faster, even though you may experince some boost in performance it's only due to the CPU not having to wait for data as much not not because it runs faster... Try overclocking for improving CPU performance specifically...)
- It makes the system more forgiving to inexperienced users with admin rights ;)
- It's easy to use since it's built for everyday use.

Disadvantages:
- You need at least 8GB of RAM, 16GB or more is highly recommended!
- Slow boot... it can take up to 10-15 minutes to load 4-6GB to memory from a slow mechanical hard drive, it should take about 2-3 minutes from SSD... It worth waiting if you don't often turn it off, but put it to sleep. Use the reswap function to restore speed if you see swapping...
- RAM is called volatile memory for good reason! In volatile mode: 1. If the power goes out, and you have no UPS or the battery dies you loose data instantly! 2. If you forget to save it before shutdown or reboot your data is gone for good! (That's where the save, autosave and backup functions come in handy... use them carefully!)

Known issues and workarounds:
- When creating new human user, you also have to create a .Volatizer folder in his/her home folder, place a copy of the volatizer config file within it, configure it, and optionally make it owned by him/her... This will be made easy in version 1.1, but until then make sure all human users have been created before installing volatizer. The installer will do this for you automatically for all existing users...
- You will get all sorts of erros and warnings if trying to update install things in volatile mode, telling you to prepare for apocalipse... Don't panic! Ubuntu wansn't exactly designed to run in tmpfs without protest... ;) You'll be just fine as the data on system partition will be discarded upon shutdown/reboot. Even if you run the save script, only your home folder will be saved(with everything within it), nothing else from the system partition... So just ignore those warnings and errors...
- If your PC fails to boot into volatile mode, try normal mode... If it runs out of ram it won't boot, since the swap is mounted after the root partition, which means that even if you're able to overfill it during normal use, it can't use swap at boot! Solution: move over your data to another partition in normal mode, then try again! (Be aware that other users can also fill up the system partition quickly causing it to not boot into volatile mode!)

Supported distros(Volatizer for these are all tested and working):
- Ubuntu 20.04 (Fixed in V1.1. The initramfs was modified so it wasn't compatible... Now it is!)
- Debian 10 Buster (As of V1.1)
- Ubuntu 18.04
- Ubuntu 16.04 and 17.04 (both Desktop and Server)
- Ubuntu MATE 16.04 and 17.04
- Ubuntu Gnome 16.04 and 17.04
- Ubuntu Budgie 17.04
- Kubuntu 16.04 and 17.04
- Lubuntu 16.04 and 17.04
- Linux Mint 18.2 (Cinemon, Mate, KDE)
(Please note that I've tested it a few months earlyer, on all these distros, when I initially wanted to release, before cleaning up the code and fixing some issues... I can not guarantee that it still works on all of these... Currently I'm using it on Ubuntu Gnome 17.04 with latest updates applied!)

Known NOT supported distros(Tested but not compatible with the current version of Volatizer):
- Fedora
- Slackware

System requirements:
- 8GB(or more) RAM (the faster in MHz the better...)
- A clean installation of any supported distro on a somewhat larger partition then the available RAM (If your distro is not listed the volatizer installer will check it for compatibility to some degree, so just try it...) Don't risk it on your main system unless you've saved all data... The modification may be risky...
- 1-2 GB swap partition (if you only have 8-16 GB of ram it's a must, especially if you also use integrated graphics(which also uses the RAM). Otherwise it's optional, but if you run out of RAM, your system may freeze, and you may loose data...)
- Do yourself a favor and use SSD for system partition if you can(for faster boot time), but preferably mechanical hard drive for swap(as swap gets written often...)! This combination will give you less then 10 minute boot time(not kidding it may take much monger), while not risking excessive write on SSD...
- Another large partition for large and rarely used files that does not need to be loaded to memory...

Installation:
- Make sure that all human users are created. New users don't have control over volatizer unless you copy the files manually.
- Download and unpack Volatizer, or clone it, whichever you prefer.
- Open terminal, and run the Install.sh with sudo in front
- Follow the instructions.
- Edit the configuration file at /home/user/.Volatizer/Config (it's in a a hidden directory in your home folder...)
- Reboot into Volatile mode.
- Open terminal, and run the command "volatizer". The rest should be easy...

Good to know:
- On Debian you can't see what you're typing at the prompt, but it works, it's just annoying.
- On Ubuntu 20.04 I added an extra 5 second delay before the prompt, otherwise it's easy to miss it among tons of messages...

Recommendations:
- Try it for learning, experimenting and entertainment! Having a fast reacting system can be very addictive(from my experience):P ...and you don't nesesarily need top specs, mine is a quad core AMD from 2011 with only integrated graphics, and an even older mechanical drive, but it lauches any program in vilatile mode in like 3-4s at most due to the nearly 15GB/s read/write speed of the RAM.(your mileage may vary depending on ram and processor speed and core cout)
- Don't use it in volatile mode for important work, without backup and autosave!
- Enable backups, and use the volatizer command for autosaving/rebooting/suspending/shutting down your pc instead of the usual buttons...
- Updating installing or removing programs in Volatile mode are temporary changes... Changes done to the system partition outside the user home folder can not be saved easily, and will only persist until shutdown/reboot!

Update plans:
- Automatic background operation of Autosave, and maybe cleanup (v2.0 << Save and backup scripts ware designed to be called by users, not by systemd when no users are logged in yet. Other then that it may not be good idea to automate save and backup, as that may save things the user may not wanna save. For now it's gonna be manual, and will think about it and maybe rewrite thigs for v2.0.)
- Clean up the code keep it basic but powerful, with some optional features. (v2.0)
- Initial step by step setup. (v2.0)
- Logging - Curently none of volatizer files are logging anything... (v2.0)

Version 1.3:
- Added snapcleaner script, which is automatically called by cleanup if snapd is detected, and can get rid of snap cache, and old snap versions, 2 of which is kept by default.
- Added journal vacuuming to cleanup script.
- Silenced some errors caused by not calling df as root when checking mode.

Version 1.2:
- Added bootmode settings which can be used via SSH, thus makes it possible to reboot into another mode remotely.
- Fixed the cleanup script, and made it even better.
- Fixed some bug(s).
- Added repair script which can restore volatizer in case initramfs gets updated, and the modified file overwritten thus the modification lost.
- Devided the Install.sh script for readability, and reusability reasons.
- Made adding new user easy with another new script.
- Re-organized the files...
- Added a disclaimer.

Version 1.1
- Added Debian compatibility.(requested by: pe3no)
- Fixed support for new Ubuntu/Mint versions. (Ubuntu 18.04 was last I used, I recently tried it with Ubuntu 20.04 and didn't work so I fixed it.)
