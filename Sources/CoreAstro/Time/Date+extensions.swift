//
//  File.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import Foundation
import CoreMeasure

/// The ``JulianDay`` quantity represents the Julian Day number. This is a value on the ``julianDay``
/// scale wih the zero point defined as the date of January 1st, 4713 BC in the Julian Calendar.
public class JulianDay: TimeInterval {
    
    /// Creates a new Julian Day quantity and value, specifying a specifc date.
    ///
    /// To convert to a ``Date`` object, you can use the initialiser in the ``Date`` extension, or use
    /// the computed variable in this class: ``date``.
    /// - Parameters:
    ///   - value: The number of Julian Days  as a `Double`.
    ///   - error: The error in the number of Julian Days.
    public init(_ value: Double, error: Double? = nil) {
        try! super.init(value, error: error, scale: .julianDay)
    }
    
    /// The ``Date`` object associated with the Julian Day.
    public var date : Date {
        return Date(julianDay: self)
    }
}

/// The ``JulianCentury`` quantity represents the Julian Century number. This is a value on the
/// ``julianCentury``  scale wih the zero point defined as the date of January 1st, 4713 BC
/// in the Julian Calendar.
public class JulianCentury: TimeInterval {
    
    /// Creates a new Julian Century quantity and value, specifying a specifc date.
    ///
    /// To convert to a ``Date`` object, you can use the initialiser in the ``Date`` extension, or use
    /// the computed variable in this class: ``date``.
    /// - Parameters:
    ///   - value: The number of Julian Centuries as a `Double`.
    ///   - error: The error in the number of Julian Centuries.
    public init(_ value: Double, error: Double? = nil) {
        try! super.init(value, error: error, scale: .julianCentury)
    }
    
    /// The ``Date`` object associated with the Julian Day.
    public var date : Date {
        return Date(julianCentury: self)
    }
}

/// This class represents a time interval.
public class TimeInterval : Quantity {
    
    /// Creates a new Julian Century quantity and value, specifying a date.
    ///
    /// To convert to a ``Date`` object, you can use the initialiser in the ``Date`` extension, or use
    /// the computed variable in this class: ``date``.
    /// - Parameters:
    ///   - value: The time interval as a `Double` expressed in the specified units.
    ///   - error: The error in the time interval.
    ///   - unit: The unit for the time interval with dimensions (T=1).
    /// - Throws: A ``UnitValidationError`` when the unit has the wrong dimensions. It should
    /// only be defined within the time dimension.
    public init(_ value: Double, error: Double? = nil, unit: CoreMeasure.OMUnit) throws {
        if unit.dimensions != CoreMeasure.OMUnit.second.dimensions {
            throw UnitValidationError.differentDimensionality
        }
        try super.init(value, error: error, unit: unit)
    }
    
    /// Creates a new Julian Century quantity and value, specifying a specifc date on a specific time scale.
    ///
    /// To convert to a ``Date`` object, you can use the initialiser in the ``Date`` extension, or use
    /// the computed variable in this class: ``date``.
    /// - Parameters:
    ///   - value: The time interval as a `Double` expressed in the specified units.
    ///   - error: The error in the time interval.
    ///   - scale: The scale for the time interval with dimensions (T=1).
    /// - Throws: A ``UnitValidationError`` when the scale has the wrong dimensions. It should
    /// only be defined within the time dimension.
    public init(_ value: Double, error: Double? = nil, scale: IntervalScale) throws {
        if scale.unit.dimensions != CoreMeasure.OMUnit.second.dimensions {
            throw UnitValidationError.differentDimensionality
        }
        try super.init(value, error: error, scale: scale)
    }
}


extension Scale {
    
    /// Defines the Julian Day scale, points on which define the number of days since January 1st, 4713 BC
    /// in the Julian calendar.
    static let julianDay = IntervalScale(symbol: "JD", unit: .day)
    
    /// Defines the Julian Centuries scale, points on which define the number of centuries since
    /// January 1st, 4713 BC in the Julian calendar.
    static let julianCentury = IntervalScale(symbol: "JC", unit: .julianCentury)
}

