//
//  CityListViewController.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class CityListViewController: UIViewController {
    private var bag = DisposeBag()
    private var viewModel: CityListViewModelProtocol
    private let reuseIdentifier = "cityListViewCell"
    private var cityListView: CityListView? {
        self.view as? CityListView
    }
    
    // MARK: - Init
    init(viewModel: CityListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecicle
    override func loadView() {
        self.view = CityListView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "City list".localized()
        definesPresentationContext = true
        navigationItem.searchController = cityListView?.searchController
        
        self.configureView()
        self.configureTableView()
        self.configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didViewReady()
    }
}

private extension CityListViewController {
    func configureView() {
        cityListView?
            .searchController
            .searchBar.rx.text.orEmpty
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.willSearchWith(query)
            }).disposed(by: bag)
        
        cityListView?
            .searchController
            .searchBar.rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.viewModel.willSearchWith(nil)
            }).disposed(by: bag)
    }
    
    func configureTableView() {
        cityListView?.tableView?.register(CityListTableViewCell.self,
                                         forCellReuseIdentifier: reuseIdentifier)
        
        cityListView?.tableView?.dataSource = self
        cityListView?.tableView?.keyboardDismissMode = .interactive
      
        cityListView?
            .tableView?.rx
            .itemSelected
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didOpenForecast(by: indexPath)
            })
            .disposed(by: bag)
    }
    
    func configureViewModel() {
        guard let tableView = cityListView?.tableView else { return }
        
        viewModel
            .cityList
            .subscribe(onNext: { _ in
                tableView.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDataSource
extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cityList.value.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CityListTableViewCell else {
            preconditionFailure()
        }
        
        guard let item = viewModel.fetchCity(by: indexPath) else { return cell }
        cell.configure(with: item)
        
        viewModel.fetchWeather(by: indexPath) { (info, error) in
            guard let info = info, error == nil else {
                cell.configureWithError()
                return
            }
            
            cell.configure(with: info)
        }
        
        return cell
    }
}
