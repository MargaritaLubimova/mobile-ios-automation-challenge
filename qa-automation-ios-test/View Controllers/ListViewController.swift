//
//  ListViewController.swift
//  qa-automation-ios-test
//
//  Created by Lorenzo Bulfone on 28.02.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
  // MARK: - Variables
  private var exercises = [Excercise]()
  private var filteredExercises = [Excercise]()
  private var dataTask: URLSessionDataTask?
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var isSearchBarEmpty: Bool {
    return navigationItem.searchController?.searchBar.text?.isEmpty ?? true
  }
  private var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  // MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureSearchController()
    fetchExcercises()
  }
  
  // MARK: - Functions
  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search exercises"
    
    navigationItem.searchController = searchController
    
    definesPresentationContext = true
  }
  
  private func fetchExcercises() {
    let defaultSession = URLSession(configuration: .default)
    
    dataTask?.cancel()
    
    if var urlComponents = URLComponents(string: "https://wger.de/api/v2/exercise") {
      urlComponents.query = "limit=30&status=2&language=2"
      
      guard let url = urlComponents.url else {
        return
      }
      
      dataTask =
        defaultSession.dataTask(with: url) { [weak self] data, response, error in
          defer {
            self?.dataTask = nil
          }
          
          if error == nil,
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            if let list = try? JSONDecoder().decode(ExcerciseList.self, from: data) {
              UITestsDataProvider.writeExcerciseList(data)
              self?.exercises = list.results
            }
            
            DispatchQueue.main.async { [weak self] in
              self?.tableView.reloadData()
            }
          }
      }
      
      dataTask?.resume()
    }
  }
  
  func filterExercisesForSearchText(_ searchText: String) {
    filteredExercises = exercises.filter { (exercise: Excercise) -> Bool in
      return exercise.meta.lowercased().contains(searchText.lowercased())
    }
    
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredExercises.count : exercises.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    let exercise = isFiltering ? filteredExercises[indexPath.row] : exercises[indexPath.row]
    
    cell.accessibilityIdentifier = exercise.meta
    cell.textLabel?.text = exercise.meta
    
    return cell
  }
}

extension ListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterExercisesForSearchText(searchBar.text!)
  }
}
