//
//  LoginTests.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

class LoginTests: XCTestCase {
    
    // MARK: - Properties
    
    private let application = XCUIApplication()
    private lazy var loginScreen = LoginScreen(application)
    private lazy var searchScreen = SearchScreen(application)
    
    private let validLogin = "automation@gymondo.de"
    private let validPassword = "automation"
    private let invalidLogin = "login"
    private let invalidPassword = "password"
    
    // MARK: - Life cycle
    
    override func setUp() {
        super.setUp()

        application.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        application.terminate()
    }
    
    // MARK: - Tests
    
    func test_checkAllFieldsAreDisplayed() {
        let login = loginScreen.loginField
        XCTAssert(login.isHittable, isNotHittableMessage(for: login))
        
        let password = loginScreen.passwordField
        XCTAssert(password.isHittable, isNotHittableMessage(for: password))
        
        let loginButton = loginScreen.loginButton
        XCTAssert(loginButton.isHittable, isNotHittableMessage(for: loginButton))
    }
    
    func test_checkLoginWithValidParameters() {
        loginScreen
            .fillLogin(validLogin)
            .fillPassword(validPassword)
            .clickLoginButton()
        
        let searchField = searchScreen.searchField
        XCTAssert(searchField.isHittable, doesNotExistMessage(for: "Search Field"))
    }

    func test_checkLoginWithInvalidLogin() {
        loginScreen
            .fillLogin(invalidLogin)
            .fillPassword(validPassword)
            .clickLoginButton()

        let alert = loginScreen.alert
        XCTAssert(alert.isHittable, isNotHittableMessage(for: alert))
    }
    
    func test_checkLoginWithInvalidPassword() {
        loginScreen
            .fillLogin(validLogin)
            .fillPassword(invalidPassword)
            .clickLoginButton()

        let alert = loginScreen.alert
        XCTAssert(alert.isHittable, isNotHittableMessage(for: alert))
    }
    
}
