# Uncomment the next line to define a global platform for your project
#platform :ios, '18.0'

flutter_application_path = '../my_flutter'
  load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
target 'QrScannerE' do
  use_frameworks!
  
  install_all_flutter_pods(flutter_application_path)

end
post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
