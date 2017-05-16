//
//  BarActivityTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/5/16.
//  Copyright © 2016 Evan Noble. All rights reserved.
//

import UIKit

protocol BarActivityCellDelegate: class {
    func likeButtonTapped(activityId: String, index: Int)
    func numButtonTapped(activityId: String)
    func nameButtonTapped(index: Int)
    func barButtonTapped(index: Int)
}

class BarActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var user: UIButton!
    @IBOutlet weak var isGoingToLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var bar: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numLikeButton: UIButton!

    // Cell delegate
    weak var delegate: BarActivityCellDelegate?
    fileprivate var activity: BarActivity!
    fileprivate var index: Int?
    
    func initializeCellWith(activity: BarActivity, index: Int) {
        self.activity = activity
        self.index = index
        
        self.backgroundColor = .clear
        
        setupProfilePicture()
        setupUsername()
        setupBarName()
        setupTime()
        setupLikeIcon()
        setupLikeNumber()
        setupLocationImage()
        setupIsGoingToLabel()
    }
}

extension BarActivityTableViewCell {
    fileprivate func setupProfilePicture() {
        // Sets a circular profile pic
        self.profilePicture.image = UIImage(named: "DefaultProfilePic.png")
        
        self.profilePicture.layer.masksToBounds = false
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2
        self.profilePicture.clipsToBounds = true
    }
    
    fileprivate func setupLocationImage() {
        locationIcon.image = #imageLiteral(resourceName: "LocationIcon").withRenderingMode(.alwaysTemplate)
        locationIcon.tintColor = .moonPurple
    }
    
    fileprivate func setupUsername() {
        if let username = activity.username {
            self.user.setTitle(username, for: .normal)
            self.user.setTitleColor(.darkGray, for: .normal)
            self.user.titleLabel?.font = UIFont.moonFont(size: 16)
        }
    }
    
    fileprivate func setupBarName() {
        if let barName = activity.barName {
            self.bar.setTitle(barName, for: .normal)
            self.bar.setTitleColor(.gray, for: .normal)
            self.bar.titleLabel?.font = UIFont.moonFont(size: 14)
        }
    }
    
    fileprivate func setupTime() {
        if let time = activity.time {
            self.timeLabel.text = getElaspedTimefromDate(fromDate: time)
            self.timeLabel.textColor = .gray

        }
    }
    
    fileprivate func setupLikeIcon() {
        // Add action to heart for liking of status
        let image = UIImage(named: "HeartIconGray")?.withRenderingMode(.alwaysTemplate)
        self.likeButton.imageView?.tintColor = .lightGray
        
        if let image = image {
            self.likeButton.setImage(image, for: .normal)
        }
    }
    
    fileprivate func setupLikeNumber() {
        if let likes = activity.likes {
            self.numLikeButton.setTitle(String(likes), for: .normal)
        } else {
            self.numLikeButton.setTitle("0", for: .normal)
        }
    }
    
    fileprivate func setupIsGoingToLabel() {
        isGoingToLabel.font = UIFont.moonFont(size: 16)
    }
}

extension BarActivityTableViewCell {
    @IBAction func nameButtonTapped(sender: UIButton) {
        if let index = index {
            delegate?.nameButtonTapped(index: index)
        }
    }
    
    @IBAction func barButtonTapped(sender: UIButton) {
        if let index = index {
            delegate?.barButtonTapped(index: index)
        }
    }
    
    @IBAction func numLikeButtonTapped(sender: UIButton) {
        if let activityId = activity.activityId {
            delegate?.numButtonTapped(activityId: activityId)
        }
    }
    
    @IBAction func heartButtonTapped(sender: UIButton) {
        if let activityId = activity.activityId, let index = index {
            delegate?.likeButtonTapped(activityId: activityId, index: index)
        }
    }
}
