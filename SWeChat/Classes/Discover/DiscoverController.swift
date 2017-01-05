//
//  DiscoverController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class DiscoverController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    fileprivate let itemDataSouce: [[(name: String, iconImage: UIImage)]] =
        [[("朋友圈",TSAsset.Ff_IconShowAlbum.image)],
         [("扫一扫",TSAsset.Ff_IconQRCode.image),
          ("摇一摇",TSAsset.Ff_IconShake.image)],
         [("附近的人",TSAsset.Ff_IconLocationService.image),
          ("漂流瓶",TSAsset.Ff_IconBottle.image)],
         [("游戏",TSAsset.MoreGame.image)],
         ];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发现"
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.listTableView.ts_registerCellNib(TSImageTextTableViewCell.self)
        self.listTableView.rowHeight = 44
        self.listTableView.tableFooterView = UIView()
    }
    
    deinit {
        log.verbose("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension DiscoverController: UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiscoverController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.itemDataSouce[section]
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TSImageTextTableViewCell = tableView.ts_dequeueReusableCell(TSImageTextTableViewCell.self)
        let item = self.itemDataSouce[indexPath.section][indexPath.row]
        cell.iconImageView.image = item.iconImage
        cell.titleLabel.text = item.name
        return cell
    }
    
}
