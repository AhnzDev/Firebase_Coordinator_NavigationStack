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
 
    
    var body: some Scene {
        WindowGroup {
            RootView()
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
