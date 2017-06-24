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
        
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCellIdenifier, for: indexPath)
        cell.clearsContextBeforeDrawing = true
        
        let height = CGFloat(250)
        let width = self.view.frame.size.width - 40
        
        let view = FeaturedEventView()
        view.frame = CGRect(x: (cell.frame.size.width / 2) - (width / 2), y: (cell.frame.size.height / 2) - (height / 2), width: width, height: height)
        view.backgroundColor = .clear
        let event = viewModel.featuredEvents.value[indexPath.row]
        view.initializeCellWith(event: viewModel.featuredEvents.value[indexPath.row],
                                index: indexPath.row,
                                likeAction: viewModel.onLikeEvent(eventID: event.id!),
                                shareAction: viewModel.onShareEvent(eventID: event.id!),
                                downloadImage: viewModel.downloadImage(url: URL(string: event.pic!)!),
                                moreInfoAction: viewModel.onMoreInfo(eventID: event.id!))
        
        cell.addSubview(view)
        
        return cell
    }
}
