//
//  NetworkConnectionManager.swift
//  Movies
//
//  Created by Владислав Баранкевич on 24.09.2023.
//

import Foundation
import Network
import Combine

protocol NetworkConnectionManager: AnyObject {
    var isInternetAvailablePublisher: AnyPublisher<Bool, Never> { get }
}

enum NetworkConnectionErrorMessages {
    case noConnection
    
    var description: String {
        switch self {
        case .noConnection: return Localization.noInternetConnectionErrorDesc
        }
    }
}

final class NetworkConnectionManagerImpl: NetworkConnectionManager {
    // MARK: - Properties
    static let shared = NetworkConnectionManagerImpl()
    private let monitor = NWPathMonitor()
    private(set) lazy var isInternetAvailablePublisher = isInternetAvailableSubject.eraseToAnyPublisher()
    private let isInternetAvailableSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: - Init
    private init() {
        setupNetworkMonitor()
    }
}

// MARK: - Private extension
private extension NetworkConnectionManagerImpl {
    func setupNetworkMonitor() {
        let monitorQueue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {
                return
            }
            if path.status == .satisfied {
                Logger.info("Connection available")
                isInternetAvailableSubject.send(true)
            } else {
                Logger.info("No Internet connection")
                isInternetAvailableSubject.send(false)
            }
        }
        monitor.start(queue: monitorQueue)
    }
}
