//
//  ViewController.swift
//  Metro
//
//  Created by Theo Phillips on 3/13/16.
//  Copyright © 2016 DurlApps. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    var routes = Array<MetroRoute>()
    var routesFiltered = Array<MetroRoute>()
    var searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LA Metro Routes"
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        MetroRoute.getAllRoutes({
            response in
            print("received \(response.count) routes")
            self.routes = response
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return routesFiltered.count
        }
        return routes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var route = routes[indexPath.row]
        if searchController.active && searchController.searchBar.text != "" {
            route = routesFiltered[indexPath.row]
        }
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = route.title!
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let route = routes[indexPath.row]
        let detail = DetailViewController(route: route)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        routesFiltered = routes.filter {
            route in
            return route.title!.lowercaseString.containsString(searchController.searchBar.text!.lowercaseString)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

