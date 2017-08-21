//
//  CreateEditGroupViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action
import Fusuma
import RxDataSources
import RxSwift
import RxCocoa
import SwiftOverlays

class CreateEditGroupViewController: UIViewController, BindableType, FusumaDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - Global
    var viewModel: CreateEditGroupViewModel!
    var backButton: UIBarButtonItem!
    let imagePicker = UIImagePickerController()
    let fusuma = FusumaViewController()
    let tap = UITapGestureRecognizer()
    var offSet: CGFloat!
    var keyboardHeight: CGFloat!
    var addMemberTextFieldIsActive = false
    var membersDataSource = RxTableViewSectionedReloadDataSource<GroupMemberSectionModel>()
    var friendSearchResultsDataSource = RxTableViewSectionedReloadDataSource<SearchSnapshotSectionModel>()
    var bag = DisposeBag()

    @IBOutlet weak var suggestedMembersView: UIView!
    @IBOutlet weak var groupPicture: UIImageView!
    @IBOutlet weak var groupNameTextField: ErrorTextField!
    @IBOutlet weak var addMemberTextField: TextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var userSearchResultsTableView: UITableView!
    
    @IBOutlet weak var suggestedMemberViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBackButton()
        prepareGroupNameTextField()
        prepareAddMemberTextField()
        prepareGroupPicture()
        prepareAddButton()
        prepareScrollView()
        prepareSuggestedMemberView()
        configureDataSource()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if addMemberTextFieldIsActive {
            animateViewUp()
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
        let bioY = screenHeight - suggestedMembersView.y
        let keyboardShift = keyboardHeight - bioY
        let extraShift = CGFloat(10) + suggestedMembersView.frame.size.height
        
        offSet = -(extraShift + keyboardShift)
    }
    
    func bindViewModel() {
        viewModel.displayUsers.bind(to: membersTableView.rx.items(dataSource: membersDataSource)).addDisposableTo(bag)
        viewModel.friendSearchResults.bind(to: userSearchResultsTableView.rx.items(dataSource: friendSearchResultsDataSource)).addDisposableTo(bag)
        
        membersTableView.rx.itemDeleted
            .map({ [unowned self] indexPath -> GroupMemberSnapshot? in
                try? self.membersTableView.rx.model(at: indexPath)
            })
            .filterNil()
            .map { $0.id }
            .filterNil()
            .bind(to: viewModel.onRemoveUser.inputs)
            .addDisposableTo(bag)
        
        userSearchResultsTableView.rx.modelSelected(SearchSnapshotSectionModel.Item.self).bind(to: viewModel.selectedFriend).addDisposableTo(bag)
        
        // Save button turns to leave button when editing a group
        saveButton.rx.action = viewModel.getActionForBottomButton()
        viewModel.onSave.executing
            .subscribe(onNext: { [weak self] executing in
                if executing {
                    self?.showWaitOverlayWithText("Creating Group")
                } else {
                    self?.removeAllOverlays()
                }
            })
            .addDisposableTo(bag)
        
        viewModel.onSave.errors
            .subscribe(onNext: {
                if case let .underlyingError(error) = $0 {
                    print(error)
                }
            })
            .addDisposableTo(bag)
        
        addButton.rx.action = viewModel.onAddUser
        backButton.rx.action = viewModel.onBack()
        
        groupNameTextField.rx.controlEvent(UIControlEvents.editingDidEnd)
            .map({ [weak self] _ in
                return self?.groupNameTextField.text
            })
            .filterNil()
            .map {$0.trimmed}
            .bind(to: viewModel.updateName.inputs)
            .addDisposableTo(bag)
        
        viewModel.showNameErrorMessage.bind(to: groupNameTextField.rx.isErrorRevealed).addDisposableTo(bag)
        
        viewModel.updateName.executionObservables
            .flatMap({ [weak self] in
                return $0.do(onNext: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    let view = UIView(frame: CGRect(x: 0, y: strongSelf.navigationController!.navigationBar.frame.height, width: strongSelf.view.frame.width, height: 30))
                    view.backgroundColor = .moonGrey
                    
                    let textField = UITextField(frame: view.bounds)
                    textField.textAlignment = .center
                    textField.text = "Group name updated"
                    textField.textColor = .lightGray
                    textField.font = UIFont.moonFont(size: 16)
                    
                    view.addSubview(textField)
                    
                    SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(view, duration: 3.0)
                })
            })
            .subscribe()
            .addDisposableTo(bag)
        
        backButton.image = viewModel.showBackArrow ? Icon.cm.arrowBack : Icon.cm.arrowDownward
        changeBottonButton(type: viewModel.bottomButtonStyle)
        
        viewModel.selectedFriendText.bind(to: addMemberTextField.rx.text).addDisposableTo(bag)
        viewModel.groupNameText.bind(to: groupNameTextField.rx.text).addDisposableTo(bag)
        addMemberTextField.rx.textInput.text.bind(to: viewModel.friendSearchText).addDisposableTo(bag)
        groupNameTextField.rx.textInput.text.map {$0?.trimmed}.bind(to: viewModel.groupName).addDisposableTo(bag)
        
        viewModel.groupImage.bind(to: groupPicture.rx.image).addDisposableTo(bag)
    }
    
    private func changeBottonButton(type: CreateEditGroupBottomButtonType) {
        
        saveButton.layer.cornerRadius = 5
        
        switch type {
        case .leave:
            saveButton.backgroundColor = .red
            saveButton.setTitle("Leave", for: .normal)
            saveButton.tintColor = .white
        case .save:
            saveButton.backgroundColor = .moonGreen
            saveButton.setTitle("Create", for: .normal)
            saveButton.tintColor = .white
        }
    }
    
    func prepareNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
        backButton = UIBarButtonItem()
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func prepareSuggestedMemberView() {
        suggestedMembersView.layer.borderWidth = 1
        suggestedMembersView.layer.cornerRadius = 5
        suggestedMembersView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func prepareGroupNameTextField() {
        groupNameTextField.placeholder = "Group Name"
        groupNameTextField.detail = "Invalid Name"
        groupNameTextField.isClearIconButtonEnabled = true
        groupNameTextField.placeholderActiveColor = .moonBlue
        groupNameTextField.dividerActiveColor = .moonBlue
        groupNameTextField.dividerNormalColor = .moonBlue
        
        groupNameTextField.returnKeyType = .done
            
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        groupNameTextField.leftView = leftView
        groupNameTextField.leftViewActiveColor = .moonBlue
        groupNameTextField.delegate = self
    }
    
    func prepareAddMemberTextField() {
        addMemberTextField.placeholder = "Member Name"
        addMemberTextField.isClearIconButtonEnabled = true
        addMemberTextField.placeholderActiveColor = .moonBlue
        addMemberTextField.dividerActiveColor = .moonBlue
        addMemberTextField.dividerNormalColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        addMemberTextField.leftView = leftView
        addMemberTextField.leftViewActiveColor = .moonBlue
        addMemberTextField.delegate = self
    }
    
    func prepareAddButton() {
        addButton.backgroundColor = .moonGreen
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 5
    }
    
    func prepareScrollView() {
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
    }
    
    func prepareFusuma() {
        fusuma.delegate = self
        fusuma.hasVideo = false
        fusumaTintColor = .moonPurple
        fusumaBaseTintColor = .moonPurple
        fusumaBackgroundColor = .white
        fusumaCropImage = true
        fusuma.cropHeightRatio = CGFloat(1)
        fusuma.allowMultipleSelection = false
    }
    
    @objc fileprivate func imageTouched() {
        prepareFusuma()
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func prepareGroupPicture() {
        groupPicture.backgroundColor = .moonGrey
        groupPicture.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(imageTouched))
        groupPicture.addGestureRecognizer(tap)
        groupPicture.layer.cornerRadius = groupPicture.frame.size.height  / 2
        groupPicture.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        groupPicture.contentMode = UIViewContentMode.scaleAspectFill
        groupPicture.clipsToBounds = true
    }
    
    // MARK: FUSUMA DELEGATES for image cropping
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        groupPicture.image = image
        viewModel.newGroupImage.value = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Multiple Images Selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func animateViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.suggestedMemberViewHeightConstraint.constant = 150
            self.view.layoutIfNeeded()
        })
        
    }
    
    func animateViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.suggestedMemberViewHeightConstraint.constant = 0
            //self.view.layoutIfNeeded()
        })
        
    }
    
    func moveScrollViewUP() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = self.offSet
            self.scrollView.layoutIfNeeded()
        })
    }
    
    func moveScrollViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.scrollView.contentOffset.y = 0 //self.scrollView.y
            self.scrollView.layoutIfNeeded()
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addMemberTextField {
             addMemberTextFieldIsActive = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == addMemberTextField {
             addMemberTextFieldIsActive = false
            animateViewDown()
            moveScrollViewDown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addMemberTextField.resignFirstResponder()
        groupNameTextField.resignFirstResponder()
        self.moveScrollViewDown()
        self.animateViewDown()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addMemberTextField.resignFirstResponder()
        groupNameTextField.resignFirstResponder()
    }
    
    fileprivate func configureDataSource() {
        
        membersTableView.rx.setDelegate(self).addDisposableTo(bag)
        membersTableView.setEditing(true, animated: false)
        
        membersDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "memberCell")
            
            cell.textLabel?.text = item.name
            cell.textLabel?.textColor = .lightGray
            
            return cell
        }
        
        membersDataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        friendSearchResultsDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "friendResultCell")
            
            switch item {
            case let .searchResult(snapshot):
                cell.textLabel?.text = snapshot.name
                cell.textLabel?.textColor = .lightGray
                return cell
            default:
                return cell
            }
        }
    }
    
}

extension CreateEditGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
}
