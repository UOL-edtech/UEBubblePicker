#
# Be sure to run `pod lib lint UEBubblePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UEBubblePicker'
  s.version          = '1.4.0'
  s.summary          = 'A dynamic and flexible picker using UIKit Dynamics. Play around with bubbles and select/deselect them.'
  s.homepage         = 'https://github.com/UOL-edtech/UEBubblePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Iuri Chiba' => 'iurichiba@gmail.com', 'Thiago Penna' => 'thiago.penna@icloud.com' }
  s.source           = { :git => 'https://github.com/UOL-edtech/UEBubblePicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version         = '4.2'
  s.module_name           = 'UEBubblePicker'
  s.source_files          = 'Source/**/*.swift'
  s.resources             = 'Source/**/*.xib'

  s.frameworks = 'UIKit'
end
