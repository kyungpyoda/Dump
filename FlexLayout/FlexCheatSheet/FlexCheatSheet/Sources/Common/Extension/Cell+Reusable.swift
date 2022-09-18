//
//  Cell+Reusable.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/07.
//

import UIKit

protocol Reusable {
    static var reusableID: String { get }
}

extension Reusable {
    static var reusableID: String { String(describing: self) }
}

extension UITableViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}
