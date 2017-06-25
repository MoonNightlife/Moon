//
//  BarProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import iCarousel
import Material
import MaterialComponents.MaterialCollections

class BarProfileViewController: UIViewController, UIScrollViewDelegate, BindableType {
    @IBOutlet weak var segmentControl: ADVSegmentedControl!

    @IBOutlet weak var toolBar: Toolbar!
    @IBOutlet weak var goingCarousel: iCarousel!
    @IBOutlet weak var pictureCarousel: iCarousel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var specialsCarousel: iCarousel!
    @IBOutlet weak var eventsCarousel: iCarousel!
    
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var specialsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel: BarProfileViewModel!
    private let bag = DisposeBag()
    var backButton: UIBarButtonItem!
    var moreInfoButton: IconButton!
    var goButton: IconButton!
    
    //Constraints outlets
    @IBOutlet weak var pictureCarouselConstraint: NSLayoutConstraint!
    @IBOutlet weak var goingViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepare the UI
        prepareScrollView()
        prepareCarousels()
        prepareSegmentControl()
        prepareToolBar()
        preparePageControl()
        prepareNavigationBackButton()
        prepareLabels()
        
        //Dynamic Heights for each view
        let phoneSize = self.view.frame.size.height
        pictureCarouselConstraint.constant = phoneSize * 0.34
        goingViewConstraint.constant = phoneSize * 0.38
        specialViewConstraint.constant = phoneSize * 0.35
        //eventViewConstraint.constant = phoneSize * 0.38
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = .moonGrey
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        moreInfoButton.rx.action = viewModel.onShowInfo()
        goButton.rx.action = viewModel.onAttendBar()
        
        segmentControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map({ [weak self] in
                return UsersGoingType(rawValue: self?.segmentControl.selectedIndex ?? 0) ?? .everyone
            }).bind(to: viewModel.selectedUserIndex).addDisposableTo(bag)
        
        viewModel.displayedUsers.asObservable().subscribe(onNext: { [weak self] _ in
            self?.goingCarousel.reloadData()
        }).addDisposableTo(bag)
        
        viewModel.barName.subscribe(onNext: { [weak self] in
            self?.title = $0
        }).addDisposableTo(bag)

        viewModel.barPics.asObservable().subscribe(onNext: { [weak self] in
            self?.pageController.numberOfPages = $0.count
            self?.pictureCarousel.reloadData()
        }).addDisposableTo(bag)
        
        viewModel.specials.asObservable().subscribe(onNext: { [weak self] _ in
            self?.specialsCarousel.reloadData()
        }).addDisposableTo(bag)
        
        viewModel.events.asObservable().subscribe(onNext: { [weak self] _ in
            self?.eventsCarousel.reloadData()
        }).addDisposableTo(bag)
        
    }
    
    func prepareScrollView() {
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1100.0)
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowBack
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func prepareSegmentControl() {
        //segment set up
        segmentControl.items = ["People Going", "Friends Going"]
        segmentControl.selectedLabelColor = .moonPurple
        segmentControl.borderColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedIndex = 0
        segmentControl.unselectedLabelColor = .lightGray
        segmentControl.thumbColor = .moonPurple
    }
    
    func prepareCarousels() {
        goingCarousel.isPagingEnabled = true
        goingCarousel.type = .linear
        goingCarousel.bounces = false
        goingCarousel.tag = 0
        goingCarousel.reloadData()
       
        eventsCarousel.isPagingEnabled = true
        eventsCarousel.type = .coverFlow
        eventsCarousel.bounces = false
        eventsCarousel.tag = 1
        eventsCarousel.reloadData()
        
        pictureCarousel.isPagingEnabled = true
        pictureCarousel.type = .linear
        pictureCarousel.bounces = false
        pictureCarousel.tag = 2
        pictureCarousel.reloadData()
        pictureCarousel.bringSubview(toFront: toolBar)
        pictureCarousel.bringSubview(toFront: pageController)
        
        specialsCarousel.isPagingEnabled = true
        specialsCarousel.type = .linear
        specialsCarousel.bounces = false
        specialsCarousel.tag = 3
        specialsCarousel.reloadData()
    }
    
    func preparePageControl() {
        pageController.numberOfPages = viewModel.barPics.value.count
        pageController.currentPageIndicatorTintColor = .white
        pageController.pageIndicatorTintColor = .lightGray
        pageController.currentPage = 0
    }
    
    func prepareToolBar() {
        
        //Adding going icon to the right of the title label
        let fullString = NSMutableAttributedString(string: " ")
        
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "goingIcon")
        attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        fullString.append(attachmentString)
        fullString.append(NSAttributedString(string: " " + "20")) //people going
        
        toolBar.titleLabel.attributedText = fullString
        toolBar.titleLabel.textColor = .white
        toolBar.backgroundColor = .clear
        
        moreInfoButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)
        goButton = IconButton(image: #imageLiteral(resourceName: "goButton"))
        toolBar.leftViews = [moreInfoButton]
        toolBar.rightViews = [goButton]
    }
    
    func prepareLabels() {
        specialsLabel.textColor = .moonBlue
        specialsLabel.dividerColor = .moonBlue
        specialsLabel.dividerThickness = 1.8
        
        eventsLabel.textColor = .moonRed
        eventsLabel.dividerColor = .moonRed
        eventsLabel.dividerThickness = 1.8
    }

}

