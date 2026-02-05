#!/bin/bash
# Filename: app_permissions.sh - coded in utf-8

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

echo '
<div class="row">
	<div class="col">'
		if [[ "${permissions}" == "true" ]]; then
			echo '<h5>'${txt_help_permissions_revoke_terminal}'</h5>'
		else
			echo '<h5>'${txt_help_permissions_expand_terminal}'</h5>'
		fi
		echo '
		<ul class="list-unstyled ps-4">
			<ol>
				<li>'${txt_help_permissions_step_1}'</li>
					<ul class="list-unstyled ps-3 pt-2">
						<li>
							<small>'
								if [[ "${permissions}" == "true" ]]; then
									echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/permissions.sh "deluser"</pre>'
								else
									echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/permissions.sh "adduser"</pre>'
								fi						
								echo '
							</small>
						</li>
					</ul>
			</ol>
		</ul>
		<br />'
		if [[ "${permissions}" == "true" ]]; then
			echo '<h5>'${txt_help_permissions_revoke_dsm}'</h5>'
		else
			echo '<h5>'${txt_help_permissions_expand_dsm}'</h5>'
		fi
		echo '	
		<ul class="list-unstyled ps-4">
			<ol>
				<li>'${txt_help_permissions_step_2}'</li>
				<li>'${txt_help_permissions_step_3}'</li>
				<li>'${txt_help_permissions_step_4}'</li>
				<li>'${txt_help_permissions_step_5}'</li>
					<ul class="list-unstyled ps-3 pt-2">
						<li>
							<small>'
								if [[ "${permissions}" == "true" ]]; then
									echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/permissions.sh "deluser"</pre>'
								else
									echo '<pre class="text-dark p-1 border border-1 rounded bg-light">/usr/syno/synoman/webman/3rdparty/'${app_name}'/permissions.sh "adduser"</pre>'
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
		<p class="text-end"><br />
			<button type="button" class="btn btn-sm text-dark" style="background-color: #e6e6e6;" data-bs-dismiss="modal">'${txt_button_Close}'</button>
		</p>
	</div>
</div>'