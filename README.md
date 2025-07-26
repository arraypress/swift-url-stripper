# CleanURL

A modern Swift package for removing tracking parameters from URLs while preserving functionality.

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-blue.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2013%20|%20macOS%2010.15%20|%20tvOS%2013%20|%20watchOS%206-lightgrey.svg)](https://swift.org)

## Overview

CleanURL automatically removes tracking parameters from URLs, helping to:
- **Protect privacy** by removing tracking identifiers
- **Clean up URLs** for sharing and bookmarking  
- **Reduce URL length** by removing unnecessary parameters
- **Maintain functionality** by preserving important query parameters

## Quick Start

```swift
import CleanURL

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

Add CleanURL to your project in Xcode:

1. **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/yourusername/CleanURL`
3. Choose the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/CleanURL", from: "1.0.0")
]
```

## Features

### 🎯 Smart Parameter Detection

CleanURL recognizes tracking parameters from major platforms:

- **Analytics**: Google Analytics (utm_*), Google Ads (gclid), Matomo
- **Social Media**: Facebook (fbclid), Twitter (twclid), TikTok (ttclid)  
- **Email Marketing**: MailChimp (mc_cid), HubSpot (_hsenc)
- **E-commerce**: Amazon (ref_), eBay (_trksid), affiliate tracking
- **500+ parameters** from popular platforms and services

### 🔧 Flexible API

```swift
// Remove all tracking
url.withoutTracking

// Remove specific categories
url.withoutTracking(categories: [.analytics, .social])

// Remove custom parameters too
url.withoutTracking(removing: ["custom_param"])
```

### 🛡️ Safe & Reliable

- **Preserves functionality** - only removes known tracking parameters
- **Handles edge cases** - malformed URLs, missing parameters, encoding
- **Type safe** - works with both `String` and `URL` types
- **Non-mutating** - original URLs are never modified
- **Thoroughly tested** - comprehensive test suite included

## Advanced Usage

### Category-Specific Cleaning

Remove only specific types of tracking:

```swift
let url = "https://shop.com?utm_source=google&fbclid=123&ref=affiliate&id=product"

// Remove only analytics tracking
let noAnalytics = url.withoutTracking(categories: [.analytics])
// Result: "https://shop.com?fbclid=123&ref=affiliate&id=product"

// Remove social and e-commerce tracking  
let limited = url.withoutTracking(categories: [.social, .ecommerce])
// Result: "https://shop.com?utm_source=google&id=product"
```

### Custom Parameter Removal

Remove additional parameters beyond standard tracking:

```swift
let url = "https://example.com?utm_source=test&internal_id=123&debug=true"

// Remove tracking + custom parameters
let cleaned = url.withoutTracking(removing: ["internal_id", "debug"])
// Result: "https://example.com"
```

### Batch Processing

Clean multiple URLs efficiently:

```swift
let urls = [
    "https://example.com?utm_source=email&fbclid=123",
    "https://shop.com?gclid=456&ref=affiliate"
]

let cleanedURLs = urls.map { $0.withoutTracking }
```

## Tracking Categories

CleanURL organizes parameters into logical categories:

| Category | Description | Examples |
|----------|-------------|----------|
| **Analytics** | Web analytics and advertising | `utm_*`, `gclid`, `_ga` |
| **Social** | Social media platform tracking | `fbclid`, `ttclid`, `igshid` |
| **Email** | Email marketing and automation | `mc_cid`, `_hsenc`, `mkt_tok` |
| **E-commerce** | Shopping and affiliate tracking | `ref`, `tag`, `affiliate_id` |
| **Other** | Miscellaneous tracking services | Various platform-specific |

## Real-World Examples

### Google Search Results
```swift
let googleURL = "https://example.com?gclid=Cj0KCQjw&utm_source=google&id=page"
let clean = googleURL.withoutTracking
// Result: "https://example.com?id=page"
```

### Facebook Shared Links
```swift
let facebookURL = "https://news.com/article?fbclid=IwAR123&utm_medium=social"  
let clean = facebookURL.withoutTracking
// Result: "https://news.com/article"
```

### Email Newsletter Links
```swift
let emailURL = "https://shop.com/sale?utm_source=newsletter&mc_cid=abc123"
let clean = emailURL.withoutTracking  
// Result: "https://shop.com/sale"
```

### Amazon Product Links
```swift
let amazonURL = "https://amazon.com/widget?ref=sr_1_1&tag=affiliate-20&keywords=test"
let clean = amazonURL.withoutTracking
// Result: "https://amazon.com/widget?keywords=test"
```

## Requirements

- **Swift 5.9+**
- **iOS 13.0+** / **macOS 10.15+** / **tvOS 13.0+** / **watchOS 6.0+**

## Performance

CleanURL is optimized for performance:

- ✅ **Fast parameter lookup** using Set-based collections
- ✅ **Efficient URL parsing** with Foundation's URLComponents  
- ✅ **Minimal memory overhead** with lazy evaluation
- ✅ **Scales well** with URLs containing many parameters

## Contributing

Contributions are welcome! Please feel free to submit pull requests, report bugs, or suggest new features.

### Adding New Tracking Parameters

To add support for new tracking parameters:

1. Add the parameter to the appropriate category in `TrackingParameters.swift`
2. Add test cases in `CleanURLTests.swift`
3. Update documentation if needed

## License

CleanURL is available under the MIT license. See LICENSE file for details.

## Related Projects

- **TextExtractor** - Extract emails, phone numbers, and other data from text
- **URLPlatform** - Detect and categorize URLs by platform

---

Made with ❤️ for a cleaner, more private web.
