//
//  SearchTests.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

class SearchTests: XCTestCase {
    
    // MARK: - Properties
    
    private let application = XCUIApplication()
    private lazy var loginScreen = LoginScreen(application)
    private lazy var searchScreen = SearchScreen(application)
    private lazy var expectation = XCDataProviderExpectation(description: "ExcerciseList")

    private let login = "automation@gymondo.de"
    private let password = "automation"
    
    // MARK: - Life cycle
    
    override func setUp() {
        super.setUp()

        application.launch()
        
        loginScreen
            .fillLogin(login)
            .fillPassword(password)
            .clickLoginButton()
    }
    
    override func tearDown() {
        super.tearDown()
        
        application.terminate()
    }
    
    // MARK: - Tests
    
    func test_checkAllFieldsAreDisplayed() {
        let searchField = searchScreen.searchField
        XCTAssert(searchField.isHittable, isNotHittableMessage(for: searchField))
    }

    func test_checkSearchExercise() {
        wait(expectation: expectation, timeout: 10)
                
        let exercise = expectation.result.results.randomElement()!.meta
        
        searchScreen.fillSearch(exercise + "\n")
        
        XCTAssert(searchScreen.getResult(exercise).isHittable, doesNotExistMessage(for: "\(exercise) cell"))
    }
    
}
