[English](https://github.com/toafez/LogAnalysis/blob/main/README_en.md) | Deutsch 

# ![Package icon](/ui/images/logo_24.png) LogAnalysis
![GitHub Release](https://img.shields.io/github/v/release/toafez/LogAnalysis?link=https%3A%2F%2Fgithub.com%2Ftoafez%2FLogAnalysis%2Freleases)

Das dem DSM zugrunde liegende Linux-System protokolliert in sogenannten Protokoll- oder auch Logdateien (engl. logfiles) sämtliche Ereignisse, Probleme und Fehler des Systems sowie laufender Dienste. Abgelegt werden diese Informationen hierbei in unterschiedlichen Textdateien, welche sich in der Regel im Ordner /var/log sowie angeschlossenen Unterordnern befinden. Das Betrachten dieser Textdateien erfolgt normalerweise in einem beliebigen Editor, welcher über das Terminal ausgeführt wird. Innerhalb des Synology DiskStation Managers (DSM) können diese Dateien nun komfortabel über die GUI von LogAnalysis betrachtet und durchsucht werden.

## Systemvoraussetzungen
**LogAnalysis** wurde speziell für die Verwendung auf **Synology NAS Systemen** entwickelt die das Betriebsystem **DiskStation Mangager 7** verwenden.

## Installationshinweise
Eine ausführliche Anleitung zum Installieren, Einrichten und Ausführen von LogAnalysis ist im [Wiki des deutschen Synology Forums](https://www.synology-forum.de/wiki/Hauptseite) hinterlegt. Diese können über die folgenden externen Links abgerufen werden.

- [LogAnalysis herunterladen, installieren und einrichten](https://www.synology-forum.de/wiki/LogAnalysis_herunterladen,_installieren_und_einrichten)
 
## Screenshots
  - #### Startseite - alle Dateien innerhalb /var/log durchsuchen
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_01.png)
  - #### Inhalt einer bestimmten Log-Datei anzeigen lassen
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_02.png)
  - #### Innerhalb einer bestimmten Log-Datei suchen
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_03.png)
    
## Versionsgeschichte
- Details zur Versionsgeschichte finden Sie in der Datei [CHANGELOG](CHANGELOG).

## Entwickler-Information
- Details zum Backend entnehmen Sie bitte dem [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/)
- Details zum Frontend entnehmen Sie bitte dem [Bootstrap Framework](https://getbootstrap.com/)
- Details zu jQuery entnehmen Sie bitte der [jQuery API](https://api.jquery.com/)

## Hilfe und Diskussion
- Hilfe und Diskussion gerne über [Das deutsche Synology Support Forum](https://www.synology-forum.de/threads/loganalysis-gui-zum-betrachten-und-durchsuchen-von-var-log.107180/) oder über [heimnetz.de](https://forum.heimnetz.de/threads/loganalysis-3rdparty-app-fuer-synology-nas-dsm-7.484/)

## Lizenz
Dieses Programm ist freie Software. Sie können es unter den Bedingungen der **GNU General Public License**, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß **Version 3** der Lizenz oder (nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein wird, aber **OHNE IRGENDEINE GARANTIE**, sogar **ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK**. Details finden Sie in der Datei [GNU General Public License](LICENSE).
