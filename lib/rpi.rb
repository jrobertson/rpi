#!/usr/bin/env ruby

# file: rpi.rb

require 'pi_piper'


class RPi
  include PiPiper

  class Led < Pin

    HIGH = 1
    LOW = 0

    def initialize(id)
      @id = id
      super(pin: id, direction: :out)
      @state = self.value
    end

    def on()  super(); @state = :on   end

    def off()

      return if self.off?
      super()
      @state = :off
    end

    def blink(seconds=0.5)

      @state = :blink

      Thread.new do
        while @state == :blink do
          (set_pin HIGH; sleep seconds; set_pin LOW; sleep seconds) 
        end
      end
    end

    alias stop off    

    def on?()  @state == :on  end
    def off?() @state == :off end

    # set val with 0 (off) or 1 (on)
    #
    def set_pin(val)

      state = @state
      self.update_value val
      @state = state
    end
  end

  def initialize(a=[])
    @leds = a.map {|pin| Led.new pin }
  end

  def led() @leds end
end


if __FILE__ == $0 then
  # example
  my_rpi = RPi.new %w(17 22 18 4 23 25 27) # <-- each pin connects to an LED
  my_rpi.led[ARGV.first.to_i].method(ARGV.last.to_sym).call
end