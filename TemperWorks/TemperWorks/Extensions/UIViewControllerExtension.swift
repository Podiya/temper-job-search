//
//  UIViewControllerExtension.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}
