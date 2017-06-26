//
//  SpecialsViewController.swift
//  
//
//  Created by Evan Noble on 5/10/17.
//
//

import UIKit
import RxDataSources
import RxSwift

class SpecialsViewController: UIViewController, BindableType {
    
    let specialCellIdenifier = "SpecialCell"
    var viewModel: SpecialsViewModel!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedAnimatedDataSource<SpecialSection>()
    
    @IBOutlet weak var specialsTableView: UITableView!
    class func instantiateFromStoryboard() -> SpecialsViewController {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SpecialsViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.specials.execute()
    }

    func bindViewModel() {
        viewModel.specials.elements.bind(to: specialsTableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
    }
    
    func configureDataSource() {
        dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.specialCellIdenifier, for: indexPath) as! SpecialTableViewCell
            if let strongSelf = self {
                cell.initilizeSpecialCellWith(data: item, likeAction: strongSelf.viewModel.onLike(specialID: item.id!), downloadImage: strongSelf.viewModel.downloadImage(url: URL(string: item.pic!)!))
            }
            return cell
        }
    }

}
