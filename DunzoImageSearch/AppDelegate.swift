//
//  AppDelegate.swift
//  DunzoImageSearch
//
//  Created by Shilpa Garg on 01/08/20.
//  Copyright © 2020 Shilpa Garg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window = UIWindow.init()
        let imageSearchController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageSearchControllerID") as! ImageSearchController
        appDelegate.window?.rootViewController = imageSearchController
        appDelegate.window?.makeKeyAndVisible()
        return true
    }


}

