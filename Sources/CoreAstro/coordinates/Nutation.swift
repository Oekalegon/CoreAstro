//
//  File.swift
//  
//
//  Created by Don Willems on 07/08/2021.
//

import CoreMeasure
import Foundation

fileprivate func nutationalArguments(T: TimeInterval) -> (D: Angle, M: Angle, Mprime: Angle, F: Angle, Ω: Angle) {
    let T1 = T.scalarValue
    let T2 = T1 * T1
    let T3 = T2 * T1
    let D = 297.85036 + 445267.111480 * T1 - 0.0019142 * T2 + T3 / 189474
    let M = 357.52772 + 35999.050340 * T1 - 0.0001603 * T2 - T3 / 300000
    let Mprime = 134.96298 + 477198.867398 * T1 + 0.0086972 * T2 + T3 / 56250
    let F = 93.27191 + 483202.017538 * T1 - 0.0036825 * T2 + T3 / 327270
    let Ω = 125.04452 - 1934.136261 * T1 + 0.0020708 * T2 + T3 / 450000
    return (
        D: try! Longitude(D, unit: .degree),
        M: try! Longitude(M, unit: .degree),
        Mprime: try! Longitude(Mprime, unit: .degree),
        F: try! Longitude(F, unit: .degree),
        Ω: try! Longitude(Ω, unit: .degree)
    )
}

fileprivate let periodicTerms : [[Double]] =
    [
        [ 0,  0,  0,  0,  1,  -171996,  -174.2,  92025,   8.9],
        [-2,  0,  0,  2,  2,   -13187,    -1.6,   5736,  -3.1],
        [ 0,  0,  0,  2,  2,    -2247,    -0.2,    977,  -0.5],
        [ 0,  0,  0,  0,  2,     2062,    +0.2,   -895,   0.5],
        [ 0,  1,  0,  0,  0,     1426,    -3.4,     54,  -0.1],
        [ 0,  0,  1,  0,  0,      712,     0.1,     -7,   0.0],
        [-2,  1,  0,  2,  2,     -517,     1.2,    224,  -0.6],
        [ 0,  0,  0,  2,  1,     -386,    -0.4,    200,   0.0],
        [ 0,  0,  1,  2,  2,     -301,     0.0,    129,  -0.1],
        [-2, -1,  0,  2,  2,      217,    -0.5,    -95,   0.3],
        [-2,  0,  1,  0,  0,     -158,     0.0,      0,   0.0],
        [-2,  0,  0,  2,  1,      129,     0.1,    -70,   0.0],
        [ 0,  0, -1,  2,  2,      123,     0.0,    -53,   0.0],
        [ 2,  0,  0,  0,  0,       63,     0.0,      0,   0.0],
        [ 0,  0,  1,  0,  1,       63,     0.1,    -33,   0.0],
        [ 2,  0, -1,  2,  2,      -59,     0.0,     26,   0.0],
        [ 0,  0, -1,  0,  1,      -58,    -0.1,     32,   0.0],
        [ 0,  0,  1,  2,  1,      -51,     0.0,     27,   0.0],
        [-2,  0,  2,  0,  0,       48,     0.0,      0,   0.0],
        [ 0,  0, -2,  2,  1,       46,     0.0,    -24,   0.0],
        [ 2,  0,  0,  2,  2,      -38,     0.0,     16,   0.0],
        [ 0,  0,  2,  2,  2,      -31,     0.0,     13,   0.0],
        [ 0,  0,  2,  0,  0,       29,     0.0,      0,   0.0],
        [-2,  0,  1,  2,  2,       29,     0.0,    -12,   0.0],
        [ 0,  0,  0,  2,  0,       26,     0.0,      0,   0.0],
        [-2,  0,  0,  2,  0,      -22,     0.0,      0,   0.0],
        [ 0,  0, -1,  2,  1,       21,     0.0,    -10,   0.0],
        [ 0,  2,  0,  0,  0,       17,    -0.1,      0,   0.0],
        [ 2,  0, -1,  0,  1,       16,     0.0,     -8,   0.0],
        [-2,  2,  0,  2,  2,      -16,     0.1,      7,   0.0],
        [ 0,  1,  0,  0,  1,      -15,     0.0,      9,   0.0],
        [-2,  0,  1,  0,  1,      -13,     0.0,      7,   0.0],
        [ 0, -1,  0,  0,  1,      -12,     0.0,      6,   0.0],
        [ 0,  0,  2, -2,  0,       11,     0.0,      0,   0.0],
        [ 2,  0, -1,  2,  1,      -10,     0.0,      5,   0.0],
        [ 2,  0,  1,  2,  2,       -8,     0.0,      3,   0.0],
        [ 0,  1,  0,  2,  2,        7,     0.0,     -3,   0.0],
        [-2,  1,  1,  0,  0,       -7,     0.0,      0,   0.0],
        [ 0, -1,  0,  2,  2,       -7,     0.0,      3,   0.0],
        [ 2,  0,  0,  2,  1,       -7,     0.0,      3,   0.0],
        [ 2,  0,  1,  0,  0,        6,     0.0,      0,   0.0],
        [-2,  0,  2,  2,  2,        6,     0.0,     -3,   0.0],
        [-2,  0,  1,  2,  1,        6,     0.0,     -3,   0.0],
        [ 2,  0, -2,  0,  1,       -6,     0.0,      3,   0.0],
        [ 2,  0,  0,  0,  1,       -6,     0.0,      3,   0.0],
        [ 0, -1,  1,  0,  0,        5,     0.0,      0,   0.0],
        [-2, -1,  0,  2,  1,       -5,     0.0,      3,   0.0],
        [-2,  0,  0,  0,  1,       -5,     0.0,      3,   0.0],
        [ 0,  0,  2,  2,  1,       -5,     0.0,      3,   0.0],
        [-2,  0,  2,  0,  1,        4,     0.0,      0,   0.0],
        [-2,  1,  0,  2,  1,        4,     0.0,      0,   0.0],
        [ 0,  0,  1, -2,  0,        4,     0.0,      0,   0.0],
        [-1,  0,  1,  0,  0,       -4,     0.0,      0,   0.0],
        [-2,  1,  0,  0,  0,       -4,     0.0,      0,   0.0],
        [ 1,  0,  0,  0,  0,       -4,     0.0,      0,   0.0],
        [ 0,  0,  1,  2,  0,        3,     0.0,      0,   0.0],
        [ 0,  0, -2,  2,  2,       -3,     0.0,      0,   0.0],
        [-1, -1,  1,  0,  0,       -3,     0.0,      0,   0.0],
        [ 0,  1,  1,  0,  0,       -3,     0.0,      0,   0.0],
        [ 0, -1,  1,  2,  2,       -3,     0.0,      0,   0.0],
        [ 2, -1, -1,  2,  2,       -3,     0.0,      0,   0.0],
        [ 0,  0,  3,  2,  2,       -3,     0.0,      0,   0.0],
        [ 2, -1,  0,  2,  2,       -3,     0.0,      0,   0.0],
    ]

