# Mipow Playbulb BTL201 Bluetooth API
## Characteristics

_"Mipow bulbs are all equal. But some bulbs are more equal than others."_

Actually the bulbs are not equal. There are a lot of different models. I have developed this script based
on a Mipow Playbulb BTL201. Even in terms of one and the same model they maybe differ in software / firmware 
versions. The result is that the API is different too in terms of the requests and _handles_ that have too be sent. 
Based on the so called _characteristics_ it is possible to find out which _handles_ are used for which API call since
all bulbs share the same _UUIDs_. 

The mipow script runs the `characteristics` command implicitly during the first run and stores the characteristics 
in `/tmp` folder, e.g. `/tmp/bulb-A9-D5-4B-0D-AC-E6.hnd`. Afterwards the script is able to map _UUIDs_ to _handles_ 
by looking them up as follows:
```
handle = 0x0002, char properties = 0x0a, char value handle = 0x0003, uuid = 00002a00-0000-1000-8000-00805f9b34fb
                                                                            ^----> ^ UUID
                                                               ^->^ Handle
```

Here is a table of UUIDs and their meaning. Maybe there are other bulbs which have more functionality and therefore more useful UUIDs.

| UUID | Meaning |
| --- | --- |
| 00002a25 | product id | 
| 00002a26 | product version |
| 00002a29 | vendor |
| 00002a28 | software version |
| 00002a27 | microprocessor |
| 0000ffff | given name |
| 0000fffd | reset |
| 0000fffc | color |
| 0000fffb | effect |
| 0000fffe | timer settings |
| 0000fff8 | timer effects |
| 0000fff9 | random mode |

Full output of `characteristcs` for my bulb:
```
handle = 0x0002, char properties = 0x0a, char value handle = 0x0003, uuid = 00002a00-0000-1000-8000-00805f9b34fb
handle = 0x0004, char properties = 0x02, char value handle = 0x0005, uuid = 00002a01-0000-1000-8000-00805f9b34fb
handle = 0x0006, char properties = 0x02, char value handle = 0x0007, uuid = 00002a04-0000-1000-8000-00805f9b34fb
handle = 0x0009, char properties = 0x22, char value handle = 0x000a, uuid = 00002a05-0000-1000-8000-00805f9b34fb
handle = 0x000d, char properties = 0x10, char value handle = 0x000e, uuid = 00002a37-0000-1000-8000-00805f9b34fb
handle = 0x0010, char properties = 0x0e, char value handle = 0x0011, uuid = 00002a39-0000-1000-8000-00805f9b34fb
handle = 0x0012, char properties = 0x02, char value handle = 0x0013, uuid = 0000fff8-0000-1000-8000-00805f9b34fb
handle = 0x0014, char properties = 0x0a, char value handle = 0x0015, uuid = 0000fff9-0000-1000-8000-00805f9b34fb
handle = 0x0016, char properties = 0x06, char value handle = 0x0017, uuid = 0000fffa-0000-1000-8000-00805f9b34fb
handle = 0x0018, char properties = 0x06, char value handle = 0x0019, uuid = 0000fffb-0000-1000-8000-00805f9b34fb
handle = 0x001a, char properties = 0x06, char value handle = 0x001b, uuid = 0000fffc-0000-1000-8000-00805f9b34fb
handle = 0x001c, char properties = 0x0a, char value handle = 0x001d, uuid = 0000fffd-0000-1000-8000-00805f9b34fb
handle = 0x001e, char properties = 0x0a, char value handle = 0x001f, uuid = 0000fffe-0000-1000-8000-00805f9b34fb
handle = 0x0020, char properties = 0x0a, char value handle = 0x0021, uuid = 0000ffff-0000-1000-8000-00805f9b34fb
handle = 0x0023, char properties = 0x12, char value handle = 0x0024, uuid = 00002a19-0000-1000-8000-00805f9b34fb
handle = 0x0027, char properties = 0x02, char value handle = 0x0028, uuid = 00002a25-0000-1000-8000-00805f9b34fb
handle = 0x0029, char properties = 0x02, char value handle = 0x002a, uuid = 00002a27-0000-1000-8000-00805f9b34fb
handle = 0x002b, char properties = 0x02, char value handle = 0x002c, uuid = 00002a26-0000-1000-8000-00805f9b34fb
handle = 0x002d, char properties = 0x02, char value handle = 0x002e, uuid = 00002a28-0000-1000-8000-00805f9b34fb
handle = 0x002f, char properties = 0x02, char value handle = 0x0030, uuid = 00002a29-0000-1000-8000-00805f9b34fb
handle = 0x0031, char properties = 0x02, char value handle = 0x0032, uuid = 00002a50-0000-1000-8000-00805f9b34fb
handle = 0x0034, char properties = 0x0a, char value handle = 0x0035, uuid = 00001013-d102-11e1-9b23-00025b00a5a5
handle = 0x0036, char properties = 0x08, char value handle = 0x0037, uuid = 00001018-d102-11e1-9b23-00025b00a5a5
handle = 0x0038, char properties = 0x12, char value handle = 0x0039, uuid = 00001014-d102-11e1-9b23-00025b00a5a5
handle = 0x003b, char properties = 0x02, char value handle = 0x003c, uuid = 00001011-d102-11e1-9b23-00025b00a5a5
```

