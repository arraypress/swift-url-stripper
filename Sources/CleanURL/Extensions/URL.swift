//
//  URL.swift
//  CleanURL
//
//  Created by David Sherlock on 26/07/2025.
//


//
//  URL+URLCleanable.swift
//  CleanURL
//
//  URLCleanable conformance for Foundation URL type
//  Created on 26/07/2025.
//

import Foundation

extension URL: URLCleanable {
    
    /// Returns a clean version of the URL with all tracking parameters removed.
    ///
    /// This property removes all known tracking parameters while preserving functional
    /// query parameters. The original URL is not modified.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dirtyURL = URL(string: "https://example.com?utm_source=newsletter&id=123")!
    /// let cleanURL = dirtyURL.withoutTracking
    /// // Result: URL for "https://example.com?id=123"
    /// ```
    ///
    /// - Returns: A clean URL without tracking parameters, or the original URL if cleaning fails
    public var withoutTracking: URL {
        return cleanURL(removing: TrackingParameters.all)
    }
    
    /// Returns a clean version of the URL with specified tracking categories removed.
    ///
    /// This method allows selective removal of tracking parameter categories,
    /// giving you fine-grained control over what gets cleaned.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=google&fbclid=123")!
    /// let cleanURL = url.withoutTracking(categories: [.analytics])
    /// // Removes utm_source but keeps fbclid
    /// ```
    ///
    /// - Parameter categories: Set of tracking categories to remove
    /// - Returns: A clean URL without specified tracking categories
    public func withoutTracking(categories: Set<TrackingCategory>) -> URL {
        let parametersToRemove = TrackingParameters.parameters(for: categories)
        return cleanURL(removing: parametersToRemove)
    }
    
    /// Returns a clean version of the URL with custom parameters removed.
    ///
    /// This method removes all standard tracking parameters plus any additional
    /// custom parameters you specify.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=test&custom=remove")!
    /// let cleanURL = url.withoutTracking(removing: ["custom"])
    /// // Removes both utm_source and custom parameters
    /// ```
    ///
    /// - Parameter additionalParams: Additional parameter names to remove
    /// - Returns: A clean URL without tracking and custom parameters
    public func withoutTracking(removing additionalParams: Set<String>) -> URL {
        let allParams = TrackingParameters.all.union(additionalParams)
        return cleanURL(removing: allParams)
    }
    
    // MARK: - Private Implementation
    
    /// Core URL cleaning implementation that removes specified parameters.
    ///
    /// This method uses URLComponents for proper URL parsing and reconstruction,
    /// ensuring that the URL structure remains valid after cleaning.
    ///
    /// - Parameter parametersToRemove: Set of parameter names to remove
    /// - Returns: Clean URL with specified parameters removed, or original URL if cleaning fails
    private func cleanURL(removing parametersToRemove: Set<String>) -> URL {
        // Convert to URLComponents for safe manipulation
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        // Return original URL if there are no query parameters to clean
        guard urlComponents.queryItems != nil else {
            return self
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
        
        // Return the cleaned URL or original URL if reconstruction fails
        return urlComponents.url ?? self
    }
}