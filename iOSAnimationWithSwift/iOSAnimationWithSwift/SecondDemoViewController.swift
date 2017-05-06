//
//  SecondDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 05/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

enum TransionDirection: Int {
	case up = -1
	case down = 1
}

class SecondDemoViewController: UIViewController {
	
	@IBOutlet var bgImageView: UIImageView!
	
	@IBOutlet var summaryIcon: UIImageView!
	@IBOutlet var summary: UILabel!
	
	@IBOutlet var flightNr: UILabel!
	@IBOutlet var gateNr: UILabel!
	@IBOutlet var departingFrom: UILabel!
	@IBOutlet var arrivingTo: UILabel!
	@IBOutlet var planeImage: UIImageView!
	
	@IBOutlet var flightStatus: UILabel!
	@IBOutlet var statusBanner: UIImageView!
	
	var snowView: SnowView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//adjust ui
		statusBanner.addSubview(flightStatus)
		summary.addSubview(summaryIcon)
		summaryIcon.center.y = summary.frame.size.height/2
		
		//add the snow effect layer
		snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
		let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
		snowClipView.clipsToBounds = true
		snowClipView.addSubview(snowView)
		view.addSubview(snowClipView)
		
		//start rotating the flights
		delay(seconds: 2) { 
			self.changeFlightDataAnimatedTo(londonToParis)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	func changeFlightDataTo(_ data: FlightData) {
		
		//
		// populate the UI with the next flight's data
		//
		summary.text = data.summary
		flightNr.text = data.flightNr
		gateNr.text = data.gateNr
		departingFrom.text = data.departingFrom
		arrivingTo.text = data.arrivingTo
		flightStatus.text = data.flightStatus
		bgImageView.image = UIImage(named: data.weatherImageName)
		snowView.isHidden = !data.showWeatherEffects
		
		//
		// schedule next flight
		//
		
		delay(seconds: 3) {
			self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis)
		}
	}
	
	func changeFlightDataAnimatedTo(_ data: FlightData) {
		
		fade(imageView: bgImageView, to: UIImage(named: data.weatherImageName)!, withEffect: data.showWeatherEffects)
		cubeTransion(label: flightNr, toText: data.flightNr, direction: data.isTakingOff ? .up : .down)
		cubeTransion(label: gateNr, toText: data.gateNr, direction: data.isTakingOff ? .up : .down)
		trasition(label: departingFrom, to: data.departingFrom, offset: CGPoint(x: data.isTakingOff ? 80 : -80, y: 0))
		trasition(label: arrivingTo, to: data.arrivingTo, offset: CGPoint(x: 0, y: data.isTakingOff ? 50 : -50))
		planeDepart()
		animateStatusBannerWithKeyframes()
		
		//
		// schedule next flight
		//
		
		delay(seconds: 3) {
			self.changeFlightDataAnimatedTo(data.isTakingOff ? parisToRome : londonToParis)
		}
	}

	func fade(imageView: UIImageView, to image:UIImage, withEffect: Bool) {
		let orginalFrame = imageView.frame
		
		let newImageView = UIImageView(image: image)
		newImageView.frame = orginalFrame
		newImageView.alpha = 0
		
		view.insertSubview(newImageView, aboveSubview: imageView)
		
		UIView.animate(withDuration: 1, animations: {
			
			imageView.alpha = 0
			newImageView.alpha = 1
			self.snowView.alpha = withEffect ? 1 : 0
		}) { _ in
			
			imageView.alpha = 1
			imageView.image = image
			newImageView.removeFromSuperview()
		}
	}
	
	func cubeTransion(label: UILabel, toText: String, direction: TransionDirection) {
		
		let originalFrame = label.frame
		
		let newLabel = UILabel(frame: originalFrame)
		newLabel.text = toText
		newLabel.textAlignment = label.textAlignment
		newLabel.textColor = label.textColor
		newLabel.font = label.font
		
		let offset = originalFrame.height / 2 * CGFloat(direction.rawValue)
		
		newLabel.transform = CGAffineTransform(scaleX: 1, y: 0).concatenating(CGAffineTransform(translationX: 0, y: offset))
		view.addSubview(newLabel)
		
		UIView.animate(withDuration: 0.5, animations: {
			
			label.transform = CGAffineTransform(scaleX: 1, y: 0.1).concatenating(CGAffineTransform(translationX: 0, y: -offset))
			newLabel.transform = CGAffineTransform.identity
			
		}) { _ in
			
			label.text = toText
			label.transform = CGAffineTransform.identity
			newLabel.removeFromSuperview()
		}
	}
	
	func trasition(label: UILabel, to text: String, offset: CGPoint) {
		
		let originalFrame = label.frame
		
		let newLabel = UILabel(frame: originalFrame)
		newLabel.text = text
		newLabel.textAlignment = label.textAlignment
		newLabel.textColor = label.textColor
		newLabel.font = label.font
		
		newLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
		newLabel.alpha = 0
		view.addSubview(newLabel)
		
		
		UIView.animate(withDuration: 0.5) { 
			label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
			label.alpha = 0
		}
		
		UIView.animate(withDuration: 0.25, delay: 0.25, animations: { 
			
			newLabel.transform = CGAffineTransform.identity
			newLabel.alpha = 1
			
		}) { _ in
			
			label.transform = CGAffineTransform.identity
			label.alpha = 1
			label.text = text
			
			newLabel.removeFromSuperview()
		}
	}
	
	func planeDepart() {
		
		let originalCenter = planeImage.center
		
		UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: { 
			
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
				
				self.planeImage.center.x += 80
				self.planeImage.center.y -= 10.0
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
				self.planeImage.center.x += 100
				self.planeImage.center.y -= 50.0
				
				self.planeImage.alpha = 0.0
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: { 
				
				self.planeImage.transform  = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 16))
				
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
				
				self.planeImage.transform = CGAffineTransform.identity
				self.planeImage.center = CGPoint(x: 0, y: originalCenter.y)
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
				
				self.planeImage.alpha = 1.0
				self.planeImage.center = originalCenter
				
			})
			
		}) { _ in
			
		}
		
	}
	
	func animateStatusBannerWithKeyframes() {
		
		statusBanner.center.x -= view.bounds.width
		statusBanner.center.y -= 50.0
		
		UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: { 
			
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: { 
				self.statusBanner.center.x += self.view.bounds.width
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.66, animations: {
				self.statusBanner.center.y += 50
			})
			
		}, completion: nil)
	}
}
