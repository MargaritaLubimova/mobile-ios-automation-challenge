//
//  UITestsDataProvider.swift
//  qa-automation-ios-test
//
//  Created by Margarita Lyubimova on 06.04.20.
//  Copyright © 2020 Lorenzo Bulfone. All rights reserved.
//

import Foundation

final class UITestsDataProvider {
    
    private static let env = "SIMULATOR_SHARED_RESOURCES_DIRECTORY"
    private static let fm = FileManager.default
    
    static func writeExcerciseList(_ value: Data) {
        #if TEST
        
        guard let shared = ProcessInfo().environment[env] else {
            return
        }
        
        let secrets = generateSecretsURL(for: shared)
        
        try? fm.createDirectory(at: secrets, withIntermediateDirectories: true, attributes: nil)
        try? value.write(to: generateFileURL(for: secrets))
        
        #endif
    }
    
    static func readExcerciseList() -> Data? {
        #if TEST
        
        guard let shared = ProcessInfo().environment[env] else {
            return nil
        }
        
        let secrets = generateSecretsURL(for: shared)
        return fm.contents(atPath: generateFileURL(for: secrets).path)
        
        #else
        
        return nil
        
        #endif
    }
    
    static func deleteExcerciseList() {
        #if TEST
        
        guard let shared = ProcessInfo().environment[env] else {
            return
        }
        
        let secrets = generateSecretsURL(for: shared)
        try? fm.removeItem(at: generateFileURL(for: secrets))
        
        #endif
    }
    
    private static func generateSecretsURL(for sharedPath: String) -> URL {
        return URL(fileURLWithPath: sharedPath).appendingPathComponent("Library/Caches/Secrets")
    }
    
    private static func generateFileURL(for url: URL) -> URL {
        return url.appendingPathComponent("excercises")
    }
    
}
