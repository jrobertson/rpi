Gem::Specification.new do |s|
  s.name = 'rpi'
  s.version = '0.2.4'
  s.summary = 'The RPi gem makes it easy to set blinking LEDs on the Raspberry Pi'
  s.authors = ['James Robertson']
  s.add_runtime_dependency('pi_piper', '~> 1.3', '>=1.3.2')
  s.files = Dir['lib/**/*.rb']
  s.signing_key = '../privatekeys/rpi.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rpi'
  s.required_ruby_version = '>= 2.1.2'
end
