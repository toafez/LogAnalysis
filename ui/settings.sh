#!/bin/bash
# Filename: debug.sh - coded in utf-8

#                     LogAnalysis for DSM 7
#
#        Copyright (C) 2026 by Tommes | License GNU GPLv3
#         Member of the German Synology Community Forum
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

# Horizontale Navigationsleiste laden
# --------------------------------------------------------------
mainnav

# Startseite anzeigen
# --------------------------------------------------------------
if [[ "${get[page]}" == "settings" && "${get[section]}" == "start" ]]; then


# Folder settings
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<h4>'${txt_link_settings}'</h4><br />
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_folder_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# Folder attributes on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_folder_attributes}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=folder_attributes&'; \
												if [[ "${folder_attributes}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
									<tr>'
										# Folder without access on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_folder_access}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=folder_access&'; \
												if [[ "${folder_access}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'

	# File settings
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_file_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# File attributes on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_file_attributes}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=file_attributes&'; \
												if [[ "${file_attributes}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
									<tr>'
										# File access on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_file_access}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=file_access&'; \
												if [[ "${file_access}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'




	# Debug
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_debug_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# Debugging
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_debug_mode_on}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=debugging&'; \
												if [[ "${debugging}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>'
							if [[ "${debugging}" == "on" ]]; then
								echo '
								<table class="table table-borderless table-hover table-sm">
									<thead></thead>
										<tbody>
											<tr>'
												# Group membership
												echo -n '
												<td scope="row" class="row-sm-auto align-middle">
													'${txt_debug_membership}'
												</td>
												<td class="text-end">'
													echo -n '
													<a href="index.cgi?page=settings&section=save&option=group_membership&'; \
														if [[ "${group_membership}" == "on" ]]; then
															echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
														else
															echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
														fi
														echo -n '
													</a>
												</td>
											</tr>
											<tr>'
												# GET & POST requests
												echo -n '
												<td scope="row" class="row-sm-auto align-middle">
													'${txt_debug_requests}'
												</td>
												<td class="text-end">'
													echo -n '
													<a href="index.cgi?page=settings&section=save&option=http_requests&'; \
														if [[ "${http_requests}" == "on" ]]; then
															echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
														else
															echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
														fi
														echo -n '
													</a>
												</td>
											</tr>
											<tr>'
												# GET & POST requests
												echo -n '
												<td scope="row" class="row-sm-auto align-middle">
													'${txt_debug_global}'
												</td>
												<td class="text-end">'
													echo -n '
													<a href="index.cgi?page=settings&section=save&option=global_enviroment&'; \
														if [[ "${global_enviroment}" == "on" ]]; then
															echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
														else
															echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
														fi
														echo -n '
													</a>
												</td>
											</tr>
										</tbody>
									</table>'
							#elif [[ "${debugging}" == "off" ]]; then
							#	[ -f "${usr_appsettings}" ] && rm "${usr_appsettings}"
							#		echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=settings&section=start">'
							fi
							echo '
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'
fi

# Debug - Ausführung
# --------------------------------------------------------------
if [[ "${get[page]}" == "settings" && "${get[section]}" == "save" ]]; then
	[ -f "${get_request}" ] && rm "${get_request}"

	# Speichern der Einstellungen nach ${app_home}/settings/user_settings.txt
	[[ "${get[option]}" == "folder_attributes" ]] && "${set_keyvalue}" "${usr_appsettings}" "folder_attributes" "${get[query]}"
	[[ "${get[option]}" == "folder_access" ]] && "${set_keyvalue}" "${usr_appsettings}" "folder_access" "${get[query]}"

	[[ "${get[option]}" == "file_attributes" ]] && "${set_keyvalue}" "${usr_appsettings}" "file_attributes" "${get[query]}"
	[[ "${get[option]}" == "file_access" ]] && "${set_keyvalue}" "${usr_appsettings}" "file_access" "${get[query]}"

	[[ "${get[option]}" == "debugging" ]] && "${set_keyvalue}" "${usr_appsettings}" "debugging" "${get[query]}"
	[[ "${get[option]}" == "http_requests" ]] && "${set_keyvalue}" "${usr_appsettings}" "http_requests" "${get[query]}"
	[[ "${get[option]}" == "group_membership" ]] && "${set_keyvalue}" "${usr_appsettings}" "group_membership" "${get[query]}"
	[[ "${get[option]}" == "global_enviroment" ]] && "${set_keyvalue}" "${usr_appsettings}" "global_enviroment" "${get[query]}"
	echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=settings&section=start">'
fi
