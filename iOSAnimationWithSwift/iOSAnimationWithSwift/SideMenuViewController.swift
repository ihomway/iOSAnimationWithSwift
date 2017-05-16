//
//  SideMenuViewController.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
	
	var centerViewController: CenterViewController!
	let imageTag = 6
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
		return MenuItem.sharedItems.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
		
		let menuItem = MenuItem.sharedItems[indexPath.row]
		cell.contentView.backgroundColor = menuItem.color
		
		(cell.viewWithTag(imageTag) as! UIImageView).image = menuItem.sideMenuImage
		
		return cell
	}
	
	//	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView  {
	//		return tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell")!
	//	}
	
	// MARK: UITableViewDelegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		centerViewController.menuItem = MenuItem.sharedItems[indexPath.row]
		
		let containerVC = parent as! SixthDemoViewController
		containerVC.toggleSideMenu()
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 84
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 64
	}
}
