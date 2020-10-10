//
//  JobViewModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation

struct JobViewModel {
    
    private let model: JobModel
    var clientName: String {
        model.client.name
    }
    var shiftTime: String {
        if !model.shifts.isEmpty {
            return "\(model.shifts[0].startTime) - \(model.shifts[0].endTime)"
        }
        return ""
    }
    var coverImage: String {
        model.client.photos.first?.formats.first?.cdnURL ?? ""
        
    }
    var jobCategory: String {
        model.jobCategory.jobCategoryDescription
    }
    var earningsPerHour: String {
        if !model.shifts.isEmpty {
            return "$ \(String(format: "%.2f", model.shifts[0].earningsPerHour))"
        }
        return ""
    }
    
    init(model: JobModel) {
        self.model = model
    }
}
