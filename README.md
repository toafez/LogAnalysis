[English](https://github.com/toafez/LogAnalysis/blob/main/README_en.md) | Deutsch

# ![Package icon](/package/ui/images/logo_24.png) LogAnalysis - Paket für Synology NAS (DSM 7)
Das dem DSM zugrunde liegende Linux-System protokolliert in sogenannten Protokoll- oder auch Logdateien (engl. logfiles) sämtliche Ereignisse, Probleme und Fehler des Systems sowie laufender Dienste. Abgelegt werden diese Informationen hierbei in unterschiedlichen Textdateien, welche sich in der Regel im Ordner /var/log sowie angeschlossenen Unterordnern befinden. Das Betrachten dieser Textdateien erfolgt normalerweise in einem beliebigen Editor, welcher über das Terminal ausgeführt wird. Innerhalb des Synology DiskStation Managers (DSM) können diese Dateien nun komfortabel über die GUI von LogAnalysis betrachtet und durchsucht werden.

# Systemvoraussetzungen
**LogAnalysis** wurde speziell für die Verwendung auf **Synology NAS Systemen** entwickelt die das Betriebsystem **DiskStation Mangager 7** verwenden.

  - ### Hinweise zur Installation von LogAnalysis auf DSM 6 Systemen
    - **LogAnalysis** kann in der jeweils aktuellsten Version über die alternative Paketquelle - **Community Package Hub** - (https://www.cphub.net/?p=loganalysis) heruntergeladen und im Anschluss über das **DSM Paket-Zentrum** manuell installiert werden.
    - Weiterhin kann **LogAnalysis** auch direkt über das **DSM Paket-Zentrum** als Installationspaket, sowie für die Bereitstellung zukünftiger Updates zur Verfügung gestellt werden. Hierfür muß im Vorfeld https://www.cphub.net dem Paket-Zentrum als **"alternative Paketquelle"** hinzugefügt werden.


# Installationshinweise
Laden Sie sich die **jeweils aktuellste Version** von LogAnalysis aus dem Bereich [Releases](https://github.com/toafez/LogAnalysis/releases) herunter. Öffnen Sie anschließend im **DiskStation Manager (DSM)** das **Paket-Zentrum**, wählen oben rechts die Schaltfläche **Manuelle Installation** aus und folgen dem **Assistenten**, um das neue **Paket** bzw. die entsprechende **.spk-Datei** hochzuladen und zu installieren. Dieser Vorgang ist sowohl für eine Erstinstallation als auch für die Durchführung eines Updates identisch. 

**Nach dem Start** von LogAnaysis wird die lokal **installierte Version** mit der auf GitHub **verfügbaren Version** verglichen. Steht ein Update zur Verfügung, wird der Benutzer über die App darüber **informiert** und es wird ein entsprechender **Link** zu dem ensprechenden Release eingeblendet. Der Download sowie der anschließende Updatevorgang wurde bereits weiter oben erläutert. 

  - ## App-Berechtigung erweitern
    Unter DSM 7 wird eine 3rd_Party Anwendung wie LogAnalysis (im folgenden App genannt) mit stark eingeschränkten Benutzer- und Gruppenrechten ausgestattet. Dies hat u.a. zur Folge, das systemnahe Befehle nicht ausgeführt werden können. Für den reibungslosen Betrieb von LogAnalysis werden jedoch erweiterte Systemrechte benötigt um z.B. auf die Ordnerstuktur des Ordners "/var/log" zugreifen zu können. Zum erweitern der App-Berechtigungen muss LogAnalysis in die Gruppe **log** aufgenommen werden, was jedoch nur durch den Benutzer selbst durchgeführt werden kann. Die nachfolgende Anleitung beschreibt diesen Vorgang.

    - ### Erweitern der App-Berechtigungen über die Konsole

      - Melden Sie sich als Benutzer **root** auf der Konsole Ihrer Synology NAS an.
      - Befehl zum erweitern der App-Berechtigungen

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/app_permissions.sh`
 
    - ### Erweitern der App-Berechtigungen über den Aufgabenplaner

      - Im **DSM** unter **Hauptmenü** > **Systemsteuerung** den **Aufgabenplaner** öffnen.
      - Im **Aufgabenplaner** über die Schaltfläche **Erstellen** > **Geplante Aufgabe** > **Benutzerdefiniertes Script** auswählen.
      - In dem nun geöffneten Pop-up-Fenster im Reiter **Allgemein** > **Allgemeine Einstellungen** der Aufgabe einen Namen geben und als Benutzer: **root** auswählen. Außerdem den Haken bei Aktiviert entfernen.
      - Im Reiter **Aufgabeneinstellungen** > **Befehl ausführen** > **Benutzerdefiniertes Script** nachfolgenden Befehl in das Textfeld einfügen...
      - Befehl zum erweitern der App-Berechtigungen

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/app_permissions.sh`
   
      - Eingaben mit **OK** speichern und die anschließende Warnmeldung ebenfalls mit **OK** bestätigen.
      - Die grade erstellte Aufgabe in der Übersicht des Aufgabenplaners markieren, jedoch **nicht** aktivieren (die Zeile sollte nach dem markieren blau hinterlegt sein).
      - Führen Sie die Aufgabe durch Betätigen Sie Schaltfläche **Ausführen** einmalig aus.

# Versionsgeschichte
- Details zur Versionsgeschichte finden Sie in der Datei [CHANGELOG](CHANGELOG).

# Entwickler-Information
- Details zum Backend entnehmen Sie bitte dem [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/)
- Details zum Frontend entnehmen Sie bitte dem [Bootstrap Framework](https://getbootstrap.com/)
- Details zu jQuery entnehmen Sie bitte der [jQuery API](https://api.jquery.com/)

# Hilfe und Diskussion
- Hilfe und Diskussion gerne über [Das deutsche Synology Support Forum](https://www.synology-forum.de/threads/loganalysis-gui-zum-betrachten-und-durchsuchen-von-var-log.107180/) oder über [heimnetz.de](https://forum.heimnetz.de/threads/loganalysis-3rdparty-app-fuer-synology-nas-dsm-7.484/)

# Lizenz
Dieses Programm ist freie Software. Sie können es unter den Bedingungen der **GNU General Public License**, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß **Version 3** der Lizenz oder (nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein wird, aber **OHNE IRGENDEINE GARANTIE**, sogar **ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK**. Details finden Sie in der Datei [GNU General Public License](LICENSE).
