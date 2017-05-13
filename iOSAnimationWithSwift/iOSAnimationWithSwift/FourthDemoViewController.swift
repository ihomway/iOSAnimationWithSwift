//
//  FourthDemoViewController.swift
//  iOSAnimationWithSwift
//
//  Created by Homway on 13/05/2017.
//  Copyright © 2017 ihomway. All rights reserved.
//

import UIKit

let kRefreshViewHeight:CGFloat = 110.0

let packItems = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

class FourthDemoViewController: UITableViewController, RefreshViewDelegate, UINavigationControllerDelegate {

	var refreshView: RefreshView!
	let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
	let transition = TransitionController()
	var isInteractive = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Vacation pack list"
		self.view.backgroundColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
		self.tableView.rowHeight = 54.0
		
		let refreshRect = CGRect(x: 0.0, y: -kRefreshViewHeight, width: 375.0, height: kRefreshViewHeight)
		refreshView = RefreshView(frame: refreshRect, scrollView: self.tableView)
		refreshView.delegate = self
		view.addSubview(refreshView)
		
		maskLayer.position = CGPoint(x: view.layer.bounds.width / 2.0, y: view.layer.bounds.height / 2.0)
		view.layer.mask = maskLayer
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		view.layer.mask = nil
		navigationController?.delegate = self
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(FourthDemoViewController.didPan(recognizer:)))
		view.addGestureRecognizer(pan)
	}
	
	func didPan(recognizer: UIPanGestureRecognizer) {
		if transition.animating {
			return
		}
		
		if recognizer.state == .began {
			isInteractive = true
			navigationController?.popViewController(animated: true)
		} else {
			isInteractive = false
		}
		
		transition.handlePan(recognizer: recognizer)
	}

	// MARK: Refresh view delegate
	
	func refreshViewDidRefresh(refreshView: RefreshView) {
		delay(seconds: 4) {
			refreshView.endRefreshing()
		}
	}
	
	// MARK: Scroll view methods
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		refreshView.scrollViewDidScroll(scrollView)
	}
	
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
	}
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.accessoryType = .none
		cell.textLabel?.text = packItems[indexPath.row]
		cell.imageView?.image = UIImage(named: "summericons_100px_0\(indexPath.row).png")
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		if operation == .pop {
			transition.operation = operation
			
			return transition
		} else {
			return nil
		}
		
	}
	
	func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
		return (isInteractive && transition.animating == false) ? transition : nil
	}
}
