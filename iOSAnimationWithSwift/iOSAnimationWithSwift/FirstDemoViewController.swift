//
//  FirstDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 04/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit
import QuartzCore

func delay(seconds: Double, completion:@escaping ()->()) {
	
	DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
		completion()
	}
	
}

class FirstDemoViewController: UIViewController {
	
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var heading: UILabel!
	@IBOutlet var username: UITextField!
	@IBOutlet var password: UITextField!
	
	@IBOutlet var cloud1: UIImageView!
	@IBOutlet var cloud2: UIImageView!
	@IBOutlet var cloud3: UIImageView!
	@IBOutlet var cloud4: UIImageView!
	
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	
	let status = UIImageView(image: UIImage(named: "banner"))
	let label = UILabel()
	let messages = ["Connecting ...", "Authorization ...", "Sending credentials ...", "Failed"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		loginButton.layer.cornerRadius = 8.0
		loginButton.layer.masksToBounds = true
		
		// add the button spinner
		spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
		spinner.startAnimating()
		spinner.alpha = 0.0
		loginButton.addSubview(spinner)
		
		//add the status banner
		status.isHidden = true
		status.center = loginButton.center
		view.addSubview(status)
		
		status.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(FirstDemoViewController.didTapStatus))
		status.addGestureRecognizer(tap)
		
		//add the status label
		label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
		label.font = UIFont(name: "HelveticaNeue", size: 18.0)
		label.textColor = UIColor(red: 228.0/255.0, green: 98.0/255.0, blue: 0.0, alpha: 1.0)
		label.textAlignment = .center
		status.addSubview(label)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
		
		username.layer.position.x -= view.bounds.width
		password.layer.position.x -= view.bounds.width
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		let flyRight = CABasicAnimation(keyPath: "position.x")
		flyRight.fromValue = -view.bounds.width / 2
		flyRight.toValue = view.bounds.width / 2
		flyRight.duration = 0.5
		heading.layer.add(flyRight, forKey: nil)
		
		flyRight.delegate = self
		flyRight.setValue("form", forKey: "name")
		flyRight.setValue(username.layer, forKey: "layer")
		
		flyRight.beginTime = CACurrentMediaTime() + 0.3
		username.layer.add(flyRight, forKey: nil)
		
		flyRight.setValue(password.layer, forKey: "layer")
		flyRight.beginTime = CACurrentMediaTime() + 0.4
		password.layer.add(flyRight, forKey: nil)
		
		let loginButtonAnimation = CAKeyframeAnimation(keyPath: "position")
		loginButtonAnimation.duration = 0.6
		loginButtonAnimation.values = [NSValue(cgPoint: CGPoint(x: -view.frame.width / 2, y: loginButton.layer.position.y + 100)),
		                               NSValue(cgPoint: CGPoint(x: view.frame.width / 2, y: loginButton.layer.position.y + 100)),
		                               NSValue(cgPoint: CGPoint(x: view.frame.width / 2, y: loginButton.layer.position.y))]
		loginButtonAnimation.keyTimes = [0.0, 0.5, 1.0]
		loginButtonAnimation.isAdditive = false
		loginButton.layer.add(loginButtonAnimation, forKey: nil)
		
		
		animateCloud(cloud1)
		animateCloud(cloud2)
		animateCloud(cloud3)
		animateCloud(cloud4)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
		
