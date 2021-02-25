//
//  CityListTableViewCell.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

class CityListTableViewCell: UITableViewCell {
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Appearance.tempFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let icoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let icoErrorView: UIImageView = {
        let errorImageView = UIImageView(image: UIImage(systemName: "xmark.octagon"))
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.tintColor = ApplicationColors.errorColor
        return errorImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.cityNameLabel.text = nil
        self.tempLabel.text = nil
        self.conditionLabel.text = nil
        self.conditionLabel.textColor = ApplicationColors.mainTextColor
        
        icoView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        icoView.isHidden = false
        icoErrorView.isHidden = true
    }
}

extension CityListTableViewCell {
    func configure(with city: City) {
        cityNameLabel.text = city.name
        tempLabel.text = "-°C"
        conditionLabel.text = "-/-"
        icoView.isHidden = false
        icoErrorView.isHidden = true
    }
    
    func configure(with weather: Weather) {
        tempLabel.text = "\(weather.temperature > 0 ? "+" : "")\(weather.temperature)°C"
        conditionLabel.text = weather.condition.rawValue.localized().capitalizedFirstLetter
        icoView.fetchWeatherIconLayer(from: weather.weartherIconUrl)
    }
    
    func configureWithError() {
        conditionLabel.text = "Error loading forecast".localized()
        conditionLabel.textColor = ApplicationColors.errorColor
        icoView.isHidden = true
        icoErrorView.isHidden = false
    }
}

// MARK: - Configure UI
private extension CityListTableViewCell {
    func configureView() {
        self.addCityName()
        self.addTempLabel()
        self.addConditionLabel()
        self.addIconView()
    }
    
    func addConditionLabel() {
        contentView.addSubview(conditionLabel)
        
        conditionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor,
                                            constant: Appearance.defaultInset).isActive = true
        conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Appearance.defaultInset).isActive = true
        conditionLabel.trailingAnchor.constraint(lessThanOrEqualTo: tempLabel.leadingAnchor,
                                                 constant: Appearance.defaultInset).isActive = true
        conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -Appearance.defaultInset).isActive = true
    }
    
    func addIconView() {
        contentView.addSubview(icoView)
        contentView.addSubview(icoErrorView)
        
        icoView.widthAnchor.constraint(equalToConstant: Appearance.icoDefaultSize).isActive = true
        icoView.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor,
                                         constant: Appearance.defaultInset).isActive = true
        icoView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: Appearance.defaultInset).isActive = true
        icoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                        constant: -Appearance.defaultInset).isActive = true
        icoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                          constant: -Appearance.iconTrailingInset).isActive = true
        
        icoErrorView.isHidden = true
        icoErrorView.widthAnchor.constraint(equalToConstant: Appearance.icoDefaultSize).isActive = true
        icoErrorView.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor,
                                         constant: Appearance.defaultInset).isActive = true
        icoErrorView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: Appearance.defaultInset).isActive = true
        icoErrorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -Appearance.defaultInset).isActive = true
        icoErrorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -Appearance.iconTrailingInset).isActive = true
    }
    
    func addCityName() {
        contentView.addSubview(cityNameLabel)
        cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: Appearance.defaultInset).isActive = true
        cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Appearance.defaultInset).isActive = true
    }
    
    func addTempLabel() {
        contentView.addSubview(tempLabel)
        
        tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: Appearance.defaultInset).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor,
                                           constant: Appearance.defaultInset).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -Appearance.defaultInset).isActive = true
    }
}

// MARK: - Constants
private extension CityListTableViewCell {
    struct Appearance {
        static let defaultInset: CGFloat = 10
        static let iconTrailingInset: CGFloat = 20
        static let tempFontSize: CGFloat = 17
        static let conditionFontSize: CGFloat = 14
        static let icoDefaultSize: CGFloat = 44
    }
}

