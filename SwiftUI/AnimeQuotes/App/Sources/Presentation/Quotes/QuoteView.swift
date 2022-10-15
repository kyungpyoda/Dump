//
//  QuoteView.swift
//  AnimeQuotes
//
//  Created by 홍경표 on 2022/10/10.
//  Copyright © 2022 kr.pio. All rights reserved.
//

import SwiftUI

struct QuoteView: View {

    let item: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tv")
                    .font(.system(size: 12, weight: .black))
                Text(item.anime)
            }
            Text(makeAttributedString(title: "Character", label: item.character))
            Text(makeAttributedString(title: "Quotes", label: item.quote))
                .lineLimit(2)
        }
        .padding()
        .foregroundColor(.primary)
    }

    private func makeAttributedString(title: String, label: String) -> AttributedString {
        var str = AttributedString("\(title) \(label)")
        str.foregroundColor = .primary
        str.font = .system(size: 16, weight: .bold)
        if let range = str.range(of: label) {
            str[range].foregroundColor = .primary.opacity(0.8)
            str[range].font = .system(size: 16, weight: .regular)
        }
        return str
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(item: Quote.dummyData.first!)
    }
}
