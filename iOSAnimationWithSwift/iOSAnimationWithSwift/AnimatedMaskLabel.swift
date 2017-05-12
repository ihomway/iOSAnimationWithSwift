//
//  AnimatedMaskLabel.swift
//  gradient+textmask
//
//  Created by Marin Todorov on 8/4/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore
import CoreText

class AnimatedMaskLabel: UIView {
  
  var gradientLayer: CAGradientLayer = CAGradientLayer()
  var text = "Slide to reveal"
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    //set the background color
    backgroundColor = UIColor.clear
    clipsToBounds = true
	
	
	gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
	gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
	gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
	
	let colors = [
		UIColor.yellow.cgColor,
		UIColor.green.cgColor,
		UIColor.orange.cgColor,
		UIColor.cyan.cgColor,
		UIColor.red.cgColor,
		UIColor.yellow.cgColor
	]
	gradientLayer.colors = colors
	
	let locations = [
		0.0,
		0.0,
		0.0,
		0.0,
		0.0,
		0.25
	]
	gradientLayer.locations = locations as [NSNumber]
	layer.addSublayer(gradientLayer)
	
	let gradientAnimation = CABasicAnimation(keyPath: "locations")
	gradientAnimation.fromValue = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
	gradientAnimation.toValue = [0.65, 0.8, 0.85, 0.9, 0.95, 1.0]
	gradientAnimation.duration = 3.0
	gradientAnimation.repeatCount = 1_000_000
	gradientAnimation.isRemovedOnCompletion = false
	gradientAnimation.fillMode = kCAFillModeForwards
	
	gradientLayer.add(gradientAnimation, forKey: nil)
	
	let font = UIFont(name: "HelveticaNeue-Thin", size: 28.0)
	let style = NSMutableParagraphStyle()
	style.alignment = .center
	
	UIGraphicsBeginImageContext(frame.size)
	let context = UIGraphicsGetCurrentContext()
	
	let string = text as! NSString;
	string.draw(in: bounds, withAttributes: [
		NSFontAttributeName: font,
		NSParagraphStyleAttributeName: style
		])
	
	let image = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	
	let maskLayer = CALayer()
	maskLayer.backgroundColor = UIColor.clear.cgColor
	
	maskLayer.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
	maskLayer.contents = image?.cgImage
	
	gradientLayer.mask = maskLayer
  }
  
}
