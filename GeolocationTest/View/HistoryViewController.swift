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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        cell.textLabel?.text = routes[indexPath.row].name
        cell.detailTextLabel?.text = Date().toString(date: routes[indexPath.row].date!) 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = Router.createDetailHistoryModule()
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    
}
