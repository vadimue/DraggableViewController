import UIKit

class InteractiveTransition: UIPercentDrivenInteractiveTransition {

  var interactive = false

  override var completionSpeed: CGFloat {
    get { return 0.999 }
    set { }
  }

  func handlePan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    var progress: CGFloat = abs(translation.y / recognizer.view!.superview!.frame.height)
    progress = min(max(progress, 0.01), 0.99)
    print(progress)

    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled, .ended:
      if progress < 0.25 {
        cancel()
      } else {
        finish()
      }
      interactive = false
    default:
      break
    }
  }
}
