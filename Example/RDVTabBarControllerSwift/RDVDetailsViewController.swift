//
//  RDVDetailsViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/2/3.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RDVTabBarControllerSwift

class RDVDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"

        self.view.backgroundColor = UIColor(red: 250 / 255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)

        let label = UILabel()
        label.text = "Detail View Controller"
        label.frame = CGRect(x: 20, y: 150, width: self.view.frame.width - 2 * 20, height: 20)
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        self.view.addSubview(label)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rdv_tabBarController?.setTabBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rdv_tabBarController?.setTabBarHidden(false, animated: true)
    }

}
