#!/bin/bash
# Filename: main.sh - coded in utf-8

#                     LogAnalysis for DSM 7
#
#        Copyright (C) 2023 by Tommes | License GNU GPLv3
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
				echo '<p class="text-center">'${txt_update_available}' <a href="https://github.com/toafez/'${app_name}'/releases" target="_blank">'${git_version}'</a></p>'
			fi
		fi

	echo '
	<div class="row mt-2">'
		# Linke Spalte - Ordnerstruktur
		# ------------------------------------------------------
		echo '
		<div class="col-4 pr-1">
			<div class="card">'
				if [[ "${get[path]}" == "/var/log" ]]; then
					# Aufbau des Hauptordners
					echo '
					<div class="card-header clearfix">
						<i class="bi-icon bi-geo-fill text-secondary float-start" style="cursor: help;" title="'${txtDisplayFolderContent}'"></i>
						<span class="text-secondary float-start">'${get[path]}'</span>
						<a href="index.cgi?page=main&section=reset" title="'${btnReset}'">
							<i class="bi-icon bi-house text-secondary float-end"></i>
						</a>
						<a href="index.cgi?page=debug&section=start" title="'${btnDebug}'">
							<i class="bi-icon bi-bug text-secondary float-end"></i>
						</a>
						<i id="load_loading" class="spinner-border text-secondary mt-1 float-end" style="width: 1rem; height: 1rem;" role="status">
							<span class="visually-hidden">Loading...</span>
						</i>
					</div>
					<div class="card-body pt-1">
						<ul class="list-unstyled mb-0" style="line-height: 1.2rem;">
							<li>
								<nobr>
									<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-secondary text-decoration-none">
										<span class="text-secondary">
											<i class="bi-folder-x text-secondary"></i>
											<small style="font-weight: 600;">'${get[path]}'</small>
										</span>
									</a>
								</nobr>
							</li>'
							while IFS= read -r folder; do
								IFS="${backupIFS}"
								[[ -z "${folder}" ]] && continue
								# Anzeige der Ordner
								if [ `ls -a "${folder}" | wc -l` -gt 2 ] ; then
									echo '
									<li>
										<nobr>&nbsp;
											<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-secondary text-decoration-none">
												<span class="text-secondary" title="'${txtFolderWithContent}'" style="cursor: help;">
													<i class="bi-folder-plus text-secondary"></i>
												</span>
												<small style="font-weight: 600; cursor: pointer;">'${folder##*/}'</small>
											</a>
										</nobr>
									</li>'
								else
									echo '
									<li>
										<nobr>&nbsp;
											<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-secondary text-decoration-none">
												<span class="text-secondary" title="'${txtFolderWithoutContent}'" style="cursor: help;">
													<i class="bi-folder text-secondary"></i>
												</span>
												<small style="font-weight: 600; cursor: pointer;">'${folder##*/}'</small>
											</a>
										</nobr>
									</li>'
								fi
							done <<< "$( find "${get[path]}"/* -mindepth 0 -maxdepth 0 -xtype d | sort )"
				elif [ -d "${get[path]}" ]; then
					# Verzweigung in einen Unterordner
					echo '
					<div class="card-header clearfix">
						<i class="bi-icon bi-geo-fill text-secondary float-start" style="cursor: help;" title="'${txtDisplayFolderContent}'"></i>
						<span class="text-secondary float-start">'${get[path]}'</span>
						<a href="index.cgi?page=main&section=reset" title="'${btnReset}'">
							<i class="bi-icon bi-house text-secondary float-end"></i>
						</a>
						<i id="load_loading" class="spinner-border text-secondary mt-1 float-end" style="width: 1rem; height: 1rem;" role="status">
							<span class="visually-hidden">Loading...</span>
						</i>
					</div>
					<div class="card-body pt-1">
						<ul class="list-unstyled mb-0" style="line-height: 1.2rem;">
							<li>
								<nobr>
									<a href="index.cgi?page=main&section=start&path='${get[path]%/*}'&file=&query=" class="text-secondary text-decoration-none" title="'${btnBack}'">
										<span class="text-secondary">
											<i class="bi-box-arrow-left text-secondary"></i>
											<small style="font-weight: 600;">'${get[path]%/*}'/<span style="font-weight: 400; font-style: italic; cursor: auto;" title="">'${get[path]##*/}'</span>
											</small>
										</span>
									</a>
								</nobr>
							</li>'
							while IFS= read -r folder; do
								IFS="${backupIFS}"
								[[ -z "${folder}" ]] && continue
								# Anzeige der Ordner
								if [ `ls -a "${folder}" | wc -l` -gt 2 ] ; then
									echo '
									<li>
										<nobr>&nbsp;
											<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-info text-decoration-none">
												<span class="text-secondary" title="'${txtFolderWithContent}'" style="cursor: help;">
													<i class="bi-folder text-secondary"></i>
												</span>
													<small style="font-weight: 600; cursor: pointer;">'${folder##*/}'</small>
											</a>
										</nobr>
									</li>'
								else
									echo '
									<li>
										<nobr>&nbsp;
											<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-muted text-decoration-none">
												<span class="text-secondary" title="'${txtFolderWithoutContent}'" style="cursor: help;">
													<i class="bi-folder text-secondary"></i>
												</span>
													<small style="font-weight: 600; cursor: pointer;">'${folder##*/}'</small>
											</a>
										</nobr>
									</li>'
								fi
							done <<< "$( find ${get[path]}/* -mindepth 0 -maxdepth 0 -xtype d | sort )"
				fi
				echo '
							<div class="clearfix">'
								while IFS= read -r file; do
									IFS="${backupIFS}"
									[[ -z "${file}" ]] && continue
									filesize=$(du -sh "$file" | sed "s#/.*##")
									# Anzeige der Dateien
									if [[ "${file}" == *.xz || "${file}" == *.tgz || "${file}" == *.txz ]]; then
										echo '
										<li>
											<nobr>&nbsp;
												<span class="text-warning" title="'${txtFileIsArchive}'" style="cursor: help;">
													<i class="bi-file-earmark-zip text-warning"></i>
												</span>
												<small class="text-warning" style="cursor: not-allowed;">'${file##*/}'</small>
											</nobr>
											<span class="float-end">
												<small><span class="text-secondary">'${filesize}'</span></small>
											</span>
										</li>'
									elif [ ! -r "${file}" ]; then
										echo '
										<li>
											<nobr>&nbsp;
												<span class="text-secondary" title="'${txtFileNoReadingRights}'" style="cursor: help;">
													<i class="bi-file-earmark-x text-danger"></i>
												</span>
												<small class="text-danger" style="cursor: not-allowed;">'${file##*/}'</small>
											</nobr>
											<span class="float-end">
												<small><span class="text-secondary">'${filesize}'</span></small>
											</span>
										</li>'
									elif [ ! -w "${file}" ]; then
										echo '
										<li>
											<nobr>&nbsp;
												<a href="index.cgi?page=main&section=start&query=view&path='${get[path]}'&file='${file}'" class="text-secondary text-decoration-none">
													<span class="text-secondary" title="'${txtFileNoWritingRights}'" style="cursor: help;">
														<i class="bi-file-earmark-font-fill text-secondary"></i>
													</span>
													<small style="cursor: pointer;">'${file##*/}'</small>
												</a>
											</nobr>
											<span class="float-end">
												<small><span class="text-secondary">'${filesize}'</span></small>
											</span>
										</li>'
									else
										echo '
										<li>
											<nobr>&nbsp;
												<a href="index.cgi?page=main&section=start&query=view&path='${get[path]}'&file='${file}'" class="text-secondary text-decoration-none">
													<span class="text-secondary" title="'${txtFileOpen}'" style="cursor: help;">
														<i class="bi-file-earmark-font text-secondary"></i>
													</span>
														<small style="cursor: pointer;">'${file##*/}'</small>
												</a>
											</nobr>
											<span class="float-end">
												<small><span class="text-secondary">'${filesize}'</span></small>
											</span>
										</li>'
									fi
								done <<< "$( find -L ${get[path]} -maxdepth 1 -type f | sort )"
								echo '
							</div>
						</ul>
					</div>
					<!-- card-body -->'
				echo '
			</div>
			<!-- card -->
			<br />
		</div>
		<!-- col -->'

		# Rechte Spalte - Suchformular
		# ------------------------------------------------------
		echo '
		<div class="col-8 pl-1">'
			# Datum und Uhrzeit formatieren
			day_now=$(date +%d)
			month_now=$(date +%m)
			year_now=$(date +%Y)
			hour_now=$(date +%H)
			minute_now=$(date +%M)
			echo '
			<div class="card mb-3">
				<div class="card-header">
					<i class="bi-icon bi-search text-secondary float-start" style="cursor: help;" title="'${txtSearchForTerms}'"></i>
					<span class="text-secondary">&nbsp;&nbsp;'${txtSearch}''
						get[file]=$(urldecode ${get[file]})
						[ -f "${get[file]}" ] && echo ' <b>'${get[file]}'</b>' || echo '<b>'${get[path]}'</b>'
						echo '
					</span>
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
								for i in {01..24}; do
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
				<div class="card mb-3">
					<div class="card-header">
						<i class="bi-icon bi-question text-secondary float-start" style="cursor: help;" title="'${txtHelp}'"></i>
						<span class="text-secondary">&nbsp;&nbsp;'${txtHelp}'
						</span>
					</div>
					<div class="card-body pb-0">'

						# Hilfe: Zeichenerklärung
						# --------------------------------------
						echo '
						<span class="text-secondary"><strong>'${txtHelpHeader}'</strong></span><br />
						<ul style="list-style-type: none">
							<li><span class="text-secondary">
									<i class="bi-house text-secondary"></i>
									<small>'${txtBtnReset}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary">
									<i class="bi-folder-plus text-secondary"></i>
									<small>'${txtFolderWithContent}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary">
									<i class="bi-folder text-secondary"></i>
									<small>'${txtFolderWithoutContent}'</small>
								</span>
							</li>
								<span class="text-secondary">
									<i class="bi-file-earmark-font text-secondary"></i>
									<small>'${txtFileOpen}'</small>
								</span>
							<li>
								<span class="text-secondary">
									<i class="bi-file-earmark-font-fill text-secondary"></i>
									<small>'${txtFileNoWritingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary">
									<i class="bi-file-earmark-x text-danger"></i>
									<small>'${txtFileNoReadingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary">
									<i class="bi-file-earmark-zip text-warning"></i>
									<small>'${txtFileIsArchive}'</small>
								</span>
							</li>
						</ul>'

						# Hinweis: Erweitern von Berechtigungen
						# --------------------------------------
						if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then
							echo '
							<span class="text-secondary"><strong>'${txt_help_permissions_Note}'</strong></span>'
								if cat /etc/group | grep ^log | grep -q LogAnalysis ; then
									app_permissions="true"
								else
									app_permissions="false"
								fi
								if [[ "${app_permissions}" == "true" ]]; then
									echo '
									<ul style="list-style-type: none">
										<li class="pb-2">
											<strong class="text-success">'${txt_help_permissions_is_expand}'</strong><br />
											<span class="text-secondary">'${txt_help_permissions_revoke}'</span>
										</li>
										<strong class="text-secondary">'${txt_help_permissions_revoke_terminal}'</strong>'
								else
									echo '
									<ul style="list-style-type: none">
										<li class="pb-2">
											<strong class="text-danger">'${txt_help_permissions_is_revoke}'</strong><br />
											<span class="text-secondary">'${txt_help_permissions_expand}'</span>
										</li>
										<strong class="text-secondary">'${txt_help_permissions_expand_terminal}'</strong>'
								fi
										echo '
										<ul class="text-secondary list-unstyled ps-4">
											<ol>
												<li>'${txt_help_permissions_step_1}'</li>
													<ul class="list-unstyled ps-3 pt-2">
														<li>
															<small>'
																if [[ "${app_permissions}" == "true" ]]; then
																	echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/app_permissions.sh "deluser"</pre>'
																else
																	echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/app_permissions.sh "adduser"</pre>'
																fi						
																echo '
															</small>
														</li>
													</ul>
											</ol>
										</ul>'
										if [[ "${app_permissions}" == "true" ]]; then
											echo '<strong class="text-secondary">'${txt_help_permissions_revoke_dsm}'</strong>'
										else
											echo '<strong class="text-secondary">'${txt_help_permissions_expand_dsm}'</strong>'
										fi
										echo '	
										<ul class="text-secondary list-unstyled ps-4">
											<ol>
												<li>'${txt_help_permissions_step_2}'</li>
												<li>'${txt_help_permissions_step_3}'</li>
												<li>'${txt_help_permissions_step_4}'</li>
												<li>'${txt_help_permissions_step_5}'</li>
													<ul class="list-unstyled ps-3 pt-2">
														<li>
															<small>'
																if [[ "${app_permissions}" == "true" ]]; then
																	echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/app_permissions.sh "deluser"</pre>'
																else
																	echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/app_permissions.sh "adduser"</pre>'
																fi						
																echo '
															</small>
														</li>
													</ul>
												<li>'${txt_help_permissions_step_6}'</li>
												<li>'${txt_help_permissions_step_7}'</li>
												<li>'${txt_help_permissions_step_8}'</li>
												<li>'${txt_help_permissions_step_9}'</li>
												<li>'${txt_help_permissions_step_10}'</li>
											</ol>
										</ul>
									</ul><br />'
							fi
						echo '
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
					<div class="card">
						<div class="card-header clearfix">
							<i class="bi-icon bi-text-left text-secondary float-start" style="cursor: help;" title="'${txtWithLineBreaks}'"></i>
							<span class="text-secondary">&nbsp;&nbsp;'${txtSearchResult}''
								#get[file]=$(urldecode ${get[file]})
								[ -z "${get[file]}" ] && echo ' '${txtFolder}' <b>'${get[path]}'</b>' || echo ' '${txtFile}' <b>'${get[file]##*/}'</b>'
								echo '
							</span>'
							if [ -s "${result}" ]; then
								echo '
								<a class="float-end" href="index.cgi?page=main&section=start&query=view&file='${get[file]}'" title="'${btnClose}'">
									<i class="bi-icon bi-x text-secondary float-end"></i>
								</a>
								<a href="index.cgi?page=contentview&path='${get[path]}'&file='${get[file]}'&resultfile='${result}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
									<i class="bi-icon bi-justify text-secondary float-end"></i>
								</a>
								<a class="float-end" href="temp/result.txt" title="Download" download >
									<i class="bi-icon bi-download text-secondary float-end"></i>
								</a>
							</i>'
							fi
							echo '
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
					<div class="card">
						<div class="card-header clearfix">
							<i class="bi-icon bi-text-left text-secondary float-start" style="cursor: help;" title="'${txtWithLineBreaks}'"></i>
								<span class="text-secondary float-start">&nbsp;&nbsp;'${txtFileContent}' <b>'${get[file]##*/}'</b></span>'
							if [ -s "${get[file]}" ]; then
								if [ -w "${get[file]}" ]; then
									echo '
									<a href="index.cgi?page=main&section=start&query=clear&path='${get[path]}'&file='${get[file]}'" title="'${txtDeleteFileContent}'">
										<i class="bi-icon bi-journal-x text-secondary float-end"></i>
									</a>'
								fi
								echo '
								<a href="index.cgi?page=contentview&resultfile='${get[file]}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
									<i class="bi-icon bi-justify text-secondary float-end"></i>
								</a>'
							fi
							echo '
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
