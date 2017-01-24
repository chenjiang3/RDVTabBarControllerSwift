//
//  BaseViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/1/24.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let label = UILabel()
        label.textColor = UIColor.red
        label.frame = CGRect(x: 20, y: 40, width: 100, height: 50)
        view.addSubview(label)
        label.text = "BaseViewController"
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
