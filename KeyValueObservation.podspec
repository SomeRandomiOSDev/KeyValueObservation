#
# Be sure to run `pod lib lint KeyValueObservation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
  s.name                = "KeyValueObservation"
  s.version             = "1.0.0"
  s.summary             = "A small KVO helper library"
  s.description         = <<-DESC
                          A small KVO helper library that provides a NSObject and a NSArray category for observing key value changes using blocks
                          DESC

  s.homepage            = "https://github.com/SomeRandomiOSDev/KeyValueObservation"
  s.license             = "MIT"
  s.author              = { "Joseph Newton" => "somerandomiosdev@gmail.com" }

  s.platform            = :ios, '8.0'
  s.source              = { :git => "https://github.com/SomeRandomiOSDev/KeyValueObservation.git", :tag => s.version.to_s }

  s.public_header_files = 'KeyValueObservation/Classes/NSObject+KeyValueObservation.h', 'KeyValueObservation/Classes/NSArray+KeyValueObservation.h', 'KeyValueObservation/Classes/SRDKeyValueObservation.h', 'KeyValueObservation/Classes/SRDKeyValueObservedChange.h'
  s.source_files        = 'KeyValueObservation/Classes/**/*'
  s.frameworks          = 'Foundation'
  s.requires_arc        = true
  
end
