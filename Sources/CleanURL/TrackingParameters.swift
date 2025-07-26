//
//  TrackingParameters.swift
//  CleanURL
//
//  Comprehensive database of tracking parameters organized by category
//  Created on 26/07/2025.
//

import Foundation

/// Centralized repository of known tracking parameters organized by category.
///
/// This struct maintains comprehensive lists of tracking parameters used by
/// various platforms, analytics services, and marketing tools. Parameters are
/// organized by category to allow selective removal.
public struct TrackingParameters {
    
    /// All known tracking parameters across all categories.
    ///
    /// This is the complete set of parameters that will be removed when using
    /// the default `.withoutTracking` property.
    public static let all: Set<String> = {
        var combined = Set<String>()
        combined.formUnion(analytics)
        combined.formUnion(social)
        combined.formUnion(email)
        combined.formUnion(ecommerce)
        combined.formUnion(other)
        return combined
    }()
    
    /// Returns the set of parameters for the specified categories.
    ///
    /// - Parameter categories: The tracking categories to get parameters for
    /// - Returns: Set of parameter names for the specified categories
    public static func parameters(for categories: Set<TrackingCategory>) -> Set<String> {
        var result = Set<String>()
        
        for category in categories {
            switch category {
            case .analytics:
                result.formUnion(analytics)
            case .social:
                result.formUnion(social)
            case .email:
                result.formUnion(email)
            case .ecommerce:
                result.formUnion(ecommerce)
            case .other:
                result.formUnion(other)
            }
        }
        
        return result
    }
    
    // MARK: - Analytics Parameters
    
    /// Google Analytics, Google Ads, and other analytics tracking parameters.
    ///
    /// These parameters are used by Google's advertising and analytics platforms
    /// to track campaign performance, user behavior, and attribution.
    public static let analytics: Set<String> = [
        // Google Analytics & Ads
        "gclid", "gclsrc", "gbraid", "wbraid", "gad_source", "srsltid",
        "utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term", "utm_id",
        "utm_source_platform", "utm_creative_format", "utm_marketing_tactic",
        "_ga", "_gl", "ei", "oq", "esrc", "uact", "cd", "cad", "aqs", "sourceid",
        "sxsrf", "rlz", "pcampaignid", "iflsig", "fbs", "ictx", "cshid",
        
        // Google Search & URL tracking (be careful with 'source' - can be functional)
        "sa", "rct", "ved", "usg", "ust", "rja",
        
        // Google DoubleClick & Merchant Centre
        "dclid", "gpromocode", "gqt",
        
        // Search Engines
        "yclid", "msclkid", "sk", "sp", "sc", "qs", "qp",
        
        // Piwik/Matomo Analytics
        "pk_campaign", "pk_kwd", "pk_keyword", "piwik_campaign", "piwik_kwd", "piwik_keyword",
        "mtm_campaign", "mtm_keyword", "mtm_source", "mtm_medium", "mtm_content",
        "mtm_cid", "mtm_group", "mtm_placement", "matomo_campaign", "matomo_keyword",
        "matomo_source", "matomo_medium", "matomo_content", "matomo_cid",
        "matomo_group", "matomo_placement"
    ]
    
    // MARK: - Social Media Parameters
    
    /// Social media platform tracking parameters.
    ///
    /// These parameters are used by social media platforms like Facebook, Twitter,
    /// TikTok, and others to track clicks, shares, and user engagement.
    public static let social: Set<String> = [
        // Facebook & Meta
        "fbclid", "__tn__", "eid", "__cft__", "__xts__", "comment_tracking", "dti", "app",
        "video_source", "ftentidentifier", "pageid", "padding", "ls_ref",
        "action_history", "tracking", "referral_code", "referral_story_type",
        "eav", "sfnsn", "idorvanity", "wtsid", "rdc", "rdr", "paipv", "_nc_x",
        "_rdr", "mibextid",
        
        // Twitter/X
        "twclid", "cn", "ref_url", "s", "__twitter_impression", "ref_src",
        
        // TikTok
        "ttclid", "is_from_webapp", "sender_device", "k", "share_app_name",
        "share_iid", "_d", "_t", "_r", "timestamp", "user_id",
        
        // Instagram
        "igshid", "igsh",
        
        // LinkedIn
        "li_fat_id",
        
        // Reddit
        "%24deep_link", "$deep_link", "correlation_id", "ref_campaign", "ref_source", "%243p",
        "%24original_url", "share_id", "utm_name",
        
        // Pinterest
        "sccid",
        
        // Snapchat
        "ndclid",
        
        // Chinese Social Platforms
        "refer_flag", "share_from", "share_medium", "share_plat", "share_tag", "share_session_id",
        
        // Other social platforms
        "share_from", "share_medium", "share_plat", "share_tag", "share_session_id"
    ]
    
    // MARK: - Email Marketing Parameters
    
