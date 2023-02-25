//
//  WeatherData.swift
//  Weather-App
//
//  Created by Catherine Shing on 2/24/23.
//

import Foundation

struct WeatherData: Codable {
    var list: [Weather]
}

struct Weather: Codable {
    let weather: [WeatherContent]

}

struct WeatherContent: Codable {
    let description: String
}

