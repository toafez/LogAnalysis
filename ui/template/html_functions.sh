#!/bin/bash
# Filename: html.function.sh - coded in utf-8

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


# Popupbox Ausgabe
# --------------------------------------------------------------
function popupbox () {
	echo '
	<div class="container">
		<div class="row">
			<div class="col">
			</div>
			<div class="col">
				<p>&nbsp;</p><p>&nbsp;</p>
				<div class="card" style="width: '${1}'rem;">
					<div class="card-header text-secondary">'${2}'</div>
					<div class="card-body">
						<p class="card-text text-center text-secondary">'${3}'</p>
						<p class="card-text text-center text-secondary">'${4}'</p>
					</div>
				</div>
			</div>
			<div class="col">
			</div>
			<!-- col -->
		</div>
		<!-- row -->
	</div>
	<!-- container -->'
	exit
}
