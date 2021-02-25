//
//  DetailListView.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import UIKit

final class DetailView: UIView {
    private let dayNightBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let temperatreLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.boldSystemFont(ofSize: Appearance.temperatureFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIco: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pressureLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = ApplicationColors.detailTextColor
        label.font = UIFont.systemFont(ofSize: Appearance.conditionFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) weak var tableView: UITableView?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: WeatherDetail) {
        temperatreLabel.text = "\(weather.temperature > 0 ? "+" : "")\(weather.temperature)°"
        conditionLabel.text = weather.condition.rawValue.localized().capitalizedFirstLetter
        feelsLikeLabel.text = String(format: "feelsLikeString".localized(), weather.temperatureFeelsLike)
        dayNightBackgroundView.backgroundColor = weather.isDayTime ?
            ApplicationColors.dayBackgroundColor :
            ApplicationColors.nightBackgroundColor
        weatherIco.fetchWeatherIconLayer(from: weather.weartherIconUrl)
        pressureLabel.text = String(format: "pressureString".localized(), weather.presureMm)
        humidityLabel.text = String(format: "humidityString".localized(), weather.humidity)
        windSpeedLabel.text = String(format: "windSpeedString".localized(), weather.windSpeed, (weather.windDir ?? ""))
    }
}

// MARK: - Configure UI
private extension DetailView {
    func configureView() {
        backgroundColor = .white
        
        self.addDayNightBackgroundView()
        self.addWeatherIcon()
        self.addTemperatureLabel()
        self.addConditionLabel()
        self.addFeelsLikeLabel()
        self.addPressureLabel()
        self.addHumidityLabel()
        self.addWindSpeedLabel()
        self.addTableView()
    }
    
    func addTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: dayNightBackgroundView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.tableView = tableView
    }
    
    func addDayNightBackgroundView() {
        addSubview(dayNightBackgroundView)
        
        dayNightBackgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        dayNightBackgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dayNightBackgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dayNightBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func addWeatherIcon() {
        dayNightBackgroundView.addSubview(weatherIco)
        
        let weatherIcoOffset = (Appearance.weatherIcoSize / 2) - Appearance.defaultInset
        weatherIco.widthAnchor.constraint(equalToConstant: Appearance.weatherIcoSize).isActive = true
        weatherIco.heightAnchor.constraint(equalToConstant: Appearance.weatherIcoSize).isActive = true
        
        NSLayoutConstraint(item: weatherIco, attribute: .centerX, relatedBy: .equal,
                           toItem: dayNightBackgroundView, attribute: .centerX, multiplier: 1,
                           constant: weatherIcoOffset).isActive = true
        NSLayoutConstraint(item: weatherIco, attribute: .centerY, relatedBy: .equal,
                           toItem: dayNightBackgroundView, attribute: .centerY, multiplier: 1,
                           constant: -weatherIcoOffset).isActive = true
    }
    
    func addTemperatureLabel() {
        dayNightBackgroundView.addSubview(temperatreLabel)
        
        temperatreLabel.trailingAnchor.constraint(equalTo: weatherIco.leadingAnchor,
                                                  constant: -Appearance.defaultInset).isActive = true
        NSLayoutConstraint(item: temperatreLabel, attribute: .centerY, relatedBy: .equal,
                           toItem: weatherIco, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func addConditionLabel() {
        dayNightBackgroundView.addSubview(conditionLabel)
        
        conditionLabel.topAnchor.constraint(equalTo: weatherIco.bottomAnchor,
                                            constant: Appearance.defaultInset).isActive = true
        NSLayoutConstraint(item: conditionLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
    
    func addFeelsLikeLabel() {
        dayNightBackgroundView.addSubview(feelsLikeLabel)
        
        feelsLikeLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor,
                                            constant: Appearance.detailTextInset).isActive = true
        NSLayoutConstraint(item: feelsLikeLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
    
    func addPressureLabel() {
        dayNightBackgroundView.addSubview(pressureLabel)
        
        pressureLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor,
                                            constant: Appearance.detailTextInset).isActive = true
        NSLayoutConstraint(item: pressureLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
    
    func addHumidityLabel() {
        dayNightBackgroundView.addSubview(humidityLabel)
        
        humidityLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor,
                                            constant: Appearance.detailTextInset).isActive = true
        NSLayoutConstraint(item: humidityLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
    
    func addWindSpeedLabel() {
        dayNightBackgroundView.addSubview(windSpeedLabel)
        
        windSpeedLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor,
                                            constant: Appearance.detailTextInset).isActive = true
        NSLayoutConstraint(item: windSpeedLabel, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX,
                           multiplier: 1, constant: 0).isActive = true
    }
}

// MARK: - Constants
private extension DetailView {
    struct Appearance {
        static let defaultInset: CGFloat = 10
        static let detailTextInset: CGFloat = 5
        static let weatherIcoSize: CGFloat = 80
        static let temperatureFontSize: CGFloat = 50
        static let conditionFontSize: CGFloat = 13
    }
}
