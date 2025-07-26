//
//  RealWorldURLTests.swift
//  CleanURL
//
//  Comprehensive real-world URL testing with actual tracking URLs
//  Created on 26/07/2025.
//

import XCTest
@testable import CleanURL

/// Extended test suite focusing on real-world URLs from major platforms.
///
/// This test suite uses actual URLs with real tracking parameters encountered
/// in the wild to ensure CleanURL handles them correctly.
final class RealWorldURLTests: XCTestCase {
    
    // MARK: - Google & Search Engine URLs
    
    func testGoogleSearchResults() {
        // Google search result with multiple tracking parameters
        let googleURL = "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjX&url=https%3A%2F%2Fexample.com%2Farticle&usg=AOvVaw123&ust=1234567890"
        let cleaned = googleURL.withoutTracking
        
        // Should preserve the actual destination URL (either encoded or decoded is fine)
        let hasEncodedURL = cleaned.contains("url=https%3A%2F%2Fexample.com%2Farticle")
        let hasDecodedURL = cleaned.contains("url=https://example.com/article")
        XCTAssertTrue(hasEncodedURL || hasDecodedURL, "Should preserve destination URL")
        
        // Should remove Google's tracking
        XCTAssertFalse(cleaned.contains("sa=t"), "Should remove sa parameter")
        XCTAssertFalse(cleaned.contains("ved="), "Should remove ved parameter")
        XCTAssertFalse(cleaned.contains("uact="), "Should remove uact parameter")
    }
    
