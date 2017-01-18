//
//  QKChatViewController+CellEnums.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/17.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import UIKit

extension MessageContentType {
    func chatCellHeight(_ model: QKChatModel) -> CGFloat {
        switch self {
        case .Text:
            return QKChatTextCell.layoutHeight(model)
        case .Image:
            return QKChatImageCell.layoutHeight(model)
        case .Voice:
            return QKChatVoiceCell.layoutHeight(model)
        case .System:
            return QKChatSystemCell.layoutHeight(model)
        case .File:
            return QKChatSystemCell.layoutHeight(model)
        case .Time:
            return QKChatTimeCell.heightForCell()
        }
    }
    
    func chatCell(_ tableView: UITableView, indexPath: IndexPath, model: QKChatModel, viewController: QKChatViewController) -> UITableViewCell? {
        switch self {
        case .Text:
            let cell: QKChatTextCell = tableView.ts_dequeueReusableCell(QKChatTextCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
        case .Image:
            let cell: QKChatImageCell = tableView.ts_dequeueReusableCell(QKChatImageCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
        case .Voice:
            let cell: QKChatVoiceCell = tableView.ts_dequeueReusableCell(QKChatVoiceCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
        case .System:
            let cell: QKChatSystemCell = tableView.ts_dequeueReusableCell(QKChatSystemCell.self)
            cell.setCellContent(model)
            return cell
        case .File:
            let cell: QKChatVoiceCell = tableView.ts_dequeueReusableCell(QKChatVoiceCell.self)
            cell.delegate = viewController
            cell.setCellContent(model)
            return cell
        case .Time:
            let cell: QKChatTimeCell = tableView.ts_dequeueReusableCell(QKChatTimeCell.self)
            cell.setCellContent(model)
            return cell
        }
    }
}
