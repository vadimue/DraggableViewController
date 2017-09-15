import UIKit

class DragAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  var animationDuration = 1.0
  var presenting = true

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if presenting {
      present(transitionContext)
    } else {
      dismiss(transitionContext)
    }
  }

  func present(_ transitionContext: UIViewControllerContextTransitioning) {
    guard let nav = transitionContext.viewController(forKey: .from) as? UINavigationController,
      let fromVC = nav.viewControllers.first as? ViewController,
      let to = transitionContext.view(forKey: .to) else {
        transitionContext.cancelInteractiveTransition()
        return
    }

    let container = transitionContext.containerView
    container.addSubview(to)
    container.bringSubview(toFront: to)

    let dragView = UIImageView(image: UIImage(view: fromVC.dragView))
    to.addSubview(dragView)

    let yShift = to.frame.height - dragView.frame.height
    to.center.y += yShift

    UIView.animate(withDuration: animationDuration,
                   delay: 0.0, options: [.curveLinear],
                   animations: {
                    to.center.y -= yShift
                    dragView.alpha = 0
    },
                   completion: { _ in
                    dragView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })

  }

  func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
    guard let from = transitionContext.view(forKey: .from),
      let nav = transitionContext.viewController(forKey: .to) as? UINavigationController,
      let toVC = nav.viewControllers.first as? ViewController,
      let to = transitionContext.view(forKey: .to) else {
        transitionContext.cancelInteractiveTransition()
        return
    }

    let dragView = UIImageView(image: UIImage(view: toVC.dragView))
    dragView.alpha = 0
    from.addSubview(dragView)

    let yShift = from.frame.height - dragView.frame.height

    let container = transitionContext.containerView
    container.addSubview(to)
    container.insertSubview(to, belowSubview: from)

    UIView.animate(withDuration: animationDuration,
                   delay: 0.0, options: [.curveLinear],
                   animations: {
                    from.center.y += yShift
                    dragView.alpha = 1
    },
                   completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })

  }
}
