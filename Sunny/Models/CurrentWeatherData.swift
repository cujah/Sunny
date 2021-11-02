//
//  CurrentWeatherData.swift
//  Sunny
//
//  Created by Илья on 30.10.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey{                 // стандартный enum для изменения имени ключа
        case temp
        case feelsLike = "feels_like"                   // меняем название ключа
    }
}

struct Weather: Codable {
    let id: Int
}
