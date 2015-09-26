#!/usr/bin/env ruby

# file: rpi.rb

require 'pi_piper'


class RPi
  include PiPiper
  
  @leds = []

  class PinX < Pin

    HIGH = 1
    LOW = 0

    def initialize(id)
      @id = id
      super(pin: id, direction: :out)
      @state = self.value
    end

    def on(duration=nil)
      super(); 
      @state = :on
      (sleep duration; self.off) if duration
    end

    def off()

      return if self.off?
      super()
      @state = :off
    end

    def blink(seconds=0.5, duration: nil)

      @state = :blink
      t2 = Time.now + duration if duration

      Thread.new do
        while @state == :blink do
          (set_pin HIGH; sleep seconds; set_pin LOW; sleep seconds) 
          self.off if duration and Time.now >= t2
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
    
    def to_s()
      @id
    end
  end
  
  class Void
    def on(duration=nil)               end
    def off()                          end
    def blink(seconds=0, duration=nil) end
    alias stop off
  end  

  def initialize(a=[])
    
    unexport_all a
    
    @pins = a.map {|pin| PinX.new pin }
    
    def @pins.[](i)

      if i.to_i >= self.length then
        puts "RPi warning: PinX instance #{i.inspect} not found"
        Void.new
      else
        self.at(i)
      end 
    end    
    
    at_exit do
      
      # to avoid "Device or resource busy @ fptr_finalize - /sys/class/gpio/export"
      # we unexport the pins we used
      
      unexport_all a
    end    
  end

  def pins()    @pins       end
    
  def unexport_all(pins)
    
    pins.each do |pin|
      
      next unless File.exists? '/sys/class/gpio/gpio' + pin.to_s

      uexp = open("/sys/class/gpio/unexport", "w")
      uexp.write(pin)
      uexp.close
    end
    
  end
  
  def on_exit
    unexport_all @pins
  end
  
  def self.unexport(a)
    a.each do |pin|
      
      uexp = open("/sys/class/gpio/unexport", "w")
      uexp.write(pin)
      uexp.close
    end    
  end

end


if __FILE__ == $0 then
  # example
  my_rpi = RPi.new %w(17 22 18 4 23 25 27) # <-- each pin connects to an LED
  my_rpi.pins[ARGV.first.to_i].method(ARGV.last.to_sym).call
end
