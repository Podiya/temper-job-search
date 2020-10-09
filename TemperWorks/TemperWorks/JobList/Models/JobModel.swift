//
//  JobModel.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import Foundation



struct JobModel: Codable {
    let id: Int
    let shifts: [ShiftModel]
    let allowsFactoring: Bool
    let url: String
    let title, key: String
    let date: JobDateModel
    let location: LocationModel
    let maxPossibleEarningsTotal, maxPossibleEarningsHour: Double
    let openPositions, newMatchesCount: Int
    let client: ClientModel
    let jobCategory: JobCategoryModel
    let photo: String?

    enum CodingKeys: String, CodingKey {
        case id, shifts
        case allowsFactoring = "allows_factoring"
        case url, title, key, date, location
        case maxPossibleEarningsTotal = "max_possible_earnings_total"
        case maxPossibleEarningsHour = "max_possible_earnings_hour"
        case openPositions = "open_positions"
        case newMatchesCount = "new_matches_count"
        case client
        case jobCategory = "job_category"
        case photo
    }
}

struct ClientModel: Codable {
    let photos: [PhotoModel]
    let factoringPaymentTermInDays: Int
    let rating: RatingModel
    let id: String
    let avgResponseTimeInHours: Int
    let clientDescription: String?
    let factoringAllowed: Bool
    let name: String

    enum CodingKeys: String, CodingKey {
        case photos
        case factoringPaymentTermInDays = "factoring_payment_term_in_days"
        case rating, id
        case avgResponseTimeInHours = "avg_response_time_in_hours"
        case clientDescription = "description"
        case factoringAllowed = "factoring_allowed"
        case name
    }
}

struct PhotoModel: Codable {
    let formats: [FormatModel]
}

struct FormatModel: Codable {
    let cdnURL: String

    enum CodingKeys: String, CodingKey {
        case cdnURL = "cdn_url"
    }
}

struct RatingModel: Codable {
    let average: String?
    let count: Int
}

struct JobDateModel: Codable {
    let date: String
    let timezone: String
    let timezoneType: Int

    enum CodingKeys: String, CodingKey {
        case date, timezone
        case timezoneType = "timezone_type"
    }
}

struct JobCategoryModel: Codable {
    let iconPath, slug, jobCategoryDescription: String

    enum CodingKeys: String, CodingKey {
        case iconPath = "icon_path"
        case slug
        case jobCategoryDescription = "description"
    }
}

struct LocationModel: Codable {
    let lat, lng: String
}

struct ShiftModel: Codable {
    let startDatetime, endTime: String
    let isAutoAcceptedWhenAppliedFor: Int
    let id, startDate, startTime, endDatetime: String
    let duration: Int
    let earningsPerHour: Double
    let currency: String
    let tempersNeeded: Int

    enum CodingKeys: String, CodingKey {
        case startDatetime = "start_datetime"
        case endTime = "end_time"
        case isAutoAcceptedWhenAppliedFor = "is_auto_accepted_when_applied_for"
        case id
        case startDate = "start_date"
        case startTime = "start_time"
        case endDatetime = "end_datetime"
        case duration
        case earningsPerHour = "earnings_per_hour"
        case currency
        case tempersNeeded = "tempers_needed"
    }
}

