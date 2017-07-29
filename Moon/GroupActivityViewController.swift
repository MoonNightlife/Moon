//
//  GroupActivityViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa
import RxDataSources
import Action

class GroupActivityViewController: UIViewController, BindableType, UICollectionViewDelegateFlowLayout {

    // MARK: - Global
    var viewModel: GroupActivityViewModel!
    var bag = DisposeBag()
    var backButton: UIBarButtonItem!
    var groupMembersDataSource = RxCollectionViewSectionedReloadDataSource<SnapshotSectionModel>()
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
        configureDataSource()
    }
    
    func prepareGroupNameLabel() {
        groupNameLabel.text = "Group Name"
        groupNameLabel.textColor = .lightGray
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        
        viewModel.groupName.bind(to: groupNameLabel.rx.text).addDisposableTo(bag)
        viewModel.barName.bind(to: planButton.rx.title()).addDisposableTo(bag)
        
        viewModel.displayUsers.bind(to: groupMembersCollectionView.rx.items(dataSource: groupMembersDataSource)).addDisposableTo(bag)
        
        viewModel.groupPicture.bind(to: groupPic.rx.image).addDisposableTo(bag)
        
        likeButton.rx.action = viewModel.onLikeGroupActivity()
        likersButton.rx.action = viewModel.onViewGroupLikers()
        planButton.rx.action = viewModel.onViewBar()
        
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
    
    func configureDataSource() {
        groupMembersDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupMemeberCollectionViewCell", for: indexPath)
            
            collectionView.collectionViewLayout = (self?.cellsPerRowVertical(cells: 2, collectionView: collectionView))!
            
            let width = cell.frame.width - 5
            let height = cell.frame.size.height - 20
            
            let view = UserCollectionView()
            
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.backgroundColor = .clear
            
            if let strongSelf = self {
                view.initViewWith()
                strongSelf.populate(userCollectionView: view, snapshot: item)
            }
            
            // Remove the last view from the cell if there is one
            for view in cell.subviews {
                if let subview = view as? UserCollectionView {
                    subview.removeFromSuperview()
                }
            }
            
            cell.addSubview(view)
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func populate(userCollectionView view: UserCollectionView, snapshot: Snapshot) {
        
        view.imageView.backgroundColor = .moonGrey
        
        if let id = snapshot.id {
            //TODO: Add information/actions to view
//            view.addFriendButton.rx.action = viewModel.onAddFriend(userID: id)
//            
//            let downloader = viewModel.getProfileImage(id: id)
//            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
//            downloader.execute()
//            
//            view.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] _ in
//                self?.searchBarController?.searchBar.textField.resignFirstResponder()
//                self?.viewModel.onShowProfile(userID: id).execute()
//            }).addDisposableTo(view.bag)
//            
        } else {
            let image = view.imageView.resizeImage(image: #imageLiteral(resourceName: "DefaultProfilePic"), targetSize: CGSize(width: 5, height: 5))
            view.imageView.image = image
        }
        
        // Bind labels
        view.nameLabel.text = snapshot.name
        
    }

}
