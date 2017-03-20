#!/bin/bash
DIR="$(dirname "$0")"
MIPOW="$DIR/mipow.exp"
BULBS="$DIR/bulb.conf"
ME="$DIR/bulb.sh"

command=""
hold=""

function get_mac() {
  egrep '^[^#]' ${BULBS} | egrep -i "$1" | egrep -o '[0-9A-Z:]+$'
}

function get_name() {
  egrep '^[^#]' ${BULBS} | egrep -i "$1"
}

function ask_bulb() {
  known_bulbs=`cat ${BULBS} | tr "\n" "\t"`
  bulb=`zenity \
  --title="Play bulb"\
  --text="Please select bulb!" \
  --width=640 \
  --height=480 \
  --list \
  --column="Name" \
  --column="MAC"\
  $known_bulbs`
  
  echo $bulb
}

function ask_command() {
  
  c=`zenity \
  --title="Bulb $NAME"\
  --text="Please select command!" \
  --width=640 \
  --height=480 \
  --list \
  --column="Command" \
  --column="Description" \
    "on"  "Turn on light (max. white)"\
    "off" "Turn off light"\
    "toggle"  "Turn off / on"\
    "up"      "Turn up light"\
    "down"    "Dim light"\
    "color"   "Set color"\
    "animate" "Start soft-effect that changes colors smoothly"\
    "triangle" "Start soft-effect that changes colors in different variations"\
    "stop" "Stop soft-effect"\
    "pulse"   "Start build-in effect pulse"\
    "blink"   "Start build-in effect blink"\
    "rainbow" "Start build-in effect rainbow"\
    "disco"   "Start build-in effect disco"\
    "hold"    "Change hold value of current build-in effect"\
    "halt"    "Halt build-in effect, keeps current color"\
    "timer 1"   "set timer 1"\
    "timer 2"   "set timer 2"\
    "timer 3"   "set timer 3"\
    "timer 4"   "set timer 4"\
    "timer 1 off" "deactivate timer 1"\
    "timer 2 off" "deactivate timer 2"\
    "timer 3 off" "deactivate timer 3"\
    "timer 4 off" "deactivate timer 4"\
    "timer all off" "deactivate all timers"\
    "fade"    "Change color smoothly"\
    "ambient" "Start ambient light program"\
    "wakeup"  "Start wake-up light program"\
    "doze"    "Start doze light program"\
    "random"  "Schedule random mode"\
    "random off" "Deactivate random mode"\
    "name"    "Give bulb a new name"\
    "status"  "Print status"\
    "reset"   "Perform factory reset"`
  
  echo $c
}

function ask_hold() {
  
  case "$1" in
    "animate" | "triangle" )
      text="Please set hold in ms for $1 effect!"
      min=100
      max=10000
      step=10
      default=500
    ;;
    "triangle_delay" )
      text="Please set delay in ms for $1 effect!"
      min=-1000
      max=3000
      step=1
      default=0
    ;;    
    "rainbow" )
      text="Please set hold in ms for $1 effect!"
      min=1
      max=255
      step=1
      default=255
    ;;
    "pulse" )
      text="Please set hold in ms for $1 effect!"
      min=1
      max=255
      step=1
      default=127
    ;;
    "blink" )
      text="Please set hold in 1/10s for $1 effect!"
      min=1
      max=255
      step=1
      default=50
    ;;
    "disco" )
      text="Please set hold in 1/100s for $1 effect!"
      min=1
      max=255
      step=1
      default=62
    ;;
    "hold" )
      text="Please set hold for current effect!"
      min=1
      max=255
      step=1
      default=127
    ;;
    "random" )
      text="Please set min. runtime in minutes!"
      min=1
      max=255
      step=1
      default=1
    ;;
    "random_max" )
      text="Please set max. runtime in minutes!"
      min=$2
      max=255
      step=1
      default=$2
    ;;
    "timer" | "fade" | "ambient" | "wakeup" | "doze" )
      text="Please set runtime in minutes!"
      min=1
      max=255
      step=1
      default=1
    ;;
  esac
  
  h=`zenity --scale --width=640 --height=480 --title="Select" --text="$text" --value=$default --min-value=$min --max-value=$max --step=$step`
  
  echo $h
}

