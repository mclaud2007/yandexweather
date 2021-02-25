//
//  WeatherService.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import Foundation
import Alamofire

protocol WeatherServiceProtocol {
    func fetchWeather(in city: City, completion: @escaping ((Weather?, Error?) -> Void))
    func fetchDetailWeather(in city: City, completion: @escaping ((WeatherDetail?, Error?) -> Void))
}

final class WeatherService: WeatherServiceProtocol {
    static let baseIcoUrlString = "https://yastatic.net/weather/i/icons/blueye/color/svg/%@.svg"
    private let baseUrl = "https://api.weather.yandex.ru/v2/forecast"
    private let queue = DispatchQueue.global(qos: .utility)
    private let token = "3dc08ca0-74f0-4cb4-aa2c-b27e4d1c93f4"
    private lazy var session: Session = {
        let session = Session()
        session.sessionConfiguration.httpShouldSetCookies = false
        session.sessionConfiguration.httpAdditionalHeaders = ["X-Yandex-API-Key": self.token]
        return session
    }()
    
    private func makeRequest<T: Codable>(ofType: T.Type, lat: Double, long: Double,
                                         hours: Bool = false, extra: Bool = false,
                                         completion: @escaping ((T?, Error?) -> Void)) {
        
        let params: Parameters = ["lat": lat, "lon": long, "hours": hours, "extra": extra, "limit": 1]
        let headers: HTTPHeaders = ["X-Yandex-API-Key": self.token]
        
        AF.request(self.baseUrl, parameters: params, headers: headers).responseDecodable(of: T.self, queue: queue) { response in
            switch response.result {
            case let .success(result):
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            case let .failure(err):
                DispatchQueue.main.async {
                    completion(nil, err)
                }
            }
        }
    }
    
    func fetchWeather(in city: City, completion: @escaping ((Weather?, Error?) -> Void)) {
        makeRequest(ofType: WeatherResponse.self, lat: city.lat, long: city.long) { (result, error) in
            guard let result = result else {
                completion(nil, error)
                return
            }
            
            let weather = Weather(cityID: city.cityID,
                                  hourTs: result.fact.hourTs,
                                  temperature: result.fact.temp,
                                  weatherIcon: result.fact.icon,
                                  condition: result.fact.condition)
            completion(weather, error)
        }
    }
    
    func fetchDetailWeather(in city: City, completion: @escaping ((WeatherDetail?, Error?) -> Void)) {
        makeRequest(ofType: WeatherDetailResponse.self,
                    lat: city.lat, long: city.long,
                    hours: true, extra: true) { (result, error) in
            
            guard let result = result else {
                completion(nil, error)
                return
            }
            
            let forecast = result.forecasts.first?.hours.map {
                Weather(cityID: city.cityID,
                        hourTs: $0.hourTs,
                        temperature: $0.temp,
                        weatherIcon: $0.icon,
                        condition: $0.condition)
            }
            
            let weatherDetailResult = WeatherDetail(cityID: city.cityID,
                                                    temperature: result.fact.temp,
                                                    temperatureFeelsLike: result.fact.feelsLike,
                                                    weatherIcon: result.fact.icon,
                                                    condition: result.fact.condition,
                                                    windSpeed: result.fact.windSpeed,
                                                    windDir: result.fact.windDir,
                                                    presureMm: result.fact.pressureMm,
                                                    humidity: result.fact.humidity,
                                                    forecast: forecast ?? [],
                                                    isDayTime: result.fact.isDay)
            completion(weatherDetailResult, error)
        }
    }
}