    /// Email marketing and automation platform tracking parameters.
    ///
    /// These parameters are used by email marketing services, marketing automation
    /// platforms, and CRM systems to track email campaign performance.
    public static let email: Set<String> = [
        // General email marketing
        "mc_cid", "mc_eid", "mc_tc", "_ke", "_kx", "dm_i", "ml_subscriber",
        "ml_subscriber_hash", "mkt_tok",
        
        // HubSpot
        "hsa_cam", "hsa_grp", "hsa_mt", "hsa_src", "hsa_ad", "hsa_acc", "hsa_net",
        "hsa_kw", "hsa_tgt", "hsa_ver", "__hssc", "__hstc", "__hsfp", "_hsenc",
        "hsctatracking", "_hsmi", "hsa_cr_id",
        
        // Marketing automation
        "_bta_tid", "_bta_c", "trk_contact", "trk_msg", "trk_module", "trk_sid",
        "mkwid", "pcrid", "ef_id", "s_kwcid", "rb_clickid", "wickedid",
        "vero_conv", "vero_id", "oly_anon_id", "oly_enc_id",
        
        // Salesforce Marketing Cloud
        "jobid", "subid", "sfmc_sub", "sfmc_mid", "sfmc_activityid",
        
        // SMS & Marketing
        "sms_source", "sms_click", "sms_uph",
        
        // Email tracking
        "email_token", "email_source", "email_referrer", "email_subject"
    ]
    
    // MARK: - E-commerce Parameters
    
    /// E-commerce and affiliate marketing tracking parameters.
    ///
    /// These parameters are used by e-commerce platforms, affiliate networks,
    /// and online marketplaces to track sales, referrals, and conversions.
    public static let ecommerce: Set<String> = [
        // E-commerce and affiliate tracking (be careful with generic terms)
        "mkevt", "mkcid", "mkrid", "campid", "toolid", "customid", "_trksid", "_trkparms",
        "_from", "hash", "_branch_match_id", "irclickid", "irgwc", "epik", "tag",
        "ref", "campaign", "ad_id", "click_id", "campaign_id", "affiliate_id",
        "partner_id", "referrer", "tracking_id", "k_clickid", "aff_request_id",
        
        // Amazon
        "qid", "sr", "sprefix", "crid", "keywords", "ref_", "th", "linkcode",
        "creativeasin", "ascsubtag", "aaxitk", "dchild", "camp",
        "creative", "content-id", "dib", "dib_tag", "social_share", "starsleft",
        "skiptwisterog", "_encoding", "smid", "field-lbr_brands_browse-bin",
        "qualifier", "spia", "ms3_c", "refrid", "linkid",
        
        // eBay
        "hash", "_trkparms", "_trksid", "mkevt", "mkcid", "mkrid",
        
        // Etsy
        "frs", "crt", "sts", "share_time",
        
        // Other e-commerce
        "price", "sourcetype", "suid", "ut_sk", "un", "share_crt_v", "sp_tk",
        "cpp", "shareurl", "short_name", "pvid", "algo_expid", "algo_pvid"
    ]
    
    // MARK: - Other Parameters
    
    /// Miscellaneous tracking parameters from various services and platforms.
    ///
    /// This category includes tracking parameters that don't fit neatly into
    /// other categories, including news sites, content platforms, and various
    /// third-party tracking services.
    public static let other: Set<String> = [
        // News & Media tracking
        "ftag", "intcid", "smid", "cmp", "sh", "ito", "sharetoken", "taid",
        "__source", "ncid", "sr_share", "guccounter", "guce_referrer",
        "guce_referrer_sig", "smtyp", "at_medium", "at_campaign", "at_custom1",
        "at_custom2", "at_custom3", "at_custom4",
        
        // Video/Content platforms
        "si", "feature", "kw", "pp", "u_code", "preview_pb", "spm_id_from",
        "vd_source", "spm", "bvid", "share_source", "msource", "refer_from",
        
        // Chinese platforms (Bilibili, Weibo, etc.)
        "spm_id_from", "vd_source", "from_source", "from", "seid", "mid",
        "share_source", "refer_from", "share_from", "share_medium",
        "share_plat", "share_tag", "share_session_id", "unique_k",
        "plat_id", "buvid", "is_story_h5", "up_id", "bbid", "ts", "visit_id",
        "session_id", "broadcast_type", "is_room_feed",
        
        // Generic tracking identifiers
        "track_id", "tracking_id", "trackid", "trk_id", "trkid", "tracker",
        "track", "trk", "tid", "tracking", "trace_id", "trace",
        
        // General tracking
        "rtid", "vmcid", "tw_source", "tw_campaign", "tw_term", "tw_content",
        "tw_adid", "cvid", "ocid", "echobox", "ceneo_spo", "_openstat",
        "os_ehash", "cmpid", "tracking_source",
        
        // Specialized services
        "gdfms", "gdftrk", "gdffi", "__s", "sznclid",
        
        // Session & misc (excluding YouTube functional parameters)
        "sessionid", "_", "r", "u", "b", "h", "cuid"
    ]
    
}
