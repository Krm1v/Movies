//
//  AppConfiguration.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

protocol BaseURLStorage: AnyObject {
    var baseURL: URL { get }
    var apiKey: String { get }
}

protocol AppConfiguration: BaseURLStorage {
    var bundleId: String { get }
}

final class AppConfigurationImpl: AppConfiguration {
    // MARK: - Private properties
    let apiKey: String
    private let apiURL: String
    
    // MARK: - Properties
    var bundleId: String
    
    lazy var baseURL: URL = {
        guard let url = URL(string: apiURL) else {
            assert(false, "Invalid URL")
        }
        return url
    }()
    
    // MARK: - Init
    init(bundle: Bundle = .main) {
        guard
            let bundleId = bundle.bundleIdentifier,
            let infoDict = bundle.infoDictionary,
            let apiKey = infoDict[Keys.APIKey] as? String,
            let baseURL = infoDict[Keys.BaseURL] as? String
        else {
            assert(false, "Config file error")
        }
        
        self.bundleId = bundleId
        self.apiKey = apiKey
        self.apiURL = baseURL
    }
}

// MARK: - Keys
private enum Keys {
    static let APIKey = "API_KEY"
    static let BaseURL = "BASE_URL"
}
