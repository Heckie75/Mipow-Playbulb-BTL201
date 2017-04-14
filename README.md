# Mipow-Playbulb-BTL201
Full-featured shell script interface based on expect and gatttool for Mipow Playbulb BTL201 (and maybe others)

This script allows to control the bluetooth bulb BTL201 with the Raspberry Pi's Raspian and other Linux distributions.   

```
$ ./mipow.exp AF:66:4B:0D:AC:E6 
Usage: <mac> <command> <parameters...>


Basic commands:

 on                              - turn on light (white)
 off                             - turn off light
 toggle                          - turn off / on
 up                              - turn up light
 down                            - dim light
 color <white> <red> <green> <blue> 
                                 - set color, each value 0 - 255

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

Build-in effects:

 pulse <hold> <white> <red> <green> <blue> 
                                 - run build-in pulse effect 
                                   <hold>: 0 - 255ms per step 
                                   color-values: 0 off, 1 on

 blink <hold> <white> <red> <green> <blue> 
                                 - run build-in blink effect 
                                   <hold>: 0 - 255ms per step 
                                   color-values: 0 - 255

 rainbow <hold>                  - run build-in rainbow effect 
                                   <hold>: 0 - 255ms per step

 disco <hold>                    - run build-in disco effect 
                                   <hold>: 0 - 255 in 1/100s

 hold <hold>                     - change hold value of effect

 halt                            - halt build-in effect, keeps color

Timer commands:

 timer <timer> <start> <minutes> [<white> <red> <green> <blue>]
                                 - schedules timer 
                                   <start>: starting time 
                                            (hh:mm or in minutes) 
                                   <minutes>: runtime in minutes 
                                   color-values: 0 - 255 
 
 timer <timer> off               - deactivates single timer 
 timer off                       - deactivates all timers

 fade <minutes> <white> <red> <green> <blue> 
                                 - change color smoothly 
                                   <minutes>: runtime in minutes 
                                   color-values: 0 - 255

 ambient <minutes> [<schedule>]  - schedules ambient program 
                                   <minutes>: runtime in minutes 
                                   <schedule>: optional, e.g. 
                                               06:30 or steps in 15m

 wakeup <minutes> [<schedule>]   - schedules wake-up program 
                                   <minutes>: runtime in minutes 
                                   <schedule>: optional, e.g. 
                                               06:30 or steps in 15m

 doze <minutes> [<schedule>]     - schedules doze program 
                                   <minutes>: runtime in minutes 
                                   <schedule>: optional, e.g. 
                                               06:30 or steps in 15m

 random <start> <stop> <min> <max> [<white> <red> <green> <blue>]
                                 - schedules random mode
                                   <start>: start time 
                                            (hh:mm or in minutes) 
                                   <stop>: stop time 
                                           (hh:mm or in minutes) 
                                   <min>: min runtime in minutes 
                                   <max>: max runtime in minutes 
                                   color-values: 0 - 255 

 random off                      - stop random mode

Other commands:

 status                          - print full state of bulb
 name <name>                     - give bulb a new displayname
 reset                           - perform factory reset
 setup                           - initialize your bulb for this program
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
$ ./mipow.exp AF:66:4B:0D:AC:E6 off
$ ./mipow.exp AF:66:4B:0D:AC:E6 on
$ ./mipow.exp AF:66:4B:0D:AC:E6 down
$ ./mipow.exp AF:66:4B:0D:AC:E6 up
```
### Software controlled animations (long running, stay connected)
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 animate  255 0 0 100
$ ./mipow.exp AF:66:4B:0D:AC:E6 triangle -10 100 10
$ ./mipow.exp AF:66:4B:0D:AC:E6 stop
```

### Build-in effects
```
$ ./mipow.exp AF:66:4B:0D:AC:E6 pulse 10 0 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 blink 20 20 0 0 0
$ ./mipow.exp AF:66:4B:0D:AC:E6 rainbow 20
$ ./mipow.exp AF:66:4B:0D:AC:E6 disco 30
$ ./mipow.exp AF:66:4B:0D:AC:E6 hold 100
```

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
```

### Set name
```
$./mipow.exp AF:66:4B:0D:AC:E6 name Timewaster
```


# Mipow Playbulb BTL201 Bluetooth API
## Device Information

**Handle 0x28 - The product id of the bulb**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „BTL201“
- Get: char-read-hnd 28
- Characteristic value/descriptor: 42 54 4c 32 30 31
- Set: n/a

