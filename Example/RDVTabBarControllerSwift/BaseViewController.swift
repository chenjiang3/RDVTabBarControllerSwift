//
//  BaseViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/1/24.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RDVTabBarControllerSwift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let label = UILabel()
        label.textColor = UIColor.red
        label.frame = CGRect(x: 20, y: 100, width: 200, height: 50)
        view.addSubview(label)
        label.text = "hide tabbar"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }

    func onTapAction() {
        guard let tabBarController = self.rdv_tabBarController() else {
            return
        }

        if tabBarController.tabBarHidden == true {
            tabBarController.setTabBarHidden(false, animated: true)
        } else {
            tabBarController.setTabBarHidden(true, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
