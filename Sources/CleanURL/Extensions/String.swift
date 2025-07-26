//
//  String.swift
//  CleanURL
//
//  Created by David Sherlock on 26/07/2025.
//


//
//  String+URLCleanable.swift
//  CleanURL
//
//  URLCleanable conformance for String type
//  Created on 26/07/2025.
//

import Foundation

extension String: URLCleanable {
    
    /// Returns a clean version of the URL string with all tracking parameters removed.
    ///
    /// This property removes all known tracking parameters while preserving functional
    /// query parameters. The original string is not modified.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dirtyURL = "https://example.com?utm_source=newsletter&id=123&fbclid=abc"
    /// let cleanURL = dirtyURL.withoutTracking
    /// // Result: "https://example.com?id=123"
    /// ```
    ///
    /// - Returns: A clean URL string without tracking parameters
    public var withoutTracking: String {
        return cleanURL(removing: TrackingParameters.all)
    }
    
    /// Returns a clean version of the URL string with specified tracking categories removed.
    ///
    /// This method allows selective removal of tracking parameter categories,
    /// giving you fine-grained control over what gets cleaned.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let url = "https://example.com?utm_source=google&fbclid=123&mc_cid=456"
    /// let cleanURL = url.withoutTracking(categories: [.analytics, .social])
    /// // Removes utm_source and fbclid, but keeps mc_cid
    /// ```
    ///
    /// - Parameter categories: Set of tracking categories to remove
    /// - Returns: A clean URL string without specified tracking categories
    public func withoutTracking(categories: Set<TrackingCategory>) -> String {
        let parametersToRemove = TrackingParameters.parameters(for: categories)
        return cleanURL(removing: parametersToRemove)
    }
    
    /// Returns a clean version of the URL string with custom parameters removed.
    ///
    /// This method removes all standard tracking parameters plus any additional
    /// custom parameters you specify.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let url = "https://example.com?utm_source=test&custom_param=remove&keep=this"
    /// let cleanURL = url.withoutTracking(removing: ["custom_param"])
    /// // Removes utm_source (standard tracking) and custom_param
    /// ```
    ///
    /// - Parameter additionalParams: Additional parameter names to remove
    /// - Returns: A clean URL string without tracking and custom parameters
    public func withoutTracking(removing additionalParams: Set<String>) -> String {
        let allParams = TrackingParameters.all.union(additionalParams)
        return cleanURL(removing: allParams)
    }
    
    // MARK: - Private Implementation
    
    /// Core URL cleaning implementation that removes specified parameters.
    ///
    /// - Parameter parametersToRemove: Set of parameter names to remove
    /// - Returns: Clean URL string with specified parameters removed
    private func cleanURL(removing parametersToRemove: Set<String>) -> String {
        // Return original string if it's empty or not a valid URL structure
        guard !isEmpty, contains("?") else { return self }
        
        // Try to parse as URL components for proper handling
        guard var urlComponents = URLComponents(string: self) else {
            // Fallback to simple string manipulation if URLComponents fails
            return cleanURLFallback(removing: parametersToRemove)
        }
        
        // Filter out tracking parameters (case-insensitive comparison)
        let lowercaseParamsToRemove = Set(parametersToRemove.map { $0.lowercased() })
        
        urlComponents.queryItems = urlComponents.queryItems?.compactMap { queryItem in
            return lowercaseParamsToRemove.contains(queryItem.name.lowercased()) ? nil : queryItem
        }
        
        // Remove query component entirely if no parameters remain
        if urlComponents.queryItems?.isEmpty == true {
            urlComponents.queryItems = nil
        }
        
        // Return the cleaned URL or original string if reconstruction fails
        return urlComponents.url?.absoluteString ?? self
    }
    
    /// Fallback URL cleaning for malformed URLs that URLComponents can't parse.
    ///
    /// This method uses string manipulation as a fallback when URLComponents
    /// fails to parse the URL string properly.
    ///
    /// - Parameter parametersToRemove: Set of parameter names to remove
    /// - Returns: Clean URL string with specified parameters removed
    private func cleanURLFallback(removing parametersToRemove: Set<String>) -> String {
        guard let questionMarkRange = range(of: "?") else { return self }
        
        let baseURL = String(self[..<questionMarkRange.lowerBound])
        let queryString = String(self[questionMarkRange.upperBound...])
        
        // Split query string into individual parameters
        let parameters = queryString.components(separatedBy: "&")
        let lowercaseParamsToRemove = Set(parametersToRemove.map { $0.lowercased() })
        
        // Filter out tracking parameters
        let cleanParameters = parameters.compactMap { parameter -> String? in
            guard let equalRange = parameter.range(of: "=") else {
                // Handle parameters without values
                return lowercaseParamsToRemove.contains(parameter.lowercased()) ? nil : parameter
            }
            
            let paramName = String(parameter[..<equalRange.lowerBound])
            return lowercaseParamsToRemove.contains(paramName.lowercased()) ? nil : parameter
        }
        
        // Reconstruct URL
        if cleanParameters.isEmpty {
            return baseURL
        } else {
            return baseURL + "?" + cleanParameters.joined(separator: "&")
        }
    }
}