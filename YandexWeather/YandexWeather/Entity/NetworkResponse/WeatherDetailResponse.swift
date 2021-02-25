//
//  WeatherDetailResponse.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import Foundation

// MARK: - WeatherDetailResponse
class WeatherDetailResponse: Codable {
    let fact: WeatherFact
    let forecasts: [Forecast]

    init(fact: WeatherFact, forecasts: [Forecast]) {
        self.fact = fact
        self.forecasts = forecasts
    }
}

// MARK: - Forecast
class Forecast: Codable {
    let date: String
    let hours: [WeatherFact]

    init(date: String, hours: [WeatherFact]) {
        self.date = date
        self.hours = hours
    }
}
