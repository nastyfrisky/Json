//
//  ViewController.swift
//  json
//
//  Created by Анастасия Ступникова on 06.05.2022.
//

import UIKit
import Alamofire

class TrackListViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let query = "Киркоров"
    private let networkManager = NetworkManager()
    private let trackListTable = UITableView()
    private let showButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var trackList: [TrackData] = []
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTable()
        addSubviews()
        setupButtons()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupButtons() {
        showButton.setTitle("Show results", for: .normal)

        showButton.backgroundColor = .systemBlue
        
        showButton.layer.cornerRadius = 10
        showButton.clipsToBounds = true
        
        showButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    private func setupTable() {
        trackListTable.register(UITableViewCell.self, forCellReuseIdentifier: "track")
        
        trackListTable.delegate = self
        trackListTable.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(showButton)
        view.addSubview(trackListTable)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        showButton.translatesAutoresizingMaskIntoConstraints = false
        trackListTable.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackListTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackListTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackListTable.bottomAnchor.constraint(equalTo: showButton.topAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            showButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func handleResponse(result: Result<[TrackData], NetworkError>) {
        hideLoading()
        
        switch result {
        case .success(let searchResult):
            self.trackList = searchResult
            trackListTable.reloadData()
        case .failure(let error):
            let alertController = UIAlertController(
                title: "Error",
                message: error.rawValue,
                preferredStyle: .alert
            )
                
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }
    
    @objc private func buttonTap() {
        showLoading()
        
        networkManager.searchTracks(query: query, completion: handleResponse)
    }
    
    private func showLoading() {
        showButton.isEnabled = false
        showButton.alpha = 0.5
        
        activityIndicator.startAnimating()
    }
    
    private func hideLoading() {
        showButton.isEnabled = true
        showButton.alpha = 1
        
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let person = trackList[indexPath.row].artistName
        let track = trackList[indexPath.row].trackName
        
        content.text = "\(person ?? "Unknown") - \(track ?? "Unknown")"
        
        cell.contentConfiguration = content
        
        return cell
    }
}
