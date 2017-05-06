//
//  SecondDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by HOMWAY on 05/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

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
		changeFlightDataTo(londonToParis)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
