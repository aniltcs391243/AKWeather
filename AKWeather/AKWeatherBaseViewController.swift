//
//  AKWeatherBaseViewController.swift
//  AKWeather
//
//  Created by Anil Kothari on 15/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit
import CoreLocation


class AKWeatherBaseViewController: UIViewController,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    // MARK: - Connectivity

    // To check reachablity if not reachable register for notification
    func hasConnectivity() -> Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        
        if !reachability.isReachable(){
            // register for app to be network reachable

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)

            reachability.startNotifier()

            return false
            
        }else{
            return true
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    
    // MARK: - location services
    
    
    func getLocationInfo(){
        self.initLocationManager()
        
    }
    
    func initLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("didUpdateLocations")
        
        self.returnCurrentLocation(manager.location.coordinate.latitude, long: manager.location.coordinate.longitude)
        
        
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        self.showAlert("Error", subtitle: error.description)
    }
    
 
    
    // To be overridden in the inherited classes
    func returnCurrentLocation(lat : Double , long: Double){
    
        
    }
    
    
    
    
    
    
    // MARK: - Alert ViewController
    
    func showAlert (title : String, subtitle: String) {
        var device : UIDevice = UIDevice.currentDevice()
        var systemVersion = device.systemVersion
        var iosVerion : Float = (systemVersion as NSString).floatValue
        if(iosVerion < 8.0) {
            let alert = UIAlertView()
            alert.title = title
            alert.message = subtitle
            alert.addButtonWithTitle("Ok")
            alert.show()
        }else{
            var alert : UIAlertController = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style:.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

    
    
    
}

