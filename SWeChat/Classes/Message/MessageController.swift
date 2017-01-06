//
//  MessageController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class MessageController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    fileprivate var itemDataSouce = [MessageModel]()
    fileprivate var actionFloatView: QKMessageActionFloatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微信"
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.navigationItem.rightButtonAction(TSAsset.Barbuttonicon_add.image) { (Void) -> Void in
            self.actionFloatView.hide(!self.actionFloatView.isHidden)
        }
        self.actionFloatView = QKMessageActionFloatView()
        self.actionFloatView.delegate = self
        self.view.addSubview(self.actionFloatView)
        self.actionFloatView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        self.listTableView.ts_registerCellNib(QKMessageCell.self)
        self.listTableView.rowHeight = 65
        self.listTableView.tableFooterView = UIView()
        self.fetchData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.actionFloatView.hide(true)
    }
    
    fileprivate func fetchData() {
        guard let JSONData = Data.ts_dataFromJSONFile("message") else {
            return
        }
        let jsonObject = JSON(data: JSONData)
        if jsonObject != JSON.null {
            var list = [MessageModel]()
            for dict  in jsonObject["data"].arrayObject! {
                guard let model = QKMapper<MessageModel>().map(JSON: dict as! [String : Any]) else {
                    continue
                }
                list.insert(model, at: list.count)
            }
            self.itemDataSouce.insert(contentsOf: list, at: 0)
            self.listTableView.reloadData()
        }
    }
    
    deinit {
        log.verbose("deinit")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MessageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatController: QKChatViewController = QKChatViewController()
        chatController.messageModel = self.itemDataSouce[indexPath.row]
        self.qk_pushAndHideTabbar(chatController, animated: true)
    }
}

extension MessageController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QKMessageCell = tableView.ts_dequeueReusableCell(QKMessageCell.self)
        let model: MessageModel = self.itemDataSouce[indexPath.row]
        cell.setCellContent(model)
        return cell
    }
    
}
extension MessageController: ActionFloatViewDelegate {
    func floatViewTapItemIndex(_ type: ActionFloatViewItemType) {
        log.info("floatViewTapItemIndex: \(type)")
        switch type {
        case .groupChat:
            break
        case .addFriend:
            break
        case .scan:
            break
        case .payement:
            break
        }
    }
}
