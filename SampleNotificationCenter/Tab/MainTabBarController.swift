//
//  MainTabBarController.swift
// SampleNotificationCenter
//
//  Created by koala panda on 2023/04/20.
//

import UIKit
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
    }

    func initTabBar() {

        guard let redVC = UIStoryboard(name: "Red", bundle: nil).instantiateInitialViewController() as? RedViewController else {
            return
        }
        // ここでViewControllerにモデルを渡しています
        redVC.countModel = CountModel.shared
        redVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let redNVC = UINavigationController(rootViewController: redVC)


        guard let blueVC = UIStoryboard(name: "Blue", bundle: nil).instantiateInitialViewController() as? BlueViewController else {
            return
        }
        blueVC.countModel = CountModel.shared
        blueVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let blueNVC = UINavigationController(rootViewController: blueVC)

        guard let greenVC = UIStoryboard(name: "Green", bundle: nil).instantiateInitialViewController() as? GreenViewController else {
            return
        }
        greenVC.countModel = CountModel.shared
        greenVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        let greenNVC = UINavigationController(rootViewController: greenVC)



        setViewControllers([redNVC, blueNVC, greenNVC], animated: false)

    }



}
