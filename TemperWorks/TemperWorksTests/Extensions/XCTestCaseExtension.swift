//
//  XCTestCaseExtension.swift
//  TemperWorksTests
//
//  Created by Ravindu Senevirathna on 11/10/20.
//

import XCTest

extension XCTestCase {
    func loadJson(name: String, ext: String) -> Data {
        return try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: name, withExtension: ext)!)
    }
}
