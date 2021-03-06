Pod::Spec.new do |s|
  s.name           = 'CocoaHTTPServerExpress'
  s.version        = '0.0.3.1'
  s.license        = 'BSD'
  s.summary        = 'Embeddable HTTP server that make testing easier.'
  s.homepage       = 'https://github.com/mgchris/CocoaHTTPServerExpress'
  s.authors        = { 'Christopher Evans' => 'christopher@morphosisgames.com' }
  s.source         = { :git => 'https://github.com/mgchris/CocoaHTTPServerExpress.git', :tag => '0.0.3.1' }
  s.source_files   = 'CocoaHTTPServerExpress/HTTPExpress/**/*.{h,m}'
  s.platform = :ios, '7.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc   = true
  s.dependency "CocoaHTTPServer"
end
