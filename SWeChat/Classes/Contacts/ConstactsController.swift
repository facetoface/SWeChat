//
//  ConstactsController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/3.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cent

class ConstactsController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var footerLineHeightConstraint: NSLayoutConstraint! {
        didSet{footerLineHeightConstraint.constant = 0.5}
    }

    fileprivate var sortedkeys = [String]()
    fileprivate var dataDict: Dictionary<String, NSMutableArray>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.listTableView.register(QKConstactCell.ts_Nib(), forCellReuseIdentifier: QKConstactCell.ts_identifier)
        self.listTableView.rowHeight = 55
        self.listTableView.sectionIndexColor = UIColor.darkGray
        self.listTableView.tableFooterView = self.footerView
        fetchContactList()
    }
    
    func fetchContactList() {
        guard let JSONData = Data.ts_dataFromJSONFile("contact") else {
            return
        }
        let jsonObject = JSON(data: JSONData)
        if jsonObject != JSON.null {
            let topArray: NSMutableArray = [
            ContactModelEnum.newFriends.model,
            ContactModelEnum.groupChat.model,
            ContactModelEnum.tags.model,
            ContactModelEnum.publicAccout.model,
            ]
            
            self.sortedkeys.append("")
            self.dataDict = ["": topArray]
            
            if let startArray = jsonObject["data"][0].arrayObject,
                startArray.count > 0
            {
                let tempList = NSMutableArray()
                for dict  in startArray {
                    guard let model = QKMapper<QKContactModel>().map(JSON: dict as! [String : Any]) else {
                        continue
                    }
                    tempList.add(model)
                }
                
                tempList.sortedArray(using: #selector(QKContactModel.compareContact(_:)))
                self.sortedkeys.append("★")
                self.dataDict = self.dataDict! + ["★" : tempList]
             
            }
            
            if let contractArray = jsonObject["data"][1].arrayObject,contractArray.count > 0 {
                let tempList = NSMutableArray()
                for dict in contractArray{
                    guard let model = QKMapper<QKContactModel>().map(JSON:dict as! [String : Any]) else {
                        continue
                    }
                    tempList.add(model)
                }
                
                self.totalNumberLabel.text = String("\(tempList.count)位联系人")
                
                var dataSouce = Dictionary<String, NSMutableArray>()
                for index in 0..<tempList.count {
                    let contractModel = tempList[index] as! QKContactModel
                    guard let nameSpell: String = contractModel.nameSpell else {
                        continue
                    }
                    let firstLettery: String = nameSpell[0..<1].uppercased()
                    if let letterArray: NSMutableArray = dataSouce[firstLettery]{
                        letterArray.add(contractModel)
                    } else {
                        let tempArray = NSMutableArray()
                        tempArray.add(contractModel)
                        dataSouce[firstLettery] = tempArray
                    }
                    
                }
                
                let sortedKeys = Array(dataSouce.keys).sorted(by: <)
                self.sortedkeys.append(contentsOf: sortedKeys)
                self.dataDict = self.dataDict! + dataSouce
                
            }
            
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

extension ConstactsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sortedkeys.count
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key: String = self.sortedkeys[section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QKConstactCell.ts_identifier, for: indexPath) as! QKConstactCell
        
        guard indexPath.section < self.sortedkeys.count else { return cell}
        let key: String = self.sortedkeys[indexPath.section]
        let dataArray: NSMutableArray = self.dataDict![key]!
        cell.setCellContent(dataArray[indexPath.row] as! QKContactModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        let title = self.sortedkeys[section]
        if title == "★" {
            return "★ 星标朋友"
        }
        return title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let _ = self.dataDict else {
            return []
        }
        let titles: [String] = self.sortedkeys as NSArray as! [String]
        return titles
    }
}

