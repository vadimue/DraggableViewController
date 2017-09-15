import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var dragView: UIView!
  let animator = DragAnimator()
  let transition = InteractiveTransition()

  override func viewDidLoad() {
    super.viewDidLoad()

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    dragView.addGestureRecognizer(tap)
    let pan = UIPanGestureRecognizer(target:self, action: #selector(didPan))
    dragView.addGestureRecognizer(pan)

    transitioningDelegate = self
  }

  func didTap() {
    performSegue(withIdentifier: "showDetail", sender: nil)
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      transition.interactive = true
      performSegue(withIdentifier: "showDetail", sender: nil)
    default:
      transition.handlePan(recognizer: recognizer)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      segue.destination.transitioningDelegate = self
    }
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController, source: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
      animator.presenting = true
      return animator
  }

  func animationController(forDismissed dismissed: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
      animator.presenting = false
      return animator
  }

  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return transition.interactive ? transition : nil
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return transition.interactive ? transition : nil
  }
}

