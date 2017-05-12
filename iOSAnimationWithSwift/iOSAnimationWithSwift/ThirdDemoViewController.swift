//
//  ThirdDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 12/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

class ThirdDemoViewController: UIViewController {
	
	let arialRounded = UIFont(name: "ArialRoundedMTBold", size: 36.0)
	
	@IBOutlet var myAvatar: AvatarView!
	@IBOutlet var opponentAvatar: AvatarView!
	
	@IBOutlet var status: UILabel!
	@IBOutlet var vs: UILabel!
	@IBOutlet var searchAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//initial setup
		
		myAvatar.name = "Me"
		myAvatar.image = UIImage(named: "avatar-1")
		
		status.font = arialRounded
		vs.font = arialRounded
		searchAgain.titleLabel?.font = arialRounded
		
		vs.alpha = 0.0
		searchAgain.alpha = 0.0
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		searchForOpponent()
	}
	
	func searchForOpponent() {
		
		let bounceXOffset: CGFloat = 46.0
		
		myAvatar.bounceOffPoint(bouncePoint: CGPoint(x:187.0 + bounceXOffset, y: myAvatar.center.y), morphSize: CGSize(width: 75, height: 100))
		
		opponentAvatar.bounceOffPoint(bouncePoint: CGPoint(x:187.0 - bounceXOffset, y: opponentAvatar.center.y), morphSize: CGSize(width: 75, height: 100))
		
		delay(seconds: 4, completion: foundOpponent)
	}
	
	func foundOpponent() {
		status.text = "Connecting..."
		
		opponentAvatar.image = UIImage(named: "avatar-2")
		opponentAvatar.name = "Ray"
		
		delay(seconds: 4.0, completion: connectedToOpponent)
	}
	
	func connectedToOpponent() {
		myAvatar.shouldTransitionToFinishedState = true
		opponentAvatar.shouldTransitionToFinishedState = true
		
		delay(seconds: 1.0, completion: completed)
	}
	
	func completed() {
		status.text = "Ready to play"
		UIView.animate(withDuration: 0.2, animations: {
			self.vs.alpha = 1.0
			self.searchAgain.alpha = 1.0
		})
	}
	
	@IBAction func actionSearchAgain() {
		
		UIApplication.shared.keyWindow!.rootViewController = storyboard?.instantiateViewController(withIdentifier: "ThirdDemoViewController")
		
	}
}
