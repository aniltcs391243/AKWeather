//
//  AKWeatherParser.swift
//  AKWeather
//
//  Created by Anil Kothari on 14/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit


protocol weatherDelegate {
    
    //Hourly forecast of the week
    func returnHourlyForecast(model : AKWeatherDailyModal?)
    
    //Daily forecast of the week
    func returnDailyForecast(model : AKWeatherDailyModal?)
    
    //Current forecast
    func returnCurrentForecast(model : AKWeatherModal?)
    
    //Error returned if not able to parse
    func returnErrorMessage(error : NSError?)
    
}

class AKWeather: NSObject {
    
    let apikey : String?
    let latitude : Double?
    let longitude : Double?

    
    var delegate: weatherDelegate?
    
    // get currentForecast Model object
    var currentForecast : AKWeatherModal?
    
    // get Array of hourly Model object
    var hourlyForecastData : AKWeatherDailyModal?

    // get Array of daily Model object
    var dailyForecastData : AKWeatherDailyModal?

    init(apikey : String, latitude : Double , longitude : Double){
        self.apikey = apikey
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
    
    
    func getForeCastData() {
        
        var forecastData = AKWebConnectionManager(latitude:self.latitude!,longitude:self.longitude!,apiKey:apikey!)
        
        forecastData.retrieveDataFromService { (response, error, success) -> () in
      
            if success {
                // Return the response
                if let responseValue = response {
                    
                    self.parseWeatherData(responseValue)
                    self.delegate?.returnCurrentForecast(self.currentForecast)
                    self.delegate?.returnDailyForecast(self.dailyForecastData)
                    self.delegate?.returnHourlyForecast(self.hourlyForecastData)

                }else{
                    
                    let error =  NSError(domain: "Response not found", code: 101, userInfo: [:])
                    self.delegate?.returnErrorMessage(error)
                }
                
            } else {
                // Return the error response
                
                self.delegate?.returnErrorMessage(error)

            }
        }
     }
    
    
    
    
    func parseWeatherData(dictResponse: NSDictionary) {
        //Parse current data 
        
        if let currentWeather = dictResponse["currently"] as? NSDictionary {
            currentForecast = parseCurrentWeather(currentWeather)
        }
        
        hourlyForecastData = parseFrequentWeatherChanges(dictResponse:dictResponse, value: "hourly")
        dailyForecastData = parseFrequentWeatherChanges(dictResponse:dictResponse, value:"daily")
        
    }
    
    
    //For daily and hourly data changes
    func parseFrequentWeatherChanges (#dictResponse: NSDictionary, value: String)-> AKWeatherDailyModal  {
        var weatherArray: [AKWeatherModal] = []
        var summary : String = ""
        var icon : String?
        
        
        if let container = dictResponse[value] as? NSDictionary,
            let dailyWeatherData = container ["data"] as? NSArray{
                
                for weatherModel in dailyWeatherData {
                    if let weatherDict = weatherModel as? NSDictionary{
                        var currentWeather = parseCurrentWeather(weatherDict)
                         weatherArray.append(currentWeather)
                    }
                }
        }
        
        
        if let container = dictResponse[value] as? NSDictionary,
            let weatherSummary = container ["summary"] as? String{
                summary = weatherSummary
        }
        
        if let container = dictResponse[value] as? NSDictionary,
            let weatherIcon = container ["icon"] as? String{
                icon = weatherIcon
        }
        
        var foreCastWithSummary : AKWeatherDailyModal
        
        if let iconValue = icon {
            foreCastWithSummary = AKWeatherDailyModal(summary: summary, icon: icon, weatherObject: weatherArray)
        }else{
            foreCastWithSummary = AKWeatherDailyModal(summary: summary, icon: nil, weatherObject: weatherArray)
            
        }
        
        return foreCastWithSummary

    }
    
    
    func parseCurrentWeather(currentWeather: NSDictionary) -> AKWeatherModal {
        
        // Parse the current weather data
        
            var objCurrentWeatherModel = AKWeatherModal()
            
            if let time = currentWeather["time"] as? Double {
                objCurrentWeatherModel.time = time
                var newDate = NSDate(timeIntervalSince1970: time)
                var dateFormat = NSDateFormatter()
                
                dateFormat.dateFormat = "dd MMM yyyy EEEE"
                var date1 = dateFormat.stringFromDate(newDate)
                
                objCurrentWeatherModel.date = date1
                
                
                dateFormat = NSDateFormatter()
                dateFormat.dateFormat = "dd MMM yyyy"
                objCurrentWeatherModel.dateOnly = dateFormat.stringFromDate(newDate)
                
                
                // Setting only time
                let formatter = NSDateFormatter()
                formatter.dateStyle = .NoStyle
                formatter.timeStyle = .ShortStyle
                
                let string = formatter.stringFromDate(newDate)
                objCurrentWeatherModel.timeOnly = string

                
            }
            
            if let summary = currentWeather["summary"] as? String {
                objCurrentWeatherModel.summary = summary
            }
            
            if let icon = currentWeather["icon"] as? String {
                objCurrentWeatherModel.icon = icon
                objCurrentWeatherModel.image = UIImage(named: icon)
            }
            
            if let temperature = currentWeather["temperature"] as? Double {
                objCurrentWeatherModel.temperature = temperature
            }
        
            if let temperatureMin = currentWeather["temperatureMin"] as? Double {
                objCurrentWeatherModel.tempMin = temperatureMin
            }

        
            if let temperatureMax = currentWeather["temperatureMax"] as? Double {
                objCurrentWeatherModel.tempMax = temperatureMax
            }
        
        
            if let Apparenttemperature = currentWeather["apparentTemperature"] as? Double {
                objCurrentWeatherModel.apparentTemperature = Apparenttemperature
            }
            
            if let humidity = currentWeather["humidity"] as? Double {
                objCurrentWeatherModel.humidity = humidity*100
            }
            
            if let windSpeed = currentWeather["windSpeed"] as? Double {
                objCurrentWeatherModel.windSpeed = windSpeed
            }
            
            return objCurrentWeatherModel
     }
    
    
}





