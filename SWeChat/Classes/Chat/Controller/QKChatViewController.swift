//
//  QKChatViewController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import SnapKit


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
    
    var chatActionBarView: QKChatActionBarView!
    var actionBarPaddingBottomConstraint: Constraint?
    var keyboardHeightConstraint: NSLayoutConstraint?
    var emotionInputeView: QKChatEmotionInputView!
    var shareMoreView: QKChatShareMoreView!
    var voiceIndicatorView: QKChatVoiceIndicatorView!
    var itemDataSouce = [QKChatModel]()
    var isReloading: Bool = false
    var currentVoiceCell: QKChatVoiceCell!
    var isEndRefreshing: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.messageModel!.nickname
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        
        self.listTableView.ts_registerCellNib(QKChatTextCell.self)
        self.listTableView.ts_registerCellNib(QKChatImageCell.self)
        self.listTableView.ts_registerCellNib(QKChatVoiceCell.self)
        self.listTableView.ts_registerCellNib(QKChatTimeCell.self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
