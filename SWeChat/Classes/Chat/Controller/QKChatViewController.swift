//
//  QKChatViewController.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/6.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

final class QKChatViewController: UIViewController {
    var messageModel: MessageModel?
    @IBOutlet var refreshView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    lazy var listTableView: UITableView = {
        let listTableView = UITableView(frame: CGRect.zero, style: .plain)
        listTableView.dataSource = self
        listTableView.delegate = self
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
    var imagePicker: UIImagePickerController!
    let disposeBag = DisposeBag()
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
        self.listTableView.ts_registerCellNib(QKChatSystemCell.self)
        self.listTableView.tableFooterView = UIView()
        self.listTableView.tableHeaderView = self.refreshView
        

    

        
        self.firstFetchMessageList()
        self.listTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}


extension QKChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatModel = self.itemDataSouce.get(index: indexPath.row) else {
            return QKChatBaseCell()
        }
        let type: MessageContentType = chatModel.messageContentType
        return type.chatCell(tableView, indexPath: indexPath, model: chatModel, viewController: self)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard  let chatModel = self.itemDataSouce.get(index: indexPath.row) else {
            return 0
        }
        let type: MessageContentType = chatModel.messageContentType
        return type.chatCellHeight(chatModel)
    }
}

extension QKChatViewController: UITableViewDelegate {
   
}

extension QKChatViewController: QKChatCellDelegate {
    func cellDidTapped(_ cell: QKChatBaseCell) {
        
    }
    
    func cellDidTapedAvatarImage(_ cell: QKChatBaseCell) {
        
    }
    
    func cellDidTapedImageView(_ cell: QKChatBaseCell) {
        
    }
    
    func cellDidTapedLink(_ cell: QKChatBaseCell, linkSting: String) {
        
    }
    
    func cellDidTapedPhone(_ cell: QKChatBaseCell, phoneString: String) {
        
    }
    
    func cellDidTapedVoiceButton(_ cell: QKChatBaseCell, isPlayingVoice: Bool) {
        
    }
    
    
}
