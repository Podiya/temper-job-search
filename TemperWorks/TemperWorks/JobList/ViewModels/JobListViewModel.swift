//
//  JobListViewModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class JobListViewModel: BaseViewControllerViewModel {
    
    private let jobListService: JobListServiceProtocol
    private var startingDate: Date!
    private let disposeBag = DisposeBag()
    private let formatEEEEdMMMM = "EEEE d MMMM"
    var jobsObserver = BehaviorRelay<[SectionModel<String, JobViewModel>]>(value: [])
    var isRefreshing = BehaviorSubject<Bool>(value: false)
    var jobDates = [String]()
    
    
    init(jobListService: JobListServiceProtocol = JobListService()) {
        self.jobListService = jobListService
    }
    
    func fetchJobViewModels() {
        jobListService.fetchJobs(dates: arrangeDates(start: startingDate)).subscribe { (response) in
            let all = self.jobsObserver.value  + self.arrangedJobs(response: response)
            self.publishJobs(sections: all)
        } onError: { (e) in
            self.error.on(.next(e.localizedDescription))
        }.disposed(by: disposeBag)
    }
    
    func initialFetch() {
        status.on(.next(.fetching))
        jobListService.fetchJobs(dates: arrangeDates()).subscribe { (response) in
            self.publishJobs(sections: self.arrangedJobs(response: response))
        } onError: { (e) in
            self.status.on(.next(.done))
            self.error.on(.next(e.localizedDescription))
        } onCompleted: {
            self.status.on(.next(.done))
        }.disposed(by: disposeBag)
    }
    
    func refresh() {
        isRefreshing.on(.next(true))
        jobListService.fetchJobs(dates: arrangeDates()).subscribe { (response) in
            self.publishJobs(sections: self.arrangedJobs(response: response))
        } onError: { (e) in
            self.isRefreshing.on(.next(false))
            self.error.on(.next(e.localizedDescription))
        } onCompleted: {
            self.isRefreshing.on(.next(false))
        }.disposed(by: disposeBag)
    }
    
    private func sorted(models: [SectionModel<String, JobViewModel>]) -> [SectionModel<String, JobViewModel>] {
        return models.sorted { (left, right) -> Bool in
            return left.model.toDate(format: formatEEEEdMMMM) < right.model.toDate(format: formatEEEEdMMMM)
        }
    }
    
    private func arrangeDates(start: Date = Date().addingTimeInterval(-86400)) -> String {
        let nextThreeDates = start.nextThreeDates
        startingDate = nextThreeDates.last!
        return nextThreeDates.map { $0.toString() }.joined(separator: ",")
    }
    
    private func arrangedJobs(response: APIResponseModel<[String: [JobModel]]>?) -> [SectionModel<String, JobViewModel>]{
        if let data = response?.data {
            var jobViewModels = [SectionModel<String, JobViewModel>]()
            for (key, value) in data {
                jobViewModels.append(SectionModel(model: key.toDate().toString(format: formatEEEEdMMMM), items: value.map { JobViewModel(model: $0) }))
            }
            return jobViewModels
        } else {
            return []
        }
    }
    
    private func publishJobs(sections: [SectionModel<String, JobViewModel>]) {
        self.jobsObserver.accept(self.sorted(models: sections))
    }
}
