//
//  WeatherModel.swift
//  Clima
//
//  Created by D i on 05.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let humidity: Int
    let windy: Double
   
    //computed property
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var minTemperatureString: String {
        return String(format: "%.1f", minTemperature)
    }
    var maxTemperatureString: String {
        return String(format: "%.1f", maxTemperature)
    }
    var windyString: String {
        return String(format: "%.1f", windy)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
