//
//  XCUIElement+Extensions.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    @discardableResult
    func fill(text: String) -> Self {
        tap()
        typeText(text)
        
        return self
    }
    
    @discardableResult
    func set(accessibilityValue: String) -> Self {
        if self.accessibilityValue == nil {
            setValue(value, forKey: "accessibilityValue")
        }
        
        return self
    }
    
}