**Handle 0x2C - The product id of the bulb incl. Version**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „BTL201_v2“
- Get: char-read-hnd 2c
- Characteristic value/descriptor: 42 54 4c 32 30 31 5f 76 32
- Set: n/a

**Handle 0x30 – The vendor of the bulb**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „Mipow Limited“
- Get: char-read-hnd 30
- Characteristic value/descriptor: 4d 69 70 6f 77 20 4c 69 6d 69 74 65 64
- Set: n/a

**Handle 0x2E – The software version of the bulb**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „Application version 2.4.3.26“
- Get: char-read-hnd 2e
- Characteristic value/descriptor: 41 70 70 6c 69 63 61 74 69 6f 6e 20 76 65 72 73 69 6f 6e 20 32 2e 34 2e 33 2e 32 36
- Set: n/a

**Handle 0x2A – Microprocessor of bulb**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „CSR101x A05“ 
- Get: char-read-hnd 2a
- Characteristic value/descriptor: 43 53 52 31 30 31 78 20 41 30 35
- Set: n/a

**Handle 0x03 / 0x21 - The given name of the bulb**
- Default value: "MIPOW SMART BULB"
- Get: char-read-hnd 3
- Characteristic value/descriptor: 4d 49 50 4f 57 20 53 4d 41 52 54 20 42 55 4c 42
- Set: char-write-req 3 4142434445464748494a4b4c4d4e4f
- Set: char-write-req 21 4142434445464748494a4b4c4d4e4f

*Note:* This seems to be the only value that will be kept after you have disconnected the bulb from power. 

## Color
The color of the bulb. Can also be used in order to read current color, in case that effect runs. 

**Handle 0x1B –  Color of bulb**
- Get: char-read-hnd 1b
- Characteristic value/descriptor: ff 00 00 00
- Set: char-write-cmd 1b ff000000
- Setting the color deactivates a running effect. Set all colors to zero in order to turn bulb off.

- Byte 1: White in hex (0 – ff)
- Byte 2: Red in hex (0 – ff)
- Byte 3: Green in hex (0 – ff)
- Byte 4: Blue in hex (0 – ff)

## Effects
The bulb has four effects, i.e. blink, pulse, smooth rainbow, hard rainbow. 
Note: Although according the app there is an additional effect called „candle“ It does not work with my bulb.

**Handle 0x19 - effect of bulb**

- Get: char-read-hnd 19
- Characteristic value/descriptor: 00 00 00 00 ff 00 00 00
- Set: char-write-cmd 19 00000000ff00ff00

- Byte: 1 to 4: Color of effect, current color, values are persisted even if effect stops (can be written in order to remember previous color after bulb has been soft-turned off in order to be able to toggle to colors before – must be programmed by yourself of course)
- Byte 5: Effect (blink=00, pulse=01, hard rainbow=02, smooth rainbow=03, halt=ff)
- Byte 6: no special meaning, always „ff“, use „00“ if you set handle
- Byte 7: Delay of the effect in hex
- Byte 8: no special meaning, always „ff“, use „00“ if you set handle

### More about delay of effects
**1. Delay for smooth rainbow effect**

The value is the delay in ms for every single step.

Example: Delay is 255 (ff)
- It takes exactly 6:30 min (390 sec.) for one sequence with fading and changing all 6 colors (red → yellow → green → magenta → blue → cyan)
- The fading from 0 to 255 takes 65 seconds 
- It takes 0,255 secs for one step with delay of 255

**2. Delay for hard rainbow effect**

The value is the hold value in seconds for each color (red → yellow → green → magenta → blue → cyan)

Example: Delay is 255 (ff)
- It takes exactly 15,3 sec. for one sequence and all 6 colors (red → yellow → green → magenta → blue → cyan)
- one color will be displayed for 2,55 secs with hold of 255
- numeric value for effect is hold in 1/10s

**3. Delay for pulse effect**

The value is the delay in ms for every single step.

Example: Pulse with hold 255 (ff)
- The fading from 0 to 255 takes 65 seconds 
- Therefore the fading from 0 to 255 and back takes 130secs.
- It takes 0,255 secs for one step with hold of 255

**4. Delay for blink effect**

The value is the period in 1/100-seconds for each state (on, off).

Example: Blink with hold 255
- 10 on/off-turns take 51 seconds
- 1 turn takes 5,1 seconds
- Hold of 255 means 2,55 seconds on and another 2,55 seconds off

## Timers
### Read current timers
The MIPOW Playbulb has 4 timers and an internal clock.
Note that information about timers are read from 2 different handles. 

