//
//  URLStripperTests.swift
//  URLStripper
//
//  Comprehensive test suite for URL tracking parameter removal
//  Created on 26/07/2025.
//

import XCTest
@testable import URLStripper

final class URLStripperTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testBasicTrackingRemoval() {
        let dirtyURL = "https://example.com?utm_source=newsletter&id=123&fbclid=abc"
        let clean = dirtyURL.withoutTracking
        let expected = "https://example.com?id=123"
        
        XCTAssertEqual(clean, expected)
    }
    
    func testEmptyURLHandling() {
        let emptyURL = ""
        XCTAssertEqual(emptyURL.withoutTracking, "")
        
        let noParams = "https://example.com"
        XCTAssertEqual(noParams.withoutTracking, "https://example.com")
    }
    
    func testURLWithoutQueryParams() {
        let url = "https://example.com/path"
        XCTAssertEqual(url.withoutTracking, url)
    }
    
    func testAllTrackingParametersRemoved() {
        let url = "https://example.com?utm_source=test&utm_medium=email&utm_campaign=summer&gclid=123&fbclid=456"
        let clean = url.withoutTracking
        let expected = "https://example.com"
        
        XCTAssertEqual(clean, expected)
    }
    
    func testFunctionalParametersPreserved() {
        let url = "https://example.com?utm_source=test&id=123&page=2&sort=date"
        let clean = url.withoutTracking
        let expected = "https://example.com?id=123&page=2&sort=date"
        
        XCTAssertEqual(clean, expected)
    }
    
    // MARK: - Category-Specific Tests
    
    func testAnalyticsOnlyRemoval() {
        let url = "https://example.com?utm_source=google&fbclid=123&mc_cid=456&id=page"
        let clean = url.withoutAnalytics
        
        XCTAssertTrue(clean.contains("fbclid=123"))
        XCTAssertTrue(clean.contains("mc_cid=456"))
        XCTAssertTrue(clean.contains("id=page"))
        XCTAssertFalse(clean.contains("utm_source=google"))
    }
    
    func testSocialOnlyRemoval() {
        let url = "https://example.com?utm_source=google&fbclid=123&mc_cid=456&id=page"
        let clean = url.withoutSocial
        
        XCTAssertTrue(clean.contains("utm_source=google"))
        XCTAssertTrue(clean.contains("mc_cid=456"))
        XCTAssertTrue(clean.contains("id=page"))
        XCTAssertFalse(clean.contains("fbclid=123"))
    }
    
    func testEmailOnlyRemoval() {
        let url = "https://example.com?utm_source=google&fbclid=123&mc_cid=456&id=page"
        let clean = url.withoutEmail
        
        XCTAssertTrue(clean.contains("utm_source=google"))
        XCTAssertTrue(clean.contains("fbclid=123"))
        XCTAssertTrue(clean.contains("id=page"))
        XCTAssertFalse(clean.contains("mc_cid=456"))
    }
    
    func testEcommerceOnlyRemoval() {
        let url = "https://example.com?utm_source=google&ref=amazon&tag=affiliate&id=page"
        let clean = url.withoutEcommerce
        
        XCTAssertTrue(clean.contains("utm_source=google"))
        XCTAssertTrue(clean.contains("id=page"))
        XCTAssertFalse(clean.contains("ref=amazon"))
        XCTAssertFalse(clean.contains("tag=affiliate"))
    }
    
    // MARK: - Custom Parameter Tests
    
    func testCustomParameterRemoval() {
        let url = "https://example.com?utm_source=test&debug=true&temp=remove&id=123"
        let clean = url.withoutTracking(removing: ["debug", "temp"])
        let expected = "https://example.com?id=123"
        
        XCTAssertEqual(clean, expected)
    }
    
    func testOnlyCustomParameterRemoval() {
        let url = "https://example.com?utm_source=test&debug=true&temp=remove&id=123"
        let clean = url.withoutParams(["debug", "temp"])
        let expected = "https://example.com?utm_source=test&id=123"
        
        XCTAssertEqual(clean, expected)
    }
    
    // MARK: - URL Type Tests
    
    func testFoundationURLSupport() {
        let url = URL(string: "https://example.com?utm_source=test&id=123")!
        let clean = url.withoutTracking
        let expected = URL(string: "https://example.com?id=123")!
        
        XCTAssertEqual(clean, expected)
    }
    
    func testURLCategorySpecificRemoval() {
        let url = URL(string: "https://example.com?utm_source=google&fbclid=123&id=page")!
        let clean = url.withoutAnalytics
        
        XCTAssertTrue(clean.absoluteString.contains("fbclid=123"))
        XCTAssertTrue(clean.absoluteString.contains("id=page"))
        XCTAssertFalse(clean.absoluteString.contains("utm_source=google"))
    }
    
    func testURLCustomParameterRemoval() {
        let url = URL(string: "https://example.com?utm_source=test&debug=true&id=123")!
        let clean = url.withoutParams(["debug"])
        
        XCTAssertTrue(clean.absoluteString.contains("utm_source=test"))
        XCTAssertTrue(clean.absoluteString.contains("id=123"))
        XCTAssertFalse(clean.absoluteString.contains("debug=true"))
    }
    
    // MARK: - Real-World URL Tests
    
    func testGoogleSearchResults() {
        let googleURL = "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjX&url=https%3A%2F%2Fexample.com%2Farticle"
        let cleaned = googleURL.withoutTracking
        
        // Should preserve the actual destination URL
        let hasURL = cleaned.contains("url=https%3A%2F%2Fexample.com%2Farticle") ||
        cleaned.contains("url=https://example.com/article")
        XCTAssertTrue(hasURL, "Should preserve destination URL")
        
        // Should remove Google's tracking
        XCTAssertFalse(cleaned.contains("sa=t"))
        XCTAssertFalse(cleaned.contains("ved="))
        XCTAssertFalse(cleaned.contains("uact="))
    }
    
    func testFacebookSharedLinks() {
        let facebookURL = "https://example.com/article?fbclid=IwAR2vQ3K8L9mN0pR1sT2uV3wX4yZ5a6B7c8D9e0F1g2H3i4J5k6L7m8N9o0P&utm_source=facebook"
        let cleaned = facebookURL.withoutTracking
        let expected = "https://example.com/article"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testAmazonProductLinks() {
        let amazonURL = "https://www.amazon.com/dp/B08N5WRWNW?ref=sr_1_1&keywords=wireless+headphones&tag=affiliate-20"
        let cleaned = amazonURL.withoutTracking
        
        // Should keep the core product identifier
        XCTAssertTrue(cleaned.contains("/dp/B08N5WRWNW"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("ref="))
        XCTAssertFalse(cleaned.contains("tag="))
    }
    
    func testYouTubeVideoLinks() {
        let youtubeURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&utm_source=facebook&feature=share&t=42s"
        let cleaned = youtubeURL.withoutTracking
        let expected = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42s"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testMailChimpNewsletterLinks() {
        let mailchimpURL = "https://example.com/newsletter?utm_source=mailchimp&utm_medium=email&mc_cid=abc123def456"
        let cleaned = mailchimpURL.withoutTracking
        let expected = "https://example.com/newsletter"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - Enhanced Real-World Tests
    
    func testAmazonInternationalVariations() {
        let testCases = [
            ("https://amazon.co.uk/dp/B123?ref=sr_1_1&tag=uk-affiliate", "https://amazon.co.uk/dp/B123"),
            ("https://amazon.de/dp/B456?ref=sr_1_2&tag=de-tag&language=de", "https://amazon.de/dp/B456?language=de"),
            ("https://amazon.ca/gp/product/B789?ref=ppx_yo_dt&tag=ca-20", "https://amazon.ca/gp/product/B789")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    func testSocialMediaPlatformVariations() {
        let testCases = [
            // TikTok
            ("https://example.com?ttclid=abc123&is_from_webapp=1&sender_device=pc&id=video", "https://example.com?id=video"),
            // Instagram
            ("https://example.com?igshid=MDJmNzVkMjY%3D&utm_source=ig_web&post_id=123", "https://example.com?post_id=123"),
            // LinkedIn
            ("https://example.com?li_fat_id=12345&utm_source=linkedin&job_id=456", "https://example.com?job_id=456"),
            // Reddit
            ("https://example.com?utm_source=share&utm_medium=web2x&context=3&thread_id=789", "https://example.com?context=3&thread_id=789")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    func testEmailMarketingPlatforms() {
        let testCases = [
            // HubSpot
            ("https://example.com?_hsenc=p2ANqtz-abc&_hsmi=12345&utm_campaign=email", "https://example.com"),
            // Salesforce Marketing Cloud
            ("https://example.com?jobid=123&subid=456&sfmc_sub=789&content_id=article", "https://example.com?content_id=article"),
            // General email tracking
            ("https://example.com?mkt_tok=eyJ0eXAi&email_source=newsletter&article_id=10", "https://example.com?article_id=10")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    func testNewsAndMediaSites() {
        let testCases = [
            // CNN
            ("https://cnn.com/article?utm_source=twCNN&utm_medium=social&ftag=cnn123", "https://cnn.com/article"),
            // BBC
            ("https://bbc.com/news/tech-123?at_medium=custom7&at_campaign=64&article_id=tech-123", "https://bbc.com/news/tech-123?article_id=tech-123"),
            // NYTimes
            ("https://nytimes.com/article?smid=tw-nytimes&smtyp=cur&story_id=456", "https://nytimes.com/article?story_id=456")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    // MARK: - Edge Cases
    
    func testCaseInsensitiveParameterRemoval() {
        let url = "https://example.com?UTM_SOURCE=test&Fbclid=123&ID=page"
        let clean = url.withoutTracking
        let expected = "https://example.com?ID=page"
        
        XCTAssertEqual(clean, expected)
    }
    
    func testParametersWithoutValues() {
        let url = "https://example.com?utm_source&fbclid&id=123"
        let clean = url.withoutTracking
        let expected = "https://example.com?id=123"
        
        XCTAssertEqual(clean, expected)
    }
    
    func testComplexMixedTrackingURL() {
        let complexURL = "https://shop.example.com/product/widget-pro?id=12345&color=blue&utm_source=google&gclid=abc123&fbclid=def456&mc_cid=newsletter123"
        let cleaned = complexURL.withoutTracking
        let expected = "https://shop.example.com/product/widget-pro?id=12345&color=blue"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testURLWithPortAndFragment() {
        let portURL = "https://analytics.example.com:8443/dashboard?utm_source=email&report_id=12345#section1"
        let cleaned = portURL.withoutTracking
        let expected = "https://analytics.example.com:8443/dashboard?report_id=12345#section1"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testMalformedURLFallback() {
        let malformedURL = "not-a-valid-url?utm_source=test&id=123"
        let cleaned = malformedURL.withoutTracking
        let expected = "not-a-valid-url?id=123"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testURLsWithSpecialCharacters() {
        let testCases = [
            // Encoded characters
            ("https://example.com?utm_source=test&name=John%20Doe&id=123", "https://example.com?name=John%20Doe&id=123"),
            // Unicode domain (URLComponents converts to punycode - this is correct behavior)
            ("https://müller.de/product?utm_source=test&productId=123", "https://xn--mller-kva.de/product?productId=123"),
            // Special characters in parameters
            ("https://example.com?utm_campaign=summer%202023&search=cats%20%26%20dogs", "https://example.com?search=cats%20%26%20dogs")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    func testVeryLongURLsWithManyParameters() {
        // Create a URL with 20+ parameters
        let baseURL = "https://example.com/very/long/path/to/resource"
        var params = [String]()
        
        // Add tracking parameters
        params.append("utm_source=google")
        params.append("utm_medium=cpc")
        params.append("utm_campaign=summer_sale_2023")
        params.append("gclid=Cj0KCQjw5ZSWBhCVARIsALERCvxABC123DEF456")
        params.append("fbclid=IwAR2vQ3K8L9mN0pR1sT2uV3wX4yZ5a6B7c8D9e0F1g2H3i4J5k6L7m8N9o0P")
        params.append("mc_cid=abc123def456")
        
        // Add functional parameters
        for i in 1...15 {
            params.append("param\(i)=value\(i)")
        }
        
        let longURL = baseURL + "?" + params.joined(separator: "&")
        let cleaned = longURL.withoutTracking
        
        // Should remove tracking but keep functional parameters
        XCTAssertFalse(cleaned.contains("utm_"))
        XCTAssertFalse(cleaned.contains("gclid"))
        XCTAssertFalse(cleaned.contains("fbclid"))
        XCTAssertFalse(cleaned.contains("mc_cid"))
        
        // Should keep functional parameters
        for i in 1...15 {
            XCTAssertTrue(cleaned.contains("param\(i)=value\(i)"))
        }
    }
    
    func testEmptyAndWhitespaceParameters() {
        let testCases = [
            ("https://example.com?utm_source=&id=123", "https://example.com?id=123"),
            ("https://example.com?utm_source=%20&id=123", "https://example.com?id=123"),
            ("https://example.com?utm_source=test&id=&page=2", "https://example.com?id=&page=2")
        ]
        
        for (input, expected) in testCases {
            let cleaned = input.withoutTracking
            XCTAssertEqual(cleaned, expected, "Failed for: \(input)")
        }
    }
    
    // MARK: - Array Processing Tests
    
    func testBatchURLProcessing() {
        let urls = [
            "https://example.com?utm_source=test&id=1",
            "https://example.com?fbclid=123&id=2",
            "https://example.com?mc_cid=456&id=3"
        ]
        
        let cleaned = urls.map { $0.withoutTracking }
        let expected = [
            "https://example.com?id=1",
            "https://example.com?id=2",
            "https://example.com?id=3"
        ]
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testMixedURLArray() {
        let urls = [
            "https://example.com?utm_source=test&id=1",        // Dirty URL
            "https://example.com?id=2",                        // Clean URL
            "not-a-url?utm_source=test&id=3",                 // Malformed URL
            "https://example.com",                              // URL without parameters
            ""                                                  // Empty string
        ]
        
        let cleaned = urls.map { $0.withoutTracking }
        let expected = [
            "https://example.com?id=1",
            "https://example.com?id=2",
            "not-a-url?id=3",
            "https://example.com",
            ""
        ]
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testFoundationURLArray() {
        let urls = [
            URL(string: "https://example.com?utm_source=test&id=1")!,
            URL(string: "https://example.com?fbclid=123&id=2")!,
            URL(string: "https://example.com?id=3")!
        ]
        
        let cleaned = urls.map { $0.withoutTracking }
        let expected = [
            URL(string: "https://example.com?id=1")!,
            URL(string: "https://example.com?id=2")!,
            URL(string: "https://example.com?id=3")!
        ]
        
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithRealWorldBatch() {
        let realWorldURLs = [
            "https://www.amazon.com/dp/B08N5WRWNW?ref=sr_1_1&keywords=headphones&tag=affiliate-20",
            "https://example.com/article?fbclid=IwAR2vQ3K8L9mN0pR1sT2uV3wX4yZ5a6B7c8D9e0F1g2H3i4J5k6L7m8N9o0P",
            "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&url=https%3A%2F%2Fexample.com",
            "https://shop.example.com/product?gclid=Cj0KCQjw5ZSWBhCVARIsALERCvx&utm_source=google",
            "https://example.com/newsletter?utm_source=mailchimp&mc_cid=abc123def456"
        ]
        
        self.measure {
            for url in realWorldURLs {
                _ = url.withoutTracking
            }
        }
    }
    
    func testPerformanceIndividualCleaning() {
        let testURL = "https://example.com?utm_source=test&utm_medium=email&utm_campaign=summer&gclid=123&fbclid=456&mc_cid=789&ref=amazon&tag=affiliate&id=123&page=2"
        
        self.measure {
            for _ in 0..<1000 {
                _ = testURL.withoutTracking
            }
        }
    }
    
    func testPerformanceVeryLongURL() {
        // Create URL with 50 parameters
        var params = [String]()
        for i in 1...25 {
            params.append("utm_param\(i)=value\(i)")
            params.append("functional_param\(i)=value\(i)")
        }
        
        let longURL = "https://example.com?" + params.joined(separator: "&")
        
        self.measure {
            for _ in 0..<100 {
                _ = longURL.withoutTracking
            }
        }
    }
    
    func testPerformanceCategorySpecific() {
        let testURL = "https://example.com?utm_source=google&fbclid=123&mc_cid=456&ref=amazon&id=page"
        
        self.measure {
            for _ in 0..<1000 {
                _ = testURL.withoutAnalytics
                _ = testURL.withoutSocial
                _ = testURL.withoutEmail
                _ = testURL.withoutEcommerce
            }
        }
    }
}
