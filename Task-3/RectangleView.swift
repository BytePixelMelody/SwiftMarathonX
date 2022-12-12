import UIKit

extension UIView {
        
    private func randomSize(mainViewFrame: CGSize) -> CGSize {
        let widthSize = mainViewFrame.width / .random(in: 3.6...4.7)
        let heightSize = widthSize * .random(in: 0.7...1.5)
        return CGSize(width: widthSize, height: heightSize)
    }
    
    private func randomColor(currentColor: UIColor) -> UIColor {
        
        let colors: [UIColor] = [
            UIColor(named: "Blue") ?? .gray,
            UIColor(named: "Cyan") ?? .gray,
            UIColor(named: "Green") ?? .gray,
            UIColor(named: "Magenta") ?? .gray,
            UIColor(named: "Orange") ?? .gray,
            UIColor(named: "Purple") ?? .gray,
            UIColor(named: "Red") ?? .gray,
            UIColor(named: "Yellow") ?? .gray,
        ]
        
        var resultColor: UIColor
        
        repeat {
            resultColor = colors.randomElement() ?? currentColor
        } while resultColor == currentColor
        
        return resultColor
    }
    
    private func possiblePositions(currentView: UIView, planingView: CGSize, mainView: UIView) -> [CGPoint] {
        
        let topLeft = CGPoint(
            x: currentView.frame.origin.x,
            y: currentView.frame.origin.y - planingView.height
        )
        let topRight = CGPoint(
            x: currentView.frame.origin.x + currentView.frame.width - planingView.width,
            y: currentView.frame.origin.y - planingView.height
        )
        let rightTop = CGPoint(
            x: currentView.frame.origin.x + currentView.frame.width,
            y: currentView.frame.origin.y
        )
        let rightBottom = CGPoint(
            x: currentView.frame.origin.x + currentView.frame.width,
            y: currentView.frame.origin.y + currentView.frame.height - planingView.height
        )
        let bottomRight = CGPoint(
            x: currentView.frame.origin.x + currentView.frame.width - planingView.width,
            y: currentView.frame.origin.y + currentView.frame.height
        )
        let bottomLeft = CGPoint(
            x: currentView.frame.origin.x,
            y: currentView.frame.origin.y + currentView.frame.height
        )
        let leftBottom = CGPoint(
            x: currentView.frame.origin.x - planingView.width,
            y: currentView.frame.origin.y + currentView.frame.height - planingView.height
        )
        let leftTop = CGPoint(
            x: currentView.frame.origin.x - planingView.width,
            y: currentView.frame.origin.y
        )
        
        let maxX = mainView.frame.width
        let maxY = mainView.frame.height
        
        let preResultPoints: [CGPoint] = [
            topLeft,
            topRight,
            rightTop,
            rightBottom,
            bottomRight,
            bottomLeft,
            leftBottom,
            leftTop
        ]
        
        var resultPoints: [CGPoint] = []
        
        for preResultPoint in preResultPoints {
            // if not overstep the boundaries of main view
            if (
                preResultPoint.x >= 0 &&
                preResultPoint.y >= 0 &&
                preResultPoint.x + planingView.width <= maxX &&
                preResultPoint.y + planingView.height <= maxY
            ) {
                resultPoints.append(preResultPoint)
            }
                
        }
        
        return resultPoints
    }
    
    private func rectIntersection(firstRect: CGRect, secondRect: CGRect) -> Bool {
        let xFirstMin = firstRect.origin.x
        let xFirstMax = xFirstMin + firstRect.width

        let xSecondMin = secondRect.origin.x
        let xSecondMax = xSecondMin + secondRect.width
        
        let yFirstMin = firstRect.origin.y
        let yFirstMax = yFirstMin + firstRect.height
        
        let ySecondMin = secondRect.origin.y
        let ySecondMax = ySecondMin + secondRect.height
        
        let xIntersection = (xFirstMin > xSecondMin && xFirstMin < xSecondMax)
        || (xFirstMax > xSecondMin && xFirstMax < xSecondMax)
        || (xSecondMin > xFirstMin && xSecondMin < xFirstMax)
        || (xSecondMax > xFirstMin && xSecondMax < xFirstMax)
        
        let yIntersection = (yFirstMin > ySecondMin && yFirstMin < ySecondMax)
        || (yFirstMax > ySecondMin && yFirstMax < ySecondMax)
        || (ySecondMin > yFirstMin && ySecondMin < yFirstMax)
        || (ySecondMax > yFirstMin && ySecondMax < yFirstMax)

        return xIntersection && yIntersection
    }
    
    public func generateViewOnFreeSpace(currentView: UIView, rectViews: [UIView]) -> UIView? {
        guard let mainView = currentView.superview else {
            print("Can not obtain main view from current view")
            return nil
        }
        
        // take size of main view
        let mainViewCGSize = mainView.frame.size
        
        // generate random size to new subview
        let generatedCGSize = randomSize(mainViewFrame: mainViewCGSize)
        
        // generate random color
        let generatedUIColor = randomColor(currentColor: currentView.backgroundColor ?? .gray)
        
        // calculate start posible positions [CGPoint]
        var possiblePositionsArray = possiblePositions(currentView: currentView, planingView: generatedCGSize, mainView: mainView)
        
        // randomize CGPoint array
        possiblePositionsArray = possiblePositionsArray.shuffled()
        
        // creating array of possible CGRects
        let possibleCGRectsArray = possiblePositionsArray.map { itemCGPoint in return CGRect(origin: itemCGPoint, size: generatedCGSize) }
        
        // creating array of existing CGRects
        let existingCGRectsArray = rectViews.map { rectView in return rectView.frame }

        // prepare result
        var resultView: UIView? = nil
        
        for possibleCGRect in possibleCGRectsArray {
            var possible = true
            for existingCGRect in existingCGRectsArray {
                // if rects are intersect
                if rectIntersection(firstRect: possibleCGRect, secondRect: existingCGRect)  {
                    possible = false
                    break
                }
            }
            if possible == true {
                resultView = UIView(frame: possibleCGRect)
            }
        }
        
        resultView?.backgroundColor = generatedUIColor

        return resultView
    }
}
