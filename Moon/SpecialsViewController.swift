//
//  SpecialsViewController.swift
//  
//
//  Created by Evan Noble on 5/10/17.
//
//

import UIKit

class SpecialsViewController: UIViewController, BindableType {
    
    let specialCellIdenifier = "SpecialCell"
    var specialData = [Special]()
    var viewModel: SpecialsViewModel!
    
    @IBOutlet weak var specialsTableView: UITableView!
    class func instantiateFromStoryboard() -> SpecialsViewController {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SpecialsViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        specialsTableView.reloadData()
    }

    func bindViewModel() {
        
    }

}

extension SpecialsViewController: UITableViewDelegate {
    
}

extension SpecialsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: specialCellIdenifier, for: indexPath) as! SpecialTableViewCell
        cell.initilizeSpecialCellWith(data: specialData[indexPath.row])
        return cell
    }
}
