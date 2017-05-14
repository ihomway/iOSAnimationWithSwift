//
//  SixthDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 14/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit
import QuartzCore

class SixthDemoViewController: UIViewController {
	
	let menuWidth: CGFloat = 80.0
	let animationTime: TimeInterval = 0.5
	
	var menuViewController: UIViewController!
	var centerViewController: UIViewController!
	
	@IBOutlet weak var menuContainer: UIView!
	@IBOutlet weak var centerContainer: UIView!
	
	var isOpening = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.black
		
		menuContainer.layer.anchorPoint = CGPoint(x:1.0, y: 0.5)
		menuContainer.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
		
		let panGesture = UIPanGestureRecognizer(target:self, action:#selector(SixthDemoViewController.handleGesture(recognizer:)))
		view.addGestureRecognizer(panGesture)
		
		(menuViewController as! SideMenuViewController).centerViewController = (centerViewController as! CenterViewController)
		
		setToPercent(percent: 0.0)
    }

	func handleGesture(recognizer:UIPanGestureRecognizer) {
		
		let translation = recognizer.translation(in: recognizer.view!.superview!)
		
		var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
		progress = min(max(progress, 0.0), 1.0)
		
		switch recognizer.state {
		case .began:
			let isOpen = floor(centerContainer.frame.origin.x/menuWidth)
			isOpening = isOpen == 1.0 ? false: true
			menuContainer.layer.shouldRasterize = true
			menuContainer.layer.rasterizationScale = UIScreen.main.scale
		case .changed:
			self.setToPercent(percent: isOpening ? progress: (1.0 - progress))
			
		case .ended: fallthrough
		case .cancelled: fallthrough
		case .failed:
			
			menuContainer.layer.shouldRasterize = false
			
			var targetProgress: CGFloat
			if (isOpening) {
				targetProgress = progress < 0.5 ? 0.0 : 1.0
			} else {
				targetProgress = progress < 0.5 ? 1.0 : 0.0
			}
			
			UIView.animate(withDuration: animationTime, animations: {
				self.setToPercent(percent: targetProgress)
			}, completion: { _ in
				//
			})
			
		default: break
		}
	}
	
	func toggleSideMenu() {
		let isOpen = floor(centerContainer.frame.origin.x/menuWidth)
		let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
		
		UIView.animate(withDuration: animationTime, animations: {
			self.setToPercent(percent: targetProgress)
		}, completion: { _ in
			self.menuContainer.layer.shouldRasterize = false
		})
	}
	
	func setToPercent(percent: CGFloat) {
		centerContainer.frame.origin.x = menuWidth * CGFloat(percent)
//		menuContainer.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
		menuContainer.layer.transform = menuTansformForPercent(percent: percent)
		menuContainer.alpha = max(0.2, percent);
		
		if let button = (centerViewController as! CenterViewController).menuButton {
			var identifier = CATransform3DIdentity
			identifier.m34 = -1.0 / 1_000
			
			button.imageView.layer.transform = CATransform3DRotate(identifier, percent * CGFloat(Double.pi), 1.0, 1.0, 1.0)
		}
	}
	
	func menuTansformForPercent(percent: CGFloat) -> CATransform3D {
		var identity = CATransform3DIdentity
		identity.m34 = -1.0 / 1_000
		
		
		let angle = (1.0 - percent) * CGFloat(-Double.pi / 2)
		
		let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
		let translationTransform = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
		
		return CATransform3DConcat(rotationTransform, translationTransform)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		
		if identifier == "Menu" {
			menuViewController = segue.destination
		} else if identifier == "Center" {
			if let nav = segue.destination as? UINavigationController {
				centerViewController = nav.topViewController!
			}
		}
	}
}
