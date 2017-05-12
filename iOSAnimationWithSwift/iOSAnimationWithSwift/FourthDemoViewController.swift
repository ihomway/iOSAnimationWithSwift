//
//  FourthDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 12/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

class FourthDemoViewController: UIViewController {
	
	@IBOutlet var slideView: AnimatedMaskLabel!
	@IBOutlet var time: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(FourthDemoViewController.didSlide))
		swipe.direction = .right
		slideView.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func didSlide() {
		print("Did slide!")
		
		let image = UIImageView(image: UIImage(named:"meme"))
		image.center = view.center
		image.center.x += view.bounds.size.width
		view.addSubview(image)
		
		UIView.animate(withDuration: 0.33, delay: 0.0, animations: { 
			
			self.time.center.y -= 200.0
			self.slideView.center.y += 200.0
			image.center.x -= self.view.bounds.width
			
		}, completion: nil)
		
		UIView.animate(withDuration: 0.33, delay: 1.0, animations: { 
			
			self.time.center.y += 200.0
			self.slideView.center.y -= 200.0
			image.center.x += self.view.bounds.size.width
			
		}) { _ in
			image.removeFromSuperview()
		}
		
	}

}
