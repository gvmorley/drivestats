#!/bin/bash

# Drivestats Splunk App for the SPL_UK User Group
# Copyright (C) 2019 Graham Morley

# A full copy of the license can be found in the LICENSE.md file
# in the root of the app directory.

#
# Splunk Notes
# - Use transforms.conf per Year Zip File
#

#
# Create some time variables
#
TIME_GENERAL="$(date +"%Y%m%dT%H%M%S%z")"

#
# Set Logging Variables
#
LOG_DIR="/tmp"
LOG_FILE="bb-download-log.$TIME_GENERAL"
TEST_MODE=0
DEBUG=0

#
# The Location Where *.zip Files Will Be Downloaded To
# - There's no logic to create this. It must already exist
# - You can use the same path in inputs.conf
#
DOWNLOAD_DIR="/opt/inputs/drivestats"

#
# URL Array to Download
# - Edit as required
#
DOWNLOAD_URL[0]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_2013.zip"
DOWNLOAD_URL[1]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_2014.zip"
#DOWNLOAD_URL[2]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_2015.zip"
#DOWNLOAD_URL[3]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2016.zip"
#DOWNLOAD_URL[4]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2016.zip"
#DOWNLOAD_URL[5]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q3_2016.zip"
#DOWNLOAD_URL[6]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q4_2016.zip"
#DOWNLOAD_URL[7]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2017.zip"
#DOWNLOAD_URL[8]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2017.zip"
#DOWNLOAD_URL[9]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q3_2017.zip"
#DOWNLOAD_URL[10]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q4_2017.zip"
#DOWNLOAD_URL[11]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2018.zip"
#DOWNLOAD_URL[12]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2018.zip"
#DOWNLOAD_URL[13]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q3_2018.zip"
#DOWNLOAD_URL[14]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q4_2018.zip"
#DOWNLOAD_URL[15]="https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2019.zip"

#
# Functions
#
help_msg () {
  echo "This script accepts some basic options:"
  echo ""
  echo "-h          : This help message"
  echo "-d          : Download Directory (Default: /opt/inputs/drivestats)"
  echo ""
  exit 2
}

script_failure () {
  echo ""
  echo "+----------------------------------"
  echo "Script Failure - Exiting"
  echo "----------------------------------+"
  echo ""
  echo "+----------------------------------"
  echo "-- E $(date +"%Y-%m-%dT%H:%M:%S%z") -----"
  echo "----------------------------------+"
  exit 1
}

script_end () {
  echo ""
  echo "+----------------------------------"
  echo "Script Finished - Exiting"
  echo "----------------------------------+"
  echo ""
  echo "+----------------------------------"
  echo "-- E $(date +"%Y-%m-%dT%H:%M:%S%z") -----"
  echo "----------------------------------+"
  exit 2
}

#
# Check all other options
#
while getopts "::hd" opt; do
  case $opt in
    h)
      help_msg
      ;;
    d)
      DOWNLOAD_DIR="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -${OPTARG}"
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument"
      exit 1
      ;;
  esac
done

#
# Start Logging
#
((
echo "+----------------------------------"
echo "-- S $(date +"%Y-%m-%dT%H:%M:%S%z") -----"
echo "----------------------------------+"

echo "+----------------------------------"
echo "-------- Options Selected ---------"
echo "-----------------------------------"
echo "TBC"
echo "----------------------------------+"

#
# Download Files
#
echo ""
echo "+----------------------------------"
echo "------- Downloading Files ---------"
echo "-----------------------------------"
for i in "${DOWNLOAD_URL[@]}"; do

  echo "Downloading : ${i}"

  wget --no-verbose "${i}" -P "${DOWNLOAD_DIR}"
  EXIT_CODE_WGET=$?

  if [ ${EXIT_CODE_WGET} -ne 0 ]; then
    echo "-----------------------------------"
    echo "Wget Failed"
    echo "DOWNLOAD_URL : ${i}"
    echo "----------------------------------+"
    script_failure
  fi
done
echo "----------------------------------+"

) 2>&1) | tee -i ${LOG_DIR}/${LOG_FILE}
#
# End
#
