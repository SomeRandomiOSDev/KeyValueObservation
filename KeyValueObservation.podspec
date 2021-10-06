Pod::Spec.new do |s|
    
  s.name                = "KeyValueObservation"
  s.version             = "1.0.4"
  s.summary             = "A small KVO helper library"
  s.description         = <<-DESC
                          A small KVO helper library that provides a NSObject and a NSArray category for observing key value changes using blocks
                          DESC

  s.homepage            = "https://github.com/SomeRandomiOSDev/KeyValueObservation"
  s.license             = "MIT"
  s.author              = { "Joe Newton" => "somerandomiosdev@gmail.com" }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source              = { :git => "https://github.com/SomeRandomiOSDev/KeyValueObservation.git", :tag => s.version.to_s }

  s.test_spec do |ts|
    ts.source_files = 'Tests/KeyValueObservationTests/*.m'
  end

  s.public_header_files = 'Sources/KeyValueObservation/NSObject+KeyValueObservation.h', 'Sources/KeyValueObservation/NSArray+KeyValueObservation.h', 'Sources/KeyValueObservation/SRDKeyValueObservation.h', 'Sources/KeyValueObservation/SRDKeyValueObservedChange.h', 'Sources/KeyValueObservation/SRDKVOInfo.h'
  s.source_files        = 'Sources/KeyValueObservation/**/*.{h,m}'
  s.frameworks          = 'Foundation'
  s.requires_arc        = true
  
end
