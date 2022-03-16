#!/bin/sh
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


# Kickme into group
# ---------------------------------------------------------------------

	# Prüfe ob Version min. DSM 7 entspricht
	# -----------------------------------------------------------------
	if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then
	
		[ -d /var/packages/Log_Analysis ] && rm -Rf /var/packages/Log_Analysis/
		[ -d /volume1/@appconf/Log_Analysis ] && rm -Rf /volume1/@appconf/Log_Analysis/
		[ -d /volume1/@appdata/Log_Analysis ] && rm -Rf /volume1/@appdata/Log_Analysis/
		[ -d /volume1/@apphome/Log_Analysis ] && rm -Rf /volume1/@apphome/Log_Analysis/
		[ -d /volume1/@appstore/Log_Analysis ] && rm -Rf /volume1/@appstore/Log_Analysis/
		[ -d /volume1/@apptemp/Log_Analysis ] && rm -Rf /volume1/@apptemp/Log_Analysis/
		[ -f /var/log/packages/Log_Analysis.* ] && rm -f /var/log/packages/Log_Analysis.*

		# Füge den Benutzer LogAnalysis der Gruppe log hinzu
		# -------------------------------------------------------------
		if ! cat /etc/group | grep ^log | grep -q LogAnalysis ; then
			sed -i "/^log:/ s/$/,LogAnalysis/" /etc/group
		fi

		# Füge den Benutzer LogAnalysis der Gruppe system hinzu
		# ---------------------------------------------------------------------
		#if ! cat /etc/group | grep ^system | grep -q LogAnalysis ; then
		#	sed -i "/^system:/ s/$/,LogAnalysis/" /etc/group
		#fi

		# Füge den Benutzer LogAnalysis der Gruppe administrators hinzu
		# ---------------------------------------------------------------------
		#if ! cat /etc/group | grep ^administrators | grep -q LogAnalysis ; then
		#	sed -i "/^administrators:/ s/$/,LogAnalysis/" /etc/group
		#fi

		# Gib eine DSM-Benachrichtung über Erfolg bzw. Misserfolg aus
		# -------------------------------------------------------------
		if cat /etc/group | grep ^log | grep -q LogAnalysis ; then
			synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:script_true
		else
			synodsmnotify -c SYNO.SDS._ThirdParty.App.LogAnalysis @administrators LogAnalysis:app:app_name LogAnalysis:app:script_false
		fi

	fi




