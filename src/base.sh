#!/usr/bin/bash
# force variable declaration. equivalent to set -u
#
# trace bash                => ok
# mode verbeux bash         => ok
# gestion des couleurs ANSI => ok
# capacité du terminal      => ok
# gestion interactif ou non => ok
# logger simple (5 niveau)  => ok
#
# reste à faire
# gestion des options ligne de commandes
#   activation du mode trace ?
#   quand acitvité le PS4 perso ?
# usage helper
#   quand je source, est-ce j'affiche l'aide ?
#
# gestion de l'appel du script:
#   dans un pipe
#   en backgroung
#   en interactif : est-ce que sourcer (quel comportement)
#     logger actif
#     PS4 soit actif
#
# TESTS UNITAIRES

set -o nounset

# some needs
TRUE=1
FALSE=""
bashDEBUG=$TRUE
bashVERBOSE=$FALSE

# first check if 1 is on terminal and if support colors
iniTerminal () {
  [[ -t 1 && ($(tput colors) -ge 8) ]] && {
    # ANSI COLOR
    COLOR_CODE="\033["
    BLACK="${COLOR_CODE}0;30m"
    RED="${COLOR_CODE}1;31m"
    GREEN="${COLOR_CODE}1;32m"
    YELLOW="${COLOR_CODE}1;33m"
    BLUE="${COLOR_CODE}1;34m"
    PURPLE="${COLOR_CODE}1;35m"
    CYAN="${COLOR_CODE}1;36m"
    GRAY="${COLOR_CODE}0;37m"
    COLOR_RESET="${COLOR_CODE}0m"

    # MY COLORS
    OK="$CYAN"
    KO="$RED"
    INFO="$GRAY"

    IN_TERMINAL=$TRUE
  } || {
    # NO COLOR
    COLOR_CODE=""
    BLACK=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    CYAN=""
    GRAY=""
    COLOR_RESET=""

    # MY COLORS
    OK=""
    KO=""
    INFO=""

    IN_TERMINAL=$FALSE
  }
}

# debugInit
debugInit () {
#  export PS4=" -[${CYAN}"'${LINENO}'"${COLOR_RESET}]"'$( printf "=%.0s" $(seq $(( $(tput cols) - ${#LINENO} - 4 )) ))'"\n"
#  export PS4="+ [ ${CYAN}"'${LINENO}'"${COLOR_RESET} ][${CYAN}"'$([[ ${FUNCNAME[0]:-""} ]] && echo ${FUNCNAME[0]} || echo "  main  " )'"${COLOR_RESET}]\011"
#  export PS4="+ [ ${CYAN}"'${LINENO}'"${COLOR_RESET} ][${CYAN}"'${FUNCNAME[0]:-"  main  "}'"${COLOR_RESET}]\011"
  export PS4="+ [ ${CYAN}"'${LINENO}'"${COLOR_RESET} ][${CYAN}"'${FUNCNAME[@]:-"  main  "}'"${COLOR_RESET}]"
}
# debugRestor
debugRestor () {
  export PS4=${PS4_BACKUP}
}
# debugStatus
debugGetStatus () {
  [[ ${SHELLOPTS} =~ xtrace ]] && echo $TRUE || echo $FALSE
}
# debugOn if DEBUG TRUE
debugOn () {
  set -o xtrace -o functrace -o errtrace
}
# debugOff
debugOff () {
  set +o xtrace +o functrace +o errtrace
}
# debugSwitch
debugSwitch () {
  [[ $SHELLOPTS =~ xtrace ]] && debugOff ||  debugOn
}
# debugActivate
debugActivate () {
  [[ $bashDEBUG ]] && debugOn
}

# verboseOn
verboseOn () {
  set -o verbose -o functrace -o errtrace
}
# verboseOff
verboseOff () {
  [[ $bashVERBOSE ]] && set +o verbose +o functrace +o errtrace
}
#verboseSwitch
verboseSwitch () {
  [[ $SHELLOPTS =~ verbose ]] && verboseOff || verboseOn
}
#verboseGetStatus
verboseGetStatus(){
  [[ ${SHELLOPTS} =~ verbose ]] && echo $TRUE || echo $FALSE
}
# verboseActivate
verboseActivate () {
  [[ $bashVERBOSE ]] && verboseOn
}

# check mode : interactif or bg
# identique à [[ -t 1 ]] ??? nop, ici si on lance le srip pas interactif.
# si on source oui interactif
getRuningMode () {
  [[ $- =~ i ]] && echo "$TRUE" || echo "$FALSE"
}

# Init
init () {
  iniTerminal
  dirname=${0%/*}
  progname=${0##*/}
  MODE_INTERACTIF=getRuningMode
  PS4_BACKUP="$PS4"
  debugInit
  debugActivate
#  debugGetStatus
  verboseActivate
#  verboseGetStatus
}
# clean before quiting
clean () {
  # reset env
  verboseOff
  debugOff
  debugRestor
}

# logger - Init
logInit () {
  declare -g -A logLevel=(CRITICAL "CRI" ERROR "ERR" WARNING "WAR" INFO "INF" DEBUG "DEB")
  CRITICAL=0
  ERROR=1
  WARNING=2
  INFO=3
  DEBUG=4
  logLevelColor[${CRITICAL}]="${YELLOW}"
  logLevelColor[${ERROR}]="${RED}"
  logLevelColor[${WARNING}]="${CYAN}"
  logLevelColor[${INFO}]="${BLUE}"
  logLevelColor[${DEBUG}]="${GRAY}"

  logLevelFormat="[DATE][LEVEL]"
}
# logger - main log function
log() {
  msg=${logLevelFormat//DATE/$(date -u "+%Y/%m/%d %T.%N %Z")}
  echo -en "${msg//LEVEL/${logLevelColor[$1]}${logLevel[$1]}${COLOR_RESET}} $2\n"
}
# logger helper
logDebug() { log "DEBUG"    "${@:-merci de fournir un message !}"; }
logInfo()  { log "INFO"     "${@:-merci de fournir un message !}"; }
logWarn()  { log "WARNING"  "${@:-merci de fournir un message !}"; }
logErr()   { log "ERROR"    "${@:-merci de fournir un message !}"; }
logCri()   { log "CRITICAL" "${@:-merci de fournir un message !}"; }

# parametres
# how the script is run



# config files

start () {
#  iniTerminal
  init
#  getRuningMode
  # cmd=("", "", "", "")
  # how the script is called

  logInit
  logCri FME
  logErr FME
  logWarn FME
  logInfo FME
  logDebug FME
  clean
}


start