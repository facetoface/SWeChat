//
//  QKChatViewController+TestData.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/19.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import SwiftyJSON


extension QKChatViewController {
    func firstFetchMessageList() {
        guard let list = self.fetchData() else {
            return
        }
        self.itemDataSouce.insert(contentsOf: list, at: 0)
        self.listTableView.reloadData({[unowned self] _ in
            self.isReloading = false
        })
        self.listTableView.setContentOffset(CGPoint.init(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
    }
    
    func pullToLoadMore() {
        self.isEndRefreshing = false
        self.indicatorView.startAnimating()
        self.isReloading = true
        
        let backgoundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        backgoundQueue.async { 
            guard let list = self.fetchData() else {
                self.indicatorView.stopAnimating()
                self.isReloading = false
                return
            }
            sleep(1)
            DispatchQueue.main.async(execute: { 
                self.itemDataSouce.insert(contentsOf: list, at: 0)
                self.indicatorView.stopAnimating()
//                self.updateta
                self.isReloading = true
            })
        }
    }
    
    func updateTableWithNewRowCount(_ count: Int) {
        var contentOffset = self.listTableView.contentOffset
        UIView.setAnimationsEnabled(false)
        var heightForNewRows: CGFloat = 0
        var indexPaths = [IndexPath]()
        for i in 0 ..< count {
            let indexPath = IndexPath.init(row: i, section: 0)
            indexPaths.append(indexPath)
            heightForNewRows += self.tableView(self.listTableView, heightForRowAt: indexPath)
        }
        contentOffset.y += heightForNewRows
        self.listTableView.insertRows(at: indexPaths, with: .none)
        self.listTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.listTableView.setContentOffset(contentOffset, animated: false)
    }
    
    
    
    func fetchData() -> [QKChatModel]? {
        guard let JSONData = Data.ts_dataFromJSONFile("chat") else {
            return nil
        }
        
        var list = [QKChatModel]()
        let jsonObj = JSON(data: JSONData)
        if jsonObj != JSON.null {
            var temp: QKChatModel?
            for dict in jsonObj["data"].arrayObject! {
                guard let model = QKMapper<QKChatModel>().map(JSON: dict as! [String : Any]) else {
                    continue
                }
                /**
                 *  1，刷新获取的第一条数据，加上时间 model
                 *  2，当后面的数据比前面一条多出 2 分钟以上，加上时间 model
                 */
                if temp == nil || model.isLateforTowMinutes(temp!) {
                    guard let timestamp = model.timestamp else {
                        continue
                    }
                    list.insert(QKChatModel(timestamp: timestamp), at: list.count)
                }
                list.insert(model, at: list.count)
                temp = model
            }
        }
        return list

    }
}
