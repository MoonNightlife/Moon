//
//  ManageGroupViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action

class ManageGroupViewController: UIViewController, BindableType, UITextFieldDelegate {

    // MARK: - Global
    var viewModel: ManageGroupViewModel!
    var backButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    @IBOutlet weak var groupPicture: UIImageView!
    @IBOutlet var groupNameLabel: UIView!
    @IBOutlet weak var groupPlan: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likersButton: UIButton!
    @IBOutlet weak var planEndTime: TextField!
    @IBOutlet weak var startPlanButton: UIButton!
    @IBOutlet weak var addVenueTextField: TextField!
    @IBOutlet weak var addVenueButton: UIButton!
    
    @IBOutlet weak var planViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestedVenuesHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareEditButton()
        prepareLikesButton()
        prepareGroupPlanButton()
        prepareGroupPicture()
        prepareAddVenueButton()
        prepareAddVenueTextField()
        prepareStartPlanButton()
        prepareEndTimeTextField()
    }

    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        editButton.rx.action = viewModel.onEdit()
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func prepareEditButton() {
        editButton = UIBarButtonItem()
        editButton.image = Icon.cm.edit
        editButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = editButton
    }
    
     func prepareGroupPlanButton() {
        groupPlan.tintColor = .lightGray
        groupPlan.titleLabel?.font = UIFont(name: "Roboto", size: 15)
    }
    
     func prepareLikesButton() {
        likersButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
        likersButton.tintColor = .lightGray
        likersButton.setTitle("100", for: .normal)
        
        let image =  Icon.favorite
        likeButton.setBackgroundImage(image, for: .normal)
        likeButton.tintColor = .lightGray
    }
    
    func prepareGroupPicture() {
        groupPicture.isUserInteractionEnabled = true
        groupPicture.layer.cornerRadius = groupPicture.frame.size.height  / 2
        groupPicture.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        groupPicture.contentMode = UIViewContentMode.scaleAspectFill
        groupPicture.clipsToBounds = true
    }
    
    func prepareAddVenueTextField() {
        addVenueTextField.placeholder = "Venue Name"
        addVenueTextField.isClearIconButtonEnabled = true
        addVenueTextField.placeholderActiveColor = .moonBlue
        addVenueTextField.dividerActiveColor = .moonBlue
        addVenueTextField.dividerNormalColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        addVenueTextField.leftView = leftView
        addVenueTextField.leftViewActiveColor = .moonBlue
        addVenueTextField.delegate = self
        addVenueTextField.isHidden = true
    }
    
    func prepareAddVenueButton() {
        addVenueButton.backgroundColor = .moonGreen
        addVenueButton.cornerRadius = 5
        addVenueButton.tintColor = .white
        addVenueButton.isHidden = true
    }
    
    func prepareEndTimeTextField() {
        planEndTime.placeholder = "Set Voting End Time"
        planEndTime.isClearIconButtonEnabled = true
        planEndTime.placeholderActiveColor = .moonBlue
        planEndTime.dividerActiveColor = .moonBlue
        planEndTime.dividerNormalColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        planEndTime.leftView = leftView
        planEndTime.leftViewActiveColor = .moonBlue
        planEndTime.delegate = self
    }
    
    func prepareStartPlanButton() {
        startPlanButton.backgroundColor = .moonGreen
        startPlanButton.cornerRadius = 5
        startPlanButton.tintColor = .white
    }
    
    func animateVenuesViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.suggestedVenuesHeightConstraint.constant = 100
            self.view.layoutIfNeeded()
        })
        
    }
    
    func animateVenuesViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.suggestedVenuesHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addVenueTextField {
            animateVenuesViewDown()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == addVenueTextField {
            animateVenuesViewUp()
        }
    }
    
    func animatePlanViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.planViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func animatePlanViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.planViewHeightConstraint.constant = 220
            self.view.layoutIfNeeded()
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addVenueTextField.resignFirstResponder()
        planEndTime.resignFirstResponder()
    }
    
    @IBAction func startPlabButtonPressed(_ sender: Any) {
        startPlanButton.isHidden = true
        planEndTime.isHidden = true
        addVenueButton.isHidden = false
        addVenueTextField.isHidden = false
        animatePlanViewDown()
    }
}
