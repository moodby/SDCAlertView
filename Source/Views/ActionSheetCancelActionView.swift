import UIKit

final class ActionSheetCancelActionView: UIView {
    private let cancelButton = UIButton(type: .custom)
    private let cancelLabel = UILabel()
    private var action: AlertAction!
    private var visualStyle: AlertVisualStyle!

    var cancelTapHandler: ((AlertAction) -> Void)?

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.cancelLabel.textColor = self.visualStyle.textColor(for: self.action) ?? self.tintColor
    }

    func buildView(cancelAction: AlertAction, visualStyle: AlertVisualStyle) {
        self.action = cancelAction
        self.visualStyle = visualStyle

        self.layer.cornerRadius = visualStyle.cornerRadius
        self.layer.masksToBounds = true

        self.backgroundColor = visualStyle.backgroundColor
        self.addCancelButton(action: cancelAction, visualStyle: visualStyle)
    }

    @objc
    func highlightAction(for sender: UIPanGestureRecognizer) {
        let cancelIsSelected = self.bounds.contains(sender.location(in: self))
        self.cancelButton.isHighlighted = cancelIsSelected

        if cancelIsSelected && sender.state == .ended {
            self.cancelButton.sendActions(for: .touchUpInside)
        }
    }

    private func addCancelButton(action: AlertAction, visualStyle: AlertVisualStyle) {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.addTarget(self, action: #selector(self.cancelTapped), for: .touchUpInside)
        self.cancelButton.setupAccessibility(using: action)
        let background = UIImage.image(with: visualStyle.actionHighlightColor)
        self.cancelButton.setBackgroundImage(background, for: .highlighted)
        self.addSubview(self.cancelButton)

        if let backgroundColor = visualStyle.backgroundColor ?? visualStyle.actionViewCancelBackgroundColor {
            self.cancelButton.backgroundColor = backgroundColor
        }

        self.cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cancelLabel.font = visualStyle.font(for: action)
        self.cancelLabel.textColor = visualStyle.textColor(for: action) ?? self.tintColor
        self.cancelLabel.attributedText = action.attributedTitle

        self.addSubview(self.cancelLabel)

        NSLayoutConstraint.activate([
            self.cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cancelButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cancelButton.heightAnchor.constraint(equalToConstant: visualStyle.actionViewSize.height),

            self.cancelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.cancelLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    @objc
    private func cancelTapped() {
        self.cancelTapHandler?(self.action)
    }
}

private extension UIImage {
    static func image(with color: UIColor) -> UIImage? {
        defer { UIGraphicsEndImageContext() }

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        color.setFill()
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
