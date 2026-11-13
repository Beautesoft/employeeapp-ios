# Minimum iOS raised from 9.0: current Xcode (16/26) cannot build for < iOS 12,
# and Firebase 11 requires iOS 13.
platform :ios, '13.0'

target 'BeauteSoft' do
  use_frameworks!

  # Pinned to the major versions the code was written against (newer majors change APIs).
  pod 'Alamofire', '~> 4.9'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'SDWebImage', '~> 5.2'
  pod 'SWRevealViewController', '~> 2.3'
  pod 'FSCalendar', '~> 2.8'

  # Firebase 6.x (2020) ships binaries with bitcode, which App Store Connect now rejects.
  pod 'Firebase/Analytics', '~> 11.0'
  pod 'Firebase/Database', '~> 11.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Old pods declare iOS 8/9 targets, which recent Xcode refuses to build.
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
