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

class FeaturedViewController: UIViewController {
    
    var images = ["pic2.jpg", "pic3.jpg", "pic4.jpg", "pic5.jpg", "pic6.jpg", "pic7.jpg"]
    var titles = ["Blink 182", "DJ Tiesto Live", "Below The Line ", "Nikko & Swae ", "Jellow Shot Party", "Halloween Special Event"]
    var barNames = ["The Fat Rabbit", "Next Door", "Quill", "Rec Billiards", "The Standard Pour", "Piano Bar"]
    var dates = ["10/05/2017", "19/04/2017", "06/11/2017", "03/12/2017", "01/25/2017", "06/10/2017"]
    var descriptions = ["Come watch blink 182 Live! Event starts at 9:00 pm", "We are featuring the famouse DJ Tiesto at 11:00 pm. Buy a table and bring your friends", "Come listen to some good live country music at 7:00 pm with family and friends", "Two young DJs showing off their skills at 10:00pm", "We are having a $1 Jellow Shot party starting at 9:00pm! Bring your friends!", "Our annual Halloween custom will start at 8:00pm with $2 beers and $3 shots!"]
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var carousel: iCarousel!
    class func instantiateFromStoryboard() -> FeaturedViewController {
        let storyboard = UIStoryboard(name: "Featured", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FeaturedViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let c = preparePresenterCard()
 //       view.layout(c).horizontally(left: 20, right: 20).center()
        carousel.isPagingEnabled = true
        carousel.type = .coverFlow
        carousel.reloadData()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Extension to define ImageCard
extension FeaturedViewController {
    
    fileprivate func prepareImageView(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)?.resize(toWidth: view.width)
        return imageView
        
//        let imageView = UIImageView(frame: view.frame)
//        imageView.contentMode = UIViewContentMode.scaleAspectFill
//        imageView.image = UIImage(named: name)
        
        return imageView
    }
    
    fileprivate func prepareDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    fileprivate func prepareDateLabel() -> UILabel {
        let dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        let df = DateFormatter()
        dateLabel.text = df.string(from: Date.distantFuture)
        return dateLabel
    }
    
    fileprivate func prepareFavoriteButton() -> IconButton {
        let favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        return favoriteButton
    }
    
    fileprivate func prepareShareButton() -> IconButton {
        let shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
        return shareButton
    }
    
    fileprivate func prepareMoreButton() -> IconButton {
        let moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
        return moreButton
    }
    
    fileprivate func prepareToolbar(barName: String, date: String) -> Toolbar {
        
        let moreButton = prepareMoreButton()
        let toolbar = Toolbar(rightViews: [moreButton])
        toolbar.backgroundColor = nil
        
        toolbar.title = barName
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detail = date
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
        return toolbar
    }
    
    fileprivate func prepareContentView(description: String) -> UILabel {
        let contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = description
        contentView.font = RobotoFont.regular(with: 14)
        
        return contentView
    }
    
    fileprivate func prepareBottomBar() -> Bar {
        let favoriteButton = prepareFavoriteButton()
        let shareButton = prepareShareButton()
        let dateLabel = prepareDateLabel()
        let bottomBar = Bar(leftViews: [favoriteButton], rightViews: [shareButton], centerViews: [dateLabel])
        return bottomBar
    }
    
    fileprivate func preparePresenterCard(image: String, barName: String, date: String, description: String) -> ImageCard {
        let card = ImageCard()
        
        card.toolbar = prepareToolbar(barName: barName, date: date)
        card.toolbarEdgeInsetsPreset = .square3
        
        card.imageView = prepareImageView(name: image)
        
        card.contentView = prepareContentView(description: description)
        card.contentViewEdgeInsetsPreset = .square3
        
        card.bottomBar = prepareBottomBar()
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        return card
    }
}

// MARK: - Extension to define carousel
extension FeaturedViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let cardView = UIView(frame: carousel.frame)
        let card = preparePresenterCard(image: images[index], barName: barNames[index], date: dates[index], description: descriptions[index])
        cardView.layout(card).horizontally(left: 20, right: 20)
        
        return cardView
    }
}
