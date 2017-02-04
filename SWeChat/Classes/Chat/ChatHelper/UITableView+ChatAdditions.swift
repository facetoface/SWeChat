//
//  UITableView+ChatAdditions.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/19.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations:{
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func insertRowsAtBottom(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        self.scrollToRow(at: rows[0], at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0 {
            return IndexPath(row: self.totalRows()-1 , section: 0)
        } else {
            return nil
        }
    }
    
    func scrollBottomWithoutFlashing()  {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func scrollToBottom(_ animated: Bool) {
        let bottomOffset = CGPoint.init(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
    
    var isContentInsetBottomZero: Bool {
        get { return self.contentInset.bottom == 0 }
    }
    
    func resetContentInsetAndScrollIndicatorInsets() {
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
}
