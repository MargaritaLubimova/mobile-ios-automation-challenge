//
//  SearchScreen.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

class SearchScreen {
    
    private let application: XCUIApplication
    
    private let searchFieldPlaceholder = "Search exercises"
    lazy var searchField = application.searchFields[searchFieldPlaceholder]
    
    lazy var cells = application.tables.cells
    
    init(_ application: XCUIApplication) {
        self.application = application
    }
    
    @discardableResult
    func fillSearch(_ exercise: String) -> SearchScreen {
        searchField
            .set(accessibilityValue: searchFieldPlaceholder)
            .fill(text: exercise)
        
        return self
    }
    
    func getResult(_ exercise: String) -> XCUIElement {
        return cells[exercise]
    }
    
}
