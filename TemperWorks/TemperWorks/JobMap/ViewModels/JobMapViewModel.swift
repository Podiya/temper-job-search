//
//  JobMapViewModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation
import RxCocoa
import RxSwift

class JobMapViewModel: BaseViewControllerViewModel {
    
    private let jobMapService: JobMapServiceProtocol
    private let disposeBag = DisposeBag()
    var jobsObserver = BehaviorRelay<[JobMapLocationViewModel]>(value: [])
    
    init(jobMapService: JobMapServiceProtocol = JobMapService()) {
        self.jobMapService = jobMapService
    }
    
    func fetchJobs(by date: Date) {
        status.on(.next(.fetching))
        let date = date.toString()
        jobMapService.fetchJobs(date: date).subscribe { response in
            if let data = response?.data, let items = data[date] {
                self.jobsObserver.accept(items.map { JobMapLocationViewModel(model: $0 )})
            }
        } onError: { error in
            self.status.on(.next(.done))
            self.error.on(.next(error.localizedDescription))
        } onCompleted: {
            self.status.on(.next(.done))
        }.disposed(by: disposeBag)
        
    }
}
