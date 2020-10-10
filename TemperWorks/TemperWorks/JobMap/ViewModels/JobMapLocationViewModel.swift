//
//  JobMapLocationViewModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation
import MapKit

struct JobMapLocationViewModel {
    
    private let model: JobModel
    
    var name: String {
        model.client.name
    }
    
    var shiftTime: String {
        if !model.shifts.isEmpty {
            return "\(model.shifts[0].startTime) - \(model.shifts[0].endTime)"
        }
        return ""
    }
    
    var latitude: CLLocationDegrees {
        CLLocationDegrees(model.location.lat) ?? 0.0
    }
    
    var longitude: CLLocationDegrees {
        CLLocationDegrees(model.location.lng) ?? 0.0
    }
    
    init(model: JobModel) {
        self.model = model
    }
}