		let tint = CABasicAnimation(keyPath: "backgroundColor")
		tint.toValue = toColor
		tint.duration = 1.5
		tint.fillMode = kCAFillModeForwards
		layer.add(tint, forKey: nil)
		layer.backgroundColor = toColor.cgColor
	}
	
	func roundCorners(layer: CALayer, toRadius: CGFloat) {
		let roundRect = CABasicAnimation(keyPath: "cornerRadius")
		roundRect.toValue = toRadius
		roundRect.duration = 1.0
		roundRect.fillMode = kCAFillModeForwards
		layer.add(roundRect, forKey: nil)
		layer.cornerRadius = toRadius
	}
	
	@IBAction func logAction() {
		
		tintBackgroundColor(layer: self.loginButton.layer, toColor: UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0))
		roundCorners(layer: loginButton.layer, toRadius: 25)
		
		UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
			
			let b = self.loginButton.bounds
			self.loginButton.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 80, height: b.size.height)
			
		}, completion: { _ in
			
			self.showMessages(index: 0)
		})
		
		UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseOut, animations: {
			
			if self.status.isHidden {
				self.loginButton.center.y += 60
			}
			
			self.spinner.alpha = 1.0
			self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.height / 2)
			
		}, completion: nil)
	}
	
	func showMessages(index: Int) {
		
		UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
			self.status.center.x += self.view.frame.width
		}) { _ in
			self.status.isHidden = true
			self.status.center.x -= self.view.frame.width
			self.label.text = self.messages[index]
			
			UIView.transition(with: self.status, duration: 0.3, options: [.curveEaseOut, .transitionCurlDown], animations: {
				
				self.status.isHidden = false
				
			}, completion: { _ in
				
				delay(seconds: 2.0, completion: { _ in
					if index < self.messages.count - 1 {
						self.showMessages(index: index + 1)
					} else {
						self.resetButton()
					}
				})
			})
		}
	}
	
	func resetButton() {
		
		tintBackgroundColor(layer: self.loginButton.layer, toColor: UIColor(red: 0.33, green: 0.83, blue: 0.35, alpha: 1.0))
		roundCorners(layer: loginButton.layer, toRadius: 10)
		
		UIView.animate(withDuration: 0.33, delay: 0, options: [], animations: {
			
			// reset spinner
			self.spinner.alpha = 0.0
			self.spinner.center = CGPoint(x: -20, y: 16)
			
		}) { _ in
			
			UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
				let b = self.loginButton.bounds
				self.loginButton.bounds = CGRect(x: b.origin.x + 20, y: b.origin.y, width: b.width - 80, height: b.height)
			}, completion: { _ in
				
			})
		}
		
		let bounce = CAKeyframeAnimation(keyPath: "transform.rotation.z")
		bounce.values = [0.0, -Double.pi / 8, 0.0, Double.pi / 8, 0.0]
		bounce.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
		bounce.isAdditive = true
		bounce.repeatCount = 4
		
		status.layer.add(bounce, forKey: "wobble")
	}
	
	func didTapStatus() {
		
		if let _ = status.layer.animation(forKey: "wobble") {
			status.layer.removeAnimation(forKey: "wobble")
		}
		
	}
	
	func animateCloud(_ cloud: UIImageView) {
		//animate clouds
		let cloudSpeed = 20.0 / Double(view.layer.frame.width)
		let duration: TimeInterval = Double(view.frame.width - cloud.frame.origin.x) * cloudSpeed
		
		let cloudMove = CABasicAnimation(keyPath: "position.x")
		cloudMove.duration = duration
		cloudMove.toValue  = self.view.bounds.width
		cloudMove.delegate = self
		cloudMove.setValue("cloud", forKey: "name")
		cloudMove.setValue(cloud, forKey: "view")
		
		cloud.layer.add(cloudMove, forKey: nil)
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

extension FirstDemoViewController: CAAnimationDelegate {
	
	func animationDidStart(_ anim: CAAnimation) {
		
	}
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		let nameValue = anim.value(forKey: "name") as? String
		
		if let name = nameValue {
			if name == "form" {
				let layer = anim.value(forKey: "layer") as! CALayer
				layer.position.x = view.bounds.width / 2
				anim.setValue(nil, forKey: "layer")
			} else if name == "loginButton" {
				loginButton.layer.position.y -= 100
				loginButton.layer.opacity = 1.0
			} else if name == "cloud" {
				let cloud: UIImageView = anim.value(forKey: "view") as! UIImageView
				cloud.frame.origin.x = -self.cloud1.frame.size.width
				
				delay(seconds: 0.1, completion: {
					self.animateCloud(cloud)
				})
			}
		}
	}
}
