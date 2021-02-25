//
//  Weather.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit
import SwiftSVG

struct Weather {
    let cityID: String
    let hourTs: Int?
    let temperature: Int
    let weatherIcon: String?
    var weartherIconUrl: URL? {
        guard let weatherIcon = weatherIcon else { return nil }
        return URL(string: String(format: WeatherService.baseIcoUrlString, weatherIcon))
    }
    
    let condition: Condition
}
