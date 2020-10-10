//
//  JobTableViewCell.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import UIKit
import RxSwift
import Nuke

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var jobCategory: UILabel!
    @IBOutlet weak var client: UILabel!
    @IBOutlet weak var shiftTime: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        earningLabel.roundCorners(corners: .topLeft, radius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(model: JobViewModel) {
        coverImage.image = nil
        client.text = ""
        jobCategory.text = ""
        shiftTime.text = ""
        earningLabel.text = ""
        
        client.text = model.clientName
        jobCategory.text = model.jobCategory.uppercased()
        shiftTime.text = model.shiftTime
        earningLabel.text = model.earningsPerHour
        if let url = URL(string: model.coverImage) {
            Nuke.loadImage(with: url, into: self.coverImage)
        }
    }
}

