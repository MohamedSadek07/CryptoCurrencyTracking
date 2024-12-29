//
//  CurrencyDetailsResponseModel.swift
//  iJusoor
//
//  Created by Mohamed Sadek on 28/12/2024.
//

import Foundation

// MARK: - CurrencyDetailsResponseModel
struct CurrencyDetailsResponseModel: Codable {
    let id: String?
    let symbol, name: String?
    let webSlug: String?
    let assetPlatformID: String?
    let platforms: Platforms?
    let detailPlatforms: DetailPlatforms?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let previewListing: Bool?
    let publicNotice: String?
    let additionalNotices: [String?]?
    let localization, description: Tion?
    let links: Links?
    let image: DetailsImage?
    let countryOrigin, genesisDate: String?
    let sentimentVotesUpPercentage, sentimentVotesDownPercentage: Double?
    let watchlistPortfolioUsers, marketCapRank: Int?
    let marketData: MarketData?
    let communityData: CommunityData?
    let developerData: DeveloperData?
    let statusUpdates: [String?]?
    let lastUpdated: String?
    let tickers: [Ticker]?

    enum CodingKeys: String, CodingKey {
          case id, symbol, name
          case webSlug
          case assetPlatformID
          case platforms
          case detailPlatforms
          case blockTimeInMinutes
          case hashingAlgorithm
          case categories
          case previewListing
          case publicNotice
          case additionalNotices
          case localization, description, links, image
          case countryOrigin
          case genesisDate
          case sentimentVotesUpPercentage
          case sentimentVotesDownPercentage
          case watchlistPortfolioUsers
          case marketCapRank
          case marketData = "market_data"
          case communityData
          case developerData
          case statusUpdates
          case lastUpdated
          case tickers
      }
}

// MARK: - CommunityData
struct CommunityData: Codable {
    let facebookLikes: String?
    let twitterFollowers, redditAveragePosts48H, redditAverageComments48H, redditSubscribers: Int?
    let redditAccountsActive48H: Int?
    let telegramChannelUserCount: String?

    enum CodingKeys: String, CodingKey {
        case facebookLikes
        case twitterFollowers
        case redditAveragePosts48H
        case redditAverageComments48H
        case redditSubscribers
        case redditAccountsActive48H
        case telegramChannelUserCount
    }
}

// MARK: - Tion
struct Tion: Codable {
    let en, de, es, fr: String?
    let it, pl, ro, hu: String?
    let nl, pt, sv, vi: String?
    let tr, ru, ja, zh: String?
    let zhTw, ko, ar, th: String?
    let id, cs, da, el: String?
    let hi, no, sk, uk: String?
    let he, fi, bg, hr: String?
    let lt, sl: String?

    enum CodingKeys: String, CodingKey {
         case en, de, es, fr, it, pl, ro, hu, nl, pt, sv, vi, tr, ru, ja, zh
         case zhTw
         case ko, ar, th, id, cs, da, el, hi, no, sk, uk, he, fi, bg, hr, lt, sl
     }
}

// MARK: - DetailPlatforms
struct DetailPlatforms: Codable {
    let empty: Empty?

    enum CodingKeys: String, CodingKey {
          case empty
      }
}

// MARK: - Empty
struct Empty: Codable {
    let decimalPlace: String?
    let contractAddress: String?

    enum CodingKeys: String, CodingKey {
        case decimalPlace
        case contractAddress
    }
}

// MARK: - DeveloperData
struct DeveloperData: Codable {
    let forks, stars, subscribers, totalIssues: Int?
    let closedIssues, pullRequestsMerged, pullRequestContributors: Int?
    let codeAdditionsDeletions4_Weeks: CodeAdditionsDeletions4_Weeks?
    let commitCount4_Weeks: Int?
    let last4_WeeksCommitActivitySeries: [String?]?

    enum CodingKeys: String, CodingKey {
          case forks, stars, subscribers
          case totalIssues
          case closedIssues
          case pullRequestsMerged
          case pullRequestContributors
          case codeAdditionsDeletions4_Weeks
          case commitCount4_Weeks
          case last4_WeeksCommitActivitySeries
      }
}

// MARK: - CodeAdditionsDeletions4_Weeks
struct CodeAdditionsDeletions4_Weeks: Codable {
    let additions, deletions: Int?
}

// MARK: - Image
struct DetailsImage: Codable {
    let thumb, small, large: String?
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let whitepaper: String?
    let blockchainSite, officialForumURL: [String]?
    let chatURL, announcementURL: [String?]?
    let snapshotURL: String?
    let twitterScreenName: String?
    let facebookUsername: String?
    let bitcointalkThreadIdentifier: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
    let reposURL: ReposURL?

