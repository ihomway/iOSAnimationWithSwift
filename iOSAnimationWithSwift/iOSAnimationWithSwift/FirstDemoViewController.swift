//
//  FirstDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 04/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

class FirstDemoViewController: UIViewController {
	
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var heading: UILabel!
	@IBOutlet var username: UITextField!
	@IBOutlet var password: UITextField!
	
	@IBOutlet var cloud1: UIImageView!
	@IBOutlet var cloud2: UIImageView!
	@IBOutlet var cloud3: UIImageView!
	@IBOutlet var cloud4: UIImageView!
	
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	
	let status = UIImageView(image: UIImage(named: "banner"))
	let label = UILabel()
	let messages = ["Connecting ...", "Authorization ...", "Sending credentials ...", "Failed"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		loginButton.layer.cornerRadius = 8.0
		loginButton.layer.masksToBounds = true
		
		// add the button spinner
		spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
		spinner.startAnimating()
		spinner.alpha = 0.0
		loginButton.addSubview(spinner)
		
		//add the status banner
		status.isHidden = true
		status.center = loginButton.center
		view.addSubview(status)
		
		//add the status label
		label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
		label.font = UIFont(name: "HelveticaNeue", size: 18.0)
		label.textColor = UIColor(red: 228.0/255.0, green: 98.0/255.0, blue: 0.0, alpha: 1.0)
		label.textAlignment = .center
		status.addSubview(label)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: true)
		
		heading.center.x -= view.bounds.width
		username.center.x -= view.bounds.width
		password.center.x -= view.bounds.width
		
		loginButton.center.y += 30.0
		loginButton.alpha = 0.0
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		
		UIView.animate(withDuration: 0.5, delay: 0, options:.curveEaseOut, animations: {
			self.heading.center.x += self.view.bounds.width
		}, completion: nil);
		
		UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: { 
			self.username.center.x += self.view.bounds.width
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
			self.password.center.x += self.view.bounds.width
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { 
			
			self.loginButton.center.y -= 30.0
			self.loginButton.alpha = 1.0
			
		}, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func logAction() {
		
		let b = self.loginButton.bounds
		
		UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: { 
			
			self.loginButton.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 80, height: b.size.height)
			
		}, completion: { _ in
			
		})
		
		UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseOut, animations: { 
			self.loginButton.center.y += 60
			self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
			self.spinner.alpha = 1.0
			self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.height / 2)
			
		}, completion: nil)
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}