//
//  XCDataProviderExpectation.swift
//  qa-automation-ios-testUITests
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import XCTest

class XCDataProviderExpectation: XCTestExpectation {
    
    private var timer: Timer?
    var result: ExcerciseList!
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            guard let data = UITestsDataProvider.readExcerciseList(),
                let result = try? JSONDecoder().decode(ExcerciseList.self, from: data) else {
                return
            }

            self.timer?.invalidate()
            self.result = result
            self.fulfill()
        })
    }
    
    deinit {
        timer?.invalidate()
        UITestsDataProvider.deleteExcerciseList()
    }
    
}
