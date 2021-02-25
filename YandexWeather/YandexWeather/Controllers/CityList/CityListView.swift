//
//  CityListView.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit

final class CityListView: UIView {
    weak var tableView: UITableView?
    var searchController = UISearchController()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI
private extension CityListView {
    func configureView() {
        backgroundColor = .white

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City search".localized()
        
        self.tableView = tableView
    }
}
