//
//  APIResponseModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import Foundation

struct APIResponseModel<T: Codable>: Codable {
    let data: T
}
