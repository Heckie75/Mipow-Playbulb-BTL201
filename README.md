# Mipow-Playbulb-BTL201
Full-featured shell script interface based on expect and gatttool for Mipow Playbulb. It is (should be compatible) with the following models:
* Mipow Playbulb Rainbow (BTL200), tested rev. BTL200_v7 / Application version 2.4.3.26 (no candle effect)
* Mipow Playbulb Smart (BTL201), tested rev. BTL201_v2 / Application version 2.4.3.26 (no candle effect)

* Mipow Playbulb Spot Mesh (BTL203), tested rev. BTL203M_V1.6 / Application version 2.4.5.13 (no candle effect, remembers whole state, light, effect etc. after power off!)

Not tested yet:
* Mipow Playbulb Candle (BTL300), untested, confirmed by other users
* MiPow Playbulb Sphere (BTL301W), untested, unconfirmed, feedback is welcome!
* MiPow Playbulb Garden (BTL400), untested, unconfirmed, feedback is welcome!
* MiPow Playbulb Comet (BTL501A), untested, unconfirmed, feedback is welcome!
* MiPow Playbulb String (BTL505-GN), untested, unconfirmed, feedback is welcome!
* MiPow Playbulb Solar (BTL601), untested, unconfirmed, feedback is welcome!

This script is NOT compatible with bulbs of series BTL1xx:
* MiPow Playbulb Lite (BTL100S)
* MiPow Playbulb Color (BTL100C)

This script allows to control Mipow PLaybulbs via bluetooth BLE (low energy, version 4) with the Raspberry Pi's Raspian and other Linux distributions.   

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 
Usage: <mac/alias> <command> <parameters...>
                                   <mac>: bluetooth mac address of bulb
                                   <alias>: you can use alias instead of mac address 
                                            after you have run setup (see setup) 
                                   <command>: For command and parameters

Basic commands:

 status                          - print main information of bulb
 on                              - turn on light (white)
 off                             - turn off light
 toggle                          - turn off / on (remembers color!)
 color <white> <red> <green> <blue> 
                                 - set color, each value 0 - 255
 up                              - turn up light
 down                            - dim light

Build-in effects:

 pulse <hold> <white> <red> <green> <blue> 
                                 - run build-in pulse effect 
                                   <hold>: 0 - 255ms per step 
                                   color values: 0=off, 1=on

 blink <hold> <white> <red> <green> <blue> 
                                 - run build-in blink effect 
                                   <hold>: 0 - 255ms per step 
                                   color values: 0 - 255

 rainbow <hold>                  - run build-in rainbow effect 
                                   <hold>: 0 - 255ms per step

 disco <hold>                    - run build-in disco effect 
                                   <hold>: 0 - 255 in 1/100s

 candle <hold> <white> <red> <green> <blue>
                                 - run build-in candle effect
                                   <hold>: 0 - 255ms per step
                                   color values: 0 - 255

 hold <hold>                     - change hold value of current effect

Soft-effects which stay connected and run long:

 animate <hold> <white> <red> <green> <blue> 
                                 - change color smoothly based 
                                   <hold>: 0 - 255ms 
                                   color-values: 0 - 255

 triangle <hold> <delay> <max>   - change colors 
                                   <hold> in ms 
                                   <delay> in ms 
                                           0 means no animation 
                                           < 0 means dark pause

 stop                            - stop soft-effect

Timer commands:

 timer <timer> <start> <minutes> [<white> <red> <green> <blue>]
                                 - schedules timer 
                                   <timer>: No. of timer 1 - 4 
 
                                   <start>: starting time 
                                            (hh:mm or in minutes) 
                                   <minutes>: runtime in minutes 
                                   color values: 0 - 255 
 
 timer <timer> off               - deactivates single timer 
                                   <timer>: No. of timer 1 - 4 
  
 timer off                       - deactivates all timers

 fade <minutes> <white> <red> <green> <blue> 
                                 - change color smoothly 
                                   <minutes>: runtime in minutes 
                                   color values: 0 - 255

 ambient <minutes> [<start>]     - schedules ambient program 
                                   <minutes>: runtime in minutes 
                                              best in steps of 15m 
                                   <start>: starting time (optional)
                                            (hh:mm or in minutes)

 wakeup <minutes> [<start>]      - schedules wake-up program 
                                   <minutes>: runtime in minutes 
                                              best in steps of 15m 
                                   <start>: starting time (optional)
                                            (hh:mm or in minutes)

 doze <minutes> [<start>]        - schedules doze program 
                                   <minutes>: runtime in minutes 
                                              best in steps of 15m 
                                   <start>: starting time (optional)
                                            (hh:mm or in minutes)

 bgr <minutes> [<start>] [<brightness>] 
                                 - schedules blue-green-red program 
                                   <minutes>: runtime in minutes 
                                              best in steps of 4m, up to 1020m
                                   <start>: starting time (optional)
                                            (hh:mm or in minutes)
                                   <brightness>: 0 - 255 (default: 255)

 random <start> <stop> <min> <max> [<white> <red> <green> <blue>]
                                 - schedules random mode
                                   <start>: start time 
                                            (hh:mm or in minutes) 
                                   <stop>: stop time 
                                           (hh:mm or in minutes) 
                                   <min>: min runtime in minutes 
                                   <max>: max runtime in minutes 
                                   color values: 0 - 255 

 random off                      - stop random mode

