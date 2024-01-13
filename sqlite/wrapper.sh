#!/bin/sh

sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/elements.csv elements"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/relations.csv relations"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/properties.csv properties"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/folders.csv folders"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/folder-content.csv folder_content"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/views.csv views"
sqlite3 -csv archi-exported.sqlite ".import /usr/var/intermediate_files/view-content.csv view_content"

echo "Executing verification scripts..."
find /usr/var/verification_scripts -type f | sort | xargs -I {} sh -c 'echo "{}"; sqlite3 --init "{}" archi-exported.sqlite ""'
echo "Verification completed"

if [ "$INTERACTIVE_SQLITE" == "true" ]
then
    sqlite3 archi-exported.sqlite
fi
