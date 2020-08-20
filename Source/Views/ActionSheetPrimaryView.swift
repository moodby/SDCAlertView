import UIKit

final class ActionSheetPrimaryView: UIView {
    private let titleLabel = AlertLabel()
    private let messageLabel = AlertLabel()
    private let actionsView = ActionsCollectionView()

    var title: NSAttributedString? {
        didSet { self.titleLabel.attributedText = self.title }
    }

    var message: NSAttributedString? {
        didSet { self.messageLabel.attributedText = self.message }
    }

    var actionTapped: ((AlertAction) -> Void)? {
        didSet { self.actionsView.actionTapped = self.actionTapped }
    }

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func highlightAction(for sender: UIPanGestureRecognizer) {
        self.actionsView.highlightAction(for: sender)
    }

    func buildView(actions: [AlertAction], contentView: UIView, visualStyle: AlertVisualStyle) {
        self.configure(visualStyle: visualStyle)

        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)

        let labelContainerView = UIView()
        labelContainerView.backgroundColor = .clear
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false

        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        let stackView = self.buildStackView(views: [labelContainerView, contentContainer, self.actionsView],
                                            in: backgroundView)
        self.buildLabelsView(in: labelContainerView)
        self.buildContentView(contentView, in: contentContainer, visualStyle: visualStyle)
        self.buildActionsView(self.actionsView, actions: actions, visualStyle: visualStyle)

        let padding = visualStyle.contentPadding.left + visualStyle.contentPadding.right
        NSLayoutConstraint.activate([
            self.titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -padding),

            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    private func configure(visualStyle: AlertVisualStyle) {
        self.backgroundColor = visualStyle.backgroundColor
        self.layer.cornerRadius = visualStyle.cornerRadius
        self.layer.masksToBounds = true
    }

    private func buildStackView(views: [UIView], in parent: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center

        parent.addSubview(stackView)

        // Skip aligning labels, they're aligned separately as they have to account for padding
        for view in views[1...] {
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: parent.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])

        return stackView
    }

    private func buildLabelsView(in parent: UIView) {
        parent.isHidden = self.title?.string.isEmpty != false && self.message?.string.isEmpty != false
        parent.addSubview(self.titleLabel)

        if let attributes = self.title {
            self.titleLabel.attributedText = attributes
        } else {
            self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            self.titleLabel.textColor = .darkText
        }

        if let attributes = self.message {
            self.messageLabel.attributedText = attributes
        } else {
            self.messageLabel.font = UIFont.systemFont(ofSize: 13)
            self.messageLabel.textColor = .darkText
        }

        if self.message != nil {
            parent.addSubview(self.messageLabel)

            NSLayoutConstraint.activate([
                self.messageLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
                self.messageLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
                self.messageLabel.firstBaselineAnchor.constraint(equalTo: self.titleLabel.lastBaselineAnchor,
                                                                constant: 28),
                self.messageLabel.lastBaselineAnchor.constraint(equalTo: parent.bottomAnchor,
                                                                constant: -28),
            ])
        }

        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.titleLabel.firstBaselineAnchor.constraint(equalTo: parent.topAnchor, constant: 27),
            self.titleLabel.lastBaselineAnchor.constraint(equalTo: parent.bottomAnchor, constant: -17)
                .prioritized(value: .defaultLow),
        ])
    }

    private func buildContentView(_ contentView: UIView, in parent: UIView, visualStyle: AlertVisualStyle) {
        parent.isHidden = contentView.subviews.isEmpty

        parent.addSubview(contentView)

        let topSpace = visualStyle.verticalElementSpacing / 2
        let bottomSpace = visualStyle.contentPadding.bottom

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: parent.topAnchor, constant: topSpace),
            contentView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottomSpace),
        ])
    }

    private func buildActionsView(_ actionsView: ActionsCollectionView, actions: [AlertAction],
                                  visualStyle: AlertVisualStyle)
    {
        actionsView.actions = actions
        actionsView.visualStyle = visualStyle

        NSLayoutConstraint.activate([
            actionsView.heightAnchor.constraint(equalToConstant: actionsView.displayHeight)
                .prioritized(value: .defaultHigh),
        ])
    }
}
