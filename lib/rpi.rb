#!/usr/bin/env ruby

# file: rpi.rb

require 'rpi_pinout'


class RPi
    
  class Void
    def on(duration=nil)               end
    def off()                          end
    def blink(seconds=0, duration=nil) end
    alias stop off
  end  

  def initialize(x=[])
    
    a = case x
    when Integer
      [x]    
    when Fixnum
      [x]
    when String
      [x]
    when Array
      x
    end
    
    @pins = a.map {|pin| RPiPinOut.new pin }
    
    def @pins.[](i)

      if i.to_i >= self.length then
        puts "RPi warning: RPiPinOut instance #{i.inspect} not found"
        Void.new
      else
        self.at(i)
      end 
    end    
  
  end

  def pin()   @pins.first  end
  def pins()  @pins        end
    

end


if __FILE__ == $0 then
  # example
  my_rpi = RPi.new %w(17 22 18 4 23 25 27) # <-- each pin connects to an LED
  my_rpi.pins[ARGV.first.to_i].method(ARGV.last.to_sym).call
end
