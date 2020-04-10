#
# Be sure to run `pod lib lint Shifu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Shifu'
  s.version          = '0.2.2'
  s.summary          = 'Shifu.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a common library that we are going to use in other projects
                       DESC

  s.homepage         = 'https://github.com/horidream/Shifu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'horidream' => 'horidream@gmail.com' }
  s.source           = { :git => 'https://github.com/horidream/Shifu.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Shifu/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Shifu' => ['Shifu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'FMDB'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
