//
//  BaseViewController.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 8/10/20.
//

import UIKit

protocol UIViewControllerSetup {
    func setupViewModelListners()
    func setupUI()
}

class BaseViewController: UIViewController, UIViewControllerSetup {
    
    private var hud: PulsateHUD!
    private let alert = FloatingAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewModelListners()
        hud = PulsateHUD(frame: self.view.bounds)
        self.view.addSubview(self.hud)
    }
    
    func showHud() {
        hud.showHud()
    }
    
    func hideHud() {
        hud.hideHud()
    }
    
    func showAlert(text: String, type: FloatingAlertType) {
        alert.show(text: text, type: type)
    }
    
    func setupViewModelListners() {}
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        self.view.addSubview(alert)
    }
    
}
