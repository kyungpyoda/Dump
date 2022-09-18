//
//  ExCollectionViewMainView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/07.
//

import UIKit
import FlexLayout
import PinLayout

final class ExCollectionViewMainView: UIView {

    var cellDatas: [ExCollectionViewCell.CellData] = (0..<10).map { _ in
        let lineCount = Int.random(in: 1...10)
        let header = "\(lineCount)줄"
        let content = (0..<lineCount)
            .map({ _ in
                (0..<Int.random(in: 5..<20)).reduce("", { "\($0)\($1)" })
            })
            .joined(separator: "\n")
        return .init(header: header, content: content)
    }

    private let titleLabel = UILabel().then {
        $0.text = "hellohello"
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(ExCollectionViewCell.self, forCellWithReuseIdentifier: ExCollectionViewCell.reusableID)
        $0.dataSource = self
        $0.delegate = self
    }

    private let cellTemplate = ExCollectionViewCell()

    init() {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemBackground
    }

    private func defined() {
        flex
            .define { flex in
                flex.addItem(collectionView)
                    .grow(1)
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
    }

    func viewDidLoad() {
        collectionView.reloadData()
    }

}

extension ExCollectionViewMainView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return cellDatas.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExCollectionViewCell.reusableID,
            for: indexPath
        ) as? ExCollectionViewCell else { fatalError("dequeue cell failed") }
        cell.configure(with: cellDatas[indexPath.row])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellTemplate.configureTemplate(with: cellDatas[indexPath.row])
        return cellTemplate.sizeThatFits(CGSize(
            width: collectionView.bounds.width,
            height: .greatestFiniteMagnitude
        ))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDatas[indexPath.row].isExpanded.toggle()
        collectionView.reloadItems(at: [indexPath])
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ExCollectionViewMainViewPreview: PreviewProvider {
  static var previews: some View {
    Group {
      UIViewPreview { ExCollectionViewMainView() }
    }
  }
}
#endif
