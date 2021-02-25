//
//  CityListViewModel.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

protocol CityListViewModelProtocol {
    var cityList: BehaviorRelay<[City]> { get }
    
    func didViewReady()
    func willSearchWith(_ query: String?)
    
    func fetchCity(by indexPath: IndexPath) -> City?
    func fetchWeather(by indexPath: IndexPath, completion: @escaping ((Weather?, Error?) -> Void))
    
    func didOpenForecast(by indexPath: IndexPath)
}

final class CityListViewModel: CityListViewModelProtocol {
    // MARK: Private properties
    private let router: CityListRouterProtocol
    private let model: CityListModelProtocol
    private let service: WeatherServiceProtocol
    private var cityListModel: [City] = []
    private var weatherList: [Weather] = []
    
    var cityList = BehaviorRelay<[City]>(value: [])
        
    init(_ model: CityListModelProtocol, router: CityListRouterProtocol, service: WeatherServiceProtocol) {
        self.router = router
        self.model = model
        self.service = service
    }
    
    func didViewReady() {
        model.loadData { [weak self] cityList in
            self?.cityListModel = cityList
            self?.cityList.accept(cityList)
        }
    }
    
    func willSearchWith(_ query: String?) {
        guard let query = query, !query.isEmpty else {
            self.cityList.accept(self.cityListModel)
            return
        }

        let filteredCity = self.cityListModel.filter({ $0.name.contains(query) })
        self.cityList.accept(filteredCity)
    }
    
    func fetchCity(by indexPath: IndexPath) -> City? {
        guard cityList.value.count >= indexPath.row else { return nil }
        return cityList.value[indexPath.row]
    }
    
    func fetchWeather(by indexPath: IndexPath, completion: @escaping ((Weather?, Error?) -> Void)) {
        guard let city = fetchCity(by: indexPath) else {
            completion(nil, nil)
            return
        }

        service.fetchWeather(in: city, completion: completion)
    }
    
    func didOpenForecast(by indexPath: IndexPath) {
        guard cityList.value.count >= indexPath.row else { return }
        let city = cityList.value[indexPath.row]
        router.didOpenForecast(for: city)
    }
}