extension CoreMeasure.OMUnit {
    
    /// Defines a year in the Julian calendar, which is equal to 365.25 days.
    static let julianYear = UnitMultiple(symbol: "yr", factor: 365.25*86400.0, unit: .second)
    
    /// Defines a century in the Julian calendar, which is equal to 36525 days.
    static let julianCentury = UnitMultiple(symbol: "centuries", factor: 36525*86400.0, unit: .second)
}

extension Date {
    
    private static var julianDay1970 = 2440587.5
    private static var julianDay2000 = 2451545.0
    private static var besselianDay1900 = 2415020.31352
    
    /// The B1950.0 standard epoch at January 0.8135, 1900, Terrestial Time (TT).
    public static var B1900 = Date(julianDay: JulianDay(2415929.3135))
    
    /// The B1950.0 standard epoch at January 0.9235, 1950, Terrestial Time (TT).
    public static var B1950 = Date(julianDay: JulianDay(2433282.4235))
    
    /// The J2000.0 standard epoch at January 1st, 2000 at 12:00 (noon) Terrestial Time (TT).
    public static var J2000 = Date(julianYear: 2000)
    
    /// The J2050.0 standard epoch at January 1st, 2000 at 12:00 (noon) Terrestial Time (TT).
    public static var J2050 = Date(besselianYear: 2050)
    
    /// Creates a new Date for the Besselian Epoch for the specified year.
    /// - Parameter year: The year whose Besselian Epoch is requested.
    public init(besselianYear year: Double) {
        let jd = (year-1900.0) * 365.242198781 + Date.besselianDay1900
        self.init(julianDay: JulianDay(jd))
    }
    
    /// Creates a new Date for the Julian Epoch for the specified year.
    /// - Parameter year: The year whose Juiian Epoch is requested.
    public init(julianYear year: Double) {
        let jd = (year-2000.0) * 365.25 + Date.julianDay2000
        self.init(julianDay: JulianDay(jd))
    }
    
    /// Creates a new Date based on the specified Julian Day number.
    /// - Parameter julianDay: The julian day number
    public init(julianDay: JulianDay) {
        let timeSeconds = (julianDay.scalarValue - Date.julianDay1970)*86400.0
        self.init(timeIntervalSince1970: timeSeconds)
    }
    
    /// Creates a new Date based on the specified Julian Century number.
    /// - Parameter julianCentury: The julian century number
    public init(julianCentury: JulianCentury) {
        let timeSeconds = (julianCentury.scalarValue/36525 - Date.julianDay1970)*86400.0
        self.init(timeIntervalSince1970: timeSeconds)
    }
    
    /// The Julian Day (as a ``JulianDay``) for the Date.
    public var julianDay: JulianDay {
        get {
            let timeSeconds = self.timeIntervalSince1970
            let timeDays = timeSeconds / 86400.0 + Date.julianDay1970
            return JulianDay(timeDays, error: 0.000001 / 86400.0)
        }
    }
    
    /// The Julian Century (as a ``JulianCentury``) for the Date.
    public var julianCenturies: JulianCentury {
        get {
            let timeSeconds = self.timeIntervalSince1970
            let timeDays = timeSeconds / 86400.0 + Date.julianDay1970
            let timeCenturies = timeDays / 36525.0
            return JulianCentury(timeCenturies, error: 0.000001 / 86400.0 / 36525.0)
        }
    }
    
    /// The number of julian centuries since the epoch J2000.0.
    ///
    /// This value is often used in astronomical calculations from Meeus, 1998.
    public var julianCenturiesSinceJ2000 : TimeInterval {
        get {
            let djd = julianDay.scalarValue-Date.julianDay2000
            let timeInterval = try! TimeInterval(djd, error: 0.000001 / 86400.0, unit: .day)
            let measure = try! timeInterval.convert(to: CoreMeasure.OMUnit.julianCentury)
            return try! TimeInterval(measure.scalarValue, error: measure.error, unit: measure.unit)
        }
    }
}
