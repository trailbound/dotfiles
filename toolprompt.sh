#!/bin/bash
tp_verbose=1

function usage {
  echo -e "
  Usage: $0 [options]
  Options:
     --select <index>      : Select menu item <index>.
     --quiet               : Turn off all output.
     --force-interactive   : Force script to run as if interactive shell was specified.
                             (You will probably have to specify this option if running from
                              the command prompt).
     --help, -h            : This help menu."
  exit $1
}

if ! args=$(getopt -o h -l help,select:,force-interactive,quiet -- "$@")
then
    # something went wrong, getopt will put out an error message for us
    exit 1
fi

eval set -- $args
while [ $# -gt 0 ]
do
  case "$1" in
    (-h|--help) usage;;
    (--select) select="$2"; shift;;
    (--force-interactive) force_interactive=1;;
    (--quiet) tp_verbose=0;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
  esac
  shift
done


# Function used for adding prompt menu entries in .config file
tp_prompt=()
tp_action=()
tp_default=1
AddToolPromptMenuItem() {
  idx=${#tp_prompt[@]}
  tp_prompt[$idx]="$1"
  tp_action[$idx]="$2"
  if [ -n "$3" ]; then
    if [ "$3" == "default" -o "$3" == "DEFAULT" ]; then
      tp_default=$((idx+1))
    fi
  fi
}


# Load the Tool Prompt config file
. ${USER_PATH}/toolprompt.config


idx=1
ToolPrompt="Select your tool configuration: (3 sec timout)"
for item in "${tp_prompt[@]}"
do
  ToolPrompt="$ToolPrompt\n   $idx  -  $item"
  idx=$((idx+1))
done
ToolPrompt=$(echo -e "$ToolPrompt\n\nSelection? $")


if [ -n "$select" ]; then
  if [ ${tp_action[$((select-1))]+yes} ]; then
    if [[ $tp_verbose -gt 0 ]]; then echo -e "ToolPrompt: Auto selecting  $select  -  ${tp_prompt[$((select-1))]}.\n"; fi
    sel=$select
  else
    echo -e "ToolPrompt ERROR: Auto selected entry not found! No configuration set ...\n"
    exit;
  fi
fi

# Only select tool configurations in an interactive shell, otherwise just execute the default
if [[ $- != *i* ]]; then
  if [ -z "$force_interactive" ]; then
    tp_verbose=0
    sel=$tp_default
    # Save the value of stdout
    exec 3>&1
    # Redirect stdout to null so that we don't bork up non-interactive
    # shells that are created by processes (such as git, scp, etc)
    exec 1> /dev/null
  fi
fi


# Run the menu selection procedure
while true; do

  if [ -z "$sel" ]; then
    if [[ $tp_verbose -gt 0 ]]; then
      read -t 3 -p "$ToolPrompt " sel
    else
      sel=$tp_default
    fi
  fi

  if [ "$?" != "0" ]; then
    if [[ $tp_verbose -gt 0 ]]; then echo -e "-\n   Timeout. Default selection applied."; fi
    sel=$tp_default
  fi

  case $sel in
    [1-${#tp_prompt[@]}]* )
    if [ ${tp_action[$((sel-1))]+yes} ]; then
      if [[ $tp_verbose -gt 0 ]]; then echo -e "\n   Selected $sel  -  ${tp_prompt[$((sel-1))]}\n\n"; fi
      eval ${tp_action[$((sel-1))]}
    else
      echo -e "\nERROR: Entry not found! No configuration set ...\n\n"
    fi
    break;;
    * )
      if [[ $tp_verbose -gt 0 ]]; then echo "Please enter a number 1-${#tp_prompt[@]}."; fi
  esac
done

# Undo stdout redirection to /dev/null in non-interactive shell
if [[ $- != *i* ]]; then
  if [ -z "$force_interactive" ]; then
    exec 1>&3;
    exec 3>&-
  fi
fi
