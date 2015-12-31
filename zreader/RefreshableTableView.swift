//
//  RefreshableTableView.swift
//  zreader
//
//  Created by 周宁 on 15/12/31.
//  Copyright © 2015年 slyak. All rights reserved.
//

import UIKit


class RefreshableTableView: UITableView, UITableViewDataSource, UITableViewDelegate {


    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
//        cell.textLabel?.text = movies[indexPath.row].title
//        cell.detailTextLabel?.text = movies[indexPath.row].genre
        return cell
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...

        // Simply adding an object to the data source for this example
//        let newMovie = Movie(title: "Serenity", genre: "Sci-fi")
//        movies.append(newMovie)
//        movies.sortInPlace() { $0.title < $1.title }

//        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

}