//
//  ViewController.swift
//  Clima
//
//  Created by D i  on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController  {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var humImage: UIImageView!
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var minTempImage: UIImageView!
    @IBOutlet weak var minTempResult: UILabel!
    
    @IBOutlet weak var maxTempImage: UIImageView!
    @IBOutlet weak var maxTempResult: UILabel!
    @IBOutlet weak var humidityResult: UILabel!
    @IBOutlet weak var windSpeedResult: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
//        locationManager(<#CLLocationManager#>, didUpdateLocations: <#[CLLocation]#>)
//        updateWeather()
        setupAnimatedLabels()
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateWeather), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @objc func updateWeather() {
        if let location = locationManager.location {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lot = location.coordinate.longitude
            
            // Вызываем метод для загрузки погоды по текущему местоположению
            weatherManager.fetchWeather(latitude: lat, longitude: lot)
        }
    }

    func setupAnimatedLabels() {
        humImage.image = UIImage(systemName: "drop.halffull")
        humImage.contentMode = .center
        humImage.tintColor = .label
        humImage.addSymbolEffect(.pulse.byLayer, options: .repeating.speed(0.7))
            
        windImage.image = UIImage(systemName: "wind")
        windImage.contentMode = .center
        windImage.tintColor = .label
        windImage.addSymbolEffect(.pulse.byLayer, options: .repeating.speed(0.7))
        
        minTempImage.image = UIImage(systemName: "thermometer.low")
        minTempImage.contentMode = .scaleAspectFit
        minTempImage.tintColor = .label
        minTempImage.addSymbolEffect(.pulse.byLayer, options: .repeating.speed(0.7))
        
        maxTempImage.image = UIImage(systemName: "thermometer.high")
        maxTempImage.contentMode = .scaleAspectFit
        maxTempImage.tintColor = .label
        maxTempImage.addSymbolEffect(.pulse.byLayer, options: .repeating.speed(0.7))
        
    }
     
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        //   print("search is pressed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("location -> \(searchTextField.text!) ")
        //        print("go is pressed")
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "enter city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            //update data on screen
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.minTempResult.text = weather.minTemperatureString
            self.maxTempResult.text = weather.maxTemperatureString
            self.humidityResult.text = String(weather.humidity)
        } // print(weather.temperature)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lot = location.coordinate.longitude
            
            // Вызываем метод для загрузки погоды по текущему местоположению
            weatherManager.fetchWeather(latitude: lat, longitude: lot)
            
        }
        print("got location")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
