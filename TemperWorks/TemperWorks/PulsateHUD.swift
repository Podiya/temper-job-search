//
//  PulsateHUD.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import UIKit

class PulsateHUD: UIView {
    private var effectView: UIVisualEffectView!
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    private let logoView = UIImageView(image: UIImage(named: "logo"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.effectView = UIVisualEffectView(effect: blurEffect)
        self.isHidden = true
        self.effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(effectView)
        self.bringSubviewToFront(effectView)
        
        self.effectView.contentView.addSubview(logoView)
        
        self.effectView.frame = self.bounds
        logoView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        logoView.center = self.effectView.center
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func showHud() {
        DispatchQueue.main.async {
            self.isHidden = false
            self.logoView.pulsate()
        }
    }
    
    func hideHud() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
}
