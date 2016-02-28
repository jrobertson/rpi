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
      @on, @blinking = false, false
    end

    def on(durationx=nil, duration: nil)
      super(); 
      @on = true      
      duration ||=  durationx
      
      @off_thread.exit if @off_thread
      @on_thread = Thread.new {(sleep duration; self.off()) } if duration

    end

    def off(durationx=nil, duration: nil)

      super();
      return if @internal_call
      
      @on, @blinking = false, false      
      duration ||=  durationx
      
      @on_thread.exit if @on_thread
      @off_thread = Thread.new { (sleep duration; self.on()) } if duration

    end
    
    alias high on # opposite of low
    alias open on # opposite of close
    alias lock on # opposite of unlock
    
    alias stop off        
    alias low off
    alias close off
    alias unlock off

    def blink(seconds=0.5, duration: nil)

      @blinking = true
      t2 = Time.now + duration if duration

      Thread.new do
        while @blinking do

          set_pin HIGH
          sleep seconds / 2.0
          break if !@blinking
          sleep seconds / 2.0 
          break if !@blinking
          
          set_pin LOW;
          sleep seconds / 2.0
          break if !@blinking
          sleep seconds / 2.0

          break if !@blinking
          
          self.off if duration and Time.now >= t2
        end
        
      end
    end
    
    alias oscillate blink

    def on?()  @on  end
    def off?() !@on end

    # set val with 0 (off) or 1 (on)
    #
    def set_pin(val)

      @internal_call = true
      self.update_value val
      @internal_call = false
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

  def initialize(x=[])
    
    a = case x
    when Fixnum
      [x]
    when String
      [x]
    when Array
      x
    end

    unexport_all a
    
    @pins = a.map {|pin| PinX.new pin }
    
    def @pins.[](i)

      if i.respond_to? :to_i and i.to_i >= self.length then
        puts "RPi warning: PinX instance #{i.inspect} not found"
        Void.new
      else
        super(i)
      end 
    end    
    
    at_exit do
      
      # to avoid "Device or resource busy @ fptr_finalize - /sys/class/gpio/export"
      # we unexport the pins we used
      
      unexport_all a
    end    
  end

  def pin()   @pins.first  end
  def pins()  @pins        end
    
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