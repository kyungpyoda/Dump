//
//  QuotesView.swift
//  AnimeQuotes
//
//  Created by 홍경표 on 2022/10/10.
//  Copyright © 2022 kr.pio. All rights reserved.
//

import SwiftUI

struct QuotesView<ViewModel>: View where ViewModel: QuotesViewModel {

    @StateObject
    private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.quotes.isEmpty {
                LoadingView(text: "Fetching Quotes")
            } else {
                List {
                    ForEach(viewModel.quotes, id: \.anime) { quote in
                        QuoteView(item: quote)
                    }
                }
            }
        }
        .task {
            await viewModel.getRancomQuotes()
        }
    }
} 

struct QuotesView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesView(viewModel: QuotesViewModelImpl(service: QuotesServiceImpl()))
    }
}
