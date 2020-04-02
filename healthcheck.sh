#!/bin/bash

boot_completed=`adb shell getprop sys.boot_completed`
if [ "x${boot_completed}" != "x1" ]; then
    exit 1
fi

bootcomplete=`adb shell getprop dev.bootcomplete`
if [ "x${bootcomplete}" != "x1" ]; then
    exit 1
fi

bootanim=`adb shell getprop init.svc.bootanim`
if [ "x${bootanim}" == "x1" ]; then
    exit 1
fi

exit 0