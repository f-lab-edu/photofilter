# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def common_pods_for_target
	
pod 'FirebaseAuth'
pod 'FirebaseFirestore'

end

target 'cameraFilter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for cameraFilter
  common_pods_for_target
  

  target 'cameraFilterTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods_for_target
  end

  target 'cameraFilterUITests' do
    # Pods for testing
    common_pods_for_target
  end

end
