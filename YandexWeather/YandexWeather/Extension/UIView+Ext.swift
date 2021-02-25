//
//  UIView+Ext.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import UIKit
import SwiftSVG

extension UIView {
    func fetchWeatherIconLayer(from url: URL?) {
        DispatchQueue.global(qos: .utility).async {
            guard let weatherUrl = url else { return }
            
            DispatchQueue.main.async {
                let _ = UIView(SVGURL: weatherUrl) { svgLayer in
                    svgLayer.resizeToFit(self.bounds)
                    self.layer.addSublayer(svgLayer)
                }
            }
        }
    }
}
