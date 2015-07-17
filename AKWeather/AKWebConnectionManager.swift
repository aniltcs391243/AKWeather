//
//  AKWebConnectionManager.swift
//  AKWeather
//
//  Created by Anil Kothari on 14/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit

class AKWebConnectionManager: NSObject  , NSURLSessionTaskDelegate {
    
    let latitude : Double?      // Latitude of current location
    let longitude : Double?     // Longitude of current location
    let apiKey : String?        // API Key for the application
    
    
    // Initialization of the object
    init (latitude : Double , longitude : Double, apiKey :String){
        self.latitude = latitude
        self.longitude = longitude
        self.apiKey = apiKey
    }
    
    // To retrieve the data from weather webservice
    func retrieveDataFromService(handler:(response:NSDictionary? , error:NSError?, success:Bool) -> ()) {
        
        //Create URL
        
        let baseURLString : String = "https://api.forecast.io/forecast/\(apiKey!)/"
        let forecastURL = NSURL(string: "\(baseURLString)\(latitude!),\(longitude!)", relativeToURL:nil)!
        
        println(baseURLString)

        println(forecastURL)
        
        
        var request = NSMutableURLRequest(URL: forecastURL)
        var session = NSURLSession.sharedSession()
        
        var err: NSError?
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
                let error =  NSError(domain: "Parsing issue", code: 101, userInfo: [:])
                
                handler (response: nil, error:error, success:false)
            }
            else {
                 // check and make sure that json has a value using optional binding.
                if let parseJsonValue = json {
                    
                     handler (response: parseJsonValue, error:nil, success:true)
                }
                else {
                    
                    let error =  NSError(domain: "Parsing issue", code: 101, userInfo: [:])
                    
                    handler (response: nil, error:error, success:false)
                }
            }
        })
        
        task.resume()
 
     }
    
}




