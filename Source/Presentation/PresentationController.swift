import UIKit

class PresentationController: UIPresentationController {

    private let dimmingView = UIView()
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.locations = [0.55, 0.85]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradient
    }()

    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        dimmingViewColor: UIColor,
        backgroundStyle: BackgroundStyle
    ) {
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

        switch backgroundStyle {
        case .plain:
            dimmingView.backgroundColor = dimmingViewColor
        case .gradient:
            dimmingView.layer.insertSublayer(gradient, at: 0)
            let startColor = dimmingViewColor.withAlphaComponent(0).cgColor
            let endColor = dimmingViewColor.cgColor
            gradient.colors = [startColor, endColor]
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .dimmed
        self.dimmingView.alpha = 0

        self.containerView?.addSubview(self.dimmingView)

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 1 }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .automatic

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 0 }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerView = self.containerView {
            self.dimmingView.frame = containerView.frame
            self.gradient.frame = self.dimmingView.bounds
        }
    }
}
