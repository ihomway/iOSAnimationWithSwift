//
//  SeventhDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 14/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit
import pop

class SeventhDemoViewController: UIViewController, POPAnimationDelegate {

	@IBOutlet var door: UIImageView!
	@IBOutlet var ball: UIImageView!
	
	var playingRect: CGRect!
	var observeBounds = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		ball.isUserInteractionEnabled = true
		ball.addGestureRecognizer(
			UIPanGestureRecognizer(target: self, action: #selector(SeventhDemoViewController.didPan(pan:)))
		)
		
		ball.addObserver(self, forKeyPath: "alpha", options: .new, context: nil)
		ball.alpha = 0.0
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		fadeIn(view: ball)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if object as! NSObject === ball && keyPath == "alpha" {
			
			print(ball.alpha)
		}
	}
	
	func didPan(pan: UIPanGestureRecognizer) {
		print("Panning...")
		
		switch pan.state {
		case .began:
			ball.pop_removeAllAnimations()
		case .changed:
			ball.center = pan.location(in: view)
		case .ended:
			let velocity = pan.velocity(in: pan.view!)
			let animation = POPDecayAnimation(propertyNamed: kPOPViewCenter)!
			animation.fromValue = NSValue(cgPoint: ball.center)
			animation.velocity = NSValue(cgPoint: velocity)
			animation.delegate = self
			ball.pop_add(animation, forKey: nil)
			
		default: break
		}
	}
	
	func fadeIn(view: UIView) {
		let animation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)!
		animation.fromValue = 0.0
		animation.toValue = 1.0
		animation.duration = 1.0
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		view.pop_add(animation, forKey: nil)
	}
	
	func resetBall() {
		//set ball at random position on the field
		let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
		ball.center = CGPoint(x: randomX * view.frame.size.width, y: 380.0)
		fadeIn(view: ball)
	}
	
	func animateMessage(text: String) {
		let label = UILabel(frame: CGRect(x: -view.frame.width, y: 200, width: view.frame.width, height: 50))
		label.font = UIFont(name: "ArialRoundedMTBold", size: 52.0)
		label.textAlignment = .center
		label.textColor = UIColor.yellow
		label.text = text
		label.shadowColor = UIColor.darkGray
		label.shadowOffset = CGSize(width: 2, height: 2)
		
		view.addSubview(label)
		
		let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)!
		animation.fromValue = NSValue(cgPoint: label.center)
		animation.toValue = NSValue(cgPoint: view.center)
		animation.springBounciness = 20.0;
		animation.springSpeed = 15;
		animation.completionBlock = {_, _ in
			UIView.animate(withDuration: 0.5, animations: { 
				label.alpha = 0.0
			}, completion: {_ in
				label.removeFromSuperview()
			})
		}
		
		label.pop_add(animation, forKey: nil)
	}

	func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
		if finished {
			resetBall()
		}
	}
	
	func pop_animationDidApply(_ anim: POPAnimation!) {
		
		let minX = ball.frame.width / 2
		let maxX = view.frame.width - ball.frame.width / 2
		
		if door.frame.contains(ball.center) {
			ball.pop_removeAllAnimations()
			resetBall()
			print("GOAL")
			animateMessage(text: "GOAL")
			
			return
		}
		
		if ball.center.x < minX || ball.center.x > maxX {
			
			if let animation = anim as? POPSpringAnimation
			{
				let velocityValue = animation.velocity as? NSValue
				let velocity = (velocityValue?.cgPointValue)!
				
				ball.pop_removeAllAnimations()
				let newVelocity = CGPoint(x: -velocity.x, y: velocity.y)
				let newX = min(max(maxX, ball.center.x), maxX)
				
				let decayAnimation = POPDecayAnimation(propertyNamed: kPOPViewCenter)!
				decayAnimation.fromValue = NSValue(cgPoint: CGPoint(x: newX, y: ball.center.y))
				decayAnimation.velocity = NSValue(cgPoint: newVelocity)
				decayAnimation.delegate = self
				ball.pop_add(decayAnimation, forKey: nil)
				
			}
			
			return
		}
		
		if ball.center.y < 0 {
			ball.pop_removeAllAnimations()
			resetBall()
			
			return
		}
	}
}
