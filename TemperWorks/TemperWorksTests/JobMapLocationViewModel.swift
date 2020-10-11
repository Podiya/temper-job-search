//
//  JobMapLocationViewModelTests.swift
//  TemperWorksTests
//
//  Created by Ravindu Senevirathna on 11/10/20.
//

import XCTest
@testable import TemperWorks

class JobMapLocationViewModelTests: XCTestCase {

    var viewModel: JobMapLocationViewModel!
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
        viewModel = JobMapLocationViewModel(model: jobModel!.first!)
    }

    override func tearDownWithError() throws {
    }
    
    func testLocationName() {
        XCTAssertEqual(viewModel.name, "Vkusvill Netherlands B.V.")
    }
    
    func testShiftTime() {
        XCTAssertEqual(viewModel.shiftTime, "07:00 - 10:00")
    }
    
    func testLatitude() {
        XCTAssertEqual(viewModel.latitude, Double("52.354639"))
    }
    
    func testLongitude() {
        XCTAssertEqual(viewModel.longitude, Double("4.890214"))
    }
}
