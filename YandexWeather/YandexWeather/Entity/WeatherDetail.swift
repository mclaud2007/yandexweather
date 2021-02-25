//
//  WeatherDetail.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import UIKit
import SwiftSVG

struct WeatherDetail {
    let cityID: String
    let temperature: Int
    let temperatureFeelsLike: Int
    let weatherIcon: String?
    var weartherIconUrl: URL? {
        guard let weatherIcon = weatherIcon else { return nil }
        return URL(string: String(format: WeatherService.baseIcoUrlString, weatherIcon))
    }
    let condition: Condition
    let windSpeed: Double
    let windDir: String?
    let presureMm: Int
    let humidity: Int
    let forecast: [Weather]
    let isDayTime: Bool
}
