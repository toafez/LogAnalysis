#!/bin/bash
# Filename: index.cgi - coded in utf-8

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


# System initiieren
# --------------------------------------------------------------
	PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/syno/bin:/usr/syno/sbin

	app_name="LogAnalysis"
	app_title="LogAnalyis"
	app_home=$(echo /volume*/@appstore/${app_name}/ui)
	app_link=$(echo /webman/3rdparty/${app_name})
	[ ! -d "${app_home}" ] && exit


# App Authentifizierung auswerten
# --------------------------------------------------------------

	# Zum auswerten der login.cgi, REQUEST_METHOD auf GET ändern
	if [[ "${REQUEST_METHOD}" == "POST" ]]; then
		REQUEST_METHOD="GET"
		OLD_REQUEST_METHOD="POST"
	fi

	# Auslesen und prüfen der Login Berechtigung ( login.cgi )
	syno_login=$(/usr/syno/synoman/webman/login.cgi)

	# Login Berechtigung ( result=success )
	if echo ${syno_login} | grep -q result ; then
		login_result=$(echo "${syno_login}" | grep result | cut -d ":" -f2 | cut -d '"' -f2)
	fi
	[[ ${login_result} != "success" ]] && { echo 'Access denied'; exit; }

	# Login erfolgreich ( success=true )
	if echo ${syno_login} | grep -q success ; then
		login_success=$(echo "${syno_login}" | grep success | cut -d "," -f3 | grep success | cut -d ":" -f2 | cut -d " " -f2 )
	fi
	[[ ${login_success} != "true" ]] && { echo 'Access denied'; exit; }

	# REQUEST_METHOD wieder zurück auf POST setzen
	if [[ "${OLD_REQUEST_METHOD}" == "POST" ]]; then
		REQUEST_METHOD="POST"
		unset OLD_REQUEST_METHOD
	fi

# App-Berechtigungen auswerten
# --------------------------------------------------------------
if cat /etc/group | grep ^log | grep -q ${app_name} ; then
	permissions="true"
else
	permissions="false"
fi

# Umgebungsvariablen festlegen
# --------------------------------------------------------------
	# Ordner für temporäre Daten einrichten
	app_temp="${app_home}/temp"
	[ ! -d "${app_temp}" ] && mkdir -p -m 755 "${app_temp}"
	result="${app_temp}/result.txt"
	
	# POST und GET Requests auswerten und in Dateien zwischenspeichern
	set_keyvalue="/usr/syno/bin/synosetkeyvalue"
	get_keyvalue="/bin/get_key_value"
	get_request="$app_temp/get_request.txt"
	post_request="$app_temp/post_request.txt"

	# Ordner für Benutzerdaten einrichten
	usr_settings="${app_home}/usersettings"
	[ ! -d "${usr_settings}" ] && mkdir -p -m 755 "${usr_settings}"

	# Ordner für Benutzerdefinierte Einstellungen einrichten
	usr_systemconfig="${usr_settings}/system"
	[ ! -d "${usr_systemconfig}" ] && mkdir -p -m 755 "${usr_systemconfig}"
	
	# Konfigurationsdatei für benutzerdefinierte Einstellungen einrichten
	usr_appsettings="${usr_systemconfig}/loganalysis.config"
	if [ ! -f "${usr_appsettings}" ]; then
		touch "${usr_appsettings}"
		chmod 777 "${usr_appsettings}"
	fi
	[ -f "${usr_appsettings}" ] && source "${usr_appsettings}"

	# Wenn keine Seite gesetzt, dann Startseite anzeigen
	if [ -z "${get[page]}" ]; then
		"${set_keyvalue}" "${get_request}" "get[page]" "main"
		"${set_keyvalue}" "${get_request}" "get[section]" "start"
	fi


