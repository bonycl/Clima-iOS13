//
//  WeatherData.swift
//  Clima
//
//  Created by D i on 05.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
var tempStatus = ""

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
}
//new level of data = new struct
struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}
struct Weather: Codable {
    let id: Int
}
struct Wind: Codable{
    let speed: Double
}

