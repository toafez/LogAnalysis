#!/bin/bash
# Filename: build_spk.sh - coded in utf-8

#                LogAnalysis
#
#        Copyright (C) 2022 by Tommes 
# Member of the German Synology Community Forum
#             License GNU GPLv3
#   https://www.gnu.org/licenses/gpl-3.0.html

# Get & set Package Version from INFO file:
version=$(grep -i "version=" "./INFO" | /bin/sed 's/version=//i' | /bin/sed 's/"//g')

# Set folder and file permissions
chmod -R 755 ./package
chmod 700 ./package/ui/modules/synowebapi
chmod -R 777 ./conf
chmod -R 777 ./scripts
chmod -R 777 ./WIZARD_UIFILES
chmod 777 ./CHANGELOG
chmod 777 ./INFO
chmod 777 ./LICENSE
chmod 777 ./PACKAGE_ICON*


# Build SPK
tar -C ./package/ -czf ./package.tgz .
chmod 755 ./package.tgz
tar --exclude="package/*" --exclude="build_spk.sh" --exclude=".git/*" --exclude=".gitignore/*" --exclude="README.md" --exclude="README_en.md" -cvf LogAnalysis_${version}.spk *
rm -f package.tgz
 
