//
//  CityListTableViewCell.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    let dateFormatter = DateFormatter()
    
    let hoursLabel: UILabel = {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.hoursLabel.text = nil
        self.tempLabel.text = nil
        icoView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
    }
}

extension ForecastTableViewCell {
    func configure(with weather: Weather) {
        hoursLabel.text = "-:-"
        
        if let hourTimeStamp = weather.hourTs {
            dateFormatter.dateFormat = "dd.MM HH:mm"
            dateFormatter.locale = Locale.current
            let date = Date(timeIntervalSince1970: TimeInterval(hourTimeStamp))
            hoursLabel.text = dateFormatter.string(from: date)
        }

        tempLabel.text = "\(weather.temperature)°C"
        conditionLabel.text = weather.condition.rawValue.localized().capitalizedFirstLetter
        icoView.fetchWeatherIconLayer(from: weather.weartherIconUrl)
    }
}

// MARK: - Configure UI
private extension ForecastTableViewCell {
    func configureView() {
        self.addCityName()
        self.addTempLabel()
        self.addConditionLabel()
        self.addIconView()
    }
    
    func addConditionLabel() {
        contentView.addSubview(conditionLabel)
        
        conditionLabel.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor,
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
        
        icoView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        icoView.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor,
                                         constant: Appearance.defaultInset).isActive = true
        icoView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: Appearance.defaultInset).isActive = true
        icoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                        constant: -Appearance.defaultInset).isActive = true
        icoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                          constant: -Appearance.iconTrailingInset).isActive = true
    }
    
    func addCityName() {
        contentView.addSubview(hoursLabel)
        hoursLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: Appearance.defaultInset).isActive = true
        hoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Appearance.defaultInset).isActive = true
    }
    
    func addTempLabel() {
        contentView.addSubview(tempLabel)
        
        tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: Appearance.defaultInset).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: hoursLabel.trailingAnchor,
                                           constant: Appearance.defaultInset).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -Appearance.defaultInset).isActive = true
    }
}

// MARK: - Constants
private extension ForecastTableViewCell {
    struct Appearance {
        static let defaultInset: CGFloat = 10
        static let iconTrailingInset: CGFloat = 20
        static let tempFontSize: CGFloat = 17
        static let conditionFontSize: CGFloat = 14
    }
}

