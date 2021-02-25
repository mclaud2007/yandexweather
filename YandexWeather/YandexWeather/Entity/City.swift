//
//  City.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import Foundation

struct City {
    let cityID: String = UUID().uuidString
    let name: String
    let lat: Double
    let long: Double
}
