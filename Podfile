project 'UNITE.xcodeproj'

# Uncomment this line to define a global platform for your project
#platform :ios, '10.0'

#abstract_target 'UNITE Universal' do 
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  #UI Pods
  pod 'Hue', '~> 2.0'
  
  # Pods for data parsing and charting
  pod 'RealmSwift'
  pod 'Charts'
  pod 'ChartsRealm'
  pod 'BezierPathLength'

  target 'UNITE Desktop' do 
  
    platform :osx, '10.12'
    
  end
  
  abstract_target 'UNITE iOS' do
    
    platform :ios, '10.0'
    # Pods for UNITE
    #pod 'Parse'
  
    pod 'ChameleonFramework/Swift'
    pod 'MXParallaxHeader'
    pod 'NGSPopoverView'
  
    # Pods for data parsing and charting
    pod 'GoogleMaps'
  
    target 'UNITE' do 
    end
    
    target 'UNITE iPad' do
    end
    
  end

#end