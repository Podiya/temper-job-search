//
//  JobMapService.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation
import RxSwift

protocol JobMapServiceProtocol {
    func fetchJobs(date: String) -> Observable<APIResponseModel<[String: [JobModel]]>?>
}

class JobMapService: JobMapServiceProtocol {
    
    func fetchJobs(date: String) -> Observable<APIResponseModel<[String: [JobModel]]>?>{
        let resource = Resource<APIResponseModel<[String: [JobModel]]>>(method: .get, route: "/contractor/shifts", queryParams: ["dates" : date])
        return HttpClient.load(resource: resource)
    }
}