public func nutation(on date: Date) -> (Δψ: Angle, Δε: Angle) {
    let T = date.julianCenturiesSinceJ2000
    let arguments = nutationalArguments(T: T)
    var Δψ = 0.0
    var Δε = 0.0
    for term in periodicTerms {
        let argument = term[0] * arguments.D.scalarValue + term[1] * arguments.M.scalarValue + term[2] * arguments.Mprime.scalarValue + term[3] * arguments.F.scalarValue + term[4] * arguments.Ω.scalarValue
        Δψ = Δψ + (term[5] + term[6] * T.scalarValue)*0.0001 * sin(argument/180.0*Double.pi)
        Δε = Δε + (term[7] + term[8] * T.scalarValue)*0.0001 * cos(argument/180.0*Double.pi)
        print("Δψ = \(Δψ)\t\tΔε = \(Δε)")
    }
    return (Δψ: try! Angle(Δψ, unit: .arcsecond), Δε: try! Angle(Δε, unit: .arcsecond))
}

public func meanObliquityOfTheEcliptic(on date: Date) throws -> Angle {
    let T = date.julianCenturiesSinceJ2000.scalarValue
    let U = T / 100.0
    if fabs(U) >= 1.0 { // The range over which the obliquity can be calculated is +- 10.000 years from J2000, results outside are meaningless and therefore cause an error.
        throw QuantityValidationError.outOfRange
    }
    let ε0_val = 84381.448 - 4680.93*U - 1.55*pow(U,2) + 1999.25*pow(U,3) - 51.38*pow(U,4) - 249.67*pow(U,5) - 39.05*pow(U,6) + 7.12*pow(U,7) + 27.87*pow(U,8) + 5.79*pow(U,9) + 2.45*pow(U,10)
    let ε0 = try! Angle(symbol:"ε_0", ε0_val/3600.0, unit: .degree)
    return ε0
}

public func trueObliquityOfTheEcliptic(on date: Date) throws -> Angle {
    let ε0 = try meanObliquityOfTheEcliptic(on: date)
    let nutation = nutation(on: date)
    let ε = try! Angle(symbol:"ε", measure: ε0 + nutation.Δε)
    return ε
}
