//
//  AKWeatherModal.swift
//  AKWeather
//
//  Created by Anil Kothari on 15/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit

class AKWeatherModal: NSObject {
   
    var date : String?
    var dateOnly : String?

    var time : Double?
    var summary : String?
    var icon : String?
    var temperature : Double?
    var apparentTemperature : Double?
    var humidity : Double?
    var windSpeed : Double?
    var image : UIImage?
    
    var timeOnly : String?

    
    // used for daily and weekly temperatures
    var tempMin : Double?
    var tempMax : Double?
    
    override init() {
        
    }
 
}
