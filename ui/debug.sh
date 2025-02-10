#!/bin/bash
# Filename: debug.sh - coded in utf-8

#                     LogAnalysis for DSM 7
#
#        Copyright (C) 2025 by Tommes | License GNU GPLv3
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
if [[ "${get[page]}" == "debug" && "${get[section]}" == "start" ]]; then

	# Debug
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary">'${txt_debug_title}'</span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">'
							# Debugging
							if [[ "${debugging}" == "on" ]]; then
								echo '
								<table class="table table-borderless table-hover table-sm">
									<thead></thead>
									<tbody>
										<tr>
											<td scope="row" class="row-sm-auto">
												'${txt_debug_mode_off}'
											</td>
											<td class="text-end">
												<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=debugging&query=off">
													<i style="font-size: 1.1rem;" class="bi bi-check-square text-secondary"></i>
												</a>
											</td>
										</tr>
									</tbody>
								</table>'
							else
								echo '
								<table class="table table-borderless table-hover table-sm">
									<thead></thead>
									<tbody>
										<tr>
											<td scope="row" class="row-sm-auto">
												'${txt_debug_mode_on}'
											</td>
											<td class="text-end">
												<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=debugging&query=on">
													<i style="font-size: 1.1rem;" class="bi bi-square text-secondary"></i>
												</a>
											</td>
										</tr>
									</tbody>
								</table>'	
							fi
							if [[ "${debugging}" == "on" ]]; then
								echo '
								<table class="table table-borderless table-hover table-sm">
									<thead></thead>
										<tbody>
											<tr>'
												# Group membership
												if [[ "${group_membership}" == "on" ]]; then
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_membership}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=group_membership&query=">
															<i style="font-size: 1.1rem;" class="bi bi-check-square text-secondary"></i>
														</a>
													</td>'
												else
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_membership}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=group_membership&query=on">
															<i style="font-size: 1.1rem;" class="bi bi-square text-secondary"></i>
														</a>
													</td>'
												fi
												echo '
											</tr>
											<tr>'
												# GET & POST requests
												if [[ "${http_requests}" == "on" ]]; then
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_requests}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=http_requests&query=">
															<i style="font-size: 1.1rem;" class="bi bi-check-square text-secondary"></i>
														</a>
													</td>'
												else
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_requests}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=http_requests&query=on">
															<i style="font-size: 1.1rem;" class="bi bi-square text-secondary"></i>
														</a>
													</td>'
												fi
												echo '
											</tr>
											<tr>'
												# Global enviroment
												if [[ "${global_enviroment}" == "on" ]]; then
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_global}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=global_enviroment&query=">
															<i style="font-size: 1.1rem;" class="bi bi-check-square text-secondary"></i>
														</a>
													</td>'
												else
													echo '
													<td scope="row" class="row-sm-auto">
														'${txt_debug_global}'
													</td>
													<td class="text-end">
														<a class="material-icons text-success" href="index.cgi?page=debug&section=save&option=global_enviroment&query=on">
															<i style="font-size: 1.1rem;" class="bi bi-square text-secondary"></i>
														</a>
													</td>'
												fi
												echo '
											</tr>
										</tbody>
									</table>'
							elif [[ "${debugging}" == "off" ]]; then
								[ -f "${usr_debugfile}" ] && rm "${usr_debugfile}"
									echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=debug&section=start">'
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
if [[ "${get[page]}" == "debug" && "${get[section]}" == "save" ]]; then
	[ -f "${get_request}" ] && rm "${get_request}"

	# Speichern der Einstellungen nach ${app_home}/settings/user_settings.txt
	[[ "${get[option]}" == "debugging" ]] && "${set_keyvalue}" "${usr_debugfile}" "debugging" "${get[query]}"
	[[ "${get[option]}" == "http_requests" ]] && "${set_keyvalue}" "${usr_debugfile}" "http_requests" "${get[query]}"
	[[ "${get[option]}" == "group_membership" ]] && "${set_keyvalue}" "${usr_debugfile}" "group_membership" "${get[query]}"
	[[ "${get[option]}" == "global_enviroment" ]] && "${set_keyvalue}" "${usr_debugfile}" "global_enviroment" "${get[query]}"
	echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=debug&section=start">'
fi
