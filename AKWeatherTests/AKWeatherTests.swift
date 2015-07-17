//
//  AKWeatherTests.swift
//  AKWeatherTests
//
//  Created by Anil Kothari on 14/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit
import XCTest
import Foundation


class AKWeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
 
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    
    
    func testWebserviceconnection(){
        let apiKey = "efde7961b1a007a10122dc4e01a5eee6"

        var forecastData = AKWebConnectionManager(latitude: 28.30,longitude: 78.30,apiKey: apiKey)
        

        forecastData.retrieveDataFromService { (response, error, success) -> () in
            
            if success {
                // Return the response
                if let responseValue = response
                {
                  XCTAssertTrue(true, "connection established")
                    
                   // var forecastData = AKWeather()
                }
                else
                {
                    XCTAssertFalse(false, "Error in Parsing")
                }
            } else {
                // Return the error response
                XCTAssertFalse(false, "connection error")
            }
        }
   
    }
    
    
    func testDateFormatterPerformance() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        
        let date = NSDate()
        
        measureBlock() {
            let string = dateFormatter.stringFromDate(date)
        }
    }
    
    
    func testTime(){
        
        let time : NSTimeInterval = 145236200
        var newDate = NSDate(timeIntervalSince1970: time)
        var dateFormat = NSDateFormatter()
        
        dateFormat.dateFormat = "dd MMM yyyy EEEE"
        var date1 = dateFormat.stringFromDate(newDate)
        
        
        dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy"
        
        // Setting only time
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        let string = formatter.stringFromDate(newDate)
     
    }
    
}
