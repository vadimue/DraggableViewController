import UIKit

class DetailViewController: UIViewController {

  var transition: InteractiveTransition?

  override func viewDidLoad() {
    super.viewDidLoad()
    let pan = UIPanGestureRecognizer(target:self, action: #selector(didPan))
    view.addGestureRecognizer(pan)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let masterVC = (presentingViewController as? UINavigationController)?.topViewController as? ViewController {
      transition = masterVC.transition
    }
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      transition?.interactive = true
      dismiss(animated: true, completion: nil)
    default:
      transition?.handlePan(recognizer: recognizer)
    }
  }

  @IBAction func closeDidTouchDown(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}