    enum CodingKeys: String, CodingKey {
        case homepage, whitepaper
        case blockchainSite
        case officialForumURL
        case chatURL
        case announcementURL
        case snapshotURL
        case twitterScreenName
        case facebookUsername
        case bitcointalkThreadIdentifier
        case telegramChannelIdentifier
        case subredditURL
        case reposURL
    }
}

// MARK: - ReposURL
struct ReposURL: Codable {
    let github: [String]?
    let bitbucket: [String?]?
}

// MARK: - MarketData
struct MarketData: Codable {
    let currentPrice: [String: Double]?
    let totalValueLocked, mcapToTvlRatio, fdvToTvlRatio: String?
    let roi: ROI?
    let ath, athChangePercentage: [String: Double]?
    let athDate: [String: String]?
    let atl, atlChangePercentage: [String: Double]?
    let atlDate: [String: String]?
    let marketCap: [String: Double]?
    let marketCapRank: Int?
    let fullyDilutedValuation: [String: Double]?
    let marketCapFdvRatio: Double?
    let totalVolume, high24H, low24H: [String: Double]?
    let priceChange24H, priceChangePercentage24H, priceChangePercentage7D, priceChangePercentage14D: Double?
    let priceChangePercentage30D, priceChangePercentage60D, priceChangePercentage200D, priceChangePercentage1Y: Double?
    let marketCapChange24H: Int?
    let marketCapChangePercentage24H: Double?
    let priceChange24HInCurrency, priceChangePercentage1HInCurrency, priceChangePercentage24HInCurrency, priceChangePercentage7DInCurrency: [String: Double]?
    let priceChangePercentage14DInCurrency, priceChangePercentage30DInCurrency, priceChangePercentage60DInCurrency, priceChangePercentage200DInCurrency: [String: Double]?
    let priceChangePercentage1YInCurrency, marketCapChange24HInCurrency, marketCapChangePercentage24HInCurrency: [String: Double]?
    let totalSupply, maxSupply: Int?
    let maxSupplyInfinite: Bool?
    let circulatingSupply: Int?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case totalValueLocked
        case mcapToTvlRatio
        case fdvToTvlRatio
        case roi, ath
        case athChangePercentage
        case athDate
        case atl
        case atlChangePercentage
        case atlDate
        case marketCap
        case marketCapRank
        case fullyDilutedValuation
        case marketCapFdvRatio
        case totalVolume
        case high24H
        case low24H
        case priceChange24H
        case priceChangePercentage24H
        case priceChangePercentage7D
        case priceChangePercentage14D
        case priceChangePercentage30D
        case priceChangePercentage60D
        case priceChangePercentage200D
        case priceChangePercentage1Y
        case marketCapChange24H
        case marketCapChangePercentage24H
        case priceChange24HInCurrency
        case priceChangePercentage1HInCurrency
        case priceChangePercentage24HInCurrency
        case priceChangePercentage7DInCurrency
        case priceChangePercentage14DInCurrency
        case priceChangePercentage30DInCurrency
        case priceChangePercentage60DInCurrency
        case priceChangePercentage200DInCurrency
        case priceChangePercentage1YInCurrency
        case marketCapChange24HInCurrency
        case marketCapChangePercentage24HInCurrency
        case totalSupply
        case maxSupply
        case maxSupplyInfinite
        case circulatingSupply
        case lastUpdated
    }
}

// MARK: - ROI
struct ROI: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

// MARK: - Platforms
struct Platforms: Codable {
    let empty: String?
}

// MARK: - Ticker
struct Ticker: Codable {
    let base, target: String?
    let market: Market?
    let last, volume: Double?
    let convertedLast, convertedVolume: [String: Double]?
    let trustScore: String?
    let bidAskSpreadPercentage: Double?
    let timestamp, lastTradedAt, lastFetchAt: String?
    let isAnomaly, isStale: Bool?
    let tradeURL: String?
    let tokenInfoURL: String?
    let coinID: String?
    let targetCoinID: String?

    enum CodingKeys: String, CodingKey {
        case base, target, market, last, volume
        case convertedLast
        case convertedVolume
        case trustScore
        case bidAskSpreadPercentage
        case timestamp
        case lastTradedAt
        case lastFetchAt
        case isAnomaly
        case isStale
        case tradeURL
        case tokenInfoURL
        case coinID
        case targetCoinID
    }
}


// MARK: - Market
struct Market: Codable {
    let name, identifier: String?
    let hasTradingIncentive: Bool?

    enum CodingKeys: String, CodingKey {
           case name, identifier
           case hasTradingIncentive
       }
}
