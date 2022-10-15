//
//  QuotesService.swift
//  AnimeQuotes
//
//  Created by 홍경표 on 2022/10/10.
//  Copyright © 2022 kr.pio. All rights reserved.
//

import Foundation

protocol QuotesService {
    func fetchRandomQuotes() async throws -> [Quote]
}

final class QuotesServiceImpl: QuotesService {

    func fetchRandomQuotes() async throws -> [Quote] {
        let url = URL(string: APIConstants.baseURL.appending("/api/quotes"))!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Quote].self, from: data)
    }

}
