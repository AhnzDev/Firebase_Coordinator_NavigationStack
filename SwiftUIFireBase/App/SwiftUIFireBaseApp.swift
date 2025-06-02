//
//  SwiftUIFireBaseApp.swift
//  SwiftUIFireBase
//
//  Created by Jihoon on 4/30/25.
//

import SwiftUI

import Firebase
import FirebaseCore

@main
struct SwiftUIFireBaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
//                        logger.debug(msg: "앱이 활성화되었습니다")
                        AZLogger.azOsLog("앱이 활성화되었습니다", level: .error)
                    case .inactive:
//                        logger.debug(msg: "앱이 비활성화됩니다")
                        AZLogger.azOsLog("앱이 비활성화됩니다", level: .error)
                    case .background:
//                        logger.debug(msg: "앱이 백그라운드로 전환됩니다")
                        AZLogger.azOsLog("앱이 백그라운드로 전환됩니다", level: .error)
                        
                    @unknown default:
                        break
                    }
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
    
}
