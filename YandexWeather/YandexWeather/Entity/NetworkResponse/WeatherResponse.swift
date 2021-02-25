//
//  WeatherResponse.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import Foundation

// MARK: - WeatherResponse
class WeatherResponse: Codable {
    let fact: WeatherFact

    init(fact: WeatherFact) {
        self.fact = fact
    }
}

// MARK: - Fact
class WeatherFact: Codable {
    let temp, feelsLike: Int
    let icon, conditionString: String
    let windSpeed: Double
    let windDir: String
    let pressureMm, humidity: Int
    let hourTs: Int?
    let daytime: String?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case icon
        case conditionString = "condition"
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case humidity
        case hourTs = "hour_ts"
        case daytime
    }
    
    var condition: Condition {
        let conditionDecoder: [String: Condition] = ["clear": .clear, "partly-cloudy": .partlyCloudy,
                                                     "cloudy": .cloudy, "overcast": .overcast,
                                                     "drizzle": .drizzle, "light-rain": .lightRain,
                                                     "rain": .rain, "moderate-rain": .moderateRain,
                                                     "heavy-rain": .heavyRain, "continuous-heavy-rain": .continuousHeavyRain,
                                                     "showers": .showers, "wet-snow": .wetSnow,
                                                     "light-snow": .lightSnow, "snow": .snow,
                                                     "snow-showers": .snowShowers, "hail": .hail,
                                                     "thunderstorm": .thunderstorm, "thunderstorm-with-rain": .thunderstormWithRain,
                                                     "thunderstorm-with-hail": .thunderstormWithHail]
        return conditionDecoder[self.conditionString] ?? .unknown
    }
    
    var isDay: Bool { daytime == "d" }

    init(temp: Int,
         feelsLike: Int,
         icon: String,
         condition: String,
         windSpeed: Double,
         windDir: String,
         pressureMm: Int,
         humidity: Int,
         hourTs: Int?,
         daytime: String?) {
        
        self.temp = temp
        self.feelsLike = feelsLike
        self.icon = icon
        self.conditionString = condition
        self.windSpeed = windSpeed
        self.windDir = windDir
        self.pressureMm = pressureMm
        self.humidity = humidity
        self.hourTs = hourTs
        self.daytime = daytime
    }
}
