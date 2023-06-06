//
//  WhatsNewVC.swift
//  BeauteSoft
//
//  Created by Ashish_IOS on 1/18/19.
//  Copyright © 2019 Ashish_IOS. All rights reserved.
//

import UIKit

class WhatsNewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