Other commands:

 help <command>                  - get help for specific command
 dump                            - dump full state of bulb
 json                            - dump full state of bulb in json format
 setup                           - setup bulb for this program
 name <name>                     - give bulb a new displayname / alias
 password <abcd>                 - set password
 status                          - print full state of bulb
 reset                           - perform factory reset
```

## Initial setup

0. Check pre-conditions

Install `expect`:
```
$ sudo apt install expect
```

Check if `gatttool` is available:
```
$ gatttool
Usage:
  gatttool [OPTION...]
...

```

1. Find out the MAC address of your bulb

```
$ sudo hcitool lescan
LE Scan ...
38:01:95:84:A8:B1 (unknown)
AF:66:4B:0D:AC:E6 (unknown)
AF:66:4B:0D:AC:E6 MIPOW SMART BULB
```

2. Run setup command

By running the setup command, two things will be done:

a. There is a new file in your home folder called `~/.known_bulbs`. This file contains a mapping of MAC addresses and names. 

b. There is a new file in your `/tmp` folder, e.g. `/tmp/bulb-AF-66-4B-0D-AC-E6.hnd`. It is a description of the _characteristics_ and _handles_ that your bulb provide. See API for more details. 

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 setup

Setup for bulb started ...

Step 1: Read characteristics from bulb AF:66:4B:0D:AC:E6 ...
> characteristics saved in /tmp/bulb-AF-66-4B-0D-AC-E6.hnd

Step 2: Read bulb name ...
> bulb name is "MIPOW SMART BULB"
> bulb name stored in ~/.known_bulbs for usage with aliases.

Setup completed!

Usage with MAC address:
$ ./mipow.exp AF:66:4B:0D:AC:E6 status

Usage with alias:
$ ./mipow.exp "MIPOW SMART BULB" status

Have fun with your bulb!
```

You can double-check both files as follows:
```
$ cat ~/.known_bulbs 
AF:66:4B:0D:AC:E6 MIPOW SMART BULB
```

```
$ cat /tmp/bulb-AF-66-4B-0D-AC-E6.hnd 
handle = 0x0002, char properties = 0x0a, char value handle = 0x0003, uuid = 00002a00-0000-1000-8000-00805f9b34fb
...
```

3. Give bulb a new name

In order to be able to distinguish multiple bulbs you should rename your bulb. 

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 name Livingroom
```

4. Dump full status of bulb

```
$ ./mipow.exp Liv status

Device mac:                 AF:66:4B:0D:AC:E6
Device name (0021):         Livingroom
Device vendor (0030):       Mipow Limited
Device id (0028):           BTL201
Device version (002c):      BTL201_v2
Device software (002e):     Application version 2.4.3.26
Device CPU (002a):          CSR101x A05

Current color (001b):       00000000
White / Red / Green / Blue: off

Current effect (0019):      006bff00ff00ffff
Effect:                     halt (ff)
Effect color:               WRGB(0,107,255,0)
Effect time (raw):          255
Effect time (approx.):      n/a

Timer Settings (001f):      04ffff04ffff04ffff04ffff160e
Timer Effect (0013):        0000000000000000000000ff2f00700000000008

Time:                       22:14

Timer 1:                    04ffff
Timer 1 effect:             0000000000
Timer 1 type:               off (04)
Timer 1 time:               n/a
Timer 1 color:              off
Timer 1 time (minutes):     0

Timer 2:                    04ffff
Timer 2 effect:             0000000000
Timer 2 type:               off (04)
Timer 2 time:               n/a
Timer 2 color:              off
Timer 2 time (minutes):     0

