//
//  SignupViewController.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import UIKit

class SignupViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        self.navigationController?.pushViewController(MobileNumberValidationViewController.initFromNib(), animated: true)
    }
}
