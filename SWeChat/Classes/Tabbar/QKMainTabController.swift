//
//  QKMainTabController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import TimedSilver
import Cent

class QKMainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController();

    }
    
    func setupViewController() {
        let titleArray = ["微信","通讯录","发现","我"];
        
        let normalImagesArray = [
            TSAsset.Tabbar_mainframe.image,
            TSAsset.Tabbar_contacts.image,
            TSAsset.Tabbar_discover.image,
            TSAsset.Tabbar_me.image,
            ];
        
        let selectedImageArray = [
            TSAsset.Tabbar_mainframeHL.image,
            TSAsset.Tabbar_contactsHL.image,
            TSAsset.Tabbar_discoverHL.image,
            TSAsset.Tabbar_meHL.image,
        ];
        
        let viewControllerArray = [
            MessageController.ts_initFromNib(),
            ConstactsController.ts_initFromNib(),
            DiscoverController.ts_initFromNib(),
            MeController.ts_initFromNib()
            ];
        
        let  navigationVCArray = NSMutableArray();
        for (index,controller) in viewControllerArray.enumerated(){
            controller.tabBarItem!.title = titleArray.get(index: index);
            controller.tabBarItem!.image = normalImagesArray.get(index: index).withRenderingMode(.alwaysOriginal)
            controller.tabBarItem!.selectedImage = selectedImageArray.get(index: index).withRenderingMode(.alwaysOriginal)
            controller.tabBarItem!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.tabbarSelectedTextColor], for: .selected)
            let navigationController = UINavigationController(rootViewController: controller)
            navigationVCArray.add(navigationController)
            
        }
        
        self.viewControllers = navigationVCArray.mutableCopy() as! [UINavigationController]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
