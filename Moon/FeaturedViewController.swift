//
//  FeaturedViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollections
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTypography
import Material
import iCarousel
import RxCocoa
import RxSwift

class FeaturedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BindableType {
    
    var viewModel: FeaturedViewModel!
    let featuredCellIdenifier = "featuredEventCell"
    private let bag = DisposeBag()
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    class func instantiateFromStoryboard() -> FeaturedViewController {
        let storyboard = UIStoryboard(name: "Featured", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FeaturedViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCollectionView.backgroundColor = Color.grey.lighten4
        eventCollectionView.isUserInteractionEnabled = true
        eventCollectionView.isScrollEnabled = true
        eventCollectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadEvents.execute()
    }
    
    func bindViewModel() {
        viewModel.featuredEvents.asObservable().subscribe(onNext: { _ in
            self.eventCollectionView.reloadData()
        }).addDisposableTo(bag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.featuredEvents.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = CGFloat(viewModel.featuredEvents.value.count)
        let spaceBetweenCells: CGFloat = 0.8
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        
        return CGSize(width: self.view.frame.width, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCellIdenifier, for: indexPath)
        cell.clearsContextBeforeDrawing = true
        
        cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
        
        let height = CGFloat(350)
        let width = self.view.frame.size.width - 40
        
        let view = FeaturedEventView()
        view.frame = CGRect(x: (cell.frame.size.width / 2) - (width / 2), y: (cell.frame.size.height / 2) - (height / 2), width: width, height: height)
        view.backgroundColor = .clear
        view.initializeCell()
        populate(view: view, indexPath: indexPath)

        // Remove the last featured view from the cell if there is one
        for view in cell.subviews {
            if let subview = view as? FeaturedEventView {
                subview.removeFromSuperview()
            }
        }
        
        cell.addSubview(view)
        
        return cell
    }
    
    func populate(view: FeaturedEventView, indexPath: IndexPath) {
        let event = viewModel.featuredEvents.value[indexPath.row]
        
        // Bind actions
        if let id = event.id {
            
            let likeAction = viewModel.onLikeEvent(eventID: id)
            view.favoriteButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                view.toggleColorAndNumber()
            }).subscribe().addDisposableTo(view.bag)
            
            let hasLiked = viewModel.hasLiked(eventID: id)
            hasLiked.elements.do(onNext: { hasLiked in
                if hasLiked {
                    view.favoriteButton.tintColor = .red
                }
            }).subscribe().addDisposableTo(view.bag)
            hasLiked.execute()
            
            view.numberOfLikesButton.rx.action = viewModel.onViewLikers(eventID: id)
            view.shareButton.rx.action = viewModel.onShareEvent(eventID: id)
            view.moreButton.rx.action = viewModel.onMoreInfo(barID: id)
            
            // Bind Image
            let downloader = viewModel.getEventImage(id: id)
            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
            downloader.execute()
        }
        
        // Bind labels
        view.dateLabel.text = event.date
        view.toolbar.detail = event.name
        view.toolbar.title = event.title
        view.content.text = event.description
        view.numberOfLikesButton.title = "\(event.numLikes ?? 0)"
    }
}
