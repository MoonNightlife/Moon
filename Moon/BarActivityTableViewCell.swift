//
//  BarActivityTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/5/16.
//  Copyright © 2016 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxSwift
import Material

class BarActivityTableViewCell: UITableViewCell {
        
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var user: UIButton!
    @IBOutlet weak var isGoingToLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var bar: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numLikeButton: UIButton!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var groupPrefixText: UILabel!
    
    var bag = DisposeBag()
    var heartColor: HeartColor = .gray
    // This formula will give you a font size of 16 on iphone 7
    let scaledFontSize = UIScreen.main.bounds.height * 0.024
    
    func initializeCell() {
    
        backgroundColor = .clear
        selectionStyle = .none
        
        setupProfilePicture()
        setupUsername()
        setupBarName()
        setupTime()
        setupLikeIcon()
        setupLikeNumber()
        setupLocationImage()
        setupIsGoingToLabel()
        setupTimeImageView()
        setupGroupPrefixText()
    }
    
    func toggleColorAndNumber() {
        
        likeButton.setImage(Icon.favorite?.tint(with: heartColor == .gray ? .red : .lightGray), for: .normal)
        if let numString = numLikeButton.titleLabel?.text, let num = Int(numString) {
            print(numString)
            numLikeButton.setTitle("\(heartColor == .gray ? num + 1 : num - 1)", for: .normal)
        }
        
        heartColor = heartColor == .gray ? .red : .gray
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
        
        likeButton.rx.action = nil
        user.rx.action = nil
        bar.rx.action = nil
        numLikeButton.rx.action = nil
    }
    
    func showGroupText() {
        groupPrefixText.text = "The group "
    }
    
    func hideGroupText() {
        groupPrefixText.text = ""
    }
}

extension BarActivityTableViewCell {
    
    fileprivate func setupProfilePicture() {
        // Sets a circular profile pic
        self.profilePicture.layer.masksToBounds = false
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2
        self.profilePicture.clipsToBounds = true
    }
    
    fileprivate func setupLocationImage() {
        locationIcon.image = #imageLiteral(resourceName: "LocationIcon")
    }
    
    fileprivate func setupUsername() {
        self.user.setTitleColor(.darkGray, for: .normal)
        self.user.titleLabel?.font = UIFont.moonFont(size: scaledFontSize)
        self.user.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    fileprivate func setupBarName() {
        self.bar.setTitleColor(.gray, for: .normal)
        self.bar.titleLabel?.font = UIFont.moonFont(size: 14)
    }
    
    fileprivate func setupTime() {
        self.timeLabel.textColor = .gray
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
        self.numLikeButton.titleLabel?.textColor = .lightGray
        self.numLikeButton.setTitle("0", for: .normal)
    }
    
    fileprivate func setupIsGoingToLabel() {
        isGoingToLabel.font = UIFont.moonFont(size: scaledFontSize)
        isGoingToLabel.text = "is going to"
        isGoingToLabel.textColor = .lightGray
    }
    
    fileprivate func setupGroupPrefixText() {
        groupPrefixText.font = UIFont.moonFont(size: scaledFontSize)
        groupPrefixText.textColor = .lightGray
    }
    
    fileprivate func setupTimeImageView() {
        timeImageView.image = #imageLiteral(resourceName: "ClockIcon").withRenderingMode(.alwaysTemplate).tint(with: .lightGray)
    }
}
