import UIKit

extension UIViewController {
    @IBAction func dimissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dimissView() {
        dismiss(animated: true, completion: nil)
    }
}
