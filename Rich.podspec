#
# Be sure to run `pod lib lint Rich.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Rich'
  s.version          = '0.1.0'
  s.summary          = 'HUD , ActionSheet & AlertView driven by Yoga'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This project attempts to test the concept of protocol-oriented programming by combining three different kinds of attempts : HUD, AlertView & ActionSheet . Driven by Facebook Yoga
                        DESC

  s.homepage         = 'https://github.com/EricYellow/Rich'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hjphfut@163.com' => 'hjphfut@163.com' }
  s.source           = { :git => 'https://github.com/EricYellow/Rich.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Rich/Classes/**/*'
  
  s.resource_bundles = {
   'Rich' => ['Rich/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
 # s.dependency 'YogaKit ', '~> 1.6.0'
end
