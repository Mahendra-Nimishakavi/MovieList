/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  var duration : TimeInterval
  var isPresenting : Bool
  var originFrame : CGRect
  var image : UIImage
  
  public let CustomAnimatorTag = 99
  
  init(duration : TimeInterval, isPresenting : Bool, originFrame : CGRect, image : UIImage) {
      self.duration = duration
      self.isPresenting = isPresenting
      self.originFrame = originFrame
      self.image = image
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      let container = transitionContext.containerView
      
      guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
      guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
      
      self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
      
      let detailView = isPresenting ? toView : fromView
      
      guard let artwork = detailView.viewWithTag(CustomAnimatorTag) as? UIImageView else { return }
      artwork.image = image
      artwork.alpha = 0
      
      let transitionImageView = UIImageView(frame: isPresenting ? originFrame : artwork.frame)
      transitionImageView.image = image
      
      container.addSubview(transitionImageView)
      
      toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
      toView.alpha = isPresenting ? 0 : 1
      toView.layoutIfNeeded()
      
      UIView.animate(withDuration: duration, animations: {
          transitionImageView.frame = self.isPresenting ? artwork.frame : self.originFrame
          detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
          detailView.alpha = self.isPresenting ? 1 : 0
      }, completion: { (finished) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          transitionImageView.removeFromSuperview()
          artwork.alpha = 1
      })
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return duration
  }
}
