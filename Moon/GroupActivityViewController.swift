//
//  GroupActivityViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action

class GroupActivityViewController: UIViewController, BindableType, UICollectionViewDelegateFlowLayout {

    // MARK: - Global
    var viewModel: GroupActivityViewModel!
    var backButton: UIBarButtonItem!
    private let membersCollectionCellResuseIdenifier = "MemberSnapshotCell"
    
    @IBOutlet weak var groupPic: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likersButton: UIButton!
    @IBOutlet weak var groupMembersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareGroupPicture()
        prepareLikesButton()
        preparePlanButton()
        prepareGroupNameLabel()
    }
    
    func prepareGroupNameLabel() {
        groupNameLabel.text = "Group Name"
        groupNameLabel.textColor = .lightGray
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func preparePlanButton() {
        planButton.tintColor = .lightGray
        planButton.titleLabel?.font = UIFont(name: "Roboto", size: 15)
    }
    
    func prepareLikesButton() {
        likersButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
        likersButton.tintColor = .lightGray
        likersButton.setTitle("100", for: .normal)
        
        let image =  Icon.favorite
        likeButton.setBackgroundImage(image, for: .normal)
        likeButton.tintColor = .lightGray
    }
    
    func prepareGroupPicture() {
        groupPic.isUserInteractionEnabled = true
        groupPic.layer.cornerRadius = groupPic.frame.size.height  / 2
        groupPic.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        groupPic.contentMode = UIViewContentMode.scaleAspectFill
        groupPic.clipsToBounds = true
    }
    
    fileprivate func cellsPerRowVertical(cells: Int, collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let numberOfCellsPerRow: CGFloat = CGFloat(cells)
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        let horizontalSpacing = flowLayout?.scrollDirection == .vertical ? flowLayout?.minimumInteritemSpacing: flowLayout?.minimumLineSpacing
        
        let cellWidth = ((self.view.frame.width) - max(0, numberOfCellsPerRow - 1) * horizontalSpacing!)/numberOfCellsPerRow
        
        flowLayout?.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        return flowLayout!
    }

}