function ask_brightness() {
  
  text="Please set brightness / white!"
  min=0
  max=255
  step=1
  default=255
  
  b=`zenity --scale --width=640 --height=480 --title="Select brightness" --text="$text" --value=$default --min-value=$min --max-value=$max --step=$step`
  
  echo $b
}

function ask_color() {
  
  text="Please select color!"
  
  selection=`zenity --color-selection  --show-palette --title="Select color" --text="$text"`
  
  selection=`echo $selection | sed 's/[rgb(|rgba(|)]//g' | tr "," " "`
  
  c=""
  i=0
  for s in $selection
  do
    let i++
    if [[ i -eq 4 ]]
    then
      w=`awk -v val=$s 'BEGIN {print int((1-val)*255)}'`
      c="$w $c"
    else
      c="$c $s "
    fi  
  done 
    
  if [[ i -eq 3 ]]
  then
    c="0 $c"
  fi
  
  echo $c
}

function ask_color_flags() {
  
  colors="white red green blue"  
  text="Please select color!"
  
  selection=`zenity \
    --list --checklist \
    --title="Select color" \
    --text="$text" \
    --column=Boxes --column=Selections --separator=' ' \
    FALSE white FALSE red FALSE green FALSE blue`
    
  c=${colors}
  for i in $selection
  do
    c=`echo $c | sed -e "s/$i/1/"`
  done
  for i in $colors
  do
    c=`echo $c | sed -e "s/$i/0/"`
  done
  
  echo $c
}

function ask_schedule() {
  text="Please enter time (hh:mm) or schedule in minutes"
  s=`zenity --entry --title="Schedule timer" --text="$text"`
  
  check_interupt $?
  
  echo $s
}

function ask_name() {
  text="Please enter new name for bulb!"
  s=`zenity --entry --title="Rename bulb" --text="$text"`
  
  check_interupt $?
  
  echo $s
}

if [ "$DISPLAY" == "" ] 
then
  /home/heckie/scripts/mipow.exp "$@"
  exit $?
fi

#MAC and name
bulb=$1
shift
if [ "$bulb" == "" ]
then
  bulb=`ask_bulb`
  if [ "$bulb" == "" ]
  then
    exit 0
  fi
fi
MAC=`get_mac $bulb`
NAME=`get_name $bulb`

# command
command=$1
shift
if [ "$command" == "" ]
then
  command=`ask_command`
  if [ "$command" == "" ]
  then
    exit 1
  fi
else
  if [ "$command" == "timer" ]
  then
    command="$command $1"
    shift
  fi
fi

# rename bulb
case "$command" in 
  "name" )
    name=$1
    shift
    
    if [ "$name" == "" ]
    then
      name=`ask_name`
      if [ "$name" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# start time for timer / random
case "$command" in 
  "timer 1" | "timer 2" | "timer 3" | "timer 4" | "ambient" | "wakeup" | "doze" | "random" )
    start=$1
    shift
    
    if [ "$start" == "" ]
    then
      start=`ask_schedule $command`
      if [ "$start" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# stop time for random
case "$command" in 
  "random" )
    stop=$1
    shift
    
    if [ "$stop" == "" ]
    then
      stop=`ask_schedule $command`
      if [ "$stop" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# minutes
case "$command" in 
  "timer 1" | "timer 2" | "timer 3" | "timer 4" | "fade" | "ambient" | "wakeup" | "doze" | "random" )
    minutes=$1
    shift
    
    if [ "$minutes" == "" ]
    then
      minutes=`ask_hold $command`
      if [ "$minutes" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# max. minutes
case "$command" in 
  "random" )
    maxminutes=$1
    shift
    
    if [ "$maxminutes" == "" ]
    then
      maxminutes=`ask_hold random_max $minutes`
      if [ "$maxminutes" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# hold
case "$command" in 
  "animate" | "triangle" | "rainbow" | "pulse" | "blink" | "disco" | "hold" )
    hold=$1
    shift
    if [ "$hold" == "" ]
    then
      hold=`ask_hold $command`
      if [ "$hold" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# delay
case "$command" in 
  "triangle" )
    delay=$1
    shift
    if [ "$delay" == "" ]
    then
      delay=`ask_hold triangle_delay`
      if [ "$delay" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# color
case "$command" in 
  "triangle" )
    brightness=$1
    shift
    
    if [ "$brightness" == "" ]
    then
      brightness=`ask_brightness`
      if [ "$brightness" == "" ]
      then
        exit 1
      fi
    fi
  ;;
  "pulse" )
    color="$1 $2 $3 $4"
    shift
    shift
    shift
    shift
    
    if [ "$color" == "   " ]
    then
      color=`ask_color_flags`
      if [ "$color" == "" ]
      then
        exit 1
      fi
    fi
    echo $color
  ;;
  "color" | "animate" | "blink" | "timer 1" | "timer 2" | "timer 3" | "timer 4" | "fade" | "random" )
    color="$1 $2 $3 $4"
    shift
    shift
    shift
    shift
    
    if [ "$color" == "   " ]
    then
      color=`ask_color`
      if [ "$color" == "" ]
      then
        exit 1
      fi
    fi
  ;;
