#
# Be sure to run `pod lib lint StepProgressIndicatorView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StepProgressIndicatorView'
  s.version          = '1.0.0'
  s.summary          = 'Swift Framework for building step progress indicator view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/miiiiiin/StepProgressIndicatorView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'miiiiiin' => 'min.songkyung@gmail.com' }
  s.source           = { :git => 'https://github.com/miiiiiin/StepProgressIndicatorView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_versions = ['4.2', '5.0']
  s.platform       = :ios, "13.0"
  s.ios.deployment_target = '13.0'

  s.source_files = 'StepProgressIndicatorView/Classes/**/*'
  s.frameworks = 'UIKit'

  # s.resource_bundles = {
  #   'StepProgressIndicatorView' => ['StepProgressIndicatorView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
