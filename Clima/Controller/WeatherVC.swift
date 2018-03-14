//
//  ViewController.swift
//  climaTest
//
//  Created by Ahmed Amr on 2/9/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import SwiftyJSON
import Alamofire


class WeatherVC: UIViewController , CLLocationManagerDelegate , ChangeCityDelegate {
    
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "0b2bbdc4cb662a5d48d4b4b37da6f08d"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var popup: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyLocation()
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func MyLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            popup.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations[ locations.count - 1 ]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = String ( location.coordinate.latitude )
            let longitude = String ( location.coordinate.longitude )
            let params : [ String : String ] = ["lat" : latitude , "lon" : longitude , "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL , parameters: params)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
        cityLabel.text = "Location Unavailable"
    }
    
    func getWeatherData ( url : String , parameters : [String:String] ) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON =  JSON( response.result.value! )
                self.updateWeatherData(weatherData: weatherJSON)
                
            } else {
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    func updateWeatherData ( weatherData : JSON ) {
        if  let temperature = weatherData["main"]["temp"].double{
        weatherDataModel.temperature  = Int ( temperature - 273.15 )
        weatherDataModel.city = weatherData["name"].stringValue
            if weatherDataModel.city == "testing" {
                weatherDataModel.city = "Cairo"
            }
        weatherDataModel.country = weatherData["sys"]["country"].stringValue
        weatherDataModel.condition = weatherData["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
         updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData () {
        cityLabel.text = weatherDataModel.city + ", " + weatherDataModel.country
      
        temperatureLabel.text = String(weatherDataModel.temperature) + "°"

        conditionImage.image = UIImage( named : weatherDataModel.weatherIconName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeWeatherView" {
            let destinationVC = segue.destination as! ChangeWeatherVC
            destinationVC.delegate = self
        }
    }
    
    @IBAction func switchButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToChangeWeatherView", sender: self)
   
    }
    
    
    func userEnteredCityANewName(city: String) {
        let params  : [ String : String ] = [ "q" : city , "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL , parameters: params)
    }
   
    @IBAction func refreshToMyLocationButtonPressed(_ sender: UIButton) {
       MyLocation()
       updateUIWithWeatherData ()
    }
    
}








