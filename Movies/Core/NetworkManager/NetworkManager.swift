//
//  NetworkManager.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation
import Combine

protocol Requestable: AnyObject {
    func request(_ request: URLRequest) -> AnyPublisher<Data, NetworkError>
}

final class NetworkManager: Requestable {
    // MARK: - Properties
    let session: URLSession
    private let networkConnectionObserver: NetworkConnectionObserver
    @Published private var isInternetAvailable = true
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(session: URLSession = .shared,
         networkConnectionObserver: NetworkConnectionObserver = NetworkConnectionObserverImpl.shared) {
        self.session = session
        self.networkConnectionObserver = networkConnectionObserver
        networkConnectionObserver.setupObserver()
        checkCurrentInternetConnectionStatus()
    }
    
    // MARK: - Public methods
    func request(_ request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        debugPrint(isInternetAvailable)
        guard isInternetAvailable else {
            return Fail(error: NetworkError.noConnection)
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: request)
            .mapError { [weak self] error -> NetworkError in
                guard let self = self else {
                    return NetworkError.unexpectedError
                }
                
                return convertError(error as NSError)
            }
            .flatMap { [weak self] output -> AnyPublisher<Data, NetworkError> in
                guard let self = self else {
                    return Fail(error: NetworkError.unexpectedError)
                        .eraseToAnyPublisher()
                }
                                Logger.log(output)
                return self.handleError(output)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private extension
private extension NetworkManager {
    func handleError(_ output: URLSession.DataTaskPublisher.Output) -> AnyPublisher<Data, NetworkError> {
        guard let httpResponse = output.response as? HTTPURLResponse else {
            return Fail(error: NetworkError.noResponse)
                .eraseToAnyPublisher()
        }
        
        switch httpResponse.statusCode {
        case 200...399:
            return Just(output.data)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case 400...499:
            return Fail(error: NetworkError.clientError)
                .eraseToAnyPublisher()
        case 500...599:
            return Fail(error: NetworkError.serverError)
                .eraseToAnyPublisher()
        default:
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }
    
    func convertError(_ error: NSError) -> NetworkError {
        switch error.code {
        case NSURLErrorBadURL:
            return .badURLError
        case NSURLErrorTimedOut:
            return .timeOutError
        case NSURLErrorCannotFindHost:
            return .hostError
        case NSURLErrorCannotConnectToHost:
            return .hostError
        case NSURLErrorHTTPTooManyRedirects:
            return .redirectError
        case NSURLErrorResourceUnavailable:
            return .resourceUnavailable
        case NSURLErrorNotConnectedToInternet:
            return .noConnection
        case NSURLErrorNetworkConnectionLost:
            return .noConnection
            
        default: return .unexpectedError
        }
    }
    
    func checkCurrentInternetConnectionStatus() {
        networkConnectionObserver.networkConnectionObserverPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAvailable in
                guard let self = self else {
                    return
                }
                self.isInternetAvailable = isAvailable
            }
            .store(in: &cancellables)
    }
}
