#!/bin/bash
# Filename: parse_language.sh - coded in utf-8

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


# Spracheinstellungen konfigurieren
# --------------------------------------------------------------
function language() {

	#********************************************************************#
	#  Description: Script get the current used dsm language             #
	#  Author:      QTip from the german Synology support forum          #
	#  Copyright:   2016-2018 by QTip                                    #
	#  License:     GNU GPLv3                                            #
	#  ----------------------------------------------------------------  #
	#  Version:     0.15 - 11/06/2018                                    #
	#********************************************************************#

	# Übersetzungstabelle deklarieren
	declare -A ISO2SYNO
	ISO2SYNO=( ["de"]="ger" ["en"]="enu" ["zh"]="chs" ["cs"]="csy" ["jp"]="jpn" ["ko"]="krn" ["da"]="dan" ["fr"]="fre" ["it"]="ita" ["nl"]="nld" ["no"]="nor" ["pl"]="plk" ["ru"]="rus" ["sp"]="spn" ["sv"]="sve" ["hu"]="hun" ["tr"]="trk" ["pt"]="ptg" )

	# Standardsprache
	default_lang="ger"

	# Script Sprache
	script_lang=$(/bin/get_key_value /etc/synoinfo.conf maillang)
	if [ "${script_lang}" == "def" ]; then
		script_lang="${default_lang}"
	fi

	# DSM Sprache
	gui_lang=$(/bin/get_key_value /etc/synoinfo.conf language)
	if [[ "${gui_lang}" == "def" ]] ; then
		# Browsersprache ermitteln
		if [ -n "${HTTP_ACCEPT_LANGUAGE}" ] ; then
			bl=$(echo ${HTTP_ACCEPT_LANGUAGE} | cut -d "," -f1)
			bl=${bl:0:2}
			gui_lang="${ISO2SYNO[${bl}]}"
		else
			gui_lang="${default_lang}"
		fi
	fi

	# Sprachdateien für die GUI laden
	if [[ "${1}" == "GUI" ]]; then
		if [ -f "lang/gui/lang_gui_${gui_lang}.txt" ]; then
			source "lang/gui/lang_gui_${gui_lang}.txt"
		fi
	fi

	# Sprachdateien für die Konsole laden
	if [[ "${1}" == "SCRIPT" ]]; then
		if [ -f "/var/packages/BasicBackup/target/ui/lang/script/lang_script_${script_lang}.txt" ]; then
			source "/var/packages/BasicBackup/target/ui/lang/script/lang_script_${script_lang}.txt"
		fi
	fi
}