import UIKit

class Transition: NSObject, UIViewControllerTransitioningDelegate {

    private let alertStyle: AlertControllerStyle
    private let dimmingViewColor: UIColor
    private let backgroundStyle: BackgroundStyle

    init(
        alertStyle: AlertControllerStyle,
        dimmingViewColor: UIColor,
        backgroundStyle: BackgroundStyle
    ) {
        self.alertStyle = alertStyle
        self.dimmingViewColor = dimmingViewColor
        self.backgroundStyle = backgroundStyle
    }

    func presentationController(forPresented presented: UIViewController,
        presenting: UIViewController?, source: UIViewController)
        -> UIPresentationController?
    {
        return PresentationController(presentedViewController: presented,
                                      presenting: presenting,
                                      dimmingViewColor: dimmingViewColor,
                                      backgroundStyle: backgroundStyle)
    }

    func animationController(forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning?
    {
        if self.alertStyle == .actionSheet {
            return nil
        }

        return AnimationController(presentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.alertStyle == .alert ? AnimationController(presentation: false) : nil
    }
}
