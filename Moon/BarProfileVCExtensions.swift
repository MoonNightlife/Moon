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
            
            let likeAction = viewModel.onLikeEvent(eventID: id)
            eventView.favoriteButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                eventView.toggleColorAndNumber()
            }).subscribe().addDisposableTo(eventView.bag)
            
            let hasLiked = viewModel.hasLikedEvent(eventID: id)
            hasLiked.elements.do(onNext: { hasLiked in
                if hasLiked {
                    eventView.favoriteButton.tintColor = .red
                }
            }).subscribe().addDisposableTo(eventView.bag)
            hasLiked.execute()
            
            eventView.numberOfLikesButton.rx.action = viewModel.onViewLikers(eventID: id)
            eventView.shareButton.rx.action = viewModel.onShareEvent(eventID: id, barID: barID)
            // No action for this button on the bar profile, so hide it
            eventView.moreButton.isHidden = true
            
            // Bind Image
            let downloader = viewModel.getEventImage(id: id)
            downloader.elements.bind(to: eventView.imageView.rx.image).addDisposableTo(eventView.bag)
            downloader.execute()
        }
        
        // Bind labels
        eventView.dateLabel.text = event.date
        eventView.toolbar.detail = event.name
        eventView.toolbar.title = event.title
        eventView.content.text = event.description
        eventView.numberOfLikesButton.title = "\(event.numLikes ?? 0)"
        
    }
    
    func populate(specialView view: SpecialCarouselView, index: Int) {
        let special = viewModel.specials.value[index]
        
        // Bind actions
        if let specialID = special.id {
            let likeAction = viewModel.onLikeSpecial(specialID: specialID)
            view.likeButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                view.toggleColorAndNumber()
            }).subscribe().addDisposableTo(view.bag)
            
            let hasLikedSpecial = viewModel.hasLikedSpecial(specialID: specialID)
            hasLikedSpecial.elements.do(onNext: { hasLiked in
                if hasLiked {
                    view.likeButton.tintColor = .red
                }
            }).subscribe().addDisposableTo(view.bag)
            hasLikedSpecial.execute()
        
            view.numberOfLikesButton.rx.action = viewModel.onViewLikers(specialID: specialID)
        }
        
        // Bind labels
        view.numberOfLikesButton.title = "\(special.numLikes ?? 0)"
        view.content.text = special.description
        
        // Bind Image
        if let imageName = special.pic, let type = special.type {
            let downloader = viewModel.getSpecialImage(imageName: imageName, type: type)
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
        if let userID = activity.userID {
            
            let likeAction = viewModel.onLikeActivity(userID: userID)
            peopleGoingView.likeButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                peopleGoingView.toggleColorAndNumber()
            }).subscribe().addDisposableTo(peopleGoingView.bag)
            
            let hasLiked = viewModel.hasLikedActivity(activityID: userID)
            hasLiked.elements.do(onNext: { hasLiked in
                if hasLiked {
                    peopleGoingView.likeButton.tintColor = .red
                }
            }).subscribe().addDisposableTo(peopleGoingView.bag)
            hasLiked.execute()
            
            peopleGoingView.numberOfLikesButton.rx.action = viewModel.onViewLikers(userID: userID)
            
            peopleGoingView.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] _ in
                self?.viewModel.onShowProfile(userID: userID).execute()
            }).addDisposableTo(peopleGoingView.bag)
            
            let downloader = viewModel.getProfileImage(id: userID)
            downloader.elements.bind(to: peopleGoingView.imageView.rx.image).addDisposableTo(peopleGoingView.bag)
            downloader.execute()
        }
        
        // Bind labels
        peopleGoingView.numberOfLikesButton.title = "\(activity.numLikes ?? 0)"
        peopleGoingView.bottomToolbar.title = activity.userName
    
    }
}
