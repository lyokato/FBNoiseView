Pod::Spec.new do |s|
  s.name         = "FBNoiseView"
  s.version      = "0.0.1"
  s.summary      = "View supports noise effect"
  s.description  = <<-DESC
  This library provids view classes support noise effect
                   DESC
  s.homepage     = "http://github.com/lyokato/FBNoiseView"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Lyo Kato" => "lyo.kato@gmail.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/lyokato/FBNoiseView.git", :tag => "0.0.1" }
  s.source_files  = 'FBNoiseView/Classes/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  # s.public_header_files = 'Classes/**/*.h'
  # s.resource    = "icon.png"
  s.resources     = "FBNoiseView/Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'
  s.requires_arc = true
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'
end
