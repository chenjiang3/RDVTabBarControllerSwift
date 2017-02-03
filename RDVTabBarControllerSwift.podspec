#
# Be sure to run `pod lib lint RDVTabBarControllerSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RDVTabBarControllerSwift'
  s.version          = '0.1.0'
  s.summary          = 'Highly customizable tabBar and tabBarController for iOS, written by Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Highly customizable tabBar and tabBarController for iOS, written by Swift. Supports iPad and iPhone,Supports landscape and portrait orientations,Can be used inside UINavigationController,Customizable badges
                       DESC

  s.homepage         = 'https://github.com/chenjiang3/RDVTabBarControllerSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenjiang' => '841346457@qq.com' }
  s.source           = { :git => 'https://github.com/chenjiang3/RDVTabBarControllerSwift.git', :tag => "v0.1.0" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RDVTabBarControllerSwift/Classes/**/*'

  # s.resource_bundles = {
  #   'RDVTabBarControllerSwift' => ['RDVTabBarControllerSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
