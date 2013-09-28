class AppDelegate
  include RMSettable

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rm_settable :device_token, :game_id
    application.setStatusBarHidden(true, withAnimation:false)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @window.rootViewController = LettersController.alloc.init

    Parse.setApplicationId('Kabo8I8ijvSFRk4x6W8TqC6I4iyZtAeGRVSu3DsQ', clientKey:'LLjdXbpiV3U9LV3AIFSAby0WKjvxWU4Gbb1wGj0H' )

    application.registerForRemoteNotificationTypes(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeAlert |
                                                       UIRemoteNotificationTypeSound)


    UIApplication.sharedApplication.delegate.settings.game_id = nil
    true

  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    PFPush.storeDeviceToken(deviceToken)
    UIApplication.sharedApplication.delegate.settings.device_token = deviceToken
    PFPush.subscribeToChannelInBackground("game_turn")
  end

  def application(application, didReceiveRemoteNotification: userInfo)
    word = userInfo['aps']['alert']
    application.rootViewController.setTurn(word)
  end


end
