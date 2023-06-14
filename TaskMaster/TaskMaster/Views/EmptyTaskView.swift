//
//  EmptyTaskView.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/9/23.
//

import UIKit

extension UICollectionView {
    func setEmptyView(title: String, message: String) {
        EmptyViewHelper.setEmptyView(for: self, frame: self.bounds, title: title, message: message)
    }
    
    func restore() {
        EmptyViewHelper.restore(for: self)
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        EmptyViewHelper.setEmptyView(for: self, frame: self.bounds, title: title, message: message)
    }
    
    func restore() {
        EmptyViewHelper.restore(for: self)
    }
}
