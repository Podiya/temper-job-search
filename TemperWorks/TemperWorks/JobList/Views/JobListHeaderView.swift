//
//  JobListHeaderView.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import UIKit

class JobListHeaderView: UIView {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        self.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: frame.width - 30, height: 40)
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.backgroundColor = .white
        label.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
