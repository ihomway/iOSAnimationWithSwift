//
//  SeventhDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 14/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit
import pop

class SeventhDemoViewController: UIViewController {
	
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
	}
	
	
}
