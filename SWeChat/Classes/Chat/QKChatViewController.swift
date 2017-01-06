//
//  QKChatViewController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

class QKChatViewController: UIViewController {
    var messageModel: MessageModel?
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    lazy var listTableView: UITableView = {
        let listTableView = UITableView(frame: CGRect.zero, style: .plain)
//        listTableView.dataSource = self
//        listTableView.delegate = self
        listTableView.backgroundColor = UIColor.clear
        listTableView.separatorStyle = .none
        listTableView.backgroundView = UIImageView(image: TSAsset.Chat_background.image)
        return listTableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
