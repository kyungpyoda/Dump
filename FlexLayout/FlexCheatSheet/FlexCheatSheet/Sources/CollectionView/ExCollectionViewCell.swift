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
        var isSelected: Bool = false
        var isExpanded: Bool = false
    }

    private enum Constants {
        static var checkImage: UIImage? { UIImage(systemName: "checkmark.circle") }
        static var checkFillImage: UIImage? { UIImage(systemName: "checkmark.circle.fill") }
        static var arrowUpImage: UIImage? { UIImage(systemName: "arrowtriangle.up.fill") }
        static var arrowDownImage: UIImage? { UIImage(systemName: "arrowtriangle.down.fill") }
    }

    private var selectHandler: (() -> Void)?
    private var expandHandler: (() -> Void)?

    private let selectButton = UIButton(type: .custom).then {
        $0.setImage(Constants.checkImage, for: .normal)
    }
    private let headerLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.backgroundColor = .systemGray4
    }
    private let expandButton = UIButton(type: .custom).then {
        $0.setImage(Constants.arrowDownImage, for: .normal)
    }
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.backgroundColor = .systemGray5
    }
    private let contentContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
        defined()
        setUpHandler()
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
                flex.addItem()
                    .direction(.row)
                    .alignItems(.center)
                    .height(40)
                    .define { flex in
                        flex.addItem(selectButton)
                            .size(30)

                        flex.addItem(headerLabel)
                            .marginHorizontal(8)
                            .grow(1)
                            .shrink(1)

                        flex.addItem(expandButton)
                            .size(30)
                    }

                flex.addItem(contentContainerView)
                    .define { flex in
                        flex.addItem(contentLabel)
                            .marginTop(8)
                    }
            }
    }

    private func setUpHandler() {
        selectButton.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        expandButton.addTarget(self, action: #selector(didExpand), for: .touchUpInside)
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
        selectHandler = nil
        expandHandler = nil
        setNeedsLayout()
    }

    func configure(
        with cellData: CellData,
        selectHandler: (() -> Void)? = nil,
        expandHandler: (() -> Void)? = nil
    ) {
        self.selectHandler = selectHandler
        self.expandHandler = expandHandler
        selectButton.setImage(cellData.isSelected ? Constants.checkFillImage : Constants.checkImage, for: .normal)
        selectButton.flex.markDirty()
        expandButton.setImage(cellData.isExpanded ? Constants.arrowUpImage : Constants.arrowDownImage, for: .normal)
        expandButton.flex.markDirty()
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

    @objc private func didSelect() {
        selectHandler?()
    }

    @objc private func didExpand() {
        expandHandler?()
    }

}
