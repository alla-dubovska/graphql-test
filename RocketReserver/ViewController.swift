//
//  ViewController.swift
//  RocketReserver
//
//  Created by Alla Dubovska on 04.01.2021.
//

import UIKit

class ViewController: UITableViewController {

    var launches = [LaunchListQuery.Data.Launch.Launch]()
    
    enum ListSection: Int, CaseIterable {
      case launches
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLaunches()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func loadLaunches() {
      Network.shared.apollo.fetch(query: LaunchListQuery()) { [weak self] result in
        
          guard let self = self else {
            return
          }

          defer {
            self.tableView.reloadData()
          }
                
          switch result {
          case .success(let graphQLResult):
            if let launchConnection = graphQLResult.data?.launches {
              self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
            }
                    
            if let errors = graphQLResult.errors {
              let message = errors
                    .map { $0.localizedDescription }
                    .joined(separator: "\n")
              self.showErrorAlert(title: "GraphQL Error(s)",
                                  message: message)
            }

          case .failure(let error):
            self.showErrorAlert(title: "Network Error",
                                message: error.localizedDescription)
          }
      }
    }

    
    private func showErrorAlert(title: String, message: String) {
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }
}

extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
      return ListSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let listSection = ListSection(rawValue: section) else {
        assertionFailure("Invalid section")
        return 0
      }
            
      switch listSection {
      case .launches:
        return self.launches.count
      }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      guard let listSection = ListSection(rawValue: indexPath.section) else {
        assertionFailure("Invalid section")
        return cell
      }
        
      switch listSection {
      case .launches:
        let launch = self.launches[indexPath.row]
        cell.textLabel?.text = launch.site
      }
        
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let listSection = ListSection(rawValue: indexPath.section) else {
          assertionFailure("Invalid section")
          return
        }
          
        switch listSection {
        case .launches:
          let launch = self.launches[indexPath.row]
            let vc = DetailViewController(launchID: launch.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

