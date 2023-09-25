// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  /// Bad URL components error occured.
  internal static let badUrlComponentsErrorDesc = Localization.tr("Localizable", "bad-url-components-error-desc", fallback: "Bad URL components error occured.")
  /// Bad URL error occured
  internal static let badUrlErrorDescription = Localization.tr("Localizable", "bad-url-error-description", fallback: "Bad URL error occured")
  /// Cancel
  internal static let cancel = Localization.tr("Localizable", "cancel", fallback: "Cancel")
  /// An error occured on the client side. Please, try again later
  internal static let clientErrorDesc = Localization.tr("Localizable", "client-error-desc", fallback: "An error occured on the client side. Please, try again later")
  /// Close
  internal static let close = Localization.tr("Localizable", "close", fallback: "Close")
  /// An error occured during data decoding. Please, try again later.
  internal static let dataDecodingErrorDesc = Localization.tr("Localizable", "data-decoding-error-desc", fallback: "An error occured during data decoding. Please, try again later.")
  /// Error occured during data encoding.
  internal static let encodingErrorDescription = Localization.tr("Localizable", "encoding-error-description", fallback: "Error occured during data encoding.")
  /// Error
  internal static let error = Localization.tr("Localizable", "error", fallback: "Error")
  /// Host error occured. Please, try again later.
  internal static let hostErrorDesc = Localization.tr("Localizable", "host-error-desc", fallback: "Host error occured. Please, try again later.")
  /// You are offline. Please, enable your Wi-Fi or connect using cellular data.
  internal static let noInternetConnectionErrorDesc = Localization.tr("Localizable", "no-internet-connection-error-desc", fallback: "You are offline. Please, enable your Wi-Fi or connect using cellular data.")
  /// There are no response from the server. Please, try again later.
  internal static let noResponseErrorDesc = Localization.tr("Localizable", "no-response-error-desc", fallback: "There are no response from the server. Please, try again later.")
  /// No results
  internal static let noResults = Localization.tr("Localizable", "no-results", fallback: "No results")
  /// OK
  internal static let ok = Localization.tr("Localizable", "ok", fallback: "OK")
  /// Popular
  internal static let popular = Localization.tr("Localizable", "popular", fallback: "Popular")
  /// Localizable.strings
  ///   Movies
  /// 
  ///   Created by Владислав Баранкевич on 20.09.2023.
  internal static let popularMovies = Localization.tr("Localizable", "popular-movies", fallback: "Popular movies")
  /// Rating
  internal static let rating = Localization.tr("Localizable", "rating", fallback: "Rating")
  /// Redirect error occured. Please, try again later.
  internal static let redirectErrorDesc = Localization.tr("Localizable", "redirect-error-desc", fallback: "Redirect error occured. Please, try again later.")
  /// The resource is currently unavailable. Please, try again later.
  internal static let resourceUnavailableErrorDesc = Localization.tr("Localizable", "resource-unavailable-error-desc", fallback: "The resource is currently unavailable. Please, try again later.")
  /// Search
  internal static let search = Localization.tr("Localizable", "search", fallback: "Search")
  /// An error occured on the server side. Please, try again later
  internal static let serverErrorDesc = Localization.tr("Localizable", "server-error-desc", fallback: "An error occured on the server side. Please, try again later")
  /// Timeout error occured. Check your Internet connection or try again later.
  internal static let timeoutErrorDesc = Localization.tr("Localizable", "timeout-error-desc", fallback: "Timeout error occured. Check your Internet connection or try again later.")
  /// Top rated
  internal static let topRated = Localization.tr("Localizable", "top-rated", fallback: "Top rated")
  /// Top rated movies
  internal static let topRatedMovies = Localization.tr("Localizable", "top-rated-movies", fallback: "Top rated movies")
  /// Oops! Something went wrong. Unexpected error occured. Please, try again later.
  internal static let unexpectedErrorDesc = Localization.tr("Localizable", "unexpected-error-desc", fallback: "Oops! Something went wrong. Unexpected error occured. Please, try again later.")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
