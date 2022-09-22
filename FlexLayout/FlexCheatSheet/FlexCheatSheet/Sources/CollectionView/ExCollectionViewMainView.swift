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

    private enum Section {
        case main
    }
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var items: [Item] = (0..<20).map { _ in
        let lineCount = Int.random(in: 5...20)
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

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.register(
            ExCollectionViewCell.self,
            forCellWithReuseIdentifier: ExCollectionViewCell.reusableID
        )
        $0.register(
            ExCollectionViewHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ExCollectionViewHeaderView.reusableID
        )
        $0.dataSource = self
        $0.delegate = self
    }

//    private lazy var dataSource: DataSource = makeDataSource()

//    private lazy var compositionalLayout: UICollectionViewLayout = makeLayout()

    private let flowLayout = MyFlowLayout()

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
        // Diffable
//        var snapshot = Snapshot()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(items, toSection: .main)
//        dataSource.apply(snapshot)

        // Normal
        collectionView.reloadData()
    }

    private func cellForRow(at indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExCollectionViewCell.reusableID,
            for: indexPath
        ) as? ExCollectionViewCell else { fatalError("wtf") }

        cell.configure(
            with: item,
            selectHandler: { [weak self] in
                guard let self = self else { return }
                self.items[indexPath.row].isSelected.toggle()
                // Diffable
//                var snapshot = Snapshot()
//                snapshot.appendSections([.main])
//                snapshot.appendItems(self.items, toSection: .main)
//                self.dataSource.apply(snapshot)

                // Normal
                self.collectionView.reloadData()
            }, expandHandler: { [weak self] in
                guard let self = self else { return }
                self.items[indexPath.row].isExpanded.toggle()
                // Diffable
//                var snapshot = Snapshot()
//                snapshot.appendSections([.main])
//                snapshot.appendItems(self.items, toSection: .main)
//                self.dataSource.apply(snapshot)
//                var snapshot = self.dataSource.snapshot()
//                snapshot.reloadItems([self.dataSource.itemIdentifier(for: indexPath)!])
//                self.dataSource.apply(snapshot)

                // Normal
//                self.collectionView.reloadData()
                self.collectionView.reloadItems(at: [indexPath])

            }
        )
        return cell
    }

    private func supplementaryView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ExCollectionViewHeaderView.reusableID,
                for: indexPath
            ) as? ExCollectionViewHeaderView else { fatalError("wtf") }
            headerView.configure(isAllSelected: items.isAllSelected) { [weak self] in
                guard let self = self else { return }

                let newValue = !self.items.isAllSelected
                for i in 0..<self.items.count {
                    self.items[i].isSelected = newValue
                }
                // Diffable
//                var snapshot = Snapshot()
//                snapshot.appendSections([.main])
//                snapshot.appendItems(self.items, toSection: .main)
//                self.dataSource.apply(snapshot)

                // Normal
                self.collectionView.reloadData()
            }
            return headerView

        default:
            return nil
        }
    }
}

// MARK: DataSource
extension ExCollectionViewMainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return cellForRow(at: indexPath, item: items[indexPath.row])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        return supplementaryView(for: indexPath, kind: kind)!
    }
}

// MARK: DiffableDataSource
extension ExCollectionViewMainView {
    private func makeDataSource() -> DataSource {
        // Cell
        let cellProvider: DataSource.CellProvider = { [weak self] (_, indexPath, item) in
            return self?.cellForRow(at: indexPath, item: item)
        }

        // Header, Footer
        let supplementaryViewProvider: DataSource.SupplementaryViewProvider = { [weak self] (_, kind, indexPath) in
            return self?.supplementaryView(for: indexPath, kind: kind)
        }

        return DataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        ).then {
            $0.supplementaryViewProvider = supplementaryViewProvider
        }
    }
}

// MARK: CompositionalLayout
extension ExCollectionViewMainView {
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitem: item,
                                                       count: 1)

        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: FlowLayout
extension ExCollectionViewMainView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellTemplate.configureTemplate(with: items[indexPath.row])
        return cellTemplate.sizeThatFits(CGSize(
            width: collectionView.bounds.width,
            height: .greatestFiniteMagnitude
        ))
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

class MyFlowLayout: UICollectionViewFlowLayout {
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ExCollectionViewMainViewPreview: PreviewProvider {
  static var previews: some View {
    Group {
      UIViewPreview {
          let v = ExCollectionViewMainView()
          v.viewDidLoad()
          return v
      }
    }
  }
}
#endif
