//
//  UIImageViewExtension.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import UIKit

extension UIImageView {
    public func pulsate() {

        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .greatestFiniteMagnitude
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }
}
