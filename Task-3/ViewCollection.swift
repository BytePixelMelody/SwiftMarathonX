import UIKit

class ViewCollection {
    private var rectViews: [UIView] = []
    
    func addView(rectViewToAdd: UIView) {
        rectViews.append(rectViewToAdd)
    }
    
    func addTap(toView: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTaps))
        tap.numberOfTapsRequired = 1
        toView.addGestureRecognizer(tap)
    }
    
    @objc func handleTaps(gesture: UITapGestureRecognizer) {
        
        // current view with gesture
        guard let currentView = gesture.view else {
            print("Can not take view from gesture")
            return
        }
        
        guard let mainView = currentView.superview else {
            print("Can not take main view from current view")
            return
        }
        
        // removing gesture from current view
        currentView.removeGestureRecognizer(gesture)
                
        // trying to create new view if possible
        guard let newView = currentView.generateViewOnFreeSpace(currentView: currentView, rectViews: rectViews) else {
            print("Can not generate new view, finishing this game")
            return
        }
        
        // add tap to new UIView
        addTap(toView: newView)
        
        // add object UIView to array [UIView]
        addView(rectViewToAdd: newView)
        
        // add new view to display
        mainView.addSubview(newView)
    }
}
