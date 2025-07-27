//
//  URL+URLStripper.swift
//  URLStripper
//
//  Simple URL cleaning for Foundation URL type
//  Created on 26/07/2025.
//

import Foundation

public extension URL {
    
    /// Returns a clean version of the URL with all tracking parameters removed.
    ///
    /// This property removes all known tracking parameters while preserving functional
    /// query parameters. The original URL is not modified.
    ///
    /// ## Example
    /// ```swift
    /// let dirtyURL = URL(string: "https://example.com?utm_source=newsletter&id=123")!
    /// let cleanURL = dirtyURL.withoutTracking
    /// // Result: URL for "https://example.com?id=123"
    /// ```
    var withoutTracking: URL {
        return cleanURL(removing: TrackingParameters.all)
    }
    
    /// Returns a clean version removing only analytics tracking parameters.
    ///
    /// Removes Google Analytics, Google Ads, and other analytics parameters
    /// while preserving social media and other tracking types.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=google&fbclid=123")!
    /// let clean = url.withoutAnalytics
    /// // Result: URL for "https://example.com?fbclid=123"
    /// ```
    var withoutAnalytics: URL {
        return cleanURL(removing: TrackingParameters.analytics)
    }
    
    /// Returns a clean version removing only social media tracking parameters.
    ///
    /// Removes Facebook, Twitter, TikTok, and other social platform tracking
    /// while preserving analytics and other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=google&fbclid=123")!
    /// let clean = url.withoutSocial
    /// // Result: URL for "https://example.com?utm_source=google"
    /// ```
    var withoutSocial: URL {
        return cleanURL(removing: TrackingParameters.social)
    }
    
    /// Returns a clean version removing only email marketing tracking parameters.
    ///
    /// Removes MailChimp, HubSpot, and other email marketing tracking
    /// while preserving other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=google&mc_cid=123")!
    /// let clean = url.withoutEmail
    /// // Result: URL for "https://example.com?utm_source=google"
    /// ```
    var withoutEmail: URL {
        return cleanURL(removing: TrackingParameters.email)
    }
    
    /// Returns a clean version removing only e-commerce tracking parameters.
    ///
    /// Removes Amazon, eBay, and other e-commerce tracking parameters
    /// while preserving other parameter types.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=google&ref=amazon")!
    /// let clean = url.withoutEcommerce
    /// // Result: URL for "https://example.com?utm_source=google"
    /// ```
    var withoutEcommerce: URL {
        return cleanURL(removing: TrackingParameters.ecommerce)
    }
    
    /// Removes custom parameters from the URL in addition to all tracking.
    ///
    /// This method removes all standard tracking parameters plus any additional
    /// custom parameters you specify.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://example.com?utm_source=test&debug=true")!
    /// let clean = url.withoutTracking(removing: ["debug"])
    /// // Result: URL for "https://example.com"
    /// ```
    func withoutTracking(removing additionalParams: [String]) -> URL {
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
    /// let url = URL(string: "https://example.com?utm_source=test&debug=true")!
    /// let clean = url.withoutParams(["debug"])
    /// // Result: URL for "https://example.com?utm_source=test"
    /// ```
    func withoutParams(_ params: [String]) -> URL {
        return cleanURL(removing: Set(params))
    }
    
    // MARK: - Private Implementation
    
    /// Core URL cleaning implementation.
    private func cleanURL(removing parametersToRemove: Set<String>) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        guard urlComponents.queryItems != nil else {
            return self
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
        
        return urlComponents.url ?? self
    }
}