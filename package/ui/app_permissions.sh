#!/bin/bash
# Filename: app_permissions.sh - coded in utf-8
# call: /usr/syno/synoman/webman/3rdparty/LogAnalysis/app_permissions.sh


#                     LogAnalysis for DSM 7
#
#        Copyright (C) 2022 by Tommes | License GNU GPLv3
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


# Funktion: Benutzer einer Gruppe hinzufügen oder entfernen
# --------------------------------------------------------------
# Aufruf: synogroupuser "[adduser or deluser]" "GROUP" "USER"
function synogroupuser()
{
	oldIFS=${IFS}
	IFS=$'\n'
	query=${1}
	group=${2}
	user=${3}
	userlist=$(synogroup --get ${group} | grep -E '^[0-9]*:'| sed -e 's/^[0-9]*:\[\(.*\)\]/\1/')
	updatelist=()
	for i in ${userlist}; do
		if [[ "${query}" == "adduser" ]]; then
			[[ "${i}" != "${user}" ]] && updatelist+=(${i})
			[[ "${i}" == "${user}" ]] && userexists="true"
		elif [[ "${query}" == "deluser" ]]; then
			[[ "${i}" != "${user}" ]] && updatelist+=(${i})
			[[ "${i}" == "${user}" ]] && userexists="true"
		else
			synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:groupuser_error
			exit 1
		fi
	done

	if [[ -z "${userexists}" && "${query}" == "adduser" ]]; then
		updatelist+=(${user})
		synogroup --member ${group} ${updatelist[@]}
		synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:adduser_true
	elif [[ -n "${userexists}" && "${query}" == "adduser" ]]; then
		synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:adduser_exists
		exit 2
	elif [[ -n "${userexists}" && "${query}" == "deluser" ]]; then
		synogroup --member ${group} ${updatelist[@]}
		synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:deluser_true
	elif [[ -z "${userexists}" && "${query}" == "deluser" ]]; then
		synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:deluser_notexist
		exit 3
	fi

	IFS=${oldIFS}
}

# Prüfe ob Version min. DSM 7 entspricht
# -----------------------------------------------------------------
if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then

	# Lösche, falls vorhanden, alte Paketdaten von Log_Analysis
	[ -d /var/packages/Log_Analysis ] && rm -Rf /var/packages/Log_Analysis/
	[ -d /volume1/@appconf/Log_Analysis ] && rm -Rf /volume1/@appconf/Log_Analysis/
	[ -d /volume1/@appdata/Log_Analysis ] && rm -Rf /volume1/@appdata/Log_Analysis/
	[ -d /volume1/@apphome/Log_Analysis ] && rm -Rf /volume1/@apphome/Log_Analysis/
	[ -d /volume1/@appstore/Log_Analysis ] && rm -Rf /volume1/@appstore/Log_Analysis/
	[ -d /volume1/@apptemp/Log_Analysis ] && rm -Rf /volume1/@apptemp/Log_Analysis/
	[ -f /var/log/packages/Log_Analysis.* ] && rm -f /var/log/packages/Log_Analysis.*

	# LogAnalysis der Grupp log hinzufügen
	if [[ "${1}" == "adduser" ]]; then
		synogroupuser "adduser" "log" "LogAnalysis"
	fi

	# LogAnalysis aus der Gruppe log entfernen
	if [[ "${1}" == "deluser" ]]; then
		synogroupuser "deluser" "log" "LogAnalysis"
	fi
fi
