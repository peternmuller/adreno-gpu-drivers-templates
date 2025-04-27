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

chcon u:object_r:vendor_firmware_file:s0 /vendor/firmware/a650_sqe.fw
chmod 644 /vendor/firmware/a650_sqe.fw
chcon u:object_r:same_process_hal_file:s0 /vendor/lib*/*/*.so
chmod 644 /vendor/lib*/*/*.so
chcon u:object_r:same_process_hal_file:s0 /vendor/lib*/*.so
chmod 644 /vendor/lib*/*.so
chcon u:object_r:system_lib_file:s0 /system/lib*/*.so
chmod 644 /system/lib*/*.so
