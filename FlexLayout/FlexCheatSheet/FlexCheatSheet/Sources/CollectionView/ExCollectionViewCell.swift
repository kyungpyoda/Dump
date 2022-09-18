//
//  ExCollectionViewCell.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/07.
//

import UIKit
import FlexLayout
import PinLayout

final class ExCollectionViewCell: UICollectionViewCell {

    struct CellData {
        let header: String
        let content: String
        var isExpanded: Bool = false
    }

    private let headerLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.backgroundColor = .systemGray4
    }
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let contentContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        contentView.layer.cornerRadius = 10
    }

    private func defined() {
        contentView
            .flex
            .padding(10)
            .define { flex in
                flex.addItem(headerLabel)

                flex.addItem(contentContainerView)
                    .define { flex in
                        flex.addItem(contentLabel)
                            .marginTop(8)
                    }
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout(mode: .adjustHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = ""
        headerLabel.flex.markDirty()
        contentLabel.text = ""
        contentLabel.flex.markDirty()
        contentContainerView.flex.markDirty()
        setNeedsLayout()
    }

    func configure(with cellData: CellData) {
        headerLabel.text = cellData.header
        headerLabel.flex.markDirty()

        contentLabel.text = cellData.content
        contentLabel.flex.markDirty()

        let isExpanding = cellData.isExpanded
        contentContainerView.isHidden = !isExpanding
        contentContainerView.flex.isIncludedInLayout(isExpanding)
        contentContainerView.flex.markDirty()

        setNeedsLayout()

        DispatchQueue.main.async {
            self.contentContainerView.alpha = isExpanding ? 0 : 1
            UIView.animate(withDuration: 0.3) {
                self.contentContainerView.alpha = isExpanding ? 1 : 0
            }
        }
    }

    func configureTemplate(with cellData: CellData) {
        headerLabel.text = cellData.header
        headerLabel.flex.markDirty()

        contentLabel.text = cellData.content
        contentLabel.flex.markDirty()

        let isExpanding = cellData.isExpanded
        contentContainerView.isHidden = !isExpanding
        contentContainerView.flex.isIncludedInLayout(isExpanding)
        contentContainerView.flex.markDirty()

        setNeedsLayout()
    }

}
