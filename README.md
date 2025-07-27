# Swift URL Stripper

A modern Swift package for removing tracking parameters from URLs while preserving functionality.

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-blue.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2013%20|%20macOS%2010.15%20|%20tvOS%2013%20|%20watchOS%206-lightgrey.svg)](https://swift.org)

## Overview

URLStripper automatically removes tracking parameters from URLs, helping to:
- **Protect privacy** by removing tracking identifiers
- **Clean up URLs** for sharing and bookmarking  
- **Reduce URL length** by removing unnecessary parameters
- **Maintain functionality** by preserving important query parameters

## Quick Start

```swift
import URLStripper

// Basic usage - removes all tracking parameters
let dirtyURL = "https://example.com?utm_source=newsletter&id=123&fbclid=abc"
let cleanURL = dirtyURL.withoutTracking
// Result: "https://example.com?id=123"

// Works with Foundation URL objects too
let url = URL(string: "https://example.com?gclid=123&page=home")!
let cleaned = url.withoutTracking
// Result: URL("https://example.com?page=home")
```

## Installation

### Swift Package Manager

Add URLStripper to your project in Xcode:

1. **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/arraypress/swift-url-stripper`
3. Choose the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-url-stripper", from: "1.0.0")
]
```

## Core APIs

### String Extensions

#### `withoutTracking: String`
Removes all tracking parameters from the URL string.

```swift
"https://example.com?utm_source=test&id=123".withoutTracking
// Result: "https://example.com?id=123"
```

#### `withoutAnalytics: String`
Removes only analytics tracking (Google Analytics, Google Ads, etc.).

```swift
"https://example.com?utm_source=google&fbclid=123&id=page".withoutAnalytics
// Result: "https://example.com?fbclid=123&id=page"
```

#### `withoutSocial: String`
Removes only social media tracking (Facebook, Twitter, TikTok, etc.).

```swift
"https://example.com?utm_source=google&fbclid=123&id=page".withoutSocial
// Result: "https://example.com?utm_source=google&id=page"
```

#### `withoutEmail: String`
Removes only email marketing tracking (MailChimp, HubSpot, etc.).

```swift
"https://example.com?utm_source=google&mc_cid=123&id=page".withoutEmail
// Result: "https://example.com?utm_source=google&id=page"
```

#### `withoutEcommerce: String`
Removes only e-commerce tracking (Amazon, eBay, affiliate links, etc.).

```swift
"https://example.com?utm_source=google&ref=amazon&id=page".withoutEcommerce
// Result: "https://example.com?utm_source=google&id=page"
```

#### `withoutTracking(removing:) -> String`
Removes all tracking plus custom parameters.

```swift
"https://example.com?utm_source=test&debug=true&id=123".withoutTracking(removing: ["debug"])
// Result: "https://example.com?id=123"
```

#### `withoutParams(_:) -> String`
Removes only specified parameters, preserving all tracking.

```swift
"https://example.com?utm_source=test&debug=true&temp=remove".withoutParams(["debug", "temp"])
// Result: "https://example.com?utm_source=test"
```

### URL Extensions

All the same methods are available for Foundation `URL` objects:

```swift
let url = URL(string: "https://example.com?utm_source=test&id=123")!

url.withoutTracking        // Returns clean URL
url.withoutAnalytics       // Removes only analytics
url.withoutSocial         // Removes only social media tracking
url.withoutEmail          // Removes only email tracking
url.withoutEcommerce      // Removes only e-commerce tracking
```

## Supported Tracking Parameters

URLStripper recognizes 500+ tracking parameters from major platforms:

### Analytics Platforms
- **Google Analytics & Ads**: `utm_*`, `gclid`, `gbraid`, `wbraid`, `_ga`, `_gl`
- **Matomo/Piwik**: `pk_campaign`, `mtm_*`, `matomo_*`
- **Search Engines**: `msclkid`, `yclid`, various search parameters

### Social Media Platforms
- **Facebook/Meta**: `fbclid`, `__tn__`, `__cft__`, `__xts__`, `mibextid`
- **Twitter/X**: `twclid`, `__twitter_impression`, `ref_src`
- **TikTok**: `ttclid`, `is_from_webapp`, `sender_device`
- **Instagram**: `igshid`, `igsh`
- **LinkedIn**: `li_fat_id`
- **Reddit**: Various share and tracking parameters

### Email Marketing
- **MailChimp**: `mc_cid`, `mc_eid`, `mc_tc`
- **HubSpot**: `_hsenc`, `_hsmi`, `hsa_*`, `__hssc`, `__hstc`
- **Salesforce**: `jobid`, `subid`, `sfmc_*`
- **General**: `mkt_tok`, `_ke`, `_kx`, `dm_i`

### E-commerce & Affiliate
- **Amazon**: `ref_`, `tag`, `linkCode`, `ascsubtag`, `creative`
- **eBay**: `_trksid`, `_trkparms`, `mkevt`, `mkcid`
- **Etsy**: `frs`, `crt`, `sts`, `share_time`
- **General**: `affiliate_id`, `partner_id`, `campaign_id`

### Other Platforms
- **News Sites**: `ftag`, `intcid`, `ncid`, `smid`
- **Video Platforms**: Various platform-specific parameters
- **Chinese Platforms**: Bilibili, Weibo, and other tracking parameters

## Examples

### Clean URLs for Sharing

```swift
func shareURL(_ originalURL: String) {
    let cleanURL = originalURL.withoutTracking
    // Share the clean URL without exposing tracking
    shareToSocialMedia(cleanURL)
}
```

### Selective Cleaning

```swift
func processAnalyticsURL(_ url: String) -> String {
    // Remove analytics tracking but keep social media attribution
    return url.withoutAnalytics
}

func processSocialURL(_ url: String) -> String {
    // Remove social media tracking but keep analytics
    return url.withoutSocial
}
```

### Batch Processing

```swift
func cleanURLList(_ urls: [String]) -> [String] {
    return urls.map { $0.withoutTracking }
}

// Clean multiple URLs efficiently
let dirtyURLs = [
    "https://example.com?utm_source=email&fbclid=123",
    "https://shop.com?gclid=456&ref=affiliate"
]
let cleanURLs = cleanURLList(dirtyURLs)
```

### Custom Parameter Removal

```swift
func processDebugURL(_ url: String) -> String {
    // Remove tracking and debug parameters
    return url.withoutTracking(removing: ["debug", "test", "dev"])
}

func removeOnlyInternalParams(_ url: String) -> String {
    // Remove only internal parameters, keep tracking for analytics
    return url.withoutParams(["internal_id", "session_debug", "dev_mode"])
}
```

### Real-World Examples

#### Google Search Results
```swift
let googleURL = "https://example.com?gclid=Cj0KCQjw&utm_source=google&id=page"
let clean = googleURL.withoutTracking
// Result: "https://example.com?id=page"
```

#### Facebook Shared Links
```swift
let facebookURL = "https://news.com/article?fbclid=IwAR123&utm_medium=social"  
let clean = facebookURL.withoutTracking
// Result: "https://news.com/article"
```

#### Amazon Product Links
```swift
let amazonURL = "https://amazon.com/widget?ref=sr_1_1&tag=affiliate-20&keywords=test"
let clean = amazonURL.withoutTracking
// Result: "https://amazon.com/widget?keywords=test"
```

#### Email Newsletter Links
```swift
let emailURL = "https://shop.com/sale?utm_source=newsletter&mc_cid=abc123"
let clean = emailURL.withoutTracking  
// Result: "https://shop.com/sale"
```

## Performance

URLStripper is optimized for performance:

- ✅ **Fast parameter lookup** using Set-based collections
- ✅ **Efficient URL parsing** with Foundation's URLComponents  
- ✅ **Minimal memory overhead** with lazy evaluation
- ✅ **Scales well** with URLs containing many parameters
- ✅ **Individual cleaning**: ~0.00007ms per URL
- ✅ **Batch processing**: ~0.0004ms per URL in batches

## Requirements

- **Swift 5.9+**
- **iOS 13.0+** / **macOS 10.15+** / **tvOS 13.0+** / **watchOS 6.0+**

## Key Features

### 🎯 Smart Parameter Detection
- Recognizes 500+ tracking parameters from major platforms
- Organized by category (analytics, social, email, e-commerce)
- Case-insensitive parameter matching
- Handles parameters with and without values

### 🔧 Flexible API
```swift
// Remove all tracking
url.withoutTracking

// Remove specific categories
url.withoutAnalytics
url.withoutSocial

// Remove custom parameters
url.withoutParams(["debug", "test"])
```

### 🛡️ Safe & Reliable
- **Preserves functionality** - only removes known tracking parameters
- **Handles edge cases** - malformed URLs, missing parameters, encoding
- **Type safe** - works with both `String` and `URL` types
- **Non-mutating** - original URLs are never modified
- **Thoroughly tested** - comprehensive test suite included

## Contributing

Contributions are welcome! Please feel free to submit pull requests, report bugs, or suggest new features.

### Adding New Tracking Parameters

To add support for new tracking parameters:

1. Add the parameter to the appropriate category in `TrackingParameters.swift`
2. Add test cases in `URLStripperTests.swift`
3. Update documentation if needed

## License

URLStripper is available under the MIT license. See LICENSE file for details.

---

Made with ❤️ for a cleaner, more private web.
