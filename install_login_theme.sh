#!/bin/bash
#description=Installs the custom login theme
#name=Install Login Theme
#argumentDescription=[true|false] - Pass 'true' to disable theme, 'false' or empty to enable
#argumentDefault=false

# Default value
DISABLE_THEME="false"

# Simple argument parsing - check if argument contains "true"
if [[ "$1" == *"true"* ]]; then
  DISABLE_THEME="true"
elif [[ "$1" == *"false"* ]]; then
  DISABLE_THEME="false"
elif [[ -n "$1" ]]; then
  echo "Usage: $0 [--disable true|false]"
  echo "Note: Pass 'true' to disable theme, 'false' or no argument to enable theme"
  exit 1
fi

## FAQ

  # If you are on an Unraid version older than 6.10 you need to update the LOGIN_PAGE variable to "/usr/local/emhttp/login.php"

echo -e "Variables set:\\n\
DISABLE_THEME = ${DISABLE_THEME}\\n"

echo "NOTE: Change the LOGIN_PAGE variable to /usr/local/emhttp/login.php if you are on a version older than 6.10"
LOGIN_PAGE="/usr/local/emhttp/webGui/include/.login.php"


IFS='"'
set $(cat /etc/unraid-version)
UNRAID_VERSION="$2"
IFS=$' \t\n'
echo "Unraid version: ${UNRAID_VERSION}"

# Restore login.php
if [ ${DISABLE_THEME} = "true" ]; then
  echo "Restoring backup of login.php" 
  cp -p ${LOGIN_PAGE}.backup ${LOGIN_PAGE}
  exit 0
fi

# Backup login page if needed.
if [ ! -f ${LOGIN_PAGE}.backup ]; then
  echo "Creating backup of login.php" 
  cp -p ${LOGIN_PAGE} ${LOGIN_PAGE}.backup
fi

# Adding stylesheets
if ! grep -q "custom-theme.min.css" ${LOGIN_PAGE}; then
  echo "Adding custom stylesheet"
  sed -i -e "\@<style>@i\    <link data-tp='custom' rel='stylesheet' href='https://cdn.jsdelivr.net/gh/wesleyks/unraid-theme@main/custom-theme.min.css'>" ${LOGIN_PAGE}
  echo 'Custom stylesheet added'
fi