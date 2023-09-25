//
//  NetworkError.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

enum RequestBuilderError: Error {
    case encodingError
    case badURL
    case badURLComponents
}

extension RequestBuilderError: LocalizedError {
    var requestErrorDescription: String? {
        switch self {
        case .encodingError:    return Localization.encodingErrorDescription
        case .badURL:           return Localization.badUrlErrorDescription
        case .badURLComponents: return Localization.badUrlComponentsErrorDesc
        }
    }
}

enum NetworkError: Error {
    case clientError
    case serverError
    case dataDecodingError
    case unexpectedError
    case badURLError
    case timeOutError
    case hostError
    case redirectError
    case resourceUnavailable
    case requestError(RequestBuilderError)
    case noResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .clientError:              return Localization.clientErrorDesc
        case .serverError:              return Localization.serverErrorDesc
        case .dataDecodingError:        return Localization.dataDecodingErrorDesc
        case .unexpectedError:          return Localization.unexpectedErrorDesc
        case .badURLError:              return Localization.badUrlErrorDescription
        case .timeOutError:             return Localization.timeoutErrorDesc
        case .hostError:                return Localization.hostErrorDesc
        case .redirectError:            return Localization.redirectErrorDesc
        case .resourceUnavailable:      return Localization.resourceUnavailableErrorDesc
        case .requestError(let error):  return error.requestErrorDescription
        case .noResponse:               return Localization.noResponseErrorDesc
        }
    }
}
