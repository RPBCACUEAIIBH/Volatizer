Usage: volatizer-repair

This will attempt to repair Volatizer in case initramfs got updated and the
modification lost. (It may or may not work, depending on whether or not the
initramfs devs made changes affecting it's compatibility.)

This is a tool for admins, not for users...

Call this script if you get no prompt at boot, and it doesn't even try to boot
into volatile mode, and you get no Volatizer errors after a system update.
