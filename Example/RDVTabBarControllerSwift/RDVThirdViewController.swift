//
//  RDVThirdViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/2/3.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class RDVThirdViewController: UITableViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Third"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBar = self.rdv_tabBarController?.tabBar, tabBar.translucent == true {
            let insets = UIEdgeInsets(top: 0, left: 0,
                                      bottom: tabBar.frame.height,
                                      right: 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return .portrait
        }
    }

    func configureCell(_ cell: UITableViewCell, forIndexPath indexPath: IndexPath) {
        cell.textLabel?.text = "\(self.title!) Controller Cell \(indexPath.row)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            configureCell(cell, forIndexPath: indexPath)
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            configureCell(cell, forIndexPath: indexPath)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = RDVDetailsViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
