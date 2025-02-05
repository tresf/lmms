#!/usr/bin/env bash

# Workaround crash in VirtualBox when hardware rendering is enabled
if lsmod |grep vboxguest > /dev/null 2>&1; then
   echo "VirtualBox detected.  Forcing libgl software rendering." >&2
   export LIBGL_ALWAYS_SOFTWARE=1;
fi