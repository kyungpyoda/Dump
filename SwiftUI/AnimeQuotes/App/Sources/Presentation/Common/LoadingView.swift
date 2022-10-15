//
//  LoadingView.swift
//  AnimeQuotes
//
//  Created by 홍경표 on 2022/10/10.
//  Copyright © 2022 kr.pio. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    let text: String
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text(text)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text:  "Loading")
    }
}
