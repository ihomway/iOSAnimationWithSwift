//
//  RefreshView.swift
//  pull-to-refresh
//
//  Created by Marin Todorov on 8/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

// MARK: Refresh View Delegate Protocol

protocol RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

// MARK: Refresh View

class RefreshView: UIView, UIScrollViewDelegate {
    
    var delegate: RefreshViewDelegate?
    var scrollView: UIScrollView?
    var refreshing: Bool = false
    var progress: CGFloat = 0.0
    
    var isRefreshing = false
    
    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    let airplaneLayer: CALayer = CALayer()
    let textLayer = CATextLayer()
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)

        self.scrollView = scrollView

        //add the background
        
        addSubview(UIImageView(image: UIImage(named: "refresh-view-bg")))
		
		ovalShapeLayer.strokeColor = UIColor.white.cgColor
		ovalShapeLayer.fillColor = UIColor.clear.cgColor
		ovalShapeLayer.lineWidth = 4.0
		ovalShapeLayer.lineDashPattern = [2, 3]
		
		let refreshRadius = frame.size.height / 2.0 * 0.8
		ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(
			x: frame.width / 2.0 - refreshRadius,
			y: frame.height / 2 - refreshRadius,
			width: 2 * refreshRadius,
			height: 2 * refreshRadius)
		).cgPath
		layer.addSublayer(ovalShapeLayer)
		
		let airplaneImage = UIImage(named: "icon-plane")!
		airplaneLayer.opacity = 1.0
		airplaneLayer.contents = airplaneImage.cgImage
		airplaneLayer.bounds = CGRect(x: 0, y: 0, width: airplaneImage.size.width, height: airplaneImage.size.height)
		airplaneLayer.position = CGPoint(x: frame.width / 2 + frame.height / 2.0 * 0.8, y: frame.height / 2.0)
		layer.addSublayer(airplaneLayer)
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    // MARK: Scroll View Delegate methods
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = CGFloat( max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0))
		self.progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
		
		if !isRefreshing
		{
			redrawFromProgress()
		}
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if !isRefreshing && self.progress >= 1.0 {
            delegate?.refreshViewDidRefresh(refreshView: self)
            beginRefreshing()
        }
	}
   
    // MARK: animate the Refresh View
	
	func redrawFromProgress() {
		
		ovalShapeLayer.strokeEnd = self.progress
		airplaneLayer.opacity = Float(self.progress)
	}
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animate(withDuration: 0.3, animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top += self.frame.size.height
            self.scrollView!.contentInset = newInsets
            })
		
		let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
		strokeStartAnimation.fromValue = -0.5
		strokeStartAnimation.toValue = 1.0
		
		let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeEndAnimation.fromValue = 0.0
		strokeEndAnimation.toValue = 1.0
		
		let strokrAnimationGroup = CAAnimationGroup()
		strokrAnimationGroup.duration = 1.5
		strokrAnimationGroup.repeatCount = 5.0
		strokrAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
		
		ovalShapeLayer.add(strokrAnimationGroup, forKey: nil)
		
		let flightAnimation = CAKeyframeAnimation(keyPath: "position")
		flightAnimation.path = ovalShapeLayer.path
		flightAnimation.calculationMode = kCAAnimationPaced
		
		let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
		airplaneOrientationAnimation.fromValue = 0
		airplaneOrientationAnimation.toValue = Double.pi * 2
		
		
		let flightAnimationGroup = CAAnimationGroup()
		flightAnimationGroup.duration = 1.5
		flightAnimationGroup.repeatDuration = 5.0
		flightAnimationGroup.animations = [flightAnimation, airplaneOrientationAnimation]
		
		airplaneLayer.add(flightAnimationGroup, forKey: nil)
    }
    
    func endRefreshing() {
        
        isRefreshing = false

		UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut ,animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top -= self.frame.size.height
            self.scrollView!.contentInset = newInsets
        }, completion: {_ in
            //finished
        })
    }
}
