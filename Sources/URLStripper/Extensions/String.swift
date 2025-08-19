//
//  String+URLStripper.swift
//  URLStripper
//
//  Simple URL cleaning for String type
//  Created on 26/07/2025.
//

import Foundation

public extension String {
    
    /// Returns a clean version of the URL string with all tracking parameters removed.
    ///
    /// This property removes all known tracking parameters while preserving functional
    /// query parameters. The original string is not modified.
    ///
    /// ## Example
    /// ```swift
    /// let dirtyURL = "https://example.com?utm_source=newsletter&id=123&fbclid=abc"
    /// let cleanURL = dirtyURL.withoutTracking
    /// // Result: "https://example.com?id=123"
    /// ```
    var withoutTracking: String {
        return cleanURL(removing: TrackingParameters.all)
    }
    
    /// Returns a clean version removing only analytics tracking parameters.
    ///
    /// Removes Google Analytics, Google Ads, and other analytics parameters
    /// while preserving social media and other tracking types.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=google&fbclid=123&id=page"
    /// let clean = url.withoutAnalytics
    /// // Result: "https://example.com?fbclid=123&id=page"
    /// ```
    var withoutAnalytics: String {
        return cleanURL(removing: TrackingParameters.analytics)
    }
    
    /// Returns a clean version removing only social media tracking parameters.
    ///
    /// Removes Facebook, Twitter, TikTok, and other social platform tracking
    /// while preserving analytics and other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=google&fbclid=123&id=page"
    /// let clean = url.withoutSocial
    /// // Result: "https://example.com?utm_source=google&id=page"
    /// ```
    var withoutSocial: String {
        return cleanURL(removing: TrackingParameters.social)
    }
    
    /// Returns a clean version removing only email marketing tracking parameters.
    ///
    /// Removes MailChimp, HubSpot, and other email marketing tracking
    /// while preserving other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=google&mc_cid=123&id=page"
    /// let clean = url.withoutEmail
    /// // Result: "https://example.com?utm_source=google&id=page"
    /// ```
    var withoutEmail: String {
        return cleanURL(removing: TrackingParameters.email)
    }
    
    /// Returns a clean version removing only e-commerce tracking parameters.
    ///
    /// Removes Amazon, eBay, and other e-commerce tracking parameters
    /// while preserving other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=google&ref=amazon&id=page"
    /// let clean = url.withoutEcommerce
    /// // Result: "https://example.com?utm_source=google&id=page"
    /// ```
    var withoutEcommerce: String {
        return cleanURL(removing: TrackingParameters.ecommerce)
    }
    
    /// Removes custom parameters from the URL in addition to all tracking.
    ///
    /// This method removes all standard tracking parameters plus any additional
    /// custom parameters you specify.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=test&debug=true&id=123"
    /// let clean = url.withoutTracking(removing: ["debug"])
    /// // Result: "https://example.com?id=123"
    /// ```
    func withoutTracking(removing additionalParams: [String]) -> String {
        let allParams = TrackingParameters.all.union(Set(additionalParams))
        return cleanURL(removing: allParams)
    }
    
    /// Removes only specified custom parameters, preserving all tracking.
    ///
    /// This method removes only the parameters you specify, leaving all
    /// tracking parameters intact.
    ///
    /// ## Example
    /// ```swift
    /// let url = "https://example.com?utm_source=test&debug=true&temp=remove"
    /// let clean = url.withoutParams(["debug", "temp"])
    /// // Result: "https://example.com?utm_source=test"
    /// ```
    func withoutParams(_ params: [String]) -> String {
        return cleanURL(removing: Set(params))
    }
    
    // MARK: - Private Implementation
    
    /// Core URL cleaning implementation.
    private func cleanURL(removing parametersToRemove: Set<String>) -> String {
        // Early return for empty strings or URLs without query parameters
        guard !isEmpty, contains("?") else { return self }
        
        // Try URLComponents first for proper URL handling
        guard var urlComponents = URLComponents(string: self) else {
            // Fallback to string manipulation if URLComponents fails
            return cleanURLFallback(removing: parametersToRemove)
        }
        
        // Remove specified parameters (case-insensitive)
        let lowercaseParamsToRemove = Set(parametersToRemove.map { $0.lowercased() })
        
        urlComponents.queryItems = urlComponents.queryItems?.compactMap { queryItem in
            lowercaseParamsToRemove.contains(queryItem.name.lowercased()) ? nil : queryItem
        }
        
        // Remove query component if no parameters remain
        if urlComponents.queryItems?.isEmpty == true {
            urlComponents.queryItems = nil
        }
        
        return urlComponents.url?.absoluteString ?? self
    }
    
    /// Fallback string-based URL cleaning for malformed URLs.
    private func cleanURLFallback(removing parametersToRemove: Set<String>) -> String {
        guard let questionMarkRange = range(of: "?") else { return self }
        
        let baseURL = String(self[..<questionMarkRange.lowerBound])
        let queryString = String(self[questionMarkRange.upperBound...])
        
        let parameters = queryString.components(separatedBy: "&")
        let lowercaseParamsToRemove = Set(parametersToRemove.map { $0.lowercased() })
        
        let cleanParameters = parameters.compactMap { parameter -> String? in
            // Handle parameters with and without values
            let paramName = parameter.components(separatedBy: "=").first ?? parameter
            return lowercaseParamsToRemove.contains(paramName.lowercased()) ? nil : parameter
        }
        
        if cleanParameters.isEmpty {
            return baseURL
        } else {
            return baseURL + "?" + cleanParameters.joined(separator: "&")
        }
    }
    
}
