//
//  BarActivityFeedViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

struct BarActivity {
    var barId: String?
    var barName: String?
    var time: NSDate?
    var username: String?
    var userId: String?
    var activityId: String?
    var likes: Int?
}

class BarActivityFeedViewController: UITableViewController {
    
    class func instantiateFromStoryboard() -> BarActivityFeedViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! BarActivityFeedViewController
    }

    var activities = [BarActivity]()
    let barActivityCellIdenifier = "barActivityCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activities = createFakeBarActivities()
        self.tableView.reloadData()
        
        viewSetUp()
    }
    
    private func createFakeBarActivities() -> [BarActivity] {
        var activities = [BarActivity]()
        activities.append(BarActivity(barId: "123", barName: "Barley House", time: NSDate(), username: "enoble89", userId: "666", activityId: "456", likes: 3))
        return activities
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Read more about this @objc keyword used in front of the function
    @objc fileprivate func reloadUsersBarFeed() {
        refreshControl?.endRefreshing()
        print("Should reload here")
    }

}

extension BarActivityFeedViewController {
    fileprivate func viewSetUp() {
        // TableView set up
        tableView.rowHeight = 75
        self.tableView.separatorStyle = .singleLine
        tableView.backgroundColor = Color.grey.lighten5
        
        // Add the refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.reloadUsersBarFeed), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
}

extension BarActivityFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let  cell = tableView.dequeueReusableCell(withIdentifier: barActivityCellIdenifier) as! BarActivityTableViewCell
        
        cell.delegate = self
        cell.initializeCellWith(activity: activities[indexPath.row], index: indexPath.row)
        
        return cell
    }
}

extension BarActivityFeedViewController: BarActivityCellDelegate {
    func likeButtonTapped(activityId: String, index: Int) {
        print("user liked activity")
    }
    
    func numButtonTapped(activityId: String) {
        print("num button tapped")
    }
    
    func nameButtonTapped(index: Int) {
        print("user profile should display")
    }
    
    func barButtonTapped(index: Int) {
        print("bar profile should display")
    }
}
