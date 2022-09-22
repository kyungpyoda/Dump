//
//  Item.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/24.
//

import Foundation

struct Item: Hashable {
//    private let id = UUID()
    let header: String
    let content: String
    var isSelected: Bool = false
    var isExpanded: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(content)
        hasher.combine(isSelected)
        hasher.combine(isExpanded)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return
        lhs.header == rhs.header &&
        lhs.content == rhs.content
//        return lhs.id == rhs.id// && lhs.isSelected == rhs.isSelected && lhs.isExpanded == rhs.isExpanded
    }
}

extension Array where Element == Item {
    var isAllSelected: Bool {
        allSatisfy(\.isSelected)
    }
}
