//
//  HistoryViewController.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    var viewModel: HistoryViewModel! {
        didSet{
            navigationItem.title = viewModel.historyModel.title
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var routes: [Route] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routes = viewModel.fetchRoutes()
        tableView.reloadData()
    }

}

extension HistoryViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
        let date = routes[indexPath.row].date!
        cell.textLabel?.text = routes[indexPath.row].name
        cell.detailTextLabel?.text = date.toString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes[indexPath.row]
        let detailView = Router.createDetailHistoryModule(detailHistoryModel: DetailHistoryModel(route: route))
        detailView.route = route
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    
}
