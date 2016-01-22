#!/bin/bash

function update_failure {
        echo Update failed...
        exit 1
}

function update_checksums {
        for web_directory in $(ls /var/www/); do
                echo Analyzing $web_directory
                find /var/www/$web_directory -type f -exec md5sum {} >> /opt/updater/checksums/$web_directory \;
        done
}

function find_changes {
        for checksum in $(ls /opt/updater/checksums/); do
                if diff /opt/updater/checksums/$checksum /opt/updater/checksums_last/$checksum; then
                        echo No changes for $checksum
                        else
                                logger "DEVELOPMENT code update for $checksum"
                                echo Changes found for $checksum
                                echo Updating $checksum
                                /opt/updater/scripts/$checksum\.sh || update_failure
                fi
        done
}

echo "Let's take a look..."
update_checksums
echo DONE
find_changes
echo "Cleaning up..."
rm /opt/updater/checksums_last/*
mv /opt/updater/checksums/* /opt/updater/checksums_last/
