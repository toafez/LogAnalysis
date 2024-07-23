English | [Deutsch](https://github.com/toafez/LogAnalysis/blob/main/README.md)

# ![Package icon](/ui/images/logo_24.png) LogAnalysis - Package for Synology NAS (DSM 7)
The Linux system on which the DSM is based logs all events, problems and errors of the system and running services in so-called log files. This information is stored in various text files, which are usually located in the /var/log folder and connected subfolders. Viewing these text files is usually done in any editor, which is executed via the terminal. Within the Synology DiskStation Manager (DSM), these files can now be viewed and searched comfortably via the GUI of LogAnalysis.

# System requirements
**LogAnalysis** has been specially developed for use on **Synology NAS systems** that use the operating system **DiskStation Mangager 7**.

  - ### Notes on the installation of LogAnalysis on DSM 6 systems
    - The latest version of **LogAnalysis** can be downloaded from the alternative package source - **Community Package Hub** - (https://www.cphub.net/?p=loganalysis) and then installed manually via the **DSM Package Centre**.
    - Furthermore, **LogAnalysis** can also be made available directly via the **DSM Package Centre** as an installation package, as well as for the provision of future updates. For this purpose, https://www.cphub.net must be added to the package centre as an **"alternative package source "** in advance.


# Installation instructions
Download the **most recent version** of LogAnalysis from the [Releases](https://github.com/toafez/LogAnalysis/releases) section. Then open the **Package Centre** in the **DiskStation Manager (DSM)**, select the **Manual Installation** button at the top right and follow the **Wizard** to upload and install the new **Package** or the corresponding **.spk file**. This process is identical for both an initial installation and for performing an update. 

**After the start** of LogAnaysis, the locally **installed version** is compared with the version **available** on GitHub. If an update is available, the user is **informed** about it via the app and a corresponding **link** to the corresponding release is displayed. The download and the subsequent update process have already been explained above. 

  - ## Extend app authorisation
    Under DSM 7, a 3rd_party application such as LogAnalysis (called app in the following) is equipped with strongly restricted user and group rights. Among other things, this has the consequence that system-related commands cannot be executed. For the smooth operation of LogAnalysis, however, extended system rights are required, e.g. to access the folder structure of the "/var/log" folder. To extend the app permissions, LogAnalysis must be added to the **log** group, but this can only be done by the user himself. The following instructions describe this process.

    - ### Extending App Permissions via the Console

      - Log in to the console of your Synology NAS as user **root**.
      - Command to extend the app permissions

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/permissions.sh "adduser"`
        
      - Command to revoke the extended app permissions again

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/permissions.sh "deluser"`
 
    - ### Extending app permissions via the task scheduler

      - Open the **Task Scheduler** in **DSM** under **Main Menu** > **Control Panel**.
      - In the **Task Scheduler**, select **Create** > **Scheduled Task** > **Custom Script** via the button.
      - In the pop-up window that now opens in the **General** > **General Settings** tab, give the task a name and select **root** as the user: **root** as the user. Also remove the tick from Activated.
      - In the **Task Settings** tab > **Execute Command** > **Custom Script**, insert the following command into the text field...
      - Command to extend app permissions

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/permissions.sh "adduser"`
       
      - Command to revoke the extended app permissions again

        `/usr/syno/synoman/webman/3rdparty/LogAnalysis/permissions.sh "deluser"`
   
      - Save the entries with **OK** and also confirm the subsequent warning message with **OK**.
      - Mark the task you have just created in the overview of the task planner, but **do not** activate it (the line should be highlighted in blue after marking).
      - Execute the task once by pressing the **Execute** button.

# Screenshots
  - ### Start page - search all files within /var/log
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_01_en.png)
  - ### Display the contents of a specific log file
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_02_en.png)
  - ### Search within a specific log file
    ![alt text](https://github.com/toafez/LogAnalysis/blob/main/images/App_Snapshot_03_en.png)

# Version history
- Details of the version history can be found in the file [CHANGELOG](CHANGELOG).

# Developer information
- For backend details, please refer to the [Synology DSM 7.0 Developer Guide](https://help.synology.com/developer-guide/).
- For details on the frontend, please refer to the [Bootstrap Framework](https://getbootstrap.com/)
- For details on jQuery, please refer to the [jQuery API](https://api.jquery.com/)

# Help and discussion
- For help and discussion, please refer to [The German Synology Support Forum](https://www.synology-forum.de/threads/loganalysis-gui-zum-betrachten-und-durchsuchen-von-var-log.107180/) or [heimnetz.de](https://forum.heimnetz.de/threads/loganalysis-3rdparty-app-fuer-synology-nas-dsm-7.484/)

# License
This program is free software. You can redistribute it and/or modify it under the terms of the **GNU General Public License** as published by the Free Software Foundation; either **version 3** of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful to you, but ** WITHOUT ANY WARRANTY**, even **without the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE**. For details, see the [GNU General Public License](LICENSE) file.