Timer 3:                    04ffff
Timer 3 effect:             00ff2f0070
Timer 3 type:               off (04)
Timer 3 time:               n/a
Timer 3 color:              WRGB(0,255,47,0)
Timer 3 time (minutes):     112

Timer 4:                    04ffff
Timer 4 effect:             0000000008
Timer 4 type:               off (04)
Timer 4 time:               n/a
Timer 4 color:              off
Timer 4 time (minutes):     8

Randommode (0015):          020e16ffffffff000000000000
Randommode status:          off
```

**Note:** You can use just a part of the name, here only "Liv", instead of MAC address or the full given name. 

4. If something wents wrong

If something wents wrong, you maybe want to cleanup some files:
```
$ rm ~/.known_bulbs
$ rm /tmp/bulb-*
```

5. Try GUI for bulb

I have also added a simple GUI.

The more parameters you pass, the less dialogs will appear ;-)
```
$ ./bulb.sh Liv color
...

$ ./bulb.sh Liv
...

$ ./bulb.sh
...
```

**Note** This GUI requires `zenity`. You can install it as follows:
```
$ sudo apt install zenity
```

## Examples
### Ask for help
``` 
$ ./mipow.exp help

...


$ ./mipow.exp help color

Usage: <mac/alias> <command> <parameters...>
                                   <mac>: bluetooth mac address of bulb
                                   <alias>: you can use alias instead of mac address 
                                            after you have run setup (see setup) 
                                   <command>: For command and parameters

 color <white> <red> <green> <blue> 
                                 - set color, each value 0 - 255


$ ./mipow.exp Liv color
Usage: <mac/alias> <command> <parameters...>
                                   <mac>: bluetooth mac address of bulb
                                   <alias>: you can use alias instead of mac address 
                                            after you have run setup (see setup) 
                                   <command>: For command and parameters
 color <white> <red> <green> <blue> 
                                 - set color, each value 0 - 255
```


### Print status of bulb
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 status


Effect:     blink, WRGB(0,255,0,0), 5.1 sec, 0.196 Hz, 11.76 bpm

Timer 1:    14:51, WRGB(0,0,0,25), 30m
Timer 3:    15:51, WRGB(0,25,0,0), 30m
Timer 4:    16:21, off, 30m

Time:       12:54
```

**Note:** Status is optional. The following has the same result: 
```
$ ./mipow.exp AF:66:4B:0D:AC:E6
...
```


### Set color
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 color 0 255 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 toggle
$ ./mipow.exp AF:66:4B:0D:AC:E6 toggle
$ ./mipow.exp AF:66:4B:0D:AC:E6 off
$ ./mipow.exp AF:66:4B:0D:AC:E6 on
$ ./mipow.exp AF:66:4B:0D:AC:E6 down
$ ./mipow.exp AF:66:4B:0D:AC:E6 up
```

### Build-in effects
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 pulse 10 0 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 blink 20 20 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 rainbow 20
$ ./mipow.exp AF:66:4B:0D:AC:E6 disco 30
$ ./mipow.exp AF:66:4B:0D:AC:E6 hold 100
```

### Software controlled animations (long running, stay connected)
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 animate  255 0 0 100
$ ./mipow.exp AF:66:4B:0D:AC:E6 triangle -10 100 10
```

You can stop _software controlled animations_ by using a second terminal and enter the following:

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 stop
```

The script finds the other running process for this bulb by reading the _process id file_, e.g. `/tmp/bulb-AF-66-4B-0D-AC-E6.pid` and sends a _stop signal_ to the other process.

**Note** If a previous process has not been terminated correctly, the script tries to stop the other process first before it continues. This takes 5 seconds. 

### Timers 
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 1 22:40 10 0 0 255 255
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 1 off
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 2 22 1 0 0 255 255
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer off
```

### Random turn-on and off
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 random 22:45 23:50 1 1 255 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 random off
```

### Light programs (based on timers)
```
$./mipow.exp AF:66:4B:0D:AC:E6 wakeup 8
$ ./mipow.exp AF:66:4B:0D:AC:E6 doze 60
$ ./mipow.exp AF:66:4B:0D:AC:E6 bgr 60 0 64
```

### Set name
```
$./mipow.exp AF:66:4B:0D:AC:E6 name Timewaster
```

### Set password
```
$./mipow.exp AF:66:4B:0D:AC:E6 password 1234
```
