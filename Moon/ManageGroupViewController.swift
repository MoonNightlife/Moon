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
import RxSwift
import RxCocoa
import RxDataSources

class ManageGroupViewController: UIViewController, BindableType, UITextFieldDelegate {

    // MARK: - Global
    var viewModel: ManageGroupViewModel!
    let bag = DisposeBag()
    var backButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var datePickerView: UIDatePicker!
    
    let membersDataSource = RxTableViewSectionedReloadDataSource<GroupMemberSectionModel>()
    let suggestedVenuesDataSource = RxTableViewSectionedAnimatedDataSource<SearchSnapshotSectionModel>()
    let venuesDataSource = RxTableViewSectionedReloadDataSource<PlanOptionSectionModel>()
    
    @IBOutlet weak var groupPicture: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var groupPlan: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likersButton: UIButton!
    @IBOutlet weak var planEndTime: TextField!
    @IBOutlet weak var startPlanButton: UIButton!
    @IBOutlet weak var addVenueTextField: TextField!
    @IBOutlet weak var addVenueButton: UIButton!
    
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var suggestedVenuesTableView: UITableView!
    @IBOutlet weak var venuesTableView: UITableView!
    
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
        prepareDatePickerView()
        prepareGroupNameLabel()
        configureDataSource()
        
        resgisterCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadMembers.onNext()
    }

    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        editButton.rx.action = viewModel.onEdit()
        likeButton.rx.action = viewModel.onLikePlan()
        likersButton.rx.action = viewModel.onViewLikers()
        startPlanButton.rx.action = viewModel.onStartPlan()
        addVenueButton.rx.action = viewModel.onAddVenue()
        groupPlan.rx.action = viewModel.onViewPlanBar()
        
        viewModel.groupImage.bind(to: groupPicture.rx.image).addDisposableTo(bag)
        viewModel.groupName.bind(to: groupNameLabel.rx.text).addDisposableTo(bag)
        viewModel.endTimeString.bind(to: planEndTime.rx.text).addDisposableTo(bag)
        viewModel.currentPlanBarName.bind(to: groupPlan.rx.title()).addDisposableTo(bag)
        viewModel.currentPlanNumberOfLikes.bind(to: likersButton.rx.title()).addDisposableTo(bag)
        viewModel.selectedVenueText.bind(to: addVenueTextField.rx.text).addDisposableTo(bag)
        viewModel.planInProcess
            .subscribe(onNext: { [weak self] inProgress in
                if inProgress {
                    self?.showPlan()
                }
            })
            .addDisposableTo(bag)
        viewModel.hasLikedGroupPlan
            .subscribe(onNext: { [weak self] hasLiked in
                self?.likeButton.tintColor = hasLiked ? .red : .lightGray
            })
            .addDisposableTo(bag)
        viewModel.displayMembers.bind(to: membersTableView.rx.items(dataSource: membersDataSource)).addDisposableTo(bag)
        viewModel.displayOptions.bind(to: venuesTableView.rx.items(dataSource: venuesDataSource)).addDisposableTo(bag)
        viewModel.venueSearchResults.bind(to: suggestedVenuesTableView.rx.items(dataSource: suggestedVenuesDataSource)).addDisposableTo(bag)
        
        datePickerView.rx.countDownDuration.bind(to: viewModel.endTime).addDisposableTo(bag)
        viewModel.limitedEndTime.skip(1).bind(to: datePickerView.rx.countDownDuration).addDisposableTo(bag)
        
        suggestedVenuesTableView.rx.modelSelected(SearchSnapshotSectionModel.Item.self).bind(to: viewModel.selectedVenue).addDisposableTo(bag)
        addVenueTextField.rx.textInput.text.orEmpty.bind(to: viewModel.venueSearchText).addDisposableTo(bag)
        membersTableView.rx.modelSelected(GroupMemberSectionModel.Item.self).map({$0.id}).filterNil().bind(to: viewModel.onViewProfile.inputs).addDisposableTo(bag)
        venuesTableView.rx.modelSelected(PlanOptionSectionModel.Item.self).map({$0.barID}).filterNil().bind(to: viewModel.onViewVenue.inputs).addDisposableTo(bag)
    }
    
    private func resgisterCells() {
        let nib = UINib(nibName: "BasicImageCell", bundle: nil)
        membersTableView.register(nib, forCellReuseIdentifier: "BasicImageCell")
    }
    
    fileprivate func prepareDatePickerView() {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .countDownTimer
        
        var dateComp = DateComponents()
        dateComp.hour = 1
        dateComp.minute = 1
        let date = Calendar.current.date(from: dateComp)
        datePickerView.setDate(date!, animated: false)
        
        planEndTime.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.planEndTime.inputView = self.datePickerView
            })
            .addDisposableTo(bag)
    }
    
    func configureDataSource() {
        membersDataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            guard let strongSelf = self else {
                return UITableViewCell()
            }
            
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicImageCell", for: indexPath) as! BasicImageTableViewCell
            cell.viewModel = strongSelf.viewModel.viewModelForCell(groupMemberSnapshot: item)
            
            return cell
        }
        
        venuesDataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "venueCell")
            
            if let barID = item.barID, let strongSelf = self {
                var voteButton = IconButton(image: Icon.cm.star, tintColor: .red)
                voteButton.rx.action = strongSelf.viewModel.onVote(barID: barID)
                cell.accessoryView = voteButton
                voteButton.sizeToFit()
            }
            
            cell.textLabel?.text = item.barName
            cell.detailTextLabel?.text = "\(item.voteCount ?? 0)"
            
            return cell
        }
        
        suggestedVenuesDataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "venueResultCell")
            
            switch item {
            case let .searchResult(snapshot):
                cell.textLabel?.text = snapshot.name
                return cell
            default:
                return cell
            }
        }
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func prepareGroupNameLabel() {
        groupNameLabel.textColor = .lightGray
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
        planEndTime.isClearIconButtonEnabled = false
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
        planEndTime.resignFirstResponder()
        showPlan()
    }
    
    private func showPlan() {
        startPlanButton.isHidden = true
        planEndTime.isHidden = true
        addVenueButton.isHidden = false
        addVenueTextField.isHidden = false
        animatePlanViewDown()
    }
}

extension ManageGroupViewController: UIPopoverPresentationControllerDelegate, PopoverPresenterType {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        viewModel.onBack().execute()
        return false
    }
    
    func didDismissPopover() {
        
    }
}
