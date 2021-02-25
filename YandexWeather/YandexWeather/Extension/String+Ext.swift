//
//  String+EXt.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

extension String {
    var capitalizedFirstLetter: String {
        self.prefix(1).uppercased() + self.dropFirst()
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "\(self)Message")
    }
}
