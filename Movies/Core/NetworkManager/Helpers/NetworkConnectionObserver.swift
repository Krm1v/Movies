//
//  NetworkConnectionObserver.swift
//  Movies
//
//  Created by Владислав Баранкевич on 26.09.2023.
//

import Network
import Combine

protocol NetworkConnectionObserver: AnyObject {
    var networkConnectionObserverPublisher: AnyPublisher<Bool, Never> { get }
    
    func setupObserver()
}

final class NetworkConnectionObserverImpl: NetworkConnectionObserver {
    // MARK: - Properties
    static let shared = NetworkConnectionObserverImpl()
    private let monitor = NWPathMonitor()
    private(set) lazy var networkConnectionObserverPublisher = networkConnectionObserverSubject.eraseToAnyPublisher()
    private let networkConnectionObserverSubject = CurrentValueSubject<Bool, Never>(true)
    
    // MARK: - Init
    private init() {
//        setupObserver()
    }
    
    func setupObserver() {
        let monitorQueue = DispatchQueue(label: "monitorQueue")
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {
                return
            }
            if path.status == .satisfied {
                self.networkConnectionObserverSubject.send(true)
            } else {
                self.networkConnectionObserverSubject.send(false)
            }
        }
        monitor.start(queue: monitorQueue)
    }
}

// MARK: - Private extension
private extension NetworkConnectionObserverImpl {
    
}
