#
# Be sure to run `pod lib lint STSegmentPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STSegmentPageView'
  s.version          = '0.1.0'
  s.summary          = 'A powerful and useful segment tool, segment controller and custom segment titleView、 segment contentView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A powerful and useful segment tool, segment controller and custom segment titleView、 segment contentView
                       DESC

  s.homepage         = 'https://github.com/wheying/STSegmentPageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EricWan' => 'hongenwan@gmail.com' }
  s.source           = { :git => 'https://github.com/wheying/STSegmentPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'STSegmentPageView/Classes/**/*'
  s.swift_version = '4.1'
  # s.resource_bundles = {
  #   'STSegmentPageView' => ['STSegmentPageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
