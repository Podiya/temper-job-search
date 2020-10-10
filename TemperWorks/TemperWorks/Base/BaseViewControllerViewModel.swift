//
//  BaseViewControllerViewModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation
import RxSwift

enum Status {
    case fetching
    case done
}


class BaseViewControllerViewModel {
    var status = BehaviorSubject<Status>(value: Status.done)
    var error = BehaviorSubject<String>(value: "")
}
