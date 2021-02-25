//
//  DetailListViewModel.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import UIKit
import RxRelay

protocol DetailViewModelProtocol {
    var weather: BehaviorRelay<WeatherDetail?> { get }
    var forecastList: [Weather] { get }
    
    func didViewReady()
    func getForecast(by indexPath: IndexPath) -> Weather?
    
    func getTitle() -> String
    func goBackOnError()
}

final class DetailViewModel: DetailViewModelProtocol {
    private let service: WeatherServiceProtocol
    private let router: DetailRouterProtocol
    private let city: City
    
    var weather: BehaviorRelay<WeatherDetail?> = BehaviorRelay<WeatherDetail?>(value: nil)
    var forecastList: [Weather] = []
    
    init(with city: City, router: DetailRouterProtocol, service: WeatherServiceProtocol) {
        self.service = service
        self.router = router
        self.city = city
    }
    
    func getTitle() -> String {
        return city.name
    }
    
    func didViewReady() {
        self.forecastList = []
        
        service.fetchDetailWeather(in: city) { [weak self] (info, error) in
            guard let info = info, error == nil else {
                self?.goBackOnError()
                return
            }
            
            self?.forecastList = info.forecast
            self?.weather.accept(info)
        }
    }
    
    func getForecast(by indexPath: IndexPath) -> Weather? {
        guard forecastList.count >= indexPath.row else { return nil }
        return forecastList[indexPath.row]
    }
    
    func goBackOnError() {
        router.goBack(with: "Error data loading".localized())
    }
}
