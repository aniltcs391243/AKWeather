//
//  AKWeatherViewController.swift
//  AKWeather
//
//  Created by Anil Kothari on 14/07/15.
//  Copyright (c) 2015 Anil Kothari. All rights reserved.
//

import UIKit

class AKWeatherViewController: AKWeatherBaseViewController, weatherDelegate   {

    var loadingSecondTime = false
    
    var currentLatitude = 0.00
    var currentLongitude = 0.00
    let apiKey = "efde7961b1a007a10122dc4e01a5eee6"

    //Data models
    var hourlyForecastData : AKWeatherDailyModal?
    var dailyForecastData : AKWeatherDailyModal?
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewActivityIndicatorBase: UIView!
    
    
    //current weather details
    @IBOutlet weak var viewHeaderContainer: UIView!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblApparentTemperature: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var tblWeeklyWeatherUpdate: UITableView!
    
    
    func hideViewForInitialLoad (hide : Bool){
        viewActivityIndicatorBase.hidden = !hide
        viewHeaderContainer.hidden = hide
        tblWeeklyWeatherUpdate.hidden = hide
    }
    
    
    //  MARK: - Reachablility notification

    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() && !loadingSecondTime  {
            self.getWeatherDetails()
        }
    }
    
    
    //  MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:111/255, green: 186/255, blue: 254/255, alpha: 1.0)
        self.tblWeeklyWeatherUpdate.backgroundColor = UIColor(red:111/255, green: 186/255, blue: 254/255, alpha: 1.0)

        // Do any additional setup after loading the view
        viewActivityIndicatorBase.layer.cornerRadius = 13.0;

        self.hideViewForInitialLoad(true)
    }
    
    
   
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
         self.getLocationInfo()
    }

    
    // MARK: - Fetch Weather Details

    
    func getWeatherDetails(){
         // these are default values of lat and long in case failure in finding locaiton
        if (currentLongitude != 0.00 && currentLongitude != 0.00) {
            var weatherObject = AKWeather(apikey: apiKey, latitude: currentLatitude, longitude: currentLongitude)
            weatherObject.delegate = self
            weatherObject.getForeCastData()
        }
    }

    
    // MARK: - Weather Delegates

    
    func returnHourlyForecast(model : AKWeatherDailyModal?){
        println("returnHourlyForecast")
        
        if let hourlyModel = model {
            hourlyForecastData = hourlyModel
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tblWeeklyWeatherUpdate.reloadData()
        }

    }
    
    func returnDailyForecast(model : AKWeatherDailyModal?){
 
        if let dailyModel = model {
            dailyForecastData = dailyModel
            dispatch_async(dispatch_get_main_queue()) {

            self.tblWeeklyWeatherUpdate.reloadData()
            }
        }
         println("returnDailyForecast")
    }
    
    
    func returnCurrentForecast(model : AKWeatherModal?){
        println("returnCurrentForecast")

    dispatch_async(dispatch_get_main_queue()) { // 2
 
            self.hideViewForInitialLoad(false)
            
            if let currentModel = model {
                
                if let apparentTemp = currentModel.apparentTemperature{
                    self.lblApparentTemperature.text="\(apparentTemp)\u{00B0}F"
                }
                
                if let date = currentModel.dateOnly{
                    self.lblDate.text="\(date)"
                }
                
                if let humidity = currentModel.humidity{
                    self.lblHumidity.text="\(humidity) %"
                }
                
                if let summary = currentModel.summary{
                    self.lblSummary.text="\(summary)"
                }
                
                if let temp = currentModel.temperature{
                    self.lblTemperature.text="\(temp)\u{00B0}F"
                }
                
                if let time = currentModel.date{
                    var array = time.componentsSeparatedByString(" ")
                    self.lblTime.text="\(array.last!)"
                }
                
                if let windSpeed = currentModel.windSpeed{
                    self.lblWindSpeed.text="\(windSpeed) Mi/H"
                }
                
            }
        
        }
        loadingSecondTime = true
 
    }
    
     
    func returnErrorMessage(error : NSError?){
        println(error)
        
        if let error = error{
            self.showAlert("Error", subtitle: error.description)
        }
        
        // Take the device cordinates again in case of error
        loadingSecondTime = false

    }
    

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Tableview Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  (dailyForecastData != nil) {
            if (dailyForecastData?.weatherObjects.count > 0){
                if let array = dailyForecastData?.weatherObjects {
                    return array.count;
                }
            }
        }
        return 0;
    }
    
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 75;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 100;
    }
  
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("AKCustomHeaderCell") as! AKCustomHeaderCell
        
        
        if  (hourlyForecastData != nil) {
            if (hourlyForecastData?.weatherObjects.count > 0){
                if let array = hourlyForecastData?.weatherObjects {
                    
                    let width = 100 * array.count
                    
                    let height = Int(headerCell.scrollView.frame.size.height)
                    
                    headerCell.scrollView.contentSize = CGSize(width: width, height: height)
                    headerCell.scrollView.backgroundColor = UIColor(red:111/255, green: 186/255, blue: 254/255, alpha: 1.0);
                    
                    for (index,item) in enumerate(array) {
                        
                        var sampleSubView = UIView()
                        sampleSubView.frame = CGRectMake(CGFloat(index*100), 0.00, 100.00, 100.00)
                        sampleSubView.backgroundColor = UIColor(red:111/255, green: 186/255, blue: 254/255, alpha: 1.0)
                        
                        var sampleTime = UILabel()
                        sampleTime.frame = CGRectMake(0, 15.00, 100.00, 20.00)
                        sampleTime.textAlignment = .Center
                        if let timeOnly = item.timeOnly{
                            sampleTime.text = timeOnly
                        }
                        sampleSubView.addSubview(sampleTime)
                        
                        
                        var imvIcon = UIImageView()
                        imvIcon.frame = CGRectMake( 30 , 30.00, 40.00, 40.00)
                         if let icon = item.image{
                            imvIcon.image = icon
                        }
                        sampleSubView.addSubview(imvIcon)
                        
                        var lblTemperature = UILabel()
                        lblTemperature.frame = CGRectMake(0, 70.00, 100.00, 20.00)
                        lblTemperature.textAlignment = .Center
                        if let timeOnly = item.temperature{
                            lblTemperature.text = "\(timeOnly)\u{00B0}F"
                        }
                        sampleSubView.addSubview(lblTemperature)

                        headerCell.scrollView.addSubview(sampleSubView)
                    }
                 }
            }
        }
        
        return headerCell
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! UITableViewCell

        cell.selectionStyle = .None
        
        var dailyWeatherObject : Array <AKWeatherModal>
        
        if  (dailyForecastData != nil) {
            if (dailyForecastData?.weatherObjects.count > 0){
                if let array = dailyForecastData?.weatherObjects {
                        dailyWeatherObject = array
                    
                    
                    let object : AKWeatherModal = dailyWeatherObject[indexPath.row] as AKWeatherModal
                    
                    var label = cell.contentView.viewWithTag(100) as! UILabel
                    
                    if let date = object.date {
                        label.text = "\(date)"
                    }else{
                        label.text = "Not Available"
                    }
                    
                    label = cell.contentView.viewWithTag(101) as! UILabel
                    
                    if let temp = object.tempMin {
                        label.text = "\(temp)\u{00B0}F"
                    }else{
                        label.text = "N/A"
                    }
                    
                    label = cell.contentView.viewWithTag(102) as! UILabel
                    
                    
                    if let temp = object.tempMax {
                        label.text = "\(temp)\u{00B0}F"
                    }else{
                        label.text = "N/A"
                    }
                    
                    
                    var icon = cell.contentView.viewWithTag(104) as! UIImageView
                    
                    icon.image = object.image
                    
                    return cell
                }
            }
        }
        
        return cell
    }
    
    //  MARK: - Lat Long, of current location received now call the webservices
    
    override  func returnCurrentLocation(lat : Double , long: Double){
        // First time check only
        println("inside return current location")
        
        currentLatitude = lat
        currentLongitude = long
        
        if !loadingSecondTime && self.hasConnectivity() {
            
            println("get weather detials called")
            self.getWeatherDetails()
            
        }
        
    }


    


}
