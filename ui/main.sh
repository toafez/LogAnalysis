#!/bin/bash
# Filename: main.sh - coded in utf-8

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


# Seite zurücksetzen
# --------------------------------------------------------------
if [[ "${get[page]}" == "main" && "${get[section]}" == "reset" ]]; then
	[ -f "${get_request}" ] && rm "${get_request}"
	[ -f "${post_request}" ] && rm "${post_request}"
	echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=main&section=start">'
fi

# Horizontale Navigationsleiste laden
# --------------------------------------------------------------
mainnav

# Funktionen zur Anzeige des Verzeichnisbaumes laden
# --------------------------------------------------------------
rootdir()
{
	maindir="/var/log"
	dirlevel="0"
	tabstop="0"

    for subfolder in "${1}"; do

		# Show root directory
        echo '
		<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-secondary text-decoration-none">
			<span class="text-secondary pe-1">
				<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>
				<small class="fw-bold">'${subfolder}'</small>'
				if [[ "${folder_attributes}" == "on" ]]; then
					foldersize=$(du -sb "${maindir}" | sed "s#/.*##")
					foldersize=$(bytesToHumanReadable "$foldersize")
					echo '
					<span class="float-end">
						<small><span class="text-secondary fw-bold">'${foldersize}'</span></small>
					</span>'
				fi
				echo '
			</span>
		</a>'

        if [ -d "${subfolder}" ]; then
            thisfolder=${subfolder}

			# Show all subdirectories of the root directory
			subdir $(ls ${thisfolder})

			# Show all files in the root directory
			subfiles "${thisfolder}"
        fi
    done
    unset tabstop
}

