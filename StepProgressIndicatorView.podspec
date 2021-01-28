#
# Be sure to run `pod lib lint StepProgressIndicatorView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StepProgressIndicatorView'
  s.version          = '1.0.2'
  s.summary          = 'iOS Library for building step progress indicator view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
		StepProgressIndicatorView is an iOS Library that indicates steps progress.
                       DESC

  s.homepage         = 'https://github.com/miiiiiin/StepProgressIndicatorView'
  s.screenshots      = "https://raw.githubusercontent.com/miiiiiin/StepProgressIndicatorView/master/Screenshots/Screenshot.png"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'miiiiiin' => 'min.songkyung@gmail.com' }
  s.source           = { :git => 'https://github.com/miiiiiin/StepProgressIndicatorView.git', :tag => s.version.to_s }
  s.swift_versions = ['4.2', '5.0']
  s.platform       = :ios, "13.0"
  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'
  s.exclude_files = 'Example/StepProgressIndicatorView/*.plist'

   #s.resource_bundles = {
    # 'StepProgressIndicatorView' => ['Assets/*.xcassets']
   #}

end
