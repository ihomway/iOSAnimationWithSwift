//
//  TransitionController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 13/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit
import QuartzCore

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
	
	let animationDuration = 1.0
	var animating = false
	var operation: UINavigationControllerOperation = .push
	
	weak var storedContext: UIViewControllerContextTransitioning? = nil

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		
		return animationDuration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		storedContext = transitionContext
		
		if operation == .push
		{
			let fromVC = transitionContext.viewController(forKey: .from) as! FifthDemoViewController
			let toVC = transitionContext.viewController(forKey: .to) as! FourthDemoViewController
			
			transitionContext.containerView.addSubview(toVC.view)
			
			// grow logo
			let animation = CABasicAnimation(keyPath: "transform")
			animation.toValue = NSValue(caTransform3D: CATransform3DConcat(
				CATransform3DMakeTranslation(0.0, -10.0, 0.0),
				CATransform3DMakeScale(75.0, 75.0, 1.0)))
			animation.duration = animationDuration
			animation.delegate = self;
			fromVC.logo.add(animation, forKey: "")
			
			toVC.maskLayer.opacity = 0.0
			
			let fadeIn = CABasicAnimation(keyPath: "opacity")
			fadeIn.duration = animationDuration
			fadeIn.toValue = 3.0
			toVC.maskLayer.add(fadeIn, forKey: nil)
			toVC.maskLayer.add(animation, forKey: nil)
		} else {
			// pop
			let fromVC = transitionContext.viewController(forKey: .from) as! FourthDemoViewController
			let toVC = transitionContext.viewController(forKey: .to) as! FifthDemoViewController
			
			transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
			
			UIView.animate(withDuration: animationDuration, animations: { 
				fromVC.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			}, completion: { _ in
				
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
				
			})
		}
	}
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		if let context = storedContext {
			context.completeTransition(true)
		}
	}
}
