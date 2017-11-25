//
//  Strings.swift
//  Pr0gramm
//
//  Created by TodDurchSterben on 12.04.17.
//  Copyright © 2017 TodDurchSterben. All rights reserved.
//

import UIKit

class Strings {
    
    // TODO localisation etc.
    static let timeString = "vor %d %@"
    static let errorLoadingVideoString = "Fehler beim laden des Videos"
    static let top = "Top"
    static let new = "Neu"
    static let comment = "Kommentar..."
    static let point = "Punkt"
    static let points = "Punkte"
    static let error = "Fehler"
    static let year = "Jahr"
    static let years = "Jahren"
    static let month = "Monat"
    static let months = "Monaten"
    static let week = "Woche"
    static let weeks = "Wochen"
    static let day = "Day"
    static let days = "Days"
    static let hour = "Stunde"
    static let hours = "Stunden"
    static let minute = "Minute"
    static let minutes = "Minuten"
    static let momentAgo = "vor einem Moment"
    static let sfw = "sfw"
    static let nsfw = "nsfw"
    static let nsfl = "nsfl"
    static let sfw_nsfw = Strings.sfw + " | " + Strings.nsfw
    static let nsfw_nsfl = Strings.nsfw + " | " + Strings.nsfl
    static let sfw_nsfl = Strings.sfw + " | " + Strings.nsfl
    static let all = "all"
    
    static func calculateTimeString(withDate created: Date) -> String {
        let intervalDate = Date(timeIntervalSince1970:Date().timeIntervalSince1970 - created.timeIntervalSince1970)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year, .weekOfMonth], from: intervalDate)
        let years = components.year! - 1970
        let months = components.month! - 1
        let weeks = components.weekOfMonth! - 1
        let days = components.day! - 1
        let hours = components.hour! - 1
        let minutes = components.minute!
        
        var value = 0
        var period = ""
        if (years > 0) {
            value = years
            if (years == 1) {
                period = Strings.year
            } else {
                period = Strings.years
            }
        } else if (months > 0) {
            value = months
            if (months == 1) {
                period = Strings.month
            } else {
                period = Strings.months
            }
        } else if (weeks > 0) {
            value = weeks
            if (weeks == 1) {
                period = Strings.week
            } else {
                period = Strings.weeks
            }
        } else if (days > 0) {
            value = days
            if (days == 1) {
                period = Strings.day
            } else {
                period = Strings.days
            }
        } else if (hours > 0) {
            value = hours
            if (hours == 1) {
                period = Strings.hour
            } else {
                period = Strings.hours
            }
        } else if (minutes > 0) {
            value = minutes
            if (minutes == 1) {
                period = Strings.minute
            } else{
                period = Strings.minutes
            }
        } else {
            return Strings.momentAgo
        }
        
        return String(format: Strings.timeString, value, period)
    }
    
}
