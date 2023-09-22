// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  /// Cancel
  internal static let cancel = Localization.tr("Localizable", "cancel", fallback: "Cancel")
  /// Error
  internal static let error = Localization.tr("Localizable", "error", fallback: "Error")
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
  /// Search
  internal static let search = Localization.tr("Localizable", "search", fallback: "Search")
  /// Top rated
  internal static let topRated = Localization.tr("Localizable", "top-rated", fallback: "Top rated")
  /// Top rated movies
  internal static let topRatedMovies = Localization.tr("Localizable", "top-rated-movies", fallback: "Top rated movies")
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
