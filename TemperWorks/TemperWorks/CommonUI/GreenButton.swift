//
//  GreenButton.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import UIKit

@IBDesignable
class GreenButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    internal func setup() {
        backgroundColor = UIColor(named: "AppFloatingAlertSuccessText")!
    }

}

