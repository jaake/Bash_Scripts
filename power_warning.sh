#!/bin/sh

# This script is used to automatically shut down the laptop when the battery gets low
# it also will warn the user to plug the machine in.
# Jacob Margason jaake@jklm.io

export DISPLAY=:0
percentage_remaining=$(acpi | awk -F' ' '{ print $4 }' | sed 's/%,//')
ac_power=$(acpi -a | awk -F' ' '{ print $3 }')


function below_20 {

  su jaake -c "notify-send 'Battery is getting low!' --icon=dialog-information" 
  aplay /usr/share/sounds/power_warning/penguin.wav

}

function below_10 {

  su jaake -c "notify-send 'Battery Low! connect power.' --icon=dialog-information" 
  aplay /usr/share/sounds/power_warning/spam_penguins.wav

}

function below_7 {

  su jaake -c "notify-send 'Shutdown imminent' --icon=dialog-information" 
  aplay /usr/share/sounds/power_warning/we_interrupt.wav
  sleep 10 && shutdown -h now

}

if [ $ac_power == "off-line" ]; then
  
  if [ $percentage_remaining -lt 20 ]; then
    case $percentage_remaining in 

      1*)
        below_20
        ;;
      [7-9])
        below_10
        ;;
      [0-6])
        below_7
        ;;
      *)
        exit 0
        ;;
  
    esac
  else

    exit 0
  
  fi

else  

  exit 0 

fi
