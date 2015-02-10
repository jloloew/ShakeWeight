//
//  ViewController.swift
//  ShakeWeight
//
//  Created by Justin Loew on 1/13/15.
//  Copyright (c) 2015 Lustin' Joew. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
	@IBOutlet weak var reps: UILabel!
	var healthStore: HKHealthStore? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// health data is not available on iPad
		if HKHealthStore.isHealthDataAvailable() {
			healthStore = HKHealthStore()
			// check whether we're authorized to save workout data
			let authStatus = healthStore!.authorizationStatusForType(HKObjectType.workoutType())
			switch authStatus {
			case .SharingAuthorized:
				loadHealthData()
				
			case .SharingDenied:
				// nothing we can do about it
				// we don't have permission, so the HKHealthStore is useless to us
				self.healthStore = nil
				
			case .NotDetermined:
				// prompt the user for permission
				let types = NSSet(object: HKObjectType.workoutType())
				healthStore?.requestAuthorizationToShareTypes(types, readTypes: types, completion: { (success: Bool, error: NSError!) -> Void in
					// success is whether the user answered the prompt, *not* whether permission has been granted.
					if error != nil {
						println(error)
						return // return from the block, not from viewDidLoad
					} else {
						// make sure we're actually authorized now
						if self.healthStore!.authorizationStatusForType(HKObjectType.workoutType()) != .SharingAuthorized {
							// we don't have permission, so the HKHealthStore is useless to us
							self.healthStore = nil
						} else {
							// we're authorized!
							self.loadHealthData()
						}
					}
				})
			}
		}
	}
	
	// Load the data from previous workouts, if any
	func loadHealthData() {
		
	}


}

