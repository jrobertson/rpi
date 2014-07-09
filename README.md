# Introducing the RPi gem

The 1st Raspberry PI GPIO project most people start with is to set an LED on or off. This gem simply allows you to set the state of multiple LEDs (either on, off, or blink).

## Example

    rpi = RPi.new %w(17 22 18) # <-- each pin connects to an LED
    rpi.led[1].on
    sleep 2
    rpi.led[1].off
    rpi.led[2].blink
    sleep 4
    rpi.led[2].stop


Note: The blink value can be changed from the default 0.5 seconds to blink more often (e.g. 0.2) or less often (e.g. 1.5).

## Blinking an LED for a specified duration

    require 'rpi'

    my_rpi = RPi.new %w(17 22 18 4 23 25 27) # <-- each pin connects to an LED

    # blink the LED attached to GPIO pin 22 for 4 seconds
    my_rpi.led[1].blink duration: 4

    # blink the LED at a rate of 0.2 for 4 seconds
    my_rpi.led[1].blink 0.2, duration: 4


## Resources

* [jrobertson/rpi](https://github.com/jrobertson/rpi)
* [jwhitehorn/pi_piper](https://github.com/jwhitehorn/pi_piper)

rpi gem pipiper raspberrypi
