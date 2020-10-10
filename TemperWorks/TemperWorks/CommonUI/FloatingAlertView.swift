//
//  FloatingAlertView.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import UIKit
import SnapKit

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
        
        childView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(10)
        }
        
        textLabel.text = ""
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textLabel.numberOfLines = 0
        childView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(childView.snp.leading).offset(10)
            make.trailing.equalTo(childView.snp.trailing).offset(-10)
            make.top.equalTo(childView.snp.top).offset(10)
            make.bottom.equalTo(childView.snp.bottom).offset(-10)
        }
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
