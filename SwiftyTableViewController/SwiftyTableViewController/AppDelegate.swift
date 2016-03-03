//
//  AppDelegate.swift
//  SwiftyTableViewController
//
//  Created by 平松　亮介 on 2016/03/03.
//  Copyright © 2016年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tableVC = MyTableViewController<Person>(
            configuration: TableViewConfiguration<Person>(
                items: people,
                style: .Plain,
                cellStyle: .Subtitle,
                editable: true) { cell, item in
                    cell.textLabel?.text = item.name
                    cell.detailTextLabel?.text = item.city
            })
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        tableVC.title = "Person"
        let navigationController = UINavigationController(rootViewController: tableVC)
        navigationController.view.frame = CGRectMake(0, 0, 320, 480)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}

