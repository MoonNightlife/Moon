//
//  ContentSuggestionsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa

import RxSwift

typealias SearchSection = AnimatableSectionModel<String, Snapshot>

class ContentSuggestionsViewController: UIViewController, BindableType, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var suggestedUsersLabel: UILabel!
    @IBOutlet weak var suggestedBarsLabel: UILabel!
    
    var viewModel: ContentSuggestionsViewModel!
    
    private let barCollectionCellResuseIdenifier = "BarSnapshotCell"
    private let userCollectionCellReuseIdenifier = "UserSearchCollectionViewCell"
    let barDataSource = RxCollectionViewSectionedAnimatedDataSource<SearchSection>()
    let userDataSource = RxCollectionViewSectionedAnimatedDataSource<SearchSection>()
    private let bag = DisposeBag()
    
    @IBOutlet var suggestedUserColletionView: UICollectionView!
    @IBOutlet var suggestedBarCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        if viewModel != nil {
            viewModel.reloadSuggestedFriends.onNext()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestedBarCollectionView.delegate = self
        suggestedUserColletionView.showsHorizontalScrollIndicator = false
        
        suggestedUserColletionView.delegate = self
        
        configureDataSource()
        prepareLabels()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBarController?.searchBar.textField.resignFirstResponder()
    }
    
    func displayEmptyViewText(text: String, view: UICollectionView) {
        print("WORKING")
        let frame = CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 30)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "Roboto", size: 16)
        label.text = text
        label.tag = 5
        
        view.addSubview(label)
        view.bringSubview(toFront: label)
    }
    
    func removeEmptyViewText(view: UICollectionView) {
        if let viewWithTag = view.viewWithTag(5) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func prepareLabels() {
        suggestedUsersLabel.textColor = .lightGray
        suggestedUsersLabel.dividerThickness = 1.8
        suggestedUsersLabel.dividerColor = .moonGrey
        
        suggestedBarsLabel.textColor = .lightGray
        suggestedBarsLabel.dividerThickness = 1.8
        suggestedBarsLabel.dividerColor = .moonGrey
    }
    
    func bindViewModel() {
        viewModel.suggestedBars.do(onNext: { [weak self] bars in
            if let snapshots = bars.first?.items, snapshots.isEmpty {
                self?.displayEmptyViewText(text: "No Suggested Venues Found", view: (self?.suggestedBarCollectionView)!)
            } else {
                self?.removeEmptyViewText(view: (self?.suggestedBarCollectionView)!)
            }
            }).drive(suggestedBarCollectionView.rx.items(dataSource: barDataSource)).disposed(by: bag)
        
        viewModel.suggestedFriends.do(onNext: { [weak self] users in
            if let snapshots = users.first?.items, snapshots.isEmpty {
                self?.displayEmptyViewText(text: "No Suggested Users Found", view: self!.suggestedUserColletionView)
            } else {
                self?.removeEmptyViewText(view: (self?.suggestedUserColletionView)!)
            }
        }).drive(suggestedUserColletionView.rx.items(dataSource: userDataSource)).disposed(by: bag)
        
        suggestedBarCollectionView.rx.modelSelected(SearchSection.Item.self).subscribe(viewModel.onShowBar.inputs).addDisposableTo(bag)
        
        viewModel.reloadSuggestedBars.onNext()
    }
    
    fileprivate func cellsPerRowVertical(cells: Int, collectionView: UICollectionView) -> UICollectionViewFlowLayout {
            let numberOfCellsPerRow: CGFloat = CGFloat(cells)
        
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            
            let horizontalSpacing = flowLayout?.scrollDirection == .vertical ? flowLayout?.minimumInteritemSpacing: flowLayout?.minimumLineSpacing
            
            let cellWidth = ((self.view.frame.width) - max(0, numberOfCellsPerRow - 1) * horizontalSpacing!)/numberOfCellsPerRow
            
            flowLayout?.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        return flowLayout!
    }
    
    fileprivate func cellsPerRowHorizontal(cells: Int, collectionView: UICollectionView) -> UICollectionViewFlowLayout {
            let numberOfCellsPerRow: CGFloat = CGFloat(cells)
        
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
            let cellWidth = ((self.view.frame.width / 2) - max(0, numberOfCellsPerRow - 1) * 0.1)/numberOfCellsPerRow
            flowLayout?.itemSize = CGSize(width: cellWidth, height: collectionView.frame.size.height)
        
            flowLayout?.minimumInteritemSpacing = 0
            flowLayout?.minimumLineSpacing = 0
            flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        return flowLayout!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGFloat(0.0)
        
        if collectionView == suggestedUserColletionView {
            cellSize = collectionView.frame.size.height * 0.90
        } else if collectionView == suggestedBarCollectionView {
            cellSize = collectionView.frame.size.height * 0.526
        }
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    fileprivate func configureDataSource() {
        barDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarSnapshotCell", for: indexPath)
            
            collectionView.collectionViewLayout = (self?.cellsPerRowVertical(cells: 2, collectionView: collectionView))!
            
            let width = cell.frame.size.width - 20
            let height = width - 15
            
            let view = BarCollectionView()
            view.frame = CGRect(x: (cell.frame.size.width / 2) - (width / 2), y: (cell.frame.size.width / 2) - (height / 2), width: width, height: height)
            view.backgroundColor = .clear
            
            if let strongSelf = self {
               view.initViewWith()
                strongSelf.populate(barCollectionView: view, snapshot: item)
            }
            
            // Remove the last view from the cell if there is one
            for view in cell.subviews {
                if let subview = view as? BarCollectionView {
                    subview.removeFromSuperview()
                }
            }

            cell.addSubview(view)
            return cell
        }
        
        userDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserSearchCollectionViewCell", for: indexPath)
            
            collectionView.collectionViewLayout = (self?.cellsPerRowHorizontal(cells: 1, collectionView: collectionView))!
            
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
}

extension ContentSuggestionsViewController {
    func populate(barCollectionView view: BarCollectionView, snapshot: Snapshot) {
        
        view.imageView.backgroundColor = .moonGrey
        // Bind actions
        if let id = snapshot.id {
            view.goButton.rx.action = viewModel.onChangeAttendance(barID: id)
            
            let downloader = viewModel.getFirstBarImage(id: id)
            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
            downloader.execute()
        }
        
        // Bind labels
        view.nameLabel.text = snapshot.name
    
    }
    
    func populate(userCollectionView view: UserCollectionView, snapshot: Snapshot) {
        
        view.imageView.backgroundColor = .moonGrey
        
        if let id = snapshot.id {
            view.addFriendButton.rx.action = viewModel.onAddFriend(userID: id)
            
            let downloader = viewModel.getProfileImage(id: id)
            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
            downloader.execute()
            
            view.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] _ in
                self?.searchBarController?.searchBar.textField.resignFirstResponder()
                self?.viewModel.onShowProfile(userID: id).execute()
            }).addDisposableTo(view.bag)

        } else {
            let image = view.imageView.resizeImage(image: #imageLiteral(resourceName: "DefaultProfilePic"), targetSize: CGSize(width: 5, height: 5))
            view.imageView.image = image
        }
    
        // Bind labels
        view.nameLabel.text = snapshot.name

    }
}
