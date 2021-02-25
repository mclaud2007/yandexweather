//
//  CityListAssembly.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

final class CityListAssembly {
    static func assembly() -> UIViewController {
        let model = CityListModel()
        let router = CityListRouter()
        let service = WeatherService()
        let viewModel = CityListViewModel(model, router: router, service: service)
        let viewController = CityListViewController(viewModel: viewModel)
        router.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
