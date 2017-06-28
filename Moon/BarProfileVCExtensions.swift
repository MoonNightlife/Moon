//
//  BarProfileVCExtensions.swift
//  Moon
//
//  Created by Evan Noble on 6/27/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import iCarousel
import Material
import MaterialComponents.MaterialCollections

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
            let downloader = viewModel.downloadImage(url: url)
            downloader.elements.bind(to: eventView.imageView.rx.image).addDisposableTo(eventView.bag)
            downloader.execute()
        } else {
            eventView.imageView.image = nil
            eventView.backgroundColor = UIColor.moonGrey
        }
        
    }
    
    func populate(specialView view: SpecialCarouselView, index: Int) {
        let special = viewModel.specials.value[index]
        
        // Bind actions
        if let specialID = special.id {
            view.likeButton.rx.action = viewModel.onLikeSpecial(specialID: specialID)
            view.numberOfLikesButton.rx.action = viewModel.onViewLikers(specialID: specialID)
        }
        
        // Bind labels
        view.numberOfLikesButton.setTitle("\(special.numLikes ?? 0)", for: .normal)
        view.content.text = special.description
        
        // Bind Image
        if let urlString = special.pic, let url = URL(string: urlString) {
            let downloader = viewModel.downloadImage(url: url)
            downloader.elements.bind(to: view.imageView.rx.image).addDisposableTo(view.bag)
            downloader.execute()
        } else {
            view.imageView.image = nil
            view.imageView.backgroundColor = UIColor.moonGrey
        }
        
    }
    
    func populateGoing(peopleGoingView: PeopleGoingCarouselView, index: Int) {
        let activity = viewModel.displayedUsers.value[index]
        
        // Bind actions
        if let activityID = activity.id, let userID = activity.userID {
            
            peopleGoingView.likeButton.rx.action = viewModel.onLikeActivity(activityID: activityID)
            peopleGoingView.numberOfLikesButton.rx.action = viewModel.onViewLikers(activityID: activityID)
            
            //TODO: test once andrew updates the swagger
            // When the user taps the photo of a user the are directed to the user's profile
            peopleGoingView.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] in
                print($0)
                self?.viewModel.onShowProfile(userID: userID).execute()
            }).addDisposableTo(peopleGoingView.bag)
        }
        
        // Bind labels
        peopleGoingView.numberOfLikesButton.title = "\(activity.numLikes ?? 0)"
        
        // Bind Image
        if let urlString = activity.pic, let url = URL(string: urlString) {
            let downloader = viewModel.downloadImage(url: url)
            downloader.elements.bind(to: peopleGoingView.imageView.rx.image).addDisposableTo(peopleGoingView.bag)
            downloader.execute()
        } else {
            peopleGoingView.imageView.image = nil
            peopleGoingView.imageView.backgroundColor = UIColor.moonGrey
        }
    }
}
