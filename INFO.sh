source /pkgscripts/include/pkg_util.sh
package="LogAnalysis"
displayname="LogAnalysis"
displayname_enu="LogAnalysis"
displayname_ger="LogAnalysis"
version="1.0-600"
firmware="7.0-40000"
os_min_ver="7.0-40000"
support_center="no"
thirdparty="yes"
reloadui="yes"
arch="noarch"
dsmuidir="ui"
ctl_stop="yes"
startable="yes"
silent_install="no"
silent_upgrade="yes"
silent_uninstall="no"
package_icon="PACKAGE_ICON.PNG"
package_icon_256="PACKAGE_ICON_256.PNG"
dsmappname="SYNO.SDS._ThirdParty.App.LogAnalysis"
maintainer="Tommes"
description="The Linux system on which the DSM is based logs all events, problems and errors of the system and running services in so-called log files. This information is stored in various text files, which are usually located in the /var/log folder and in connected subfolders. The viewing of these text files is normally done in any editor, which is executed via the terminal. Within Synology DiskStation Manager (DSM), these files can now be conveniently viewed and searched using the GUI of LogAnalysis."
description_enu="The Linux system on which the DSM is based logs all events, problems and errors of the system and running services in so-called log files. This information is stored in various text files, which are usually located in the /var/log folder and in connected subfolders. The viewing of these text files is normally done in any editor, which is executed via the terminal. Within Synology DiskStation Manager (DSM), these files can now be conveniently viewed and searched using the GUI of LogAnalysis."
description_ger="Das dem DSM zugrunde liegende Linux-System protokolliert in sogenannten Protokoll- oder auch Logdateien (engl. logfiles) sämtliche Ereignisse, Probleme und Fehler des Systems sowie laufender Dienste. Abgelegt werden diese Informationen hierbei in unterschiedlichen Textdateien, welche sich in der Regel im Ordner /var/log sowie angeschlossenen Unterordnern befinden. Das Betrachten dieser Textdateien erfolgt normalerweise in einem beliebigen Editor, welcher über das Terminal ausgeführt wird. Innerhalb des Synology DiskStation Managers (DSM) können diese Dateien nun komfortabel über die GUI von LogAnalysis betrachtet und durchsucht werden."
helpurl="https://www.synology-forum.de/showthread.html?107180-LogAnalysis-GUI-zum-betrachten-und-durchsuchen-von-var-log"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
