# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion2.6/lib")
require 'motion/project/template/ios'
require 'bundler'
require 'bubble-wrap/media'
require "sugarcube-repl"
require 'sugarcube-all'
require 'bubble-wrap/reactor'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Letters Controller'
  app.icons = []
  app.prerendered_icon = true
  app.info_plist['View-Controller Based Status Bar Appearance'] = false
  app.pods do
    pod 'MBProgressHUD', '~> 0.8'
    pod 'Facebook-iOS-SDK'
  #  #pod 'JMImageCache'
  #  #pod 'SVPullToRefresh'
  #  #pod 'Mixpanel'
  end

  app.info_plist['FacebookAppID'] = '198671046923922'
  app.info_plist['FacebookDisplayName'] = 'Wiñata'
  app.info_plist['CFBundleURLTypes'] = [{'CFBundleURLSchemes' => ['198671046923922']}]
  app.info_plist['CFBundleURLTypes'] = [{'CFBundleURLSchemes' => ['fb198671046923922']}]

  app.files.unshift(*Dir['lib/*.rb'])

  app.libs << '/usr/lib/libz.1.1.3.dylib'
  app.libs << '/usr/lib/libsqlite3.dylib'

  app.deployment_target = "7.0"
  app.device_family = :iphone

  app.frameworks += [
      'AudioToolbox',
      'CFNetwork',
      'CoreGraphics',
      'CoreLocation',
      'MobileCoreServices',
      'QuartzCore',
      'Security',
      'StoreKit',
      'SystemConfiguration',
      'MediaPlayer',
      'Accelerate',
      'Foundation',
      'UIKit',
      'SystemConfiguration',
      'CoreTelephony',
      'ImageIO'
  ]

  app.weak_frameworks += [
      'Accounts',
      'AdSupport',
      'Social',
      'Twitter']

  app.files_dependencies  'app/app_delegate.rb' => 'app/lib/rmsettable.rb',
                          'app/lib/rmsettable.rb' => 'app/lib/rmsettings.rb'

  app.vendor_project('vendor/Parse.framework', :static, :products => ['Parse'], :headers_dir => 'Headers')

  app.provisioning_profile = '/Users/Sam/Library/MobileDevice/Provisioning Profiles/622AFBB8-E781-42A8-9EFD-4A2D7B0BD165.mobileprovision'
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.codesign_certificate = 'iPhone Distribution: VaynerMedia, LLC'
  app.identifier = "com.vaynermedia.letttershack"
  app.entitlements['get-task-allow'] = false # was crashing testflight build/deploy without
  app.seed_id = "VT38VC682R"


  app.entitlements['application-identifier'] = app.seed_id + '.' + app.identifier
  app.entitlements['keychain-access-groups'] = [
      app.seed_id + '.' + app.identifier
  ]
  app.entitlements['aps-environment'] = 'production'


  #app.development do
  #  app.testflight do
  #    app.testflight.sdk = 'vendor/TestFlightSDK'
  #    app.testflight.api_token = 'ae95c5690bc63e16d5f98ce02f484da7_MTA3NzQ2NzIwMTMtMDUtMjggMTg6MDE6MzcuNjExOTY2'
  #    app.testflight.team_token = 'ccd3f1b120446b2fc06e229c3e827bb4_MjI5NDg3MjAxMy0wNS0yOCAxODowNzoxNC44NTc0MDI'
  #    app.testflight.app_token = '8cdcf930-08e8-4c49-b1c0-7eb5fedb0f09'
  #  end
  #end

end

desc 'Build against production server'
task :prod do
  ENV['API_ENV'] = 'production'
  Rake::Task["simulator"].invoke
end

desc 'Build against staging server'
task :stage do
  ENV['API_ENV'] = 'staging'
  Rake::Task["simulator"].invoke
end

desc 'Build against local server'
task :dev do
  ENV['API_ENV'] = 'development'
  Rake::Task["simulator"].invoke
end