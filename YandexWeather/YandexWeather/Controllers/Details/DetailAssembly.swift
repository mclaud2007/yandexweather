//
//  DetailAssembly.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import Foundation
import UIKit

final class DetailAssembly {
    static func assembly(with city: City) -> UIViewController {
        let service = WeatherService()
        let router = DetailRouter()
        let viewModel = DetailViewModel(with: city, router: router, service: service)
        let viewController = DetailViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
