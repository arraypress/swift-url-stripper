# Swift URL Stripper

A lightweight Swift library for removing tracking parameters from URLs while preserving the parameters that actually matter. It strips analytics, social, email, and e-commerce trackers from both `String` and `URL` values, with a comprehensive built-in database of known tracking parameters and category-specific removal. Zero dependencies, Foundation only.

## Features

- 🎯 **One-call cleanup** — `withoutTracking` removes every known tracking parameter in a single property access
- 📊 **Category-specific stripping** — remove only analytics, only social, only email, or only e-commerce trackers
- 🗄️ **Comprehensive database** — hundreds of parameters covering Google, Facebook, TikTok, Mailchimp, HubSpot, Amazon, eBay, and many more
- 🔡 **Case-insensitive matching** — `UTM_Source` and `utm_source` are both removed
- 🧩 **Custom parameters** — add your own params to remove, or remove only your params while keeping trackers
- 🔗 **Works on `String` and `URL`** — identical API surface on both types
- 🛟 **Robust fallback** — malformed URLs fall back to string-based query parsing instead of failing
- 🧼 **Clean output** — drops the trailing `?` when no parameters remain
- 🔒 **Non-mutating** — always returns a new value; the original is never modified
- 🍎 **Pure Swift, no dependencies** — Foundation only, works fully offline

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 26.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-url-stripper.git", from: "1.0.0")
]
```

## Usage

### Remove all tracking

```swift
import URLStripper

let dirty = "https://example.com?utm_source=newsletter&id=123&fbclid=abc"
let clean = dirty.withoutTracking
// "https://example.com?id=123"

// Also works on URL
let url = URL(string: "https://example.com?utm_source=newsletter&id=123")!
let cleanURL = url.withoutTracking
// URL for "https://example.com?id=123"
```

### Remove only a specific category

```swift
import URLStripper

let url = "https://example.com?utm_source=google&fbclid=123&id=page"

url.withoutAnalytics   // "https://example.com?fbclid=123&id=page"
url.withoutSocial      // "https://example.com?utm_source=google&id=page"
url.withoutEmail       // removes mc_cid, mkt_tok, hsa_*, etc.
url.withoutEcommerce   // removes amazon/ebay/affiliate trackers
```

### Custom parameters

```swift
import URLStripper

// Remove all tracking PLUS your own params
"https://example.com?utm_source=test&debug=true&id=123"
    .withoutTracking(removing: ["debug"])
    // "https://example.com?id=123"

// Remove ONLY your params, keep tracking intact
"https://example.com?utm_source=test&debug=true"
    .withoutParams(["debug"])
    // "https://example.com?utm_source=test"
```

### Inspecting the parameter database

```swift
import URLStripper

TrackingParameters.all         // every known tracking parameter
TrackingParameters.analytics   // Google Analytics/Ads, Matomo, search engines
TrackingParameters.social      // Facebook, Twitter/X, TikTok, Instagram, Reddit
TrackingParameters.email       // Mailchimp, HubSpot, Salesforce, Klaviyo
TrackingParameters.ecommerce   // Amazon, eBay, Etsy, affiliate networks
TrackingParameters.other       // news sites, video platforms, misc trackers
```

## How It Works

The cleaner parses the URL with `URLComponents`, lowercases the parameter names to remove for case-insensitive matching, then drops any query item whose name is in the removal set. If all parameters are removed, the query component is dropped entirely so no trailing `?` remains. For the `String` API, when `URLComponents` cannot parse a malformed URL, a string-based fallback splits on `?` and `&` and filters manually, so cleanup still succeeds.

`TrackingParameters.all` is the union of the `analytics`, `social`, `email`, `ecommerce`, and `other` category sets, so `withoutTracking` covers everything the category-specific helpers do.

## Models

| Type | Description |
|------|-------------|
| `TrackingParameters` | Static sets of known tracking parameter names, grouped by category (`all`, `analytics`, `social`, `email`, `ecommerce`, `other`) |

## Use Cases

- Cleaning shared links before posting or storing them
- Normalising URLs for deduplication and caching
- Privacy tooling that strips trackers from copied or pasted links
- Sanitising affiliate/marketing URLs in scrapers and aggregators

## Testing

```bash
swift test
```

The test suite covers all-category removal, per-category stripping, custom parameter handling, case-insensitivity, and the malformed-URL fallback.

## License

MIT License — see LICENSE file for details.

## Author

Created by David Sherlock ([ArrayPress](https://github.com/arraypress)) in 2026.
