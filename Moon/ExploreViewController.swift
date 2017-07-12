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
import RxDataSources

class ExploreViewController: UIViewController, BindableType, UITableViewDelegate {
    
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
        
        self.specialsTableView.autoresizingMask = .flexibleHeight
        self.specialsTableView.contentInset = EdgeInsets(top: 0, left: 0, bottom: (self.view.frame.size.height * 0.37), right: 0)
        specialsTableView.rx.setDelegate(self).addDisposableTo(bag)
        
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
                return AlcoholType.from(int: self?.specialsTypeSegmentController.selectedIndex ?? 0)!
            }).bind(to: viewModel.selectedSpecialIndex).addDisposableTo(bag)
        
        viewModel.topBars.elements.subscribe(onNext: { [weak self] topBars in
            if let strongSelf = self, strongSelf.arraysAreEqual(a1: topBars, a2: strongSelf.topBars) {
                strongSelf.topBars = topBars
                strongSelf.topBarPageController.numberOfPages = topBars.count
                strongSelf.topBarCarousel.reloadData()
            }
        })
        .addDisposableTo(bag)
        
        viewModel.specials.bind(to: specialsTableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
    }
    
    func arraysAreEqual(a1: [TopBar], a2: [TopBar]) -> Bool {
        // If array is empty then always try to reload
        guard a1.isEmpty else {
            return true
        }
        guard a1.count == a2.count else {
            return false
        }
        
        return a1 == a2
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
            
            let likeAction = viewModel.onLike(specialID: specialID)
            cell.likeButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                cell.toggleColorAndNumber()
            }).subscribe().addDisposableTo(cell.bag)
            
            let hasLikedSpecial = viewModel.hasLikedSpecial(specialID: specialID)
            hasLikedSpecial.elements.do(onNext: { hasLiked in
                if hasLiked {
                    cell.likeButton.setImage(Icon.favorite?.tint(with: .red), for: .normal)
                    cell.heartColor = .red
                }
            }).subscribe().addDisposableTo(cell.bag)
            hasLikedSpecial.execute()
            
            cell.numLikesButton.rx.action = viewModel.onViewLikers(specialID: specialID)
            cell.barNameButton.rx.action = viewModel.onViewBar(barID: barID)
        }
        
        // Bind labels
        cell.mainTitle.text = special.description
        cell.barNameButton.setTitle(special.name, for: .normal)
        cell.numLikesButton.setTitle("\(special.numLikes ?? 0)", for: .normal)
        
        // Bind image
        
        if let imageName = special.pic {
            let downloader = viewModel.getSpecialImage(imageName: imageName)
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
        topBarView.initializeImageCardView()
        populate(view: topBarView, bar: topBars[index])
        return topBarView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if carousel == topBarCarousel {
            topBarPageController.currentPage = carousel.currentItemIndex
        }
        
    }
    
    func populate(view: ImageViewCell, bar: TopBar) {
        
        if let id = bar.id {
            // Bind Action
            view.moreButton.rx.action = viewModel.showBar(barID: id)
            
            let attendAction = viewModel.onChangeAttendence(barID: id)
            view.goButton.rx.action = attendAction
            attendAction.elements.do(onNext: {
                //TODO: Change button icon
            }).subscribe().disposed(by: view.bag)
            
            // Download Image
            let downloader = viewModel.getFirstBarImage(id: id)
            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
            downloader.execute()
        }
        
        view.toolbar.title = bar.name
        
        let fullString = NSMutableAttributedString(string: " ")
        
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "goingIcon")
        attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        fullString.append(attachmentString)
        fullString.append(NSAttributedString(string: " " + (bar.usersGoing ?? "")))
        
        view.toolbar.detailLabel.attributedText = fullString

    }
}

extension ExploreViewController {
    func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}
