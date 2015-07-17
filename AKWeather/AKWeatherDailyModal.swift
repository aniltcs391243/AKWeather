//
//  AKWeatherDailyModal.swift
//  AKWeather
//
//  Created by Anil Kothari on 15/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit

class AKWeatherDailyModal: NSObject {
 
    var summary : String?
    var icon : String?
    var weatherObjects : Array <AKWeatherModal>
    
    var image: UIImage?
    
    init( summary: String, icon: String? , weatherObject: Array<AKWeatherModal>) {
        
        self.summary = summary
        
        if let iconValue = icon {
            self.icon = iconValue
            self.image = UIImage(named: iconValue)
        }
        
        self.weatherObjects = weatherObject
    }
    
    
}
