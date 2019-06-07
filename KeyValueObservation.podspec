Pod::Spec.new do |s|
    
  s.name                = "KeyValueObservation"
  s.version             = "1.0.1"
  s.summary             = "A small KVO helper library"
  s.description         = <<-DESC
                          A small KVO helper library that provides a NSObject and a NSArray category for observing key value changes using blocks
                          DESC

  s.homepage            = "https://github.com/SomeRandomiOSDev/KeyValueObservation"
  s.license             = "MIT"
  s.author              = { "Joseph Newton" => "somerandomiosdev@gmail.com" }

  s.ios.deployment_target     = '8.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source              = { :git => "https://github.com/SomeRandomiOSDev/KeyValueObservation.git", :tag => s.version.to_s }

  s.public_header_files = 'KeyValueObservation/NSObject+KeyValueObservation.h', 'KeyValueObservation/NSArray+KeyValueObservation.h', 'KeyValueObservation/SRDKeyValueObservation.h', 'KeyValueObservation/SRDKeyValueObservedChange.h'
  s.source_files        = 'KeyValueObservation/**/*.{h,m}'
  s.frameworks          = 'Foundation'
  s.requires_arc        = true
  
end
