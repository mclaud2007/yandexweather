//
//  AppManager.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import Foundation
import UIKit

final class AppManager {
    static let shared = AppManager()
    private var window: UIWindow?
    
    func start(with window: UIWindow?) {
        self.window = window
        window?.rootViewController = CityListAssembly.assembly()
        window?.makeKeyAndVisible()
    }
}
