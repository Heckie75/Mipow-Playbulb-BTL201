# Mipow-Playbulb-BTL201
Full-features shell script interface based on expect and gatttool for Mipow Playbulb BTL201 (and maybe others)

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 
Usage: <mac> <command> <parameters...>


Basic commands:
 turnon                                         - Turn on light (max. white)
 turnoff                                        - Turn off light
 toggle                                         - Turn off / on
 dim                                            - Dim light
 turnup                                         - Turn up light
 color <white> <red> <green> <blue>             - Set color based on wrgb-values (0..255)

Soft-effects / light programs                   - These effects are long-running and send permanant data to bulb while bulb stays connected
 animate <white> <red> <green> <blue> <hold>    - Change color smoothly based on wrgb-values (0..255) and hold in ms
 triangle <delay> <hold> <max>                  - Change colors, delay in ms (if zero then no animation, if negative then dia effect) and hold in ms
 stop                                           - Stop long-runnning effect / light program

Build-in effects:
 pulse <hold> <white> <red> <green> <blue>      - Build-in effect pulse, hold (0..255 ms per step), colors (0..255)
 blink <hold> <white> <red> <green> <blue>      - Build-in effect blink, hold in 1/50s (0..255), colors (0..255)
 rainbow <hold>                                 - Build-in effect rainbow (smooth), hold 0..255 ms
 disco <hold>                                   - Build-in effect disco, hold is 0..255 where value is 1/100s
 hold <hold>                                    - Change hold value of current build-in effect
 halt                                           - Halt build-in effect, keeps current color

Timer commands:
 timer <timer> <start> <white> <red> <green> <blue> <minutes>
                                                - Schedules timer with starting time (hh:mm or schedule in minutes), color and runtime in minutes, e.g. 1 21:00 255 0 0 0 1
 timer reset                                    - Deactivates all four timers
 timer <timer> off                              - Deactivates single timer
 fade <white> <red> <green> <blue> <minutes>    - Change color smoothly based on wrgb-values (0..255), program will be written to timer 3
 ambient <minutes>                              - Starts ambient program (red to orange), program will be written to timer 3
 wakeup <minutes>                               - Starts wake up program (blue dawn), runtime in minutes, program will use all 4 timers
 doze <minutes>                                 - Starts doze program (red-orange dusk), program will be written to timer 3 and timer 4
 random <start> <stop> <min> <max> <white> <red> <green> <blue>
                                                - Schedules random mode with starting and ending time, min/max minutes and color, e.g. 21:00 23:59 5 60 255 0 0 0
    
 random off                                     - Turns of random mode

Other commands:
 debug <iterations> <from hnd> <to hnd>         - Prints values of handles to stdout
 status                                         - Receive and print full state of bulb incl. color, effect, timers and randommode
 name <name>                                    - Give bulb a new displayname
```

## Examples
### Receive status

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 status

Device name (21):           Bulb Livingroom
Device vendor (30):         Mipow Limited
Device id (28):             BTL201
Device version (2c):        BTL201_v2
Device software (2e):       Application version 2.4.3.26
Device CPU (2a):            CSR101x A05

Current color (1b):         89762f00
White / Red / Green / Blue: WRGB(137,118,47,0)

Current effect (19):        0000ff00ff006464
Effect:                     halt (ff)
Effect color:               WRGB(0,0,255,0)
Effect time (raw):          100
Effect time (approx.):      n/a

Timer Settings (1f):        04ffff04ffff00ffff02171b1703
Timer Effect (13):          0000000000000000000000ff2f001e000000001e

Time:                       23:03

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

Timer 3:                    00ffff
Timer 3 effect:             00ff2f001e
Timer 3 type:               turnon (00)
Timer 3 time:               n/a
Timer 3 color:              WRGB(0,255,47,0)
Timer 3 time (minutes):     30

Timer 4:                    02171b
Timer 4 effect:             000000001e
Timer 4 type:               turnoff (02)
Timer 4 time:               23:27
Timer 4 color:              off
Timer 4 time (minutes):     30

Randommode (15):            2f0317ffffffffffff00000000
Randommode status:          off
```

### Set color
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 color 0 255 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 toggle
$ ./mipow.exp AF:66:4B:0D:AC:E6 toggle
$ ./mipow.exp AF:66:4B:0D:AC:E6 turnoff
$ ./mipow.exp AF:66:4B:0D:AC:E6 turnon
$ ./mipow.exp AF:66:4B:0D:AC:E6 dim
$ ./mipow.exp AF:66:4B:0D:AC:E6 turnup
```
### Software controlled animations (long running, stay connected)
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 animate
$ ./mipow.exp AF:66:4B:0D:AC:E6 animate  255 0 0 100
$ ./mipow.exp AF:66:4B:0D:AC:E6 triangle -10 100 10
$ ./mipow.exp AF:66:4B:0D:AC:E6 stop
```

### Build-in effects
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 pulse 10 0 0 0 0
$./mipow.exp AF:66:4B:0D:AC:E6 blink 20 20 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 rainbow 20
$ ./mipow.exp AF:66:4B:0D:AC:E6 disco 30
$ ./mipow.exp AF:66:4B:0D:AC:E6 hold 100
```

### Timers 
```$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 1 22:40 0 0 255 255 10
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 1 off
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer 2 22 0 0 255 255 1
$ ./mipow.exp AF:66:4B:0D:AC:E6 timer reset
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
```