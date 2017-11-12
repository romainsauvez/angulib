#!/bin/

#####################################################################
# ANGULIB v1.0  --  AngularCLI module to library packager
#
# autor: Romain Sauvez
# github: https://github.com/romainsauvez/angulib
# description : convert your AngularCLI module into library for npm publication or
# local development use.
#
#
# Put this script in the root folder of your
# AngularCLI project.
#
#####################################################################

# color
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# show header/title
function displayHeader {
  clear
  echo -e ""
  echo -e "          ${BLUE}ANGULIB${RESET} ${CYAN}[AngularCLI library packager]${RESET}"
  echo -e ""
}

function displayFinalUi {
  displayHeader

  echo -e "             ${PURPLE}1 - Setup project${RESET}"
  echo -e "                 ${GREEN}install ng-packagr"
  echo -e "                 generate ng-packagr.json file"
  echo -e "                 update package.json file${RESET}"
  echo -e ""
  echo -e "             ${PURPLE}2 - Define path to the module ${RESET}"
  echo -e "                 ${GREEN}path: $element_names"
  echo -e "                 generate public_api.ts file${RESET}" 
  echo -e ""
  echo -e "             ${PURPLE}3 - Package files ${RESET}"
}

# generate ng-package.json file
function generateNgPkgrJsonFile {
  filePath='ng-package.json'
  touch $filePath
cat <<EOT > $filePath
{
  "\$schema": "./node_modules/ng-packagr/ng-package.schema.json",
  "lib": {
    "entryFile": "public_api.ts"
  }
}

EOT
}

# generate public_api.ts file
function generatePublicApiFile {
  filePath='public_api.ts'
  touch $filePath
cat <<EOT > $filePath
export * from '${1}'

EOT
}

# check for ng-packagr installation
function checkIfPackageInstalled {
  local return_=1
  # set to 0 if not found
  ls node_modules 2>/dev/null | grep $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

# finalize with packaging file
function packageFile {

  displayFinalUi
  echo -n "                 prepare file..." 

  npm run packagr &> /dev/null
  if [ $? -ne 0 ]; then
    npm run packagr
    if [ $? -ne 0 ]; then
      exit
    fi
  fi

  displayFinalUi
  echo -e "                 ${GREEN}package files complete" 

  cd dist
  npm pack &> /dev/null
  if [ $? -ne 0 ]; then
    npm pack
    if [ $? -ne 0 ]; then
      exit
    fi
  fi
  echo -e "                 generate tgz${RESET}"
  echo -e ""
  echo -e "             ${PURPLE}4 - Process complete ! ${RESET}"
  echo -e ""
  echo -e ""
}

# define path to the angular module
function setupPath {
  echo -e ""
  echo -e "             ${PURPLE}2 - Define path and file name of the module ${RESET}"
  echo -e "                 ex: src/app/home/home.module"
  echo -e ""
  read -p $'                 src/app/' element_names

  if [ -z $element_names ]; then
      setupPath
  fi

  # store the path
  path='./src/app/'$element_names

  # generate public_api.ts file
  generatePublicApiFile $path
  echo -e "                 generate public_api.ts file" 

  # go to package file function
  packageFile
}

# setup environment
function setupEnvironment {
  displayHeader

  echo -e "             ${PURPLE}1 - Setup project${RESET}"

  # check if ng-packagr is installed
  isPackInstalled=$(checkIfPackageInstalled ng-packagr)

  # if not installed, we install it
  if [ $isPackInstalled = 0 ]; then
  echo -e "                 ng-packagr is not installed"
  echo -n "                 install ng-packagr..." 
  
  npm install ng-packagr --save --only=dev &> /dev/null
  if [ $? -ne 0 ]; then
      npm install ng-packagr --save --only=dev
      if [ $? -ne 0 ]; then
          exit
      fi
  fi 
  fi

  # generate ng-packagr.json file
  generateNgPkgrJsonFile

  # update UI
  displayHeader
  echo -e "             ${PURPLE}1 - Setup project${RESET}"
  echo -e "                 ${GREEN}install ng-packagr"
  echo -e "                 generate ng-packagr.json file"

  # update package.json with new script "packagr"
  # this script can be used for generate package
  sed -i.bak -e 's/"scripts": {/"scripts": { "packagr": "ng-packagr -p ng-package.json",/' package.json
  rm package.json.bak
  echo -e "                 update package.json file${RESET}"

  # go to setup path/name of module
  setupPath

}


############ start application ###########
 setupEnvironment
##########################################



