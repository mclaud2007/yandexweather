//
//  DetailViewController.swift
//  YandexWeather
//
//  Created by Григорий Мартюшин on 24.02.2021.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    private let bag = DisposeBag()
    private let reuseIdentifier = "detailTableViewCell"
    private let viewModel: DetailViewModelProtocol
    private var detailView: DetailView? {
        return self.view as? DetailView
    }
    
    // MARK: - Init
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getTitle()
        self.configureViewModel()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didViewReady()
    }
    
    override func loadView() {
        self.view = DetailView()
    }
}

// MARK: - Configure UI
private extension DetailViewController {
    func configureViewModel() {
        viewModel
            .weather
            .subscribe(onNext: { [weak self] info in
                guard let info = info else { return }
                self?.detailView?.configure(with: info)
                self?.detailView?.tableView?.reloadData()
        }).disposed(by: bag)
    }
    
    func configureTableView() {
        detailView?.tableView?.register(ForecastTableViewCell.self,
                                        forCellReuseIdentifier: reuseIdentifier)
        
        detailView?.tableView?.delegate = self
        detailView?.tableView?.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                       for: indexPath) as? ForecastTableViewCell else {
            preconditionFailure()
        }
        
        if let item = viewModel.getForecast(by: indexPath) {
            cell.configure(with: item)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }
}
