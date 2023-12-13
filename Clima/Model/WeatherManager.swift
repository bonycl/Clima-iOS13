//
//  WeatherManager.swift
//  Clima
//
//  Created by D i on 05.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
   private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=62847c8c821f5e0b937333fd49880838&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
        // print(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Create a URl
        if let url = URL(string: urlString) {
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give URLSession a Task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                       
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        //добавив self мы добавляем не обьект, а его тип
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, minTemperature: minTemp, maxTemperature: maxTemp, humidity: Int(humidity), windy: windSpeed)
            
            
            
            print("condition -> \(weather.conditionName)")
            print("tempString -> \(weather.temperatureString)")
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}

