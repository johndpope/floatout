 platform :ios, '8.0'
 use_frameworks!

target 'Floatinc' do
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'CameraManager'
  pod 'PBJVideoPlayer'
  pod 'AKPickerView-Swift'
  pod 'SDWebImage'
  pod 'GoogleMaps'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      target.build_settings(configuration.name)['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
