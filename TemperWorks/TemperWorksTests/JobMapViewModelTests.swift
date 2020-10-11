//
//  JobMapViewModelTests.swift
//  TemperWorksTests
//
//  Created by Ravindu Senevirathna on 11/10/20.
//

import XCTest
import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import TemperWorks


class JobMapViewModelTests: XCTestCase {

    private var viewModel: JobMapViewModel!
    private var jobModels: [JobModel]!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var jobMapLocationViewModelBehaviorRelay: BehaviorRelay<[JobMapLocationViewModel]>!

    override func setUpWithError() throws {
        self.viewModel = JobMapViewModel(jobMapService: JobMapService())
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.jobMapLocationViewModelBehaviorRelay = .init(value: [])
        
        let jsonData = loadJson(name: "jobs", ext: "json")
        let decoder = JSONDecoder()
        var apiResponse: APIResponseModel<[String: [JobModel]]>!
        do {
            apiResponse = try decoder.decode(APIResponseModel<[String: [JobModel]]>.self, from: jsonData)
        } catch {
            print(error)
        }
        jobModels = apiResponse.data["2020-10-11"]
    }

    override func tearDownWithError() throws {
    }
    
    func testFetchJobs() {
        scheduler
            .createColdObservable([.next(10, jobModels.map { JobMapLocationViewModel(model: $0) })])
               .bind(to: jobMapLocationViewModelBehaviorRelay)
               .disposed(by: disposeBag)
        
        
        let observer = scheduler
            .record(
                viewModel.jobsObserver.asObservable(),
                disposeBag: disposeBag)
        
        scheduler.start()
        self.viewModel.fetchJobs(by: Date())
        print("scheduler.started")
        print(observer.events)
    }
}


