//
//  DetailRouter.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import UIKit

protocol DetailRouterProtocol {
    var viewController: UIViewController? { get set }
    
    func goBack(with text: String)
}

class DetailRouter: DetailRouterProtocol {
    var viewController: UIViewController?
    
    func goBack(with text: String) {
        let actionController = UIAlertController(title: NSLocalizedString("Error", comment: "errorMessage"), message: text, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewController?.navigationController?.popViewController(animated: true)
        }
        
        actionController.addAction(actionButton)
        viewController?.present(actionController, animated: true)
    }
}
