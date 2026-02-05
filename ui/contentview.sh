#!/bin/bash
# Filename: contentview.sh - coded in utf-8

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



# Dateiinhalt ohne Zeilenumbruch anzeigen
# --------------------------------------------------------------
echo '
<div class="row">
	<div class="col">'
		get[resultfile]=$(urldecode ${get[resultfile]})
		get[file]=$(urldecode ${get[file]})
		if [ -f "${get[resultfile]}" ]; then
			if [[ "${get[resultfile]}" == *result.txt ]]; then
				# Gebe Suchergebnis aus
				if [ -z "${get[file]}" ]; then
					echo '<h5>'${txtSearchResultFolder}' '${get[path]}'</h5>'
				else
					echo '<h5>'${txtSearchResultFile}' '${get[file]}'</h5>'
				fi
				echo '
				<div class="text-monospace text-nowrap" style="font-size: 87.5%;">'
					while read line; do
						IFS=: read source row hit <<< "${line}"
						if [[ "${get[query]}" == "view" ]]; then
							# Suchergebnisse aus einer ausgewählten Datei
							echo ''${txtHitInLine}' '${row}' ->'
							echo -e -n ''${hit}'<br />'
						elif [ -z "${get[query]}" ]; then
							# Suchergebnisse aus allen Dateien
							IFS=: read source row hit <<< "${line}"
							echo ''${txtHitIn}' '${source}' '${txtLine}' '${row}' ->'
							echo -e -n ''${hit}'<br />'
						fi
					done < "${get[resultfile]}"
					unset source row hit
					IFS="${backupIFS}"
					echo '
				</div>'
			elif [[ "${get[resultfile]}" == /var/log/* ]]; then
				# Gebe Dateiinhalt aus
				echo '
				<h5>'${txtViewFile}' '${get[file]}'</h5>
				<div class="text-monospace text-nowrap" style="font-size: 87.5%;">'
					row=1
					while read line; do
						echo ''${txtLine}' '${row}' -> '${line}'<br>'
						row=$[${row}+1]
					done < "${get[resultfile]}"
					unset counter
					echo '
				</div>'
			else
				echo '
				<h5>'${txtAlertSystemError}'</h5>
				'${txtAlertAccessDenied_step1}' <strong class="text-danger">'${get[resultfile]}'</strong> '${txtAlertAccessDenied_step2}''
			fi
			unset line
		else
			echo '
			<h5>'${txtAlertSystemError}' '${get[resultfile]}'</h5>
			'${txtAlertProcessingError}''
		fi
		echo '
	</div>
	<!-- col -->
</div>
<!-- row -->'
