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
import SwiftOverlays

class ManageGroupViewController: UIViewController, BindableType, UITextFieldDelegate, UIScrollViewDelegate {

    // MARK: - Global
    var viewModel: ManageGroupViewModel!
    let bag = DisposeBag()
    var backButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var datePickerView: UIDatePicker!
    var indicator: UIActivityIndicatorView!
    var offSet: CGFloat!
    var keyboardHeight: CGFloat!
    var addVenueTextFieldIsActive = false
    
    let membersDataSource = RxTableViewSectionedReloadDataSource<GroupMemberSectionModel>()
    let suggestedVenuesDataSource = RxTableViewSectionedAnimatedDataSource<SearchSnapshotSectionModel>()
    let venuesDataSource = RxTableViewSectionedReloadDataSource<PlanOptionSectionModel>()
    
    @IBOutlet weak var groupPicture: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var groupPlan: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likersButton: UIButton!
    @IBOutlet weak var planEndTime: TextField!
    @IBOutlet weak var startPlanButton: UIButton!
    @IBOutlet weak var addVenueTextField: TextField!
    @IBOutlet weak var addVenueButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
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
        prepareGroupNameLabel()
        configureDataSource()
        setupActivityIndicator()
        prepareScrollView()
        prepareDatePickerView()
        prepareSuggestedTableView()
        resgisterCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadGroup.onNext()
        viewModel.reloadMembers.onNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Make sure overlay is removed
        SwiftOverlays.removeAllBlockingOverlays()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if addVenueTextFieldIsActive {
            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame: NSValue = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            calculateOffset()
            moveScrollViewUP()
        }
    }
    
    func calculateOffset() {
        let screenHeight = self.view.frame.size.height
        let bioY = screenHeight - suggestedVenuesTableView.y
        let keyboardShift = keyboardHeight - bioY
        let extraShift = suggestedVenuesTableView.frame.size.height - CGFloat(100)
        
        offSet = -(extraShift + keyboardShift)
    }

    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        editButton.rx.action = viewModel.onEdit()
        likeButton.rx.action = viewModel.onLikePlan()
        likersButton.rx.action = viewModel.onViewLikers()
        startPlanButton.rx.action = viewModel.onStartPlan()
        addVenueButton.rx.action = viewModel.onAddVenue()
        groupPlan.rx.action = viewModel.onViewPlanBar()
        
        viewModel.showSearchLoadingIndicator.asObservable().subscribe(onNext: { [weak self] in
            if $0 {
                self?.indicator.startAnimating()
            } else {
                self?.indicator.stopAnimating()
            }
        }).addDisposableTo(bag)
        
        viewModel.showBlockingLoadingIndicator.asObservable()
            .subscribe(onNext: {
                if $0 {
                    SwiftOverlays.showBlockingWaitOverlay()
                } else {
                    SwiftOverlays.removeAllBlockingOverlays()
                }
            })
            .addDisposableTo(bag)
        viewModel.showActivityHeartAndNumber.map(!).bind(to: likeButton.rx.isHidden).addDisposableTo(bag)
        viewModel.showActivityHeartAndNumber.map(!).bind(to: likersButton.rx.isHidden).addDisposableTo(bag)
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
        
        viewModel.displayMembers
            .bind(to: membersTableView.rx.items(dataSource: membersDataSource))
            .addDisposableTo(bag)
        
        viewModel.displayOptions.bind(to: venuesTableView.rx.items(dataSource: venuesDataSource)).addDisposableTo(bag)
        viewModel.venueSearchResults.bind(to: suggestedVenuesTableView.rx.items(dataSource: suggestedVenuesDataSource)).addDisposableTo(bag)
    
        datePickerView.rx.countDownDuration.bind(to: viewModel.endTime).addDisposableTo(bag)
        viewModel.limitedEndTime.bind(to: datePickerView.rx.countDownDuration).addDisposableTo(bag)
        
        suggestedVenuesTableView.rx.modelSelected(SearchSnapshotSectionModel.Item.self)
            .do(onNext: { [weak self] _ in
                guard let selectedIndexPath = self?.suggestedVenuesTableView.indexPathForSelectedRow else {
                    return
                }
                self?.suggestedVenuesTableView.deselectRow(at: selectedIndexPath, animated: true)
            })
            .bind(to: viewModel.selectedVenue)
            .addDisposableTo(bag)
        
        addVenueTextField.rx.textInput.text.orEmpty.bind(to: viewModel.venueSearchText).addDisposableTo(bag)
        membersTableView.rx.modelSelected(GroupMemberSectionModel.Item.self).map({$0.id})
            .do(onNext: { [weak self] _ in
                guard let selectedIndexPath = self?.membersTableView.indexPathForSelectedRow else {
                    return
                }
                self?.membersTableView.deselectRow(at: selectedIndexPath, animated: true)
                self?.planEndTime.resignFirstResponder()
            })
            .filterNil()
            .bind(to: viewModel.onViewProfile.inputs)
            .addDisposableTo(bag)
        
        venuesTableView.rx.modelSelected(PlanOptionSectionModel.Item.self).map({$0.barID})
            .filterNil()
            .do(onNext: { [weak self] _ in
                guard let selectedIndexPath = self?.venuesTableView.indexPathForSelectedRow else {
                    return
                }
                self?.venuesTableView.deselectRow(at: selectedIndexPath, animated: true)
            })
            .bind(to: viewModel.onViewVenue.inputs)
            .addDisposableTo(bag)
    }
    
    private func resgisterCells() {
        let nib = UINib(nibName: "BasicImageCell", bundle: nil)
        membersTableView.register(nib, forCellReuseIdentifier: "BasicImageCell")
    }
    
    fileprivate func prepareDatePickerView() {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .countDownTimer
        
        planEndTime.rx.controlEvent(.editingDidBegin)
            .do(onNext: {
                // This hack fixes the iOS bug with the date picker
                // https://stackoverflow.com/questions/19251803/objective-c-uidatepicker-uicontroleventvaluechanged-only-fired-on-second-select
                DispatchQueue.main.async {
                    var dateComp = DateComponents()
                    dateComp.second = Int(self.datePickerView.countDownDuration)
                    let date = Calendar.current.date(from: dateComp)
                    self.datePickerView.setDate(date!, animated: false)
                }
            })
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
                var voteButton = IconButton()
                let image = (item.userVoted ?? false) ? Icon.cm.star?.tint(with: .red) : Icon.cm.star?.tint(with: .lightGray)
                voteButton.image = image
                voteButton.rx.action = strongSelf.viewModel.onVote(barID: barID)
                cell.accessoryView = voteButton
                voteButton.sizeToFit()
            }
            
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.text = item.barName
            cell.detailTextLabel?.text = "\(item.voteCount ?? 0)"
            
            return cell
        }
        
        suggestedVenuesDataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "venueResultCell")
            
            switch item {
            case let .searchResult(snapshot):
                cell.textLabel?.textColor = .lightGray
                cell.textLabel?.text = snapshot.name
                return cell
                
            case .loading:
                self?.indicator.center = cell.contentView.center
                if let strongSelf = self {
                    cell.contentView.addSubview(strongSelf.indicator)
                }
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
        groupPicture.backgroundColor = .moonGrey
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
        planEndTime.placeholder = "Set Timer"
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
    
    func setupActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
    }
    
    func prepareScrollView() {
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
    }
    
    func prepareSuggestedTableView() {
        suggestedVenuesTableView.layer.cornerRadius = 5
        suggestedVenuesTableView.layer.borderWidth = 1
        suggestedVenuesTableView.layer.borderColor = UIColor.lightGray.cgColor
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
            addVenueTextFieldIsActive = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == addVenueTextField {
            animateVenuesViewUp()
            addVenueTextFieldIsActive = false
        }
    }

    func animatePlanViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.planViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        })
        
    }
    
    func animatePlanViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.planViewHeightConstraint.constant = 180
            self.view.layoutIfNeeded()
        })
        
    }
    
    func moveScrollViewUP() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = 50 //self.offSet
            self.scrollView.layoutIfNeeded()
        })
    }
    
    func moveScrollViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = 0 //self.scrollView.y
            self.scrollView.layoutIfNeeded()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addVenueTextField.resignFirstResponder()
        self.moveScrollViewDown()

        return true
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
