//
//  XCTestCase+Helpers.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func isNotHittableMessage(for element: XCUIElement) -> String {
        return "\(element.accessibilityValue ?? "") is not hittable"
    }

    func doesNotExistMessage(for elementNamed: String) -> String {
        return "\(elementNamed) does not exist"
    }
    
}