extension BarProfileViewController: iCarouselDataSource, iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if carousel == pictureCarousel {
            return value
        } else {
            if option == .spacing {
                return value * 1.2
            }
        }
        
        return value
    }
        
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        if carousel.tag == 0 {
            return viewModel.displayedUsers.value.count //returns number of people going
        } else if carousel.tag == 1 {
            return viewModel.events.value.count //returns number of fake events
        } else if carousel.tag == 2 {
            return viewModel.barPics.value.count //returns number of bar pictures
        } else if carousel.tag == 3 {
            return viewModel.specials.value.count //returns number of specials
        }
        
        return 0
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        if carousel == pictureCarousel {
            pageController.currentPage = pictureCarousel.currentItemIndex
        }
      
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        if carousel == pictureCarousel {
            return setUpPictureView(index: index)
        } else if carousel == specialsCarousel {
            return setUpSpecialView(index: index)
        } else if carousel == goingCarousel {
            return setUpGoingView(index: index)
        } else if carousel == eventsCarousel {
            return setUpEventView(index: index)
        }
        
        return UIView(frame: carousel.frame)
    }
    
    func setUpGoingView(index: Int) -> UIView {
        let size = (self.view.frame.size.height * 0.325) - 50
        let frame = CGRect(x: goingCarousel.frame.size.width / 2, y: goingCarousel.frame.size.height / 2, width: size, height: size)
        let view = PeopleGoingCarouselView()
        view.frame = frame
        view.initializeView()
        populateGoing(peopleGoingView: view, index: index)
        
        return view
    }
    
    func setUpSpecialView(index: Int) -> UIView {
        let view = SpecialCarouselView()
        let size = (self.view.frame.size.height * 0.298) - 50
        let frame = CGRect(x: specialsCarousel.frame.size.width / 2, y: specialsCarousel.frame.size.height / 2, width: size + 20, height: size)
        view.frame = frame
        view.initializeView()
        populate(specialView: view, index: index)
        
        return view
    }
    
    func setUpEventView(index: Int) -> UIView {
        let view = FeaturedEventView()
        let size = (self.view.frame.size.height * 0.513) - 60
        view.frame = CGRect(x: eventsCarousel.frame.size.width / 2, y: eventsCarousel.frame.size.height / 2, width: size + 60, height: size)
        view.backgroundColor = .clear
        view.initializeCell()
        populate(eventView: view, index: index)
        
        return view
    }
    
    

    
    func setUpPictureView(index: Int) -> UIView {
        let barPic = BottomGradientImageView(frame: pictureCarousel.frame)
        barPic.image = viewModel.barPics.value[index]
        
        return barPic
    }

}

extension BarProfileViewController {
    // MARK: - Populate view functions
    // These functions should be handed in the view model of the cells, but we have not created them yet so they are here
    
    func populate(eventView: FeaturedEventView, index: Int) {
        let event = viewModel.events.value[index]
        
        // Bind actions
        if let id = event.id, let barID = event.barID {
            eventView.favoriteButton.rx.action = viewModel.onLikeEvent(eventID: id)
            eventView.numberOfLikesButton.rx.action = viewModel.onViewLikers(eventID: id)
            eventView.shareButton.rx.action = viewModel.onShareEvent(eventID: id, barID: barID)
            // No action for this button on the bar profile, so hide it
            eventView.moreButton.isHidden = true
        }
        
        // Bind labels
        eventView.dateLabel.text = event.date
        eventView.toolbar.detail = event.name
        eventView.toolbar.title = event.title
        eventView.content.text = event.description
        eventView.numberOfLikesButton.title = "\(event.numLikes ?? 0)"
        
        // Bind image
        if let urlString = event.pic, let url = URL(string: urlString) {
            viewModel.downloadImage(url: url).elements.bind(to: eventView.imageView.rx.image).addDisposableTo(eventView.bag)
        } else {
            //TODO: change this to default bar picture
            eventView.imageView.image = #imageLiteral(resourceName: "DefaultProfilePic")
        }
        
    }
    
    func populate(specialView: SpecialCarouselView, index: Int) {
        let special = viewModel.specials.value[index]
        //TOOD: finish populating specials
        // Bind actions
        if let specialID = special.id {
            specialView.likeButton.rx.action = viewModel.onLikeSpecial(specialID: specialID)
        }
    }
    
    func populateGoing(peopleGoingView: PeopleGoingCarouselView, index: Int) {
        let activity = viewModel.displayedUsers.value[index]
        
        // Bind actions
        if let activityID = activity.id, let userID = activity.userID {
            
            peopleGoingView.likeButton.rx.action = viewModel.onLikeActivity(activityID: activityID)
            peopleGoingView.numberOfLikesButton.rx.action = viewModel.onViewLikers(activityID: activityID)
            
            // When the user taps the photo of a user the are directed to the user's profile
            peopleGoingView.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] in
                print($0)
                self?.viewModel.onShowProfile(userID: userID).execute()
            }).addDisposableTo(peopleGoingView.bag)
        }
        
        // Bind labels
        peopleGoingView.numberOfLikesButton.title = "\(activity.numLikes ?? 0)"
    }
}

extension BarProfileViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}
