#!/bin/bash
# Filename: SPK_Build_Stage.sh - coded in utf-8

#                     LogAnalysis for DSM 7
#
#        Copyright (C) 2026 by Tommes | License GNU GPLv3
#        Member from the  German Synology Community Forum
#
# Extract from  GPL3   https://www.gnu.org/licenses/gpl-3.0.html
#                                     ...
# This program is free software: you can redistribute it  and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# See the GNU General Public License for more details.You should
# have received a copy of the GNU General Public  License  along
# with this program. If not, see http://www.gnu.org/licenses/  !


# -------------------------------------------------------------------------------------------------
# Please make your desired changes here
# -------------------------------------------------------------------------------------------------

# Changing the copyright
copyright="Copyright (C) 2026 by"

# -------------------------------------------------------------------------------------------------
# Please do not make any changes below, unless you know what you are doing!
# -------------------------------------------------------------------------------------------------
old_copyright="Copyright (C) 2026 by"
path=$(pwd)

# Costumize Copyright
# -----------------------------------------------
if [[ "${copyright}" != "${old_copyright}" ]]; then
    find . -type f -print0 | xargs -0 -n 1 sed -i -e 's/'"${old_copyright}"'/'"${copyright}"'/g'
    echo 'Copyright was changed from [ '${old_copyright}' ] to [ '${copyright}' ]'
else
    echo 'Copyright [ '${copyright}' ] was not changed'
fi

if [[ "${changedirname}" == "yes" ]]; then
    mv ${path} ${path%/*}/${packagename}
    cd ${path%/*}/${packagename}
    exec bash
else
    exit 0
fi

