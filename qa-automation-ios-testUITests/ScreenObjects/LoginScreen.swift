//
//  LoginScreen.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

class LoginScreen {
    
    // MARK: - Properties
    
    private let application: XCUIApplication
    
    private let loginFieldID = "usernameTextField"
    lazy var loginField = application.textFields[loginFieldID]
    
    private let passwordFieldID = "passwordTextField"
    lazy var passwordField = application.textFields[passwordFieldID]
    
    private let loginButtonID = "loginButton"
    lazy var loginButton = application.buttons[loginButtonID]
    
    private let alertLabel = "Try again"
    lazy var alert: XCUIElement = {
        let element = application.alerts[alertLabel]
        element.set(accessibilityValue: alertLabel)
        return element
    }()
    
    // MARK: - Life cycle
    
    init(_ application: XCUIApplication) {
        self.application = application
    }
    
    // MARK: - Interface

    @discardableResult
    func fillLogin(_ login: String) -> LoginScreen {
        loginField
            .set(accessibilityValue: loginFieldID)
            .fill(text: login)
        
        return self
    }

    @discardableResult
    func fillPassword(_ password: String) -> LoginScreen {
        passwordField
            .set(accessibilityValue: passwordFieldID)
            .fill(text: password)
        
        return self
    }

    @discardableResult
    func clickLoginButton() -> LoginScreen {
        loginButton
            .set(accessibilityValue: loginButtonID)
            .tap()
        
        return self
    }

}
