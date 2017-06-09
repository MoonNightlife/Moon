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
    
    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel: BarProfileViewModel!
    
    var barPics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barPics = ["b1.jpg", "b2.jpg", "b3.jpg", "b4.jpg", "b5.jpg"]
        prepareScrollView()
        prepareCarousels()
        prepareSegmentControl()
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
    
    func prepareSegmentControl() {
        //segment set up
        segmentControl.items = ["People Going", "Friends Going"]
        //segmentControler.font = UIFont(name: "Roboto-Bold", size: 10)
        segmentControl.selectedLabelColor = .moonBlue
        segmentControl.borderColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedIndex = 0
        segmentControl.unselectedLabelColor = .lightGray
        segmentControl.thumbColor = .moonBlue
  
    }
    
    func prepareCarousels() {
        
        goingCarousel.isPagingEnabled = true
        goingCarousel.type = .linear
        goingCarousel.bounces = false
        goingCarousel.tag = 0
        goingCarousel.reloadData()
       
        eventsCarousel.isPagingEnabled = true
        eventsCarousel.type = .linear
        eventsCarousel.bounces = false
        eventsCarousel.tag = 1
        eventsCarousel.reloadData()
        
        pictureCarousel.isPagingEnabled = true
        pictureCarousel.type = .linear
        pictureCarousel.bounces = false
        pictureCarousel.tag = 2
        pictureCarousel.reloadData()
        
        specialsCarousel.isPagingEnabled = true
        specialsCarousel.type = .linear
        specialsCarousel.bounces = false
        specialsCarousel.tag = 3
        specialsCarousel.reloadData()
        
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
            return 20 //returns number of people going
        } else if carousel.tag == 1 {
            return fakeEvents.count //returns number of fake events
        } else if carousel.tag == 2 {
            return barPics.count //returns number of bar pictures
        } else if carousel.tag == 3 {
            return 10 //returns number of specials
        }
        
        return 0
    }

//    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
//        
//      pageController.currentPage = pictureCarousel.currentItemIndex
//      
//    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        if carousel == pictureCarousel {
            return setUpPictureView(index: index)
        } else if carousel == specialsCarousel {
            return setUpSpecialView()
        } else if carousel == goingCarousel {
            return setUpGoingView()
        } else if carousel == eventsCarousel {
            return setUpEventView(event: fakeEvents[index], index: index)
        }
        
        return UIView(frame: carousel.frame)
    }
    
    func setUpGoingView() -> UIView {
        
        let view = UIView()
        let size = goingCarousel.frame.size.height - 25
        view.frame = CGRect(x: goingCarousel.frame.size.width / 2, y: goingCarousel.frame.size.height / 2, width: size, height: size)
        view.backgroundColor = .white
        
        return view
    }
    
    func setUpSpecialView() -> UIView {
        
        return UIView(frame: specialsCarousel.frame)
    }
    
    func setUpEventView(event: FeaturedEvent, index: Int) -> UIView {
                
        let view = FeaturedEventCollectionViewCell()
        let size = eventsCarousel.frame.size.height - 60
        view.frame = CGRect(x: eventsCarousel.frame.size.width / 2, y: eventsCarousel.frame.size.height / 2, width: size + 60, height: size)
        view.backgroundColor = .clear
        view.initializeCellWith(event: event, index: index)
        print(view.imageView.frame.size)
        return view
    }
    
    func setUpPictureView(index: Int) -> UIView {
        
        let barPic = BottomGradientImageView(frame: pictureCarousel.frame)
        barPic.image = UIImage(named: barPics[index])
        //profilePic.contentMode = UIViewContentMode.scaleAspectFill
        
        return barPic
    }

}
