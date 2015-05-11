/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

// A delay function
func delay(#seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

func tintBackgroundColor(#layer: CALayer, #toColor: UIColor) {
  
  let tint = CABasicAnimation(keyPath: "backgroundColor")
  tint.fromValue = layer.backgroundColor
  tint.toValue = toColor.CGColor
  tint.duration = 1.0
  layer.addAnimation(tint, forKey: nil)
  layer.backgroundColor = toColor.CGColor
}

func roundCorners(#layer: CALayer, #toRadius: CGFloat) {
  
  let round = CABasicAnimation(keyPath: "cornerRadius")
  round.fromValue = layer.cornerRadius
  round.toValue = toRadius
  round.duration = 0.33
  layer.addAnimation(round, forKey: nil)
  layer.cornerRadius = toRadius
}

class ViewController: UIViewController {
  
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zeroPoint
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.hidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .Center
    status.addSubview(label)
    
    statusPosition = status.center
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    loginButton.center.y += 30.0
    loginButton.alpha = 0.0
    
    username.layer.position.x -= view.bounds.width
    password.layer.position.x -= view.bounds.width
    
    delay(seconds: 5.0, {
      println("where are the fields?")
    })
    
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0.0
    fadeIn.toValue = 1.0
    fadeIn.duration = 0.5
    fadeIn.fillMode = kCAFillModeBackwards
    fadeIn.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.addAnimation(fadeIn, forKey: nil)
    
    fadeIn.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.addAnimation(fadeIn, forKey: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.toValue = view.bounds.size.width/2
    flyRight.fromValue = -view.bounds.size.width/2
    flyRight.duration = 0.5
    
    heading.layer.addAnimation(flyRight, forKey: nil)
    
    flyRight.beginTime = CACurrentMediaTime() + 0.3
    flyRight.fillMode = kCAFillModeBoth
    username.layer.addAnimation(flyRight, forKey: nil)
    username.layer.position.x = view.bounds.size.width/2
    
    flyRight.beginTime = CACurrentMediaTime() + 0.4
    password.layer.addAnimation(flyRight, forKey: nil)
    password.layer.position.x = view.bounds.size.width/2
    
    UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: nil, animations: {
        self.loginButton.center.y -= 30.0
        self.loginButton.alpha = 1.0
    }, completion: nil)

    animateCloud(cloud1)
    animateCloud(cloud2)
    animateCloud(cloud3)
    animateCloud(cloud4)
  }
  
  // MARK: further methods
  
  @IBAction func login() {

    UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.bounds.size.width += 80.0
    }, completion: nil)

    UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: nil, animations: {
      self.loginButton.center.y += 60.0
      
      self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
      self.spinner.alpha = 1.0

    }, completion: {_ in
      self.showMessage(index: 0)
    })
    
    let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
    tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
    
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
  }

  func showMessage(#index: Int) {
    label.text = messages[index]
    
    UIView.transitionWithView(status, duration: 0.33, options:
      .CurveEaseOut | .TransitionFlipFromBottom, animations: {
        self.status.hidden = false
      }, completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
    })
  }

  func removeMessage(#index: Int) {
    UIView.animateWithDuration(0.33, delay: 0.0, options: nil, animations: {
      self.status.center.x += self.view.frame.size.width
    }, completion: {_ in
      self.status.hidden = true
      self.status.center = self.statusPosition
      
      self.showMessage(index: index+1)
    })
  }

  func resetForm() {
    UIView.transitionWithView(status, duration: 0.2, options: .TransitionFlipFromTop, animations: {
      self.status.hidden = true
      self.status.center = self.statusPosition
    }, completion: nil)
    
    UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
      self.spinner.center = CGPoint(x: -20.0, y: 16.0)
      self.spinner.alpha = 0.0
      self.loginButton.bounds.size.width -= 80.0
      self.loginButton.center.y -= 60.0
    }, completion: {_ in
      let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
      tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
      roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    })
  }
  
  func animateCloud(cloud: UIImageView) {
    let cloudSpeed = 60.0 / view.frame.size.width
    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
    UIView.animateWithDuration(NSTimeInterval(duration), delay: 0.0, options: .CurveLinear, animations: {
      cloud.frame.origin.x = self.view.frame.size.width
    }, completion: {_ in
      cloud.frame.origin.x = -cloud.frame.size.width
      self.animateCloud(cloud)
    })
  }
  
}

