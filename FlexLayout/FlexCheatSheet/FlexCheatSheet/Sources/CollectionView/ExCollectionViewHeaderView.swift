//
//  ExCollectionViewHeaderView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/22.
//

import UIKit
import FlexLayout
import PinLayout

final class ExCollectionViewHeaderView: UICollectionReusableView {

    private enum Constants {
        static var checkImage: UIImage? { UIImage(systemName: "checkmark.circle") }
        static var checkFillImage: UIImage? { UIImage(systemName: "checkmark.circle.fill") }
    }

    private var selectAllButtonHandler: (() -> Void)?

    private let selectAllButton = UIButton(type: .custom).then {
        $0.setImage(Constants.checkImage, for: .normal)
    }

    private let buttonLabel = UILabel().then {
        $0.text = "전체선택"
    }

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

    }

    private func defined() {
        flex.addItem()
            .backgroundColor(.systemGreen)
            .direction(.row)
            .alignItems(.center)
            .height(50)
            .paddingHorizontal(20)
            .define { flex in
                flex.addItem(selectAllButton)

                flex.addItem(buttonLabel)
                    .marginLeft(20)
            }
    }

    private func setUpHandler() {
        selectAllButton.addTarget(self, action: #selector(didSelectAll), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout(mode: .adjustHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        flex.layout(mode: .adjustHeight)
        return frame.size
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        selectAllButtonHandler = nil
    }

    func configure(isAllSelected: Bool, selectAllButtonHandler: (() -> Void)? = nil) {
        selectAllButton.setImage(isAllSelected ? Constants.checkFillImage : Constants.checkImage, for: .normal)
        self.selectAllButtonHandler = selectAllButtonHandler
    }

    @objc private func didSelectAll() {
        selectAllButtonHandler?()
    }
}
