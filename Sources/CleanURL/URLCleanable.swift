//
//  URLCleanable.swift
//  CleanURL
//
//  Core protocol for URL cleaning functionality
//  Created on 26/07/2025.
//

import Foundation

/// A protocol that provides URL cleaning capabilities to conforming types.
///
/// Types that conform to `URLCleanable` can remove tracking parameters and other
/// unwanted query parameters from URLs while preserving the core functionality.
///
/// ## Usage
///
/// ```swift
/// let dirtyURL = "https://example.com?utm_source=newsletter&id=123"
/// let cleanURL = dirtyURL.withoutTracking
/// // Result: "https://example.com?id=123"
/// ```
public protocol URLCleanable {
    
    /// The same type as the conforming type, with tracking parameters removed.
    ///
    /// This computed property removes all known tracking parameters while preserving
    /// functional query parameters. The original value is not modified.
    ///
    /// - Returns: A clean version of the URL without tracking parameters
    var withoutTracking: Self { get }
    
    /// Removes specific tracking parameter categories from the URL.
    ///
    /// - Parameter categories: Set of tracking categories to remove
    /// - Returns: A clean version of the URL without specified tracking categories
    func withoutTracking(categories: Set<TrackingCategory>) -> Self
    
    /// Removes custom parameters from the URL in addition to standard tracking.
    ///
    /// - Parameter additionalParams: Additional parameter names to remove
    /// - Returns: A clean version of the URL without tracking and custom parameters
    func withoutTracking(removing additionalParams: Set<String>) -> Self
}

/// Categories of tracking parameters that can be selectively removed.
///
/// These categories help users fine-tune which types of tracking to remove
/// while potentially preserving others that might be needed for functionality.
public enum TrackingCategory: String, CaseIterable, Hashable {
    /// Google Analytics and Google Ads parameters (utm_, gclid, etc.)
    case analytics = "analytics"
    
    /// Social media platform tracking (fbclid, ttclid, etc.)
    case social = "social"
    
    /// Email marketing and automation tracking (mc_cid, _hsenc, etc.)
    case email = "email"
    
    /// E-commerce and affiliate tracking (ref, affiliate_id, etc.)
    case ecommerce = "ecommerce"
    
    /// All other miscellaneous tracking parameters
    case other = "other"
    
    /// All tracking categories combined
    public static var all: Set<TrackingCategory> {
        Set(TrackingCategory.allCases)
    }
}