# Verarbeitung von GET/POST-Request Variablen
# --------------------------------------------------------------
	# urlencode und urldecode Funktion aus der ../modules/parse_url.sh laden
	[ -f "${app_home}/modules/parse_url.sh" ] && source "${app_home}/modules/parse_url.sh" || exit

	[ -z "${POST_STRING}" -a "${REQUEST_METHOD}" = "POST" -a ! -z "${CONTENT_LENGTH}" ] && read -n ${CONTENT_LENGTH} POST_STRING

	# Sicherung des Internal Field Separator (IFS) sowie das separieren der
	# GET/POST key/value Anfragen, durch Lokalisierung des Trennzeichen "&"
	if [ -z "${backupIFS}" ]; then
		backupIFS="${IFS}"
		IFS='=&'
		GET_vars=(${QUERY_STRING})
		POST_vars=(${POST_STRING})
		readonly backupIFS
		IFS="${backupIFS}"
	fi

	# Analysieren eingehende GET-Anfragen und Verarbeitung zu ${get[key]}="$value" Variablen
	declare -A get
	for ((i=0; i<${#GET_vars[@]}; i+=2)); do
		GET_key=get[${GET_vars[i]}]
		GET_value=${GET_vars[i+1]}
		#GET_value=$(urldecode ${GET_vars[i+1]})

		# Zurücksetzen gespeicherter GET/POST-Requests falls main gesetzt
		if [[ "${get[page]}" == "main" ]] && [ -z "${get[section]}" ]; then
			[ -f "${get_request}" ] && rm "${get_request}"
			[ -f "${post_request}" ] && rm "${post_request}"
		fi

		# Speichern von GET-Requests zur späteren Weiterverarbeitung
		"${set_keyvalue}" "${get_request}" "$GET_key" "$GET_value"
	done

	# Analysieren eingehende POST-Anfragen und Verarbeitung zu ${post[key]}="$value" Variablen
	declare -A post
	for ((i=0; i<${#POST_vars[@]}; i+=2)); do
		POST_key=post[${POST_vars[i]}]
		#POST_value=${POST_vars[i+1]}
		POST_value=$(urldecode ${POST_vars[i+1]})

		# Speichern von POST-Requests zur späteren Weiterverarbeitung
		"${set_keyvalue}" "${post_request}" "$POST_key" "$POST_value"
	done

	# Einbinden der temporär gespeicherten GET/POST-Requests ( key="value" ) sowie der Benutzereinstellungen
	[ -f "${get_request}" ] && source "${get_request}"
	[ -f "${post_request}" ] && source "${post_request}"


# Layoutausgabe
# --------------------------------------------------------------
if [ $(synogetkeyvalue /etc.defaults/VERSION majorversion) -ge 7 ]; then

	# Spracheinstellungen aus der ../modules/parse_language.sh laden
	[ -f "${app_home}/modules/parse_language.sh" ] && source "${app_home}/modules/parse_language.sh" || exit
	language "GUI"

	# Websitefunktionen aus der ../modules/html.function.sh laden
	[ -f "${app_home}/template/html_functions.sh" ] && source "${app_home}/template/html_functions.sh" || exit

	echo "Content-type: text/html"
	echo
	echo '
	<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>'${app_title}'</title>
		<link rel="shortcut icon" href="images/logo_32.png" type="image/x-icon" />
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

		<!-- Einbinden eigener CSS Formatierungen -->
		<link rel="stylesheet" href="template/css/mystyle.css" />

		<!-- Einbinden von bootstrap Framework 5.3.8 -->
		<link rel="stylesheet" href="template/bootstrap/css/bootstrap.min.css" />

		<!-- Einbinden von bootstrap Icons 1.13.1 -->
		<link rel="stylesheet" href="template/bootstrap/font/bootstrap-icons.css" />

		<!-- Einbinden von jQuery 4.0.0 -->
		<script src="template/jquery/jquery-4.0.0.slim.min.js"></script>

		<!-- Einbinden von resize für box mit Logfile-Inhalt (class="card-body px-0 py-1" in main.sh) -->
		<script src="template/js/resize.js"></script>
	</head>
	<body>
	<header></header>
	<article>
		<!-- container -->
		<div class="container-fluid">
			<form action="index.cgi" method="post" id="myform" autocomplete="on">'

				# Funktion: Hauptnavigation anzeigen
				# --------------------------------------------------------------
				function mainnav()
				{
					echo '
					<nav class="navbar fixed-top navbar-expand-sm navbar-light bg-light">
						<div class="container-fluid">
							<a class="btn btn-sm text-dark text-decoration-none py-0" role="button" style="background-color: #e6e6e6;" href="index.cgi?page=main&section=reset" title="'${txt_button_refresh}'">
								<i class="bi bi-house-door text-dark" style="font-size: 1.2rem;"></i>
							</a>
							<div class="float-end">
								<ul class="navbar-nav">
									<li class="nav-item dropdown pt-1">
										<a class="dropdown-toggle btn btn-sm text-dark text-decoration-none" style="background-color: #e6e6e6;" href="#" id="navDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
											'${txt_link_system_settings}'
										</a>
										<ul class="dropdown-menu dropdown-menu-sm-end" aria-labelledby="navDropdown">
											<li><a class="dropdown-item" href="index.cgi?page=settings&section=start">'${txt_link_settings}'</a></li>'
											if [[ "${permissions}" == "true" ]]; then
												echo '<li><button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#help-app_permissions">'${txt_link_revoke_permissions}'</button></li>'
											else
												echo '<li><button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#help-app_permissions">'${txt_link_expand_permissions}'</button></li>'
											fi
											echo '
										</ul>
									</li>
								</ul>
							</div>
						</div>
					</nav>
					<p>&nbsp;</p>
					<br />'
				}

				# Funktion: Hilfeartikel im Popupfenster anzeigen
				# --------------------------------------------------------------
				function help_modal ()
				{
					echo '
					<!-- Modal -->
					<div class="modal fade" id="help-'${1}'" tabindex="-1" aria-labelledby="help-'${1}'-label" aria-hidden="true">
						<div class="modal-dialog modal-fullscreen">
							<div class="modal-content">
								<div class="modal-header bg-light">
									<h5 class="modal-title" style="color: #FF8C00;" id="help-'${1}'-label"><span class="navbar-brand">'${2}'</span></h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" title="'${txt_button_Close}'"></button>
								</div>
								<div class="modal-body">'
									[ -f "${app_home}/help/${1}.sh" ] && source "${app_home}/help/${1}.sh" || echo "Page not found"
									echo '
								</div>
							</div>
						</div>
					</div>'
				}

				# Hilfeartikel laden
				# --------------------------------------------------------------
				if [[ "${permissions}" == "true" ]]; then
					help_modal "app_permissions" "${txt_link_revoke_permissions}"
				else
					help_modal "app_permissions" "${txt_link_expand_permissions}"
				fi

				# Dynamische Seitenausgabe
				if [ -f "${post[page]}.sh" ]; then
					. ./"${post[page]}.sh"
				elif [ -f "${get[page]}.sh" ]; then
					. ./"${get[page]}.sh"
				else
					echo 'Page '${get[page]}''${post[page]}'.sh not found!'
				fi

				# Debugging
				if [[ "${debugging}" == "on" ]]; then
					echo '
					<p>&nbsp;</p>
					<div class="card border-0 mb-3">
						<div class="card-header border-0">
							<i class="bi-icon bi-bug text-secondary float-start" style="cursor: help;" title="Debug"></i>
							<span class="text-secondary">&nbsp;&nbsp;<b>Debug</b></span>
						</div>
						<div class="card-body pb-0">'
							if [ -z "${group_membership}" ] && [ -z "${http_requests}" ] && [ -z "${global_enviroment}" ]; then
								echo "<p>Bitte wählen Sie eine oder mehrere Debug Optionen aus der Liste aus!</p>"
							fi

							# Gruppenmitgliedschaften der App
							if [[ "${group_membership}" == "on" ]]; then
								echo '
								<ul class="list-unstyled">
									<li class="text-dark list-style-square"><strong>'${txt_debug_membership}'</strong>
										<ul class="list-unstyled ps-3">'
											if cat /etc/group | grep ^${app_name} | grep -q ${app_name} ; then
												echo ''${app_name}'<br />'
											fi
											if cat /etc/group | grep ^system | grep -q ${app_name} ; then
												echo 'system<br />'
											fi
											if cat /etc/group | grep ^administrators | grep -q ${app_name} ; then
												echo 'administrators<br />'
											fi
											if cat /etc/group | grep ^log | grep -q ${app_name} ; then
												echo 'log<br />'
											fi
											echo '
										</ul>
									</li>
								</ul>'
							fi

							# GET und POST Requests
							if [[ "${http_requests}" == "on" ]]; then
								echo '
								<ul class="list-unstyled">
									<li class="text-dark list-style-square"><strong>'${txt_debug_get}'</strong>
										<ul class="list-unstyled ps-3">
											<pre>'; cat ${get_request}; echo '</pre>
										</ul>
									</li>
									<li class="text-dark list-style-square"><strong>'${txt_debug_post}'</strong>
										<ul class="list-unstyled ps-3">
											<pre>'; cat ${post_request}; echo '</pre>
										</ul>
									</li>
								</ul>'
							fi

							# Globale Umgebung
							if [[ "${global_enviroment}" == "on" ]]; then
								echo '
								<ul class="list-unstyled">
									<li class="text-dark list-style-square"><strong>'${txt_debug_global}'</strong>
										<ul class="list-unstyled ps-3">
											<pre>'; (set -o posix ; set | sed '/txt.*/d;'); echo '</pre>
										</ul>
									</li>
								</ul>'
							fi
							echo '
						</div>
						<!-- card-body -->
					</div>
					<!-- card -->'
				fi
				echo '
			</form>
		</div>
		<!-- container -->
	</article>

	<!-- Einbinden von bootstrap JavaScript 5.3.8 -->
	<script src="template/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Script für Popupfenster (z.B. für die Hilfe) -->
	<script src="template/js/popup.js"></script>

	<!-- Ladeanzeige ein- bzw. ausblenden -->
	<script src="template/js/loading.js"></script>

	</body>
	</html>'
fi
exit
