Pod::Spec.new do |s|
  s.name         = "Dahab"
  s.version      = "0.1"
  s.homepage    = "http://google.com"
  s.summary      = "An abstraction for resusable tableviews"
  s.license      = { :type => 'BSD' }
  s.author        = { "Yousef Hamza" => "jo.adam.93@gmail.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/yousefhamza/Dahab.git", :tag => "#{s.version}" }
  s.source_files  = "Dahab"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.dependency "Snapkit", "~> 3.2.0"
end