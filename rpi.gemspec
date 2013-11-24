Gem::Specification.new do |s|
  s.name = 'rpi'
  s.version = '0.1.0'
  s.summary = 'The RPi gem makes it easy to set blinking LEDs on the Rapsberry Pi'
  s.authors = ['James Robertson']
  s.add_dependency('pi_piper')
  s.files = Dir['lib/**/*.rb']
  s.signing_key = '../privatekeys/rpi.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rpi'
end
