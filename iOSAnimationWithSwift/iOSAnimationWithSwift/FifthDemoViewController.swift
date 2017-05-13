//
//  FifthDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 13/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

class FifthDemoViewController: UIViewController, UINavigationControllerDelegate {

	let logo = RWLogoLayer.logoLayer()
	let transition = TransitionController()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		title = "Start"
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.delegate = self
		
		// add the pan gesture recognizer
		let pan = UIPanGestureRecognizer(target: self, action: #selector(FifthDemoViewController.didPan(recognizer:)))
		view.addGestureRecognizer(pan)
		
		
		// add the logo to the view
		logo.position = CGPoint(x: view.layer.bounds.size.width/2,
		                        y: view.layer.bounds.size.height/2 + 30)
		logo.fillColor = UIColor.white.cgColor
		view.layer.addSublayer(logo)
		
		
	}
	
	//
	// MARK: Gesture recognizer handler
	//
	func didPan(recognizer: UIPanGestureRecognizer) {
		if transition.animating {
			return
		}
		
		if recognizer.state == .began {
			performSegue(withIdentifier: "details", sender: nil)
		} else {
			transition.handlePan(recognizer: recognizer)
		}
	}
	
	func didTap() {
		performSegue(withIdentifier: "details", sender: nil)
	}

	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		if operation == .push {
			transition.operation = operation
			
			return transition
		} else {
			
			return nil
		}
	}
	
	func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
		if transition.animating {
			return nil
		} else {
			return transition
		}
		
	}
}
