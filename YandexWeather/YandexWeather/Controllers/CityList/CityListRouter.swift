//
//  CityListRouter.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

protocol CityListRouterProtocol {
    var viewController: UIViewController? { get set }
    
    func didOpenForecast(for city: City)
}

final class CityListRouter: CityListRouterProtocol {
    weak var viewController: UIViewController?
    
    func didOpenForecast(for city: City) {
        let detailViewController = DetailAssembly.assembly(with: city)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
