import UIKit

class ViewController: UIViewController {
    
    let startView = UIView(frame: CGRect(x: 100, y: 400, width: 130, height: 75))
    
    let rectViews = ViewCollection()
    
    
    override func viewDidLoad() {
        startView.backgroundColor = .brown
        
        rectViews.addTap(toView: startView)
        rectViews.addView(rectViewToAdd: startView)
        
        // add new view to display
        view.addSubview(startView)

    }
}

