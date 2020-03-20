//
//  AppDelegate.swift
//  MKMapView 37-38 SW HW
//
//  Created by Marentilo on 20.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mapView = ViewController()
        let navigationController = UINavigationController(rootViewController: mapView)
        window?.rootViewController = navigationController
        return true
    }


}

