//
//  SwiftUIFireBaseApp.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI

import Firebase
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct SwiftUIFireBaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        KakaoSDK.initSDK(appKey: "e75744d6e9f6fc99f43c5ab0ee34b8d7")
    }
    var body: some Scene {
        WindowGroup {
            CrashView()
//            RootView()
//                .onOpenURL(perform: { url in
//                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                        AuthController.handleOpenUrl(url: url)
//                    }
//                })
        }
      
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        debugPrint("\(type(of: self))",#function,#line, "jha - <#Comment#>")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