    func testGoogleAdsURL() {
        // Google Ads click URL
        let adsURL = "https://example.com/landing?gclid=Cj0KCQjw5ZSWBhCVARIsALERCvxABC123DEF456&gclsrc=aw.ds&utm_source=google&utm_medium=cpc&utm_campaign=summer_sale"
        let cleaned = adsURL.withoutTracking
        let expected = "https://example.com/landing"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testBingSearchURL() {
        // Bing search result
        let bingURL = "https://example.com/page?msclkid=abc123def456&utm_source=bing&utm_medium=cpc"
        let cleaned = bingURL.withoutTracking
        let expected = "https://example.com/page"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - Social Media Platform URLs
    
    func testFacebookSharedLinks() {
        // Facebook shared link with multiple tracking
        let facebookURL = "https://example.com/article?fbclid=IwAR2vQ3K8L9mN0pR1sT2uV3wX4yZ5a6B7c8D9e0F1g2H3i4J5k6L7m8N9o0P&utm_source=facebook&utm_medium=social&utm_campaign=organic"
        let cleaned = facebookURL.withoutTracking
        let expected = "https://example.com/article"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testTwitterSharedLinks() {
        // Twitter/X shared link
        let twitterURL = "https://example.com/news?twclid=2-abc123def456&utm_source=twitter&utm_medium=social&ref_src=twsrc%5Etfw"
        let cleaned = twitterURL.withoutTracking
        let expected = "https://example.com/news"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testTikTokSharedLinks() {
        // TikTok shared link
        let tiktokURL = "https://example.com/product?ttclid=abc123&is_from_webapp=1&sender_device=pc&utm_source=tiktok"
        let cleaned = tiktokURL.withoutTracking
        let expected = "https://example.com/product"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testInstagramLinks() {
        // Instagram shared link
        let instaURL = "https://example.com/photo?igshid=MDJmNzVkMjY%3D&utm_source=ig_web_copy_link"
        let cleaned = instaURL.withoutTracking
        let expected = "https://example.com/photo"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testLinkedInLinks() {
        // LinkedIn shared content
        let linkedinURL = "https://example.com/job?li_fat_id=12345678-abcd-1234-efgh-123456789012&utm_source=linkedin&utm_medium=social"
        let cleaned = linkedinURL.withoutTracking
        let expected = "https://example.com/job"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testRedditLinks() {
        // Reddit shared link
        let redditURL = "https://example.com/discussion?utm_source=share&utm_medium=web2x&utm_name=iossmf&context=3"
        let cleaned = redditURL.withoutTracking
        // Context is functional (thread context), should be preserved
        let expected = "https://example.com/discussion?context=3"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - E-commerce Platform URLs
    
    func testAmazonProductLinks() {
        // Amazon product link with multiple tracking
        let amazonURL = "https://www.amazon.com/dp/B08N5WRWNW?ref=sr_1_1&keywords=wireless+headphones&qid=1635789012&sr=8-1&linkCode=ll1&tag=affiliate-20&linkId=abc123&language=en_US&ref_=as_li_ss_tl"
        let cleaned = amazonURL.withoutTracking
        
        // Should keep the core product identifier
        XCTAssertTrue(cleaned.contains("/dp/B08N5WRWNW"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("ref="))
        XCTAssertFalse(cleaned.contains("tag="))
        XCTAssertFalse(cleaned.contains("linkCode="))
        XCTAssertFalse(cleaned.contains("linkId="))
    }
    
    func testEbayItemLinks() {
        // eBay item link
        let ebayURL = "https://www.ebay.com/itm/123456789?hash=item123abc456&_trksid=p2047675.c100005.m1851&_trkparms=aid%3D222007%26algo%3DSIC.MBE"
        let cleaned = ebayURL.withoutTracking
        
        // Should keep item ID
        XCTAssertTrue(cleaned.contains("/itm/123456789"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("_trksid="))
        XCTAssertFalse(cleaned.contains("_trkparms="))
        XCTAssertFalse(cleaned.contains("hash="))
    }
    
    func testEtsyProductLinks() {
        // Etsy product link
        let etsyURL = "https://www.etsy.com/listing/123456789/handmade-item?ref=shop_home_active_1&frs=1&crt=1"
        let cleaned = etsyURL.withoutTracking
        
        // Should keep listing info
        XCTAssertTrue(cleaned.contains("/listing/123456789/handmade-item"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("ref="))
        XCTAssertFalse(cleaned.contains("frs="))
        XCTAssertFalse(cleaned.contains("crt="))
    }
    
    // MARK: - Email Marketing URLs
    
    func testMailChimpNewsletterLinks() {
        // MailChimp newsletter link
        let mailchimpURL = "https://example.com/newsletter?utm_source=mailchimp&utm_medium=email&utm_campaign=weekly_digest&mc_cid=abc123def456&mc_eid=xyz789"
        let cleaned = mailchimpURL.withoutTracking
        let expected = "https://example.com/newsletter"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testHubSpotEmailLinks() {
        // HubSpot email tracking
        let hubspotURL = "https://example.com/blog-post?utm_source=hubspot&utm_medium=email&_hsmi=12345678&_hsenc=p2ANqtz-abc123def456&utm_campaign=monthly_update"
        let cleaned = hubspotURL.withoutTracking
        let expected = "https://example.com/blog-post"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testSalesforceMarketingCloud() {
        // Salesforce Marketing Cloud
        let sfmcURL = "https://example.com/promo?utm_source=exacttarget&utm_medium=email&utm_campaign=flash_sale&jobid=12345&subid=67890"
        let cleaned = sfmcURL.withoutTracking
        
        // Should preserve functional parameters if any exist
        XCTAssertTrue(cleaned.contains("example.com/promo"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("utm_"))
        XCTAssertFalse(cleaned.contains("jobid="))
        XCTAssertFalse(cleaned.contains("subid="))
    }
    
    // MARK: - News & Media URLs
    
    func testCNNArticleLinks() {
        // CNN article with tracking
        let cnnURL = "https://edition.cnn.com/2023/07/26/tech/ai-news/index.html?utm_source=twCNN&utm_medium=social&utm_campaign=more"
        let cleaned = cnnURL.withoutTracking
        let expected = "https://edition.cnn.com/2023/07/26/tech/ai-news/index.html"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testBBCNewsLinks() {
        // BBC News with analytics
        let bbcURL = "https://www.bbc.com/news/technology-66123456?utm_source=twitter&utm_medium=social&utm_campaign=news_sharing&at_medium=custom7&at_campaign=64&at_custom1=link&at_custom2=twitter"
        let cleaned = bbcURL.withoutTracking
        
        XCTAssertTrue(cleaned.contains("/news/technology-66123456"))
        XCTAssertFalse(cleaned.contains("utm_"))
        XCTAssertFalse(cleaned.contains("at_"))
    }
    
    func testNewYorkTimesLinks() {
        // New York Times article
        let nytURL = "https://www.nytimes.com/2023/07/26/technology/artificial-intelligence.html?smid=tw-nytimes&smtyp=cur&utm_source=twitter&utm_medium=social"
        let cleaned = nytURL.withoutTracking
        
        XCTAssertTrue(cleaned.contains("/2023/07/26/technology/artificial-intelligence.html"))
        XCTAssertFalse(cleaned.contains("smid="))
        XCTAssertFalse(cleaned.contains("smtyp="))
        XCTAssertFalse(cleaned.contains("utm_"))
    }
    
    // MARK: - Video Platform URLs
    
    func testYouTubeVideoLinks() {
        // YouTube video with tracking
        let youtubeURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&utm_source=facebook&utm_medium=social&feature=share&t=42s"
        let cleaned = youtubeURL.withoutTracking
        
        // Debug output
        print("YouTube Original: \(youtubeURL)")
        print("YouTube Cleaned:  \(cleaned)")
        
        // Should keep video ID and timestamp (functional parameters)
        XCTAssertTrue(cleaned.contains("v=dQw4w9WgXcQ"), "Should preserve video ID")
        XCTAssertTrue(cleaned.contains("t=42s"), "Should preserve timestamp")
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("utm_"), "Should remove UTM parameters")
        XCTAssertFalse(cleaned.contains("feature="), "Should remove feature parameter")
        
        // Test the expected result
        let expected = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42s"
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - Subscription & SaaS URLs
    
    func testZoomMeetingLinks() {
        // Zoom meeting with tracking
        let zoomURL = "https://zoom.us/j/123456789?pwd=abc123def456&utm_source=calendar&utm_medium=integration"
        let cleaned = zoomURL.withoutTracking
        
        // Should keep meeting info
        XCTAssertTrue(cleaned.contains("/j/123456789"))
        XCTAssertTrue(cleaned.contains("pwd=abc123def456"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("utm_"))
    }
    
    func testSlackWorkspaceLinks() {
        // Slack workspace invite
        let slackURL = "https://join.slack.com/t/workspace/shared_invite/abc123?utm_source=email&utm_medium=invite"
        let cleaned = slackURL.withoutTracking
        
        // Should keep invite info
        XCTAssertTrue(cleaned.contains("/shared_invite/abc123"))
        // Should remove tracking
        XCTAssertFalse(cleaned.contains("utm_"))
    }
    
    // MARK: - Complex Mixed URLs
    
    func testComplexMixedTrackingURL() {
        // URL with multiple different tracking systems
        let complexURL = "https://shop.example.com/product/widget-pro?id=12345&color=blue&utm_source=google&utm_medium=cpc&utm_campaign=summer_sale&gclid=abc123&fbclid=def456&mc_cid=newsletter123&_hsenc=email789&ref=affiliate_partner&tag=promo2023&track_id=xyz789"
        let cleaned = complexURL.withoutTracking
        let expected = "https://shop.example.com/product/widget-pro?id=12345&color=blue"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testURLWithFunctionalAndTrackingMixed() {
        // URL where functional and tracking parameters are interspersed
        let mixedURL = "https://api.example.com/data?api_key=secret123&utm_source=docs&format=json&utm_medium=referral&limit=50&offset=0&utm_campaign=api_usage&sort=date"
        let cleaned = mixedURL.withoutTracking
        let expected = "https://api.example.com/data?api_key=secret123&format=json&limit=50&offset=0&sort=date"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    // MARK: - International & Special Cases
    
    func testChinesePlatformURLs() {
        // Bilibili video link (Chinese platform)
        let bilibiliURL = "https://www.bilibili.com/video/BV1234567890?spm_id_from=333.851.b_7265636f6d6d656e64.7&vd_source=abc123"
        let cleaned = bilibiliURL.withoutTracking
        
        XCTAssertTrue(cleaned.contains("/video/BV1234567890"))
        XCTAssertFalse(cleaned.contains("spm_id_from="))
        XCTAssertFalse(cleaned.contains("vd_source="))
    }
    
    func testWeiboPosts() {
        // Weibo social media link
        let weiboURL = "https://weibo.com/1234567890/abc123def456?utm_source=share&utm_medium=social&refer_flag=1001030103_"
        let cleaned = weiboURL.withoutTracking
        
        XCTAssertTrue(cleaned.contains("/1234567890/abc123def456"))
        XCTAssertFalse(cleaned.contains("utm_"))
        XCTAssertFalse(cleaned.contains("refer_flag="))
    }
    
    // MARK: - Edge Cases with Real URLs
    
    func testURLWithPortAndPath() {
        // URL with port number and complex path
        let portURL = "https://analytics.example.com:8443/dashboard/reports?utm_source=email&utm_campaign=monthly&report_id=12345&date_range=30d"
        let cleaned = portURL.withoutTracking
        let expected = "https://analytics.example.com:8443/dashboard/reports?report_id=12345&date_range=30d"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testURLWithSubdomainAndFragment() {
        // URL with subdomain and fragment
        let fragmentURL = "https://blog.company.example.com/posts/ai-future?utm_source=newsletter&utm_medium=email&category=tech#introduction"
        let cleaned = fragmentURL.withoutTracking
        let expected = "https://blog.company.example.com/posts/ai-future?category=tech#introduction"
        
        XCTAssertEqual(cleaned, expected)
    }
    
    func testInternationalDomainWithTracking() {
        // International domain with tracking
        let intlURL = "https://новости.рф/tech/article?utm_source=социальные_сети&utm_medium=vk&id=12345"
        let cleaned = intlURL.withoutTracking
        
        XCTAssertTrue(cleaned.contains("id=12345"))
        XCTAssertFalse(cleaned.contains("utm_"))
    }
    
    // MARK: - Performance Test with Real URLs
    
    func testPerformanceWithRealWorldBatch() {
        let realWorldURLs = [
            "https://www.amazon.com/dp/B08N5WRWNW?ref=sr_1_1&keywords=headphones&qid=1635789012&sr=8-1&linkCode=ll1&tag=affiliate-20",
            "https://example.com/article?fbclid=IwAR2vQ3K8L9mN0pR1sT2uV3wX4yZ5a6B7c8D9e0F1g2H3i4J5k6L7m8N9o0P&utm_source=facebook",
            "https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjX&url=https%3A%2F%2Fexample.com",
            "https://shop.example.com/product?gclid=Cj0KCQjw5ZSWBhCVARIsALERCvx&utm_source=google&utm_medium=cpc&utm_campaign=summer",
            "https://example.com/newsletter?utm_source=mailchimp&utm_medium=email&mc_cid=abc123def456&mc_eid=xyz789"
        ]
        
        self.measure {
            for url in realWorldURLs {
                _ = url.withoutTracking
            }
        }
    }
}
