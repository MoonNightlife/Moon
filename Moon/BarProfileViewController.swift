//
//  BarProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import iCarousel
import Material
import MaterialComponents.MaterialCollections

class BarProfileViewController: UIViewController, UIScrollViewDelegate, BindableType {
    @IBOutlet weak var segmentControl: ADVSegmentedControl!

    @IBOutlet weak var toolBar: Toolbar!
    @IBOutlet weak var goingCarousel: iCarousel!
    @IBOutlet weak var pictureCarousel: iCarousel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var specialsCarousel: iCarousel!
    @IBOutlet weak var eventsCarousel: iCarousel!
    
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var specialsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel: BarProfileViewModel!
    
    //fake variabls
    var barPics = [String]()
    var barName = String()
    var peoplePics = [String]()
    var peopleNames = [String]()
    var fakeUsers = [FakeUser]()
    var fakeSpecials = [Special]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Fake Data loading
        barPics = ["b1.jpg", "b2.jpg", "b3.jpg", "b4.jpg", "b5.jpg"]
        peoplePics = ["pp2.jpg", "p1.jpg", "p2.jpg", "p3.jpg", "p4.jpg", "p5.jpg", "p6.jpg", "p7.jpg", "p8.jpg"]
        peopleNames = ["Marisol Leiva", "Collin Duzyk", "Camden Moore", "Mony Gonzalez", "Molly Smith", "Sarah Smith", "Sloan Stearman", "Henry Berlhe", "Andrea Adler"]
        barName = "Avenu Lounge"
        fakeUsers = createFakeUsers()
        fakeSpecials = createFakeSpecials()
        
        //prepare the UI
        prepareScrollView()
        prepareCarousels()
        prepareSegmentControl()
        prepareToolBar()
        preparePageControl()
        prepareNavigationBackButton()
        prepareLabels()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = .moonGrey
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.title = "Avenu Lounge"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
    }
    
    func prepareScrollView() {
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1100.0)
    }
    
    func prepareNavigationBackButton() {
        let navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
        self.navigationItem.title = "Avenu Lounge"
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
        pageController.numberOfPages = barPics.count
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
        
        toolBar.leftViews = [IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)]
        toolBar.rightViews = [IconButton(image: #imageLiteral(resourceName: "goButton"))]
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
            return fakeUsers.count //returns number of people going
        } else if carousel.tag == 1 {
            return fakeEvents.count //returns number of fake events
        } else if carousel.tag == 2 {
            return barPics.count //returns number of bar pictures
        } else if carousel.tag == 3 {
            return 10 //returns number of specials
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
            return setUpEventView(event: fakeEvents[index], index: index)
        }
        
        return UIView(frame: carousel.frame)
    }
    
    func setUpGoingView(index: Int) -> UIView {
        let size = goingCarousel.frame.size.height - 50
        let frame = CGRect(x: goingCarousel.frame.size.width / 2, y: goingCarousel.frame.size.height / 2, width: size, height: size)
        let view = PeopleGoingCarouselView()
        view.frame = frame
        view.initializeViewWith(user: fakeUsers[index], index: index)
        
        return view
    }
    
    func setUpSpecialView(index: Int) -> UIView {
        
        let view = SpecialCarouselView()
        let size = specialsCarousel.frame.size.height - 30
        let frame = CGRect(x: specialsCarousel.frame.size.width / 2, y: specialsCarousel.frame.size.height / 2, width: size, height: size)
        view.frame = frame
        view.initializeViewWith(special: fakeSpecials[index], index: index)
        
        return view
    }
    
    func setUpEventView(event: FeaturedEvent, index: Int) -> UIView {
                
        let view = FeaturedEventCollectionViewCell()
        let size = eventsCarousel.frame.size.height - 60
        view.frame = CGRect(x: eventsCarousel.frame.size.width / 2, y: eventsCarousel.frame.size.height / 2, width: size + 60, height: size)
        view.backgroundColor = .clear
        view.initializeCellWith(event: event, index: index)
        
        return view
    }
    
    func setUpPictureView(index: Int) -> UIView {
        
        let barPic = BottomGradientImageView(frame: pictureCarousel.frame)
        barPic.image = UIImage(named: barPics[index])
        //profilePic.contentMode = UIViewContentMode.scaleAspectFill
        
        return barPic
    }

}
