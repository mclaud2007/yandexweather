//
//  CityList.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 25.02.2021.
//

import CoreLocation

protocol CityListModelProtocol {
    func loadData(completion: @escaping (([City]) -> Void))
}

final class CityListModel: CityListModelProtocol {
    /// Mock data
    let cityList = ["Moscow", "St. Petersburg",
                    "Kazan", "Vladivostok",
                    "Pskov", "Perm",
                    "Ekaterinburg", "Anapa",
                    "Sochi", "Barnaul"]
    
    func loadData(completion: @escaping (([City]) -> Void)) {
        var cityListArray: [City] = []
        let geocodeGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: geocodeGroup, qos: .utility) {
            for name in self.cityList {
                geocodeGroup.enter()
                CLGeocoder().geocodeAddressString(name) { (placemark, _) in
                    guard let location = placemark?.first?.location?.coordinate else { return }
                    let city = City(name: name, lat: location.latitude, long: location.longitude)
                    cityListArray.append(city)
                    geocodeGroup.leave()
                }
            }
        }
        
        geocodeGroup.notify(queue: .main) {
            cityListArray.sort(by: { $0.name < $1.name })
            completion(cityListArray)
        }
    }
}