**Handle 0x1f – Status and starting times of timers**

- Get: char-write-req 1f
- Characteristic value/descriptor: 04 ff ff 04 ff ff 04 ff ff 04 ff ff 00 00
- Set: (see chapter „Set timer“)

Timer 1:

- Byte 1: Timer type (00 – wake-up timer, 02 – doze timer, 04 – deactivated timer) - actually it is unclear where the difference is
- Byte 2 and 3: Time of the timer in hex (hh mm), „ff“ if timer is deactivated

Timer 2:
- ident. timer 1 but in bytes 4 to 6

Timer 3:
- ident. timer 1 but in bytes 7 to 9

Timer 4:
- ident. timer 1 but in bytes 10 to 12

Clock:
- Byte 13 and 14: Current time (hh mm) in hex, does not run if neither random mode nor at least one timer is active!

**Handle 0x13 – Color and running time of timers**

- Get: char-write-req 13
- Characteristic value/descriptor: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
- Set: (see chapter „write new timer) 

Timer 1:
- Byte 1 to 4: Color of this timer (values for white, red, green, blue)
- Byte 5: Runtime of timer effect in minutes

Timer 2:
- ident. timer 1 but in bytes 6 to 10

Timer 3:
- ident. timer 1 but in bytes 11 to 15

Timer 4:
- ident. timer 1 but in bytes 16 to 20

### Set timer
The MIPOW Playbulb has 4 timers and an internal clock. 
Note: With my bulb (see version above) it is not possible to activate timers with repetition. The bulb always deactivates a timer after it has started.
In order to set a new timer only one handle must be written in request-mode (instead of command mode) 

**Write to Handle 0x1f**
- Set: char-write-req 1f 
- Byte 1: Number of timer that you want to set (value 00 to 03) – stored in handle 0x1f
- Byte 2: Timer type (00 – wake-up timer, 02 – doze timer, 04 – deactivated timer), actually values from 00 to 03 – stored in handle 0x1f
- Byte 3: set current time in seconds of internal clock in hex (note that it is just for sync reasons) -  written to handle 0x15 byte 1)
- Byte 4: set current time minutes of internal clock in hex – afterwards available in handle 0x1f byte 14 and handle 0x15 byte 2, clock runs automatically 
- Byte 5: set current time hours of internal clock in hex – afterwards available in handle 0x1f byte 13 and handle 0x15 byte 3, clock runs automatically
- Byte 6: "00" = Set timer, "ff" = delete timer
- Byte 7: Minutes of starting time in hex – stored in handle 0x1f
- Byte 8: Hours of starting time in hex – stored  in handle 0x1f
- Bytes 9 – 12: Color of this timer (values for white, red, green, blue) – stored in handle 0x13
- Byte 13: Runtime of timer in minutes or very fast if "ff" – stored in handle 13

### Random mode (called „security“ in app)
The bulb has a build-in functionality to turn on and off in a certain period. It is called „Security“ in app.
Note that handle must be written in request-mode (instead of command mode)

- Get: char-read-hnd 15
- Characteristic value/descriptor: 17 12 12 01 02 03 04 05 06 ff 00 00 00
- Set: char-write-req 15 000312ffffffffffff00000000

- Byte 1: current time in seconds of internal clock in hex (note that it is just for sync reasons) 
- Bytes 2 - 3: Current time in hex (mm hh)
- Bytes 4 - 5: Starting time of random mode (hh mm) in hex
- Bytes 6 to 7: Ending time of random mode (hh mm) in hex
- Byte 8: Min. interval (in minutes) in hex
- Byte 9: Max. interval (in minutes) in hex
- Byte 10 - 13: Color security mode (white red green blue)

Example:
- char-write-req 15 000312ffffffffffff00000000
- sets time to 18:03 and turns security function off

### Internal clock

The MIPOW Playbulb has an internal clock. Unfortunately it only runs in case that at least one timer is scheduled.

## Password (n/a)
Although according the app it should be possible to set a password for the bulb it does not work with my bulb.

## Factory Reset

A factory reset can be performed by sending the value 3 to handle 1d in request-mode (instead of command mode). 
This resets everything (timers, randommode, name etc.). It does neither turn off the bulb nor stops running effect.  

**Write to Handle 0x1d**
- Set: char-write-req 1d
- Byte 1: value "03" for factory reset


BTW: The bulb forgets everything after you have disconnected it from power. Therefore this is similar to a factory reset. It seems that the „given name“ of the bulb is the only thing that is still available after loss of power. 
