//
//  AvatarView.swift
//  shape-mutation
//
//  Created by Marin Todorov on 8/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class AvatarView: UIView {
	
	let photoLayer = CALayer()
	let circleLayer = CAShapeLayer()
	let maskLayer = CAShapeLayer()
	
	var image: UIImage? {
		didSet {
			photoLayer.contents = image?.cgImage
		}
	}
	
	var name: String? {
		didSet {
			label.text = name
		}
	}
	
	let label: UILabel = UILabel()
	
	let lineWidth: CGFloat = 6.0
	let animationDuration = 1.0
	
	var shouldTransitionToFinishedState = false
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		
		backgroundColor = UIColor.clear
		
		//add the initial image of the avatar view
		let blankImage = UIImage(named: "empty")!
		photoLayer.contents = blankImage.cgImage
		photoLayer.frame = CGRect(
			x: (bounds.size.width - blankImage.size.width + lineWidth)/2,
			y: (bounds.size.height - blankImage.size.height - lineWidth)/2,
			width: blankImage.size.width,
			height: blankImage.size.height)
		
		layer.addSublayer(photoLayer)
		
		//draw the circle
		circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
		circleLayer.strokeColor = UIColor.white.cgColor
		circleLayer.lineWidth = lineWidth
		circleLayer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(circleLayer)
		
		//mask layer
		maskLayer.path = circleLayer.path
		maskLayer.position = CGPoint(x: 0.0, y: 10.0)
		photoLayer.mask = maskLayer
		
		//add label
		label.frame = CGRect(x: 0.0, y: bounds.size.height + 10, width: bounds.size.width, height: 24)
		label.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
		label.textAlignment = .center
		label.textColor = UIColor.black
		addSubview(label)
	}
 
	func bounceOffPoint(bouncePoint: CGPoint, morphSize: CGSize) {
		
		let originalCenter = center
		
		UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
			
			self.center = bouncePoint
			
		}, completion: {_ in
			
			if self.shouldTransitionToFinishedState {
				self.animateToSquare()
			}
			
			UIView.animate(withDuration: self.animationDuration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, animations: {
				
				self.center = originalCenter
				
			}, completion: {_ in
				
				if !self.shouldTransitionToFinishedState {
					delay(seconds: 0.1, completion: {
						self.bounceOffPoint(bouncePoint: bouncePoint, morphSize: morphSize)
					})
				}
				
			})
			
			
		})
		
		let morphFrame = (originalCenter.x > bouncePoint.x) ?
			CGRect(x: 0.0, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height) :
			CGRect(x: bounds.width - morphSize.width, y: bounds.height - morphSize.height, width: morphSize.width, height: morphSize.height)
		
		let morphAnimation = CABasicAnimation(keyPath: "path")
		morphAnimation.duration = animationDuration
		morphAnimation.toValue = UIBezierPath(ovalIn: morphFrame).cgPath
		morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		
		circleLayer.add(morphAnimation, forKey: nil)
		maskLayer.add(morphAnimation, forKey: nil)
		
	}
	
	func animateToSquare() {
		
	}
	
}
