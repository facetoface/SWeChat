//
//  MeController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class MeController: UIViewController {

    @IBOutlet weak var listTabbleView: UITableView!
    
    fileprivate let itemDataSouce:[[(name: String, iconImage: UIImage?)]] =
        [
            [("",nil)],
            [("相册",TSAsset.MoreMyAlbum.image),
             ("收藏",TSAsset.MoreMyFavorites.image),
             ("钱包",TSAsset.MoreMyBankCard.image),
             ("优惠券",TSAsset.MyCardPackageIcon.image),],
            [("表情",TSAsset.MoreExpressionShops.image)],
            [("设置",TSAsset.MoreSetting.image)],
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我";
        self.view.backgroundColor = UIColor.viewBackgroundColor;
        self.listTabbleView.ts_registerCellNib(TSMeAvatarTableViewCell.self);
        self.listTabbleView.ts_registerCellNib(TSImageTextTableViewCell.self);
        self.listTabbleView.tableFooterView = UIView();
        // Do any additional setup after loading the view.
    }

    deinit {
        log.verbose("deinit");
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

extension MeController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:TSMeAvatarTableViewCell = tableView.ts_dequeueReusableCell( TSMeAvatarTableViewCell.self);
            return cell;
        } else {
            let cell:TSImageTextTableViewCell = tableView.ts_dequeueReusableCell( TSImageTextTableViewCell.self);
            let item = self.itemDataSouce[indexPath.section][indexPath.row];
            cell.iconImageView.image = item.iconImage;
            cell.titleLabel.text = item.name;
            return cell;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemDataSouce.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.itemDataSouce[section];
        return rows.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88;
        } else {
            return 44;
        }
    }
}