esac

# execute
case "$command" in
  "on" | "toggle" | "up" | "halt" | "stop" )
    $MIPOW $MAC $command &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command"
  ;;
  "off" | "down" | "timer all off" | "timer 1 off" | "timer 2 off" | "timer 3 off" | "timer 4 off" | "random off" | "reset" )
    $MIPOW $MAC $command &
    notify-send -i $DIR/icons/bulb-off.png "$NAME" "Command: $command"
  ;;
  "color" )
    $MIPOW $MAC $command $color &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nColor: $color"
  ;;
  "animate" )
    $MIPOW $MAC $command $hold $color &
    notify-send -i $DIR/icons/bulb-rainbow.png "$NAME" "Command: $command\nHold: $hold\nColor: $color!"
  ;;
  "triangle" )
    $MIPOW $MAC $command $hold $delay $brightness &
    notify-send -i $DIR/icons/bulb-rainbow.png "$NAME" "Command: $command\nHold: ${hold}ms\nDelay: ${delay}ms\nBrightness: ${brightness}"
  ;;  
  "pulse" | "blink" )
    $MIPOW $MAC $command $hold $color &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nColor: $color\nHold: ${hold}"
  ;;
  "rainbow" | "disco" | "hold" )
    $MIPOW $MAC $command $hold &
    notify-send -i $DIR/icons/bulb-rainbow.png "$NAME" "Command: $command\nHold: ${hold}"
  ;;
  "timer 1" | "timer 2" | "timer 3" | "timer 4")
    $MIPOW $MAC $command $start $minutes $color &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nStart: ${start}\nMinutes: ${minutes}\nColor: $color"
  ;;  
  "fade" )
    $MIPOW $MAC $command $minutes $color &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nColor: $color\nMinutes: ${minutes}"
  ;;
  "wakeup" )
    $MIPOW $MAC $command $minutes $start &
    notify-send -i $DIR/icons/bulb-wakeup.png "$NAME" "Command: $command\nStart: ${start}\nMinutes: ${minutes}"
  ;;
  "doze" | "ambient" )
    $MIPOW $MAC $command $minutes $start &
    notify-send -i $DIR/icons/bulb-doze.png "$NAME" "Command: $command\nStart: ${start}\nMinutes: ${minutes}"
  ;;
  "random" )
    $MIPOW $MAC $command $start $stop $minutes $maxminutes $color &
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nStart: ${start}\nStop: ${stop}\nMin. minutes: ${minutes}\nMax. minutes: ${maxminutes}\nColor: ${color}"
  ;;
  "name" )
    $MIPOW $MAC $command $name
    notify-send -i $DIR/icons/bulb-on.png "$NAME" "Command: $command\nNew name: ${name}"
  ;;
  "status" )
    echo "<html><body><h2>Bulb $NAME</h2><pre>" > /tmp/bulb.$MAC.status
    $MIPOW $MAC $command >> /tmp/bulb.$MAC.status
    echo "</pre></body></html>" >> /tmp/bulb.$MAC.status
    
    zenity --width=640 --height=600 --title "Bulb status" --text-info --html --filename /tmp/bulb.$MAC.status
    ret=$?
    rm -f /tmp/bulb.$MAC.status
    if [ $ret != 0 ]
    then
      exit 0
    fi
  ;;
        
esac

#$ME $MAC