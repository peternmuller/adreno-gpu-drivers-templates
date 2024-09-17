#
# Copyright (C) 2024 Peter Noël Muller
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Info
soc=$(getprop ro.soc.model)
modver=$(grep_prop version "$MODPATH/module.prop")
moddesc=$(grep_prop description "$MODPATH/module.prop")
ui_print "- Version: $modver"
ui_print "- $moddesc"
ui_print ""


# Determine which version information to display
if [ "$KSU" == true ]; then
  ui_print "- KSUVersion=$KSU_VER"
  ui_print "- KSUVersionCode=$KSU_VER_CODE"
  ui_print "- KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
else
  ui_print "- MagiskVersion=$MAGISK_VER"
  ui_print "- MagiskVersionCode=$MAGISK_VER_CODE"
fi

ui_print ""
ui_print "- Installing drivers for $soc..."


# Handle firmware file and set permissions based on SoC
if [[ "$soc" == "SM8250" || "$soc" == "SM8250-AB" || "$soc" == "SM8250-AC" ]]; then
  set_perm "$MODPATH/system/vendor/firmware/a650_sqe.fw" 0 0 0644 u:object_r:vendor_firmware_file:s0
  ui_print "- A650 SQE firmware successfully installed."
else
  rm -rf "$MODPATH/system/vendor/firmware"
  ui_print "- A650 SQE firmware (kona-specific) is not installed because your SoC is not SM8250, SM8250-AB, or SM8250-AC."
fi

# Add patch permissions for paths
if set_perm_recursive "$MODPATH/system/vendor/lib*/" 0 0 0755 0644 u:object_r:same_process_hal_file:s0 \
   && set_perm_recursive "$MODPATH/system/lib*/" 0 0 0644 u:object_r:system_lib_file:s0; then
  ui_print "- Drivers successfully installed!"
else
  ui_print "- Error: Failed to install drivers."
  exit 1
fi


# Set overlay image parameters
OVERLAY_IMAGE_EXTRA=0
OVERLAY_IMAGE_SHRINK=true

# Only use OverlayFS if Magisk_OverlayFS is installed
if [ -f "/data/adb/modules/magisk_overlayfs/util_functions.sh" ] && \
   /data/adb/modules/magisk_overlayfs/overlayfs_system --test; then
  ui_print "- Add support for OverlayFS."
  . /data/adb/modules/magisk_overlayfs/util_functions.sh
  support_overlayfs
  rm -rf "$MODPATH"/system
fi


# Cache Cleaner
ui_print ""
ui_print "- Running GPU Cache Cleaner... Please wait!"
find /data/user_de/*/*/*cache/* -iname "*shader*" -exec rm -rf {} +
find /data/data/* -iname "*shader*" -exec rm -rf {} +
find /data/data/* -iname "*graphitecache*" -exec rm -rf {} +
find /data/data/* -iname "*gpucache*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*shader*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*graphitecache*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*gpucache*" -exec rm -rf {} +
ui_print "- Done."
ui_print ""


ui_print "- Please reboot!"
ui_print ""