subdir()
{
	dirlevel=$[${dirlevel}+1]
    tabstop=$[${tabstop}+20]

    for folder in "${@}"; do

        thisfolder=${thisfolder}/${folder}

        # Show all subdirectories of the root directory (directory level 0)
		if [ -d "${thisfolder}" ]; then
			if [ -z "$(ls -A ${thisfolder})" ] && [[ -z "${folder_access}" || "${folder_access}" == "off" ]]; then
				echo '
				<a class="text-start text-secondary text-decoration-none" data-bs-toggle="collapse" href="#'${thisfolder}'" role="button" aria-expanded="false" aria-controls="'${thisfolder}'">
					<span style="margin-left: '${tabstop}'px;">
						<nobr>
							<span class="text-secondary align-middle pe-1" title="'${txtFolderWithoutContent}'">
								<i class="bi bi-folder text-warning" style="font-size: 1.3rem;"></i>
								<small style="cursor: not-allowed;">'${folder}'</small>
							</span>
						</nobr>'
						if [[ "${folder_attributes}" == "on" ]]; then
							foldersize=$(du -sb "${thisfolder}" | sed "s#/.*##")
							foldersize=$(bytesToHumanReadable "$foldersize")
							echo '
							<span class="float-end">
								<small><span class="text-secondary">'${foldersize}'</span></small>
							</span>'
						fi
						echo '
					</span>
				</a>'
			elif [ -n "$(ls -A ${thisfolder})" ]; then
				echo '
				<a class="text-start text-secondary text-decoration-none" data-bs-toggle="collapse" href="#'${thisfolder}'" role="button" aria-expanded="false" aria-controls="'${thisfolder}'">
					<span style="margin-left: '${tabstop}'px;">
						<nobr>
							<span class="text-secondary align-middle pe-1" title="'${txtFolderWithContent}'">
								<i class="bi bi-folder-fill text-warning" style="font-size: 1.3rem;"></i>
								<small style="cursor: pointer;">'${folder}'</small>'
								echo '
							</span>
						</nobr>'
						if [[ "${folder_attributes}" == "on" ]]; then
							foldersize=$(du -sb "${thisfolder}" | sed "s#/.*##")
							foldersize=$(bytesToHumanReadable "$foldersize")
							echo '
							<span class="float-end">
								<small><span class="text-secondary">'${foldersize}'</span></small>
							</span>'
						fi
						echo '
					</span>
				</a>'
			fi

			# Show all files in the root directory (directory level 0)
			if [[ "${dirlevel}" -eq 0 ]]; then
				subfiles "${thisfolder}"

			# Hide all subdirectories and files, except for the path to the selected file
			elif [[ "${dirlevel}" -ne 0 ]]; then

				# Extract the third directory name from the path, starting from the left
				subdir=$(echo "${get[file]%/*}" | awk -v FS='/' '{print $4}')

				# Show all files and subdirectories around the selected file
				if [[ "${thisfolder}" == "${get[file]%/*}" ]]; then
					echo '
					<div class="collapse.show" id="'${thisfolder}'">'
						subfiles "${thisfolder}"
						echo '
					</div>
					<div class="collapse.show" id="'${thisfolder}'">'
						subdir $(ls ${thisfolder})
						echo '
					</div>'

				# Hide all files in all other subdirectories
				else
					echo '
					<div class="collapse" id="'${thisfolder}'">'
						subfiles "${thisfolder}"
						echo '
					</div>'

					# Show all directorys and subdirectories around the selected file
					if [[ "${get[file]%/*}" == ${maindir}/${subdir}/* ]]; then
						if [[ "${thisfolder}" == ${maindir}/${subdir} ]]; then
							echo '
							<div class="collapse.show" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						elif [[ "${thisfolder}" == ${maindir}/${subdir}/* ]]; then
							echo '
							<div class="collapse.show" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						else
							echo '
							<div class="collapse" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						fi

					# Hide directorys and subdirectories in all other subdirectories
					else
						echo '
						<div class="collapse" id="'${thisfolder}'">'
							subdir $(ls ${thisfolder})
							echo '
						</div>'
					fi
				fi
			fi
        fi
        thisfolder=${thisfolder%/*}
    done

    tabstop=$[${tabstop}-20]
	dirlevel=$[${dirlevel}-1]
}

subfiles()
{
	while IFS= read -r file; do
		[[ -z "${file}" ]] && continue
		tabstop=$[${tabstop}+20]
		if [[ "${file_attributes}" == "on" ]]; then
			filesize=$(du -sb "${file}" | sed "s#/.*##")
			filesize=$(bytesToHumanReadable "$filesize")
			permissions=$(ls -l "$file" | cut -d' ' -f1)
			lastmodified=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
		fi
		# Anzeige der Dateien
		[[ "${file}" == "${get[file]}" ]] && boldtext="class=\"fw-bold\""
		if [[ "${file}" == *.xz || "${file}" == *.tgz || "${file}" == *.txz ]]; then
			if [ -z "${file_access}" ] || [[ "${file_access}" == "off" ]]; then
				echo '
				<div style="margin-left: '${tabstop}'px;">
					<div>
						<span class="text-warning align-middle pe-1" title="'${txtFileIsArchive}'" style="cursor: help;">
							<i class="bi bi-file-earmark-zip text-danger" style="font-size: 1.3rem;"></i>
						</span>
						<small class="text-danger" style="cursor: not-allowed;">'${file##*/}'</small>
					</div>'
					if [[ "${file_attributes}" == "on" ]]; then
						echo '
						<div style="border-bottom:1px #cccccc solid;">
							<small><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
							<span class="float-end">
								<small><span class="text-secondary">'${filesize}'</span></small>
							</span>
						</div>'
					fi
					echo '
				</div>'
			fi
		elif [ ! -r "${file}" ]; then
			if [ -z "${file_access}" ] || [[ "${file_access}" == "off" ]]; then
				echo '
				<div style="margin-left: '${tabstop}'px;">
					<div>
						<span class="text-secondary align-middle pe-1" title="'${txtFileNoReadingRights}'" style="cursor: help;">
							<i class="bi bi-file-earmark-x text-danger" style="font-size: 1.3rem;"></i>
						</span>
						<small class="text-danger" style="cursor: not-allowed;">'${file##*/}'</small>
					</div>'
					if [[ "${file_attributes}" == "on" ]]; then
						echo '
						<div style="border-bottom:1px #cccccc solid;">
							<small><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
							<span class="float-end">
								<small><span class="text-secondary">'${filesize}'</span></small>
							</span>
						</div>'
					fi
					echo '
				</div>'
			fi
		elif [ ! -w "${file}" ]; then
			echo '
			<div style="margin-left: '${tabstop}'px;">
				<div>
					<a href="index.cgi?page=main&section=start&query=view&path='${get[path]}'&file='${file}'" class="text-secondary text-decoration-none">
						<span class="text-secondary align-middle pe-1" title="'${txtFileNoWritingRights}'" style="cursor: help;">
							<i class="bi bi-file-earmark-font text-warning" style="font-size: 1.3rem;"></i>
						</span>
						<small '${boldtext}' style="cursor: pointer;">'${file##*/}'</small>
					</a>
				</div>'
				if [[ "${file_attributes}" == "on" ]]; then
					echo '
					<div style="border-bottom:1px #cccccc solid;">
						<small '${boldtext}'><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
						<span class="float-end">
							<small '${boldtext}'><span class="text-secondary">'${filesize}'</span></small>
						</span>
					</div>'
				fi
				echo '
			</div>'
		else
			echo '
			<div style="margin-left: '${tabstop}'px;">
				<div>
					<a href="index.cgi?page=main&section=start&query=view&path='${get[path]}'&file='${file}'" class="text-secondary text-decoration-none">
						<span class="text-secondary align-middle pe-1" title="'${txtFileOpen}'" style="cursor: help;">
							<i class="bi bi-file-earmark-font text-success" style="font-size: 1.3rem;"></i>
						</span>
							<small '${boldtext}' style="cursor: pointer;">'${file##*/}'</small>
					</a>
				</div>'
				if [[ "${file_attributes}" == "on" ]]; then
					echo '
					<div style="border-bottom:1px #cccccc solid;">
						<small '${boldtext}'><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
						<span class="float-end">
							<small '${boldtext}'><span class="text-secondary">'${filesize}'</span></small>
						</span>
					</div>'
				fi
				echo '
			</div>'
		fi
		unset boldtext
		tabstop=$[${tabstop}-20]
	done <<< "$( find ${1} -maxdepth 1 -type f | sort )"
}

# Load library function for byte conversion
# --------------------------------------------------------------
[ -f "${app_home}/modules/bytes2human.sh" ] && source "${app_home}/modules/bytes2human.sh"

# Startseite anzeigen
# --------------------------------------------------------------
if [[ "${get[page]}" == "main" && "${get[section]}" == "start" ]]; then
	[ -z "${get[path]}" ] && get[path]="/var/log"

	# Überprüfen des App-Versionsstandes
	# --------------------------------------------------------------
	local_version=$(cat "/var/packages/${app_name}/INFO" | grep ^version | cut -d '"' -f2)
	git_version=$(wget --no-check-certificate --timeout=60 --tries=1 -q -O- "https://raw.githubusercontent.com/toafez/${app_name}/main/INFO.sh" | grep ^version | cut -d '"' -f2)
	if [ -n "${git_version}" ] && [ -n "${local_version}" ]; then
		if dpkg --compare-versions ${git_version} gt ${local_version}; then
			echo '
			<div class="card">
				<div class="card-header bg-danger-subtle"><strong>'${txt_update_available}'</strong></div>
				<div class="card-body">'${txt_update_from}'<span class="text-danger"> '${local_version}' </span>'${txt_update_to}'<span class="text-success"> '${git_version}'</span>
					<div class="float-end">
						<a href="https://github.com/toafez/'${app_name}'/releases" class="btn btn-sm text-dark text-decoration-none" style="background-color: #e6e6e6;" target="_blank">Update</a>
					</div>
				</div>
			</div><br />'
		fi
	fi

	# Überprüfen der App-Berechtigung
	# --------------------------------------------------------------
	if [ -z "${permissions}" ] || [[ "${permissions}" == "false" ]]; then
		echo '
		<div class="card">
			<div class="card-header bg-danger-subtle"><strong>'${txt_group_status}'</strong></div>
			<div class="card-body">'${txt_group_status_false}'
				<div class="float-end"> 
					<a href="#help-permissions" class="btn btn-sm text-dark text-decoration-none" style="background-color: #e6e6e6;" data-bs-toggle="modal" data-bs-target="#help-app_permissions">'${txt_button_extend_permission}'</a>
				</div>
			</div>
		</div>'
	fi

	echo '
	<div class="row my-2 mx-1">'
		# Linke Spalte - Ordnerstruktur
		# ------------------------------------------------------
		echo '
		<div class="col-4">
			<div class="card border-0 mb-3">'
				rootdir "${get[path]}" 
				echo '
			</div>
		</div>
		<!-- col -->'

		# Rechte Spalte - Suchformular
		# ------------------------------------------------------
		echo '
		<div class="col-8 ps-1">'
			# Datum und Uhrzeit formatieren
			day_now=$(date +%d)
			month_now=$(date +%m)
			year_now=$(date +%Y)
			hour_now=$(date +%H)
			minute_now=$(date +%M)
			echo '
			<div class="card border-0 mb-3">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txtSearch}'&nbsp;&nbsp;</strong>'
						get[file]=$(urldecode ${get[file]})
						if [ -f "${get[file]}" ]; then
							if [ ! -w "${get[file]}" ]; then 
								echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
							else
								echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
							fi
						else
							echo '<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[path]}''
						fi
						echo '
					</span>
					<i id="load_loading" class="spinner-border text-secondary mt-1 ms-2" style="width: 1rem; height: 1rem;" role="status">
						<span class="visually-hidden">Loading...</span>
					</i>
				</div>
				<div class="card-body pb-0">
					<div class="form-group px-4 mb-3">'
						echo -n '<input type="text" class="form-control form-control-sm" name="searchstring" value='; \
							[ -n "${post[searchstring]}" ] && echo -n '"'${post[searchstring]}'" />' || echo -n '"" placeholder="'${txtSearchingFor}'" />'
						echo '
					</div>
					<div class="row px-4 mb-3">
						<div class="form-group col-md-12">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="casesensitive_check" name="casesensitive"'; \
									[[ "${post[casesensitive]}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="casesensitive_check" class="form-check-label text-secondary">'${txtCaseSensitive}'</label>
							</div>
						</div>
					</div>
					<!-- row -->
					<div class="row px-4 mb-3">
						<div class="form-group col-md-5">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="date_check" name="date"'; \
									[[ "${post[date]}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="date_check" class="form-check-label text-secondary">'${txtUseDate}'</label>
							</div>
						</div>
						<div class="form-group col-md-2">
							<select id="day" name="day" class="form-select form-select-sm">'
								for i in {01..31}; do
									if [[ "${i}" == "${post[day]}" ]]; then
										echo '<option value="'${post[day]}'" selected>'${post[day]}'</option>'
									elif [ -z "${post[day]}" ] && [[ "${i}" == "${day_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-2">
							<select id="month" name="month" class="form-select form-select-sm">'
								for i in {01..12}; do
									if [[ "${i}" == "${post[month]}" ]]; then
										echo '<option value="'${post[month]}'" selected>'${post[month]}'</option>'
									elif [ -z "${post[month]}" ] && [[ "${i}" == "${month_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-3">
							<select id="year" name="year" class="form-select form-select-sm">'
								for i in {2010..2040}; do
									if [[ "${i}" == "${post[year]}" ]]; then
										echo '<option value="'${post[year]}'" selected>'${post[year]}'</option>'
									elif [ -z "${post[year]}" ] && [[ "${i}" == "${year_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
					</div>
					<!-- row -->
					<div class="row px-4 mb-3">
						<div class="form-group col-md-8">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="time_check" name="time"'; \
									[[ "${post[time]}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="time_check" class="form-check-label text-secondary">'${txtUseTime}'</label>
							</div>
						</div>
						<div class="form-group col-md-2">
							<select id="hour" name="hour" class="form-select form-select-sm">'
								for i in {00..23}; do
									if [[ "${i}" == "${post[hour]}" ]]; then
										echo '<option value="'${post[hour]}'" selected>'${post[hour]}'</option>'
									elif [ -z "${post[hour]}" ] && [[ "${i}" == "${hour_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-2">
							<select id="minute" name="minute" class="form-select form-select-sm">'
								if [[ "---" == "${post[minute]}" ]]; then
									echo '<option value="---" selected>---</option>'
								else
									echo '<option value="---">---</option>'
								fi
								for i in {0..5}; do
									if [[ "${i}" == "${post[minute]}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'x</option>'
									else
										echo '<option value="'${i}'">'${i}'x</option>'
									fi
								done
								echo '
							</select>
						</div>
					</div>
					<!-- row -->

					<p class="text-center">'
						if [ -f "${get[file]}" ]; then
							echo '
							<input type="hidden" name="path" value="'${get[path]}'">
							<input type="hidden" name="searchfile" value="'${get[file]}'">'
						else
							echo '<input type="hidden" name="searchpath" value="'${get[path]}'">'
						fi
						echo '
						<input type="hidden" name="query" value="search">
						<button class="btn btn-secondary btn-sm" type="submit" name="formular" value="execute">'$btnStartSearching'</button>
					</p>
				</div>
				<!-- card-body -->
			</div>
			<!-- card -->'

			# Hilfe anzeigen, so lange keine Operation aktiv
			# --------------------------------------------------
			if [[ -z "${post[formular]}" ]] && [[ "${get[query]}" != "view" ]] && [[ "${get[query]}" != "clear" ]]; then
				echo '
				<div class="card border-0 mb-3">
					<div class="card-header border-0">
						<span class="text-secondary">'${txtHelpHeader}'
						</span>
					</div>
					<div class="card-body pb-0">'

						# Hilfe: Zeichenerklärung
						# --------------------------------------
						echo '
						<ul style="list-style-type: none">
							<li><span class="text-secondary pe-1">
									<i class="bi bi-house-door text-secondary" style="font-size: 1.3rem;"></i>
									<small>'${txtBtnReset}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-folder-fill text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFolderWithContent}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-folder text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFolderWithoutContent}'</small>
								</span>
							</li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-font text-success" style="font-size: 1.3rem;"></i>
									<small>'${txtFileOpen}'</small>
								</span>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-font text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFileNoWritingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-x text-danger" style="font-size: 1.3rem;"></i>
									<small>'${txtFileNoReadingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-zip text-danger" style="font-size: 1.3rem;"></i>
									<small>'${txtFileIsArchive}'</small>
								</span>
							</li>
						</ul>
					</div>
					<!-- card-body -->
				</div>
				<!-- card -->'
			fi

			# Formulardaten auswerten und anzeigen
			# --------------------------------------------------
			if [[ "${post[query]}" == "search" ]] && [[ "${post[formular]}" == "execute" ]]; then
				[ -f "${post_request}" ] && rm "${post_request}"
				"${set_keyvalue}" "${post_request}" "post[searchstring]" "${post[searchstring]}"

				# Vorhandene Protokolldatei löschen
				[ -f "${result}" ] && rm "${result}"

				# Neue Protokolldatei erstellen und entsprechende Rechte setzen
				if [ ! -f "${result}" ]; then
					touch "${result}"
					chmod a+rx "${result}"
				fi

				if [ -f "${post[searchfile]}" ]; then
					PathOrFile=${post[searchfile]}
					"${set_keyvalue}" "${get_request}" "get[path]" "${post[path]}"
					"${set_keyvalue}" "${get_request}" "get[file]" "${post[searchfile]}"
				else
					PathOrFile=${post[searchpath]}
					"${set_keyvalue}" "${get_request}" "get[path]" "${post[searchpath]}"
					"${set_keyvalue}" "${get_request}" "get[file]" ""
				fi

				if [[ "${post[casesensitive]}" == "on" ]]; then
					GrepOptions="-EnH"
				else
					GrepOptions="-EnHi"
				fi

				# Werte die Checkbox-Zustände aus...
				if [ -z "${post[time]}" ] && [ -z "${post[date]}" ]; then
					# Datum und Uhrzeit werden NICHT verwendet
					find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*(.*'"${post[searchstring]}"').*' {} \; >> ${result}
				fi

				if [ -z "${post[date]}" ] && [[ "${post[time]}" == "on" ]]; then
					# Uhrzeit wird verwendet
					if [[ "${post[minute]}" == "---" ]]; then
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${post[hour]}':.{2}:.{2}.*'"${post[searchstring]}"').*' {} \; >> ${result}
					else
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${post[hour]}':'${post[minute]}'.{1}:.{2}.*'"${post[searchstring]}"').*' {} \; >> ${result}
					fi
				fi

				if [[ "${post[date]}" == "on" ]] && [ -z "${post[time]}" ]; then
					# Datum wird verwendet
					find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${post[year]}'.?'${post[month]}'.?'${post[day]}'.*'"${post[searchstring]}"').*' {} \; >> ${result}
				fi

				if [[ "${post[date]}" == "on" ]] && [[ "${post[time]}" == "on" ]]; then
					# Datum und Uhrzeit wird verwendet
					if [[ "${post[minute]}" == "---" ]]; then
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${post[year]}'.?'${post[month]}'.?'${post[day]}'.?'${post[hour]}':.{2}:.{2}.*'"${post[searchstring]}"').*' {} \; >> ${result}
					else
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${post[year]}'.?'${post[month]}'.?'${post[day]}'.?'${post[hour]}':'${post[minute]}'.{1}:.{2}.*'"${post[searchstring]}"').*' {} \; >> ${result}
					fi
				fi

				if [ -f "${result}" ]; then
					# Gebe Suchergebnis aus
					echo '
					<div class="card border-0">
						<div class="card-header border-0">
							<span class="text-secondary"><strong>'${txtSearchResult}'&nbsp;&nbsp;</strong>'
								#get[file]=$(urldecode ${get[file]})
								if [ -z "${get[file]}" ]; then
									echo '<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[path]}''
									#echo ' '${txtFolder}' '${get[path]}''
								else
									if [ -f "${get[file]}" ]; then
										if [ ! -w "${get[file]}" ]; then 
											echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
										else
											echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
										fi
									fi
								fi
									#echo ' '${txtFile}' '${get[file]##*/}''
								fi
								if [ -s "${result}" ]; then
									echo '
									<a class="float-end" href="index.cgi?page=main&section=start&query=view&file='${get[file]}'" title="'${btnClose}'">
										<i class="bi bi-x-lg text-secondary align-middle float-end pe-1" style="font-size: 1.3rem;"></i>
									</a>
									<a href="index.cgi?page=contentview&path='${get[path]}'&file='${get[file]}'&resultfile='${result}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
										<i class="bi bi-card-text text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>
									<a class="float-end" href="temp/result.txt" title="Download" download >
										<i class="bi bi-cloud-arrow-down text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>
								</i>'
								fi
								echo '
							</span>
						</div>
						<div class="card-body px-1 py-1">
							<div id="file-content-box" class="form-group">
								<textarea id="file-content-txt" spellcheck="false" class="form-control border-white bg-white text-monospace" style="font-size: 80%;" rows="13" readonly>'
									if [ -s "${result}" ]; then
										while read line; do
											IFS=: read source row hit <<< "${line}"
											if [[ "${get[query]}" == "view" ]]; then	# Suchergebnisse aus einer ausgewählten Datei
												echo ''${txtHitInLine}' '${row}'...'
												echo -e -n ''${hit}''
											elif [ -z "${get[query]}" ]; then			# Suchergebnisse aus allen Dateien
												IFS=: read source row hit <<< "${line}"
												echo ''${txtHitIn}' '${source}' '${txtLine}' '${row}'...'
												echo -e -n ''${hit}''
											fi
											IFS="${backupIFS}"
											echo '&#13;&#10;'
										done < "${result}"
										unset line
									else
										echo ''${txtNoMatches}''
									fi
									echo '
								</textarea>
							</div>
						</div>
						<!-- card-body -->
					</div>
					<!-- card -->'
				fi
			fi
			# Dateiinhalt ausgeben
			# --------------------------------------------------
			if [[ "${get[query]}" == "view" ]] && [ -z "${post[formular]}" ]; then
				# Link zurück zur Übersicht
				if [ -f "${get[file]}" ]; then
					#[ -f "${get_request}" ] && rm "${get_request}"
					# Gebe Dateiinhalt als ganzes aus
					echo '
					<div class="card border-0">
						<div class="card-header border-0">
							<span class="text-secondary"><strong>'${txtFileContent}'&nbsp;&nbsp;</strong>'
								if [ -f "${get[file]}" ]; then
									if [ ! -w "${get[file]}" ]; then 
										echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
									else
										echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${get[file]}''
									fi
								fi
								if [ -s "${get[file]}" ]; then
									if [ -w "${get[file]}" ]; then
										echo '
										<a href="index.cgi?page=main&section=start&query=clear&path='${get[path]}'&file='${get[file]}'" title="'${txtDeleteFileContent}'">
											<i class="bi bi-file-earmark-x text-secondary align-middle float-end pe-1" style="font-size: 1.3rem;"></i>
										</a>'
									fi
									echo '
									<a href="index.cgi?page=contentview&resultfile='${get[file]}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
										<i class="bi bi-card-text text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>'
								fi
								echo '
							</span>
						</div>
						<div class="card-body px-0 py-1">
							<div id="file-content-box" class="form-group">
								<textarea id="file-content-txt" spellcheck="false" class="form-control border-white bg-white text-monospace" style="font-size: 80%;" rows="13" readonly>'
									if [ -s "${get[file]}" ]; then
										while read line; do
											echo -e -n ''${line}'&#13;&#10;'
										done < "${get[file]}"
										unset line
									else
										echo ''${txtFileIsEmpty}''
									fi
									echo '
								</textarea>
							</div>
						</div>
						<!-- card-body -->
					</div>
					<!-- card -->'
				fi
			fi

			# Dateiinhalt löschen
			# --------------------------------------------------
			if [[ "${get[query]}" == "clear" ]] && [ -z "${post[formular]}" ]; then

				if [ -z "${get[execute]}" ]; then
					[ -f "${get_request}" ] && rm "${get_request}"
					# Pop-up-Fenster einblenden
					popupbox "30" "${txtAlertInputConfirmation}" "${txtAlertClearEntry}" "<a href=\"index.cgi?page=main&section=start&query=clear&execute=yes&path=${get[path]}&file=${get[file]}\" class=\"btn btn-secondary btn-sm\">${btnDeleteNow}</a>&nbsp;&nbsp;&nbsp;<a href=\"index.cgi?page=main&section=start&query=view&path=${get[path]}&file=${get[file]}\" class=\"btn btn-secondary btn-sm\">${btnCancel}</a>"
				fi

				if [[ "${get[execute]}" == "yes" ]] && [ -f "${get[file]}" ]; then
					[ -f "${get_request}" ] && rm "${get_request}"
					:> "${get[file]}"
					echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=main&section=start&query=view&path='${get[path]}'&file='${get[file]}'">'
				else
					# Pop-up-Fenster einblenden - Fehler bei der Verarbeitung
					popupbox "30" "${txtAlertSystemError}" "${txtAlertProcessingError}" "<a href=\"index.cgi?page=main&section=start&query=view&path=${get[path]}&file=${get[file]}\" class=\"btn btn-secondary btn-sm\">${btnUnderstood}</a>"
				fi
			fi
			echo '
		</div>
		<!-- col -->
	</div>
	<!-- row -->'
fi

echo '
<script>
	$("#contentview").show();
</script>'