**Note: The handles mentioned below are meant for my bulb. Therefore you have to check the characteristics of your device by running the "characteristics" command in gatttool.**

## Device Information

**The product id of the bulb (uuid = 00002a25)**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „BTL201“
- Get: char-read-hnd 28
- Characteristic value/descriptor: 42 54 4c 32 30 31
- Set: n/a

**The product id of the bulb incl. Version (uuid = 00002a26)**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „BTL201_v2“
- Get: char-read-hnd 2c
- Characteristic value/descriptor: 42 54 4c 32 30 31 5f 76 32
- Set: n/a

**The vendor of the bulb (uuid = 00002a29)**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „Mipow Limited“
- Get: char-read-hnd 30
- Characteristic value/descriptor: 4d 69 70 6f 77 20 4c 69 6d 69 74 65 64
- Set: n/a

**The software version of the bulb (uuid = 00002a28)**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „Application version 2.4.3.26“
- Get: char-read-hnd 2e
- Characteristic value/descriptor: 41 70 70 6c 69 63 61 74 69 6f 6e 20 76 65 72 73 69 6f 6e 20 32 2e 34 2e 33 2e 32 36
- Set: n/a

**Microprocessor of bulb (uuid = 00002a27)**
- Encoded in ASCII, you must transform hex to ascii
- Default value: „CSR101x A05“ 
- Get: char-read-hnd 2a
- Characteristic value/descriptor: 43 53 52 31 30 31 78 20 41 30 35
- Set: n/a

**The given name of the bulb (uuid = 0000ffff)**
- Default value: "MIPOW SMART BULB"
- Get: char-read-hnd 3
- Characteristic value/descriptor: 4d 49 50 4f 57 20 53 4d 41 52 54 20 42 55 4c 42
- Set: char-write-req 3 4142434445464748494a4b4c4d4e4f
- Set: char-write-req 21 4142434445464748494a4b4c4d4e4f

*Note:* This seems to be the only value that will be kept after you have disconnected the bulb from power. 

## Color
The color of the bulb. Can also be used in order to read current color, in case that effect runs. 

**Color of bulb (uuid = 0000fffc)**
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

**effect of bulb (uuid = 0000fffb)**

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

**Status and starting times of timers (uuid = 0000fffe)**

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

**Color and running time of timers (uuid = 0000fff8)**

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

**Write to Handle 0x1f (uuid = 0000fffe)**
- Set: char-write-req 1f 
- Byte 1: Number of timer that you want to set (value 01 to 04) – stored in handle 0x1f
- Byte 2: Timer type (00 – wake-up timer, 02 – doze timer, 04 – deactivated timer), actually values from 00 to 03 – stored in handle 0x1f
- Byte 3: set current time in seconds of internal clock in hex (note that it is just for sync reasons) -  written to handle 0x15 byte 1)
- Byte 4: set current time minutes of internal clock in hex – afterwards available in handle 0x1f byte 14 and handle 0x15 byte 2, clock runs automatically 
- Byte 5: set current time hours of internal clock in hex – afterwards available in handle 0x1f byte 13 and handle 0x15 byte 3, clock runs automatically
- Byte 6: "00" = Set timer, "ff" = delete timer
- Byte 7: Minutes of starting time in hex – stored in handle 0x1f
- Byte 8: Hours of starting time in hex – stored  in handle 0x1f
- Bytes 9 – 12: Color of this timer (values for white, red, green, blue) – stored in handle 0x13
- Byte 13: Runtime of timer in minutes or very fast if "ff" – stored in handle 13

### Random mode called „security“ in app (uuid = 0000fff9)
The bulb has a build-in functionality to turn on and off in a certain period. It is called „Security“ in app.
Note that handle must be written in request-mode (instead of command mode)

- Get: char-read-hnd 15
- Characteristic value/descriptor: 17 12 12 01 02 03 04 05 06 ff 00 00 00
- Set: char-write-req 15 000312ffffffffffff00000000

- Byte 1: Meaning is unclear, if random mode or timer is active value is different from „00“
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

## Factory Reset (uuid = 0000fffd)

A factory reset can be performed by sending the value 3 to handle 1d in request-mode (instead of command mode). 
This resets everything (timers, randommode, name etc.). It does neither turn off the bulb nor stops running effect.  

**Write to Handle 0x1d**
- Set: char-write-req 1d
- Byte 1: value "03" for factory reset


BTW: The bulb forgets everything after you have disconnected it from power. Therefore this is similar to a factory reset. It seems that the „given name“ of the bulb is the only thing that is still available after loss of power. 
