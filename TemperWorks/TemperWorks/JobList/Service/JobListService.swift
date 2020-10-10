//
//  JobListService.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import Foundation
import RxSwift

protocol JobListServiceProtocol {
    func fetchJobs(dates: String) -> Observable<APIResponseModel<[String: [JobModel]]>?>
}

class JobListService: JobListServiceProtocol {
    
    func fetchJobs(dates: String) -> Observable<APIResponseModel<[String: [JobModel]]>?>{
        let resource = Resource<APIResponseModel<[String: [JobModel]]>>(method: .get, route: "/contractor/shifts", queryParams: ["dates" : dates])
        return HttpClient.load(resource: resource)
    }
}
