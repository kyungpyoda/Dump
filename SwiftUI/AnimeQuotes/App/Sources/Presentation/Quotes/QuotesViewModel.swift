//
//  QuotesViewModel.swift
//  AnimeQuotes
//
//  Created by 홍경표 on 2022/10/10.
//  Copyright © 2022 kr.pio. All rights reserved.
//

import Foundation

protocol QuotesViewModel: ObservableObject {
    var quotes: [Quote] { get }
    func getRancomQuotes() async
}

@MainActor
final class QuotesViewModelImpl: QuotesViewModel {

    @Published private(set) var quotes: [Quote] = []

    private let service: QuotesService

    init(service: QuotesService) {
        self.service = service
    }

    func getRancomQuotes() async {
        do {
            quotes = try await service.fetchRandomQuotes()
        } catch {
            print(error)
        }
    }
}
