Gem::Specification.new do |s|
  s.name = 'rpi'
  s.version = '0.5.0'
  s.summary = 'The RPi gem makes it easy to set the GPIO pins on the Raspberry Pi e.g. RPi.new([4,27]).pins.first.on'
  s.authors = ['James Robertson']
  s.add_runtime_dependency('rpi_pinout', '~> 0.1', '>=0.1.1')
  s.files = Dir['lib/rpi.rb']
  s.signing_key = '../privatekeys/rpi.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/rpi'
  s.required_ruby_version = '>= 2.1.2'
end
