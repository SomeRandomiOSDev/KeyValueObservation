Pod::Spec.new do |s|

  s.name         = "KeyValueObservation"
  s.version      = "1.0.6"
  s.summary      = "A small KVO helper library"
  s.description  = <<-DESC
                   A small KVO helper library that provides a NSObject and a NSArray category for observing key value changes using blocks
                   DESC

  s.homepage     = "https://github.com/SomeRandomiOSDev/KeyValueObservation"
  s.license      = "MIT"
  s.author       = { "Joe Newton" => "somerandomiosdev@gmail.com" }
  s.source       = { :git => "https://github.com/SomeRandomiOSDev/KeyValueObservation.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files        = 'Sources/KeyValueObservation/**/*.{h,m}'
  s.public_header_files = 'Sources/KeyValueObservation/include/*.h'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target     = '9.0'
    ts.macos.deployment_target   = '10.10'
    ts.tvos.deployment_target    = '9.0'
    ts.watchos.deployment_target = '2.0'

    ts.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_TARGET_SRCROOT}/Sources/KeyValueObservation/include' }
    ts.preserve_paths      = 'Sources/KeyValueObservation/include/*.modulemap'
    ts.source_files        = 'Tests/KeyValueObservationTests/*.m'
  end

end
