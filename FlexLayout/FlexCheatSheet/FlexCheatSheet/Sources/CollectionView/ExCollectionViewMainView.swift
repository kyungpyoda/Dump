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

    private let containerView = UIView()

    private let titleLabel = UILabel().then {
        $0.text = "hellohello"
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textAlignment = .center
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(ExCollectionViewCell.self, forCellWithReuseIdentifier: ExCollectionViewCell.reusableID)
        $0.register(ExCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExCollectionViewHeaderView.reusableID)
        $0.dataSource = self
        $0.delegate = self
    }

    private let cellTemplate = ExCollectionViewCell()

    private let headerViewTemplate = ExCollectionViewHeaderView()

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
        addSubview(containerView)
    }

    private func defined() {
        containerView
            .flex
            .define { flex in
                flex.addItem(titleLabel)

                flex.addItem(collectionView)
                    .grow(1)
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all(pin.safeArea)
        containerView.flex.layout()
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
        let data = cellDatas[indexPath.row]
        cell.configure(
            with: data,
            selectHandler: { [weak self] in
                self?.cellDatas[indexPath.row].isSelected.toggle()
//                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.reloadItems(at: [indexPath])
                    self?.collectionView.reloadSections([0])
                }

//                self?.collectionView.reloadData()
            }, expandHandler: { [weak self] in
                self?.cellDatas[indexPath.row].isExpanded.toggle()
                self?.collectionView.reloadItems(at: [indexPath])
            }
        )

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

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ExCollectionViewHeaderView.reusableID,
                for: indexPath
            )
            guard let headerView = supplementaryView as? ExCollectionViewHeaderView else { return supplementaryView }
            headerView.configure(isAllSelected: cellDatas.isAllSelected) { [weak self] in
                guard let self = self else { return }
                let newValue = !self.cellDatas.isAllSelected
                for i in 0..<self.cellDatas.count {
                    self.cellDatas[i].isSelected = newValue
                }
//                self.collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
//                self.collectionView.reloadData()
                self.collectionView.reloadSections([0])
            }
            return headerView
        default:
            fatalError("wtf")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return headerViewTemplate.sizeThatFits(CGSize(
            width: collectionView.bounds.width,
            height: .greatestFiniteMagnitude
        ))
    }

}

extension Array where Element == ExCollectionViewCell.CellData {
    var isAllSelected: Bool {
        allSatisfy(\.isSelected)
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
