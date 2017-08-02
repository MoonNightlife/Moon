//
//  BasicImageTableViewCell.swift
//  
//
//  Created by Evan Noble on 8/1/17.
//
//

import UIKit
import RxSwift
import RxCocoa

class BasicImageTableViewCell: UITableViewCell {

    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    var viewModel: BasicImageCellViewModelType! {
        didSet {
            bindViewModel()
        }
    }
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabel()
        setupImageView()
    }
    
    private func setupLabel() {
        mainLabel.font = UIFont.moonFont(size: 16)
        mainLabel.textColor = UIColor.lightGray
    }
    
    private func setupImageView() {
        mainImageView.backgroundColor = .moonGrey
        mainImageView.cornerRadius = mainImageView.frame.size.width / 2
        mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
    }
    
    func bindViewModel() {
        viewModel.mainLabelText.bind(to: mainLabel.rx.text).addDisposableTo(bag)
        viewModel.mainImage.bind(to: mainImageView.rx.image).addDisposableTo(bag)
        viewModel.accessoryButtonEnabled.bind(to: accessoryButton.rx.isEnabled).addDisposableTo(bag)
        //viewModel.accessoryButtonImage.bind(to: accessoryButton.rx.image().addDisposableTo(bag)
    }

    override func prepareForReuse() {
        bag = DisposeBag()
    }
}
