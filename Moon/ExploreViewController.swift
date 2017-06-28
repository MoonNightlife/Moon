//
//  ExploreViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa
import iCarousel
import SwaggerClient
import RxDataSources

class ExploreViewController: UIViewController, BindableType {
    
    var viewModel: ExploreViewModel!
    
    class func instantiateFromStoryboard() -> ExploreViewController {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ExploreViewController
    }
    
    let specialCellIdenifier = "SpecialCell"
    let dataSource = RxTableViewSectionedAnimatedDataSource<SpecialSection>()
    @IBOutlet weak var topBarPageController: UIPageControl!
    @IBOutlet weak var topBarCarousel: iCarousel!
    fileprivate let reuseIdentifier = "TopBarCell"
    
    @IBOutlet weak var specialsTypeSegmentController: ADVSegmentedControl!
    @IBOutlet weak var specialsTableView: UITableView!
    
    var topBars = [TopBar]()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        prepareSegmentControl()
        setupCarousel()
        configureDataSource()
        
        topBarPageController.superview?.bringSubview(toFront: topBarPageController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.topBars.execute()
        viewModel.reloadSpecial.onNext()
    }
    
    func prepareSegmentControl() {
        //segment set up
        let segmentControl: ADVSegmentedControl = specialsTypeSegmentController
        segmentControl.items = ["Beer", "Liquor", "Wine"]
        segmentControl.selectedLabelColor = .moonPurple
        segmentControl.borderColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedIndex = 0
        segmentControl.unselectedLabelColor = .lightGray
        segmentControl.thumbColor = .moonPurple
    }
    
    private func setupCarousel() {
        topBarCarousel.isPagingEnabled = true
        topBarCarousel.type = .linear
        topBarCarousel.bounces = false
        topBarCarousel.clipsToBounds = true
    }
    
    func bindViewModel() {
        specialsTypeSegmentController.rx.controlEvent(UIControlEvents.valueChanged)            
            .map({ [weak self] _ in
                return AlcoholType.from(int: self?.specialsTypeSegmentController.selectedIndex ?? 0)
            }).bind(to: viewModel.selectedSpecialIndex).addDisposableTo(bag)
        
        viewModel.topBars.elements.subscribe(onNext: { [weak self] topBars in
            self?.topBars = topBars
            self?.topBarCarousel.reloadData()
        })
        .addDisposableTo(bag)
        
        viewModel.specials.bind(to: specialsTableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
    }
    
    func configureDataSource() {
        dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.specialCellIdenifier, for: indexPath) as! SpecialTableViewCell
            if let strongSelf = self {
                cell.initilizeSpecialCell()
                strongSelf.populate(specialCell: cell, special: item)
            }
            return cell
        }
    }
    
    fileprivate func populate(specialCell cell: SpecialTableViewCell, special: Special) {
        // Bind actions
        if let specialID = special.id, let barID = special.barID {
            cell.likeButton.rx.action = viewModel.onLike(specialID: specialID)
            cell.numLikesButton.rx.action = viewModel.onViewLikers(specialID: specialID)
            cell.barNameButton.rx.action = viewModel.onViewBar(barID: barID)
        }
        
        // Bind labels
        cell.mainTitle.text = special.description
        cell.barNameButton.setTitle(special.name, for: .normal)
        cell.numLikesButton.setTitle("\(special.numLikes ?? 0)", for: .normal)
        
        // Bind image
        if let urlString = special.pic, let url = URL(string: urlString) {
            let downloader = viewModel.downloadImage(url: url)
            downloader.elements.bind(to: cell.mainImage.rx.image).addDisposableTo(cell.bag)
            downloader.execute()
        } else {
            cell.mainImage.image = nil
            cell.mainImage.backgroundColor = UIColor.moonGrey
        }
    }

}

extension ExploreViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return topBars.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let topBarView = ImageViewCell(frame: carousel.frame)
        topBarView.initializeImageCardViewWith(data: topBars[index], downloadAction: viewModel.downloadImage(url: topBars[index].imageURL))
        //TODO: enter real bar id once api returns bar snapshot and i can get rid of the top bar model
        topBarView.moreButton.rx.action = viewModel.showBar(barID: "123123")
        return topBarView
    }
}
