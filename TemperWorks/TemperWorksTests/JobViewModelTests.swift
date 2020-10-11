//
//  JobViewModelTests.swift
//  TemperWorksTests
//
//  Created by Ravindu Senevirathna on 11/10/20.
//

import XCTest
@testable import TemperWorks

class JobViewModelTests: XCTestCase {
    
    var viewModel: JobViewModel!
    var apiResponse: APIResponseModel<[String: [JobModel]]>!

    override func setUpWithError() throws {
        let jsonData = loadJson(name: "jobs", ext: "json")
        let decoder = JSONDecoder()
        do {
            apiResponse = try decoder.decode(APIResponseModel<[String: [JobModel]]>.self, from: jsonData)
        } catch {
            print(error)
        }
        let jobModel = apiResponse.data["2020-10-11"]
        viewModel = JobViewModel(model: jobModel!.first!)
    }

    override func tearDownWithError() throws {
    }

    func testClientName() {
        XCTAssertEqual(viewModel.clientName, "Vkusvill Netherlands B.V.")
    }
    
    func testCoverImage() {
        XCTAssertEqual(viewModel.coverImage, "https://tmpr-photos.ams3.digitaloceanspaces.com/hero/190558.jpg")
    }
    
    func testJobCategory() {
        XCTAssertEqual(viewModel.jobCategory, "Assistant cook")
    }
    
    func testShoftTime() {
        XCTAssertEqual(viewModel.shiftTime, "07:00 - 10:00")
    }
}
