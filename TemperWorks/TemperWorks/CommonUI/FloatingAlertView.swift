//
//  FloatingAlertView.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import UIKit

enum FloatingAlertType {
    case success
    case error
    
    var fontColor: UIColor {
        switch self {
        case .success:
            return UIColor(named: "AppFloatingAlertSuccessText") ?? UIColor.black
        case .error:
            return UIColor(named: "AppFloatingAlertErrorText") ?? UIColor.black
        }
    }
}

class FloatingAlertView: UIView {
    private let childView = UIView()
    private let textLabel = UILabel()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 25, width: UIScreen.main.bounds.width, height: 60))
        self.layer.opacity = 0
        childView.backgroundColor = .white
        childView.layer.cornerRadius = 14
        self.addSubview(childView)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        childView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        childView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        
        textLabel.text = ""
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textLabel.numberOfLines = 0
        childView.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: childView.leadingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: childView.trailingAnchor, constant: -10).isActive = true
        textLabel.topAnchor.constraint(equalTo: childView.topAnchor, constant: 10).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(text: String, type: FloatingAlertType) {
        DispatchQueue.main.async {
            self.textLabel.text = text
            self.textLabel.textColor = type.fontColor
            UIView.animate(withDuration: 0.6, animations: {
                self.layer.opacity = 1
            }) { (done) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.6) {
                        self.layer.opacity = 0
                    }
                }
            }
        }
    }
}
