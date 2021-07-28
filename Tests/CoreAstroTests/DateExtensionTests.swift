import XCTest
import CoreMeasure
@testable import CoreAstro

final class DateExtensionTests: XCTestCase {
    
    func testJulianCenturiesSinceJ2000() throws {
        let JD = JulianDay(2462088.69)
        let T = JD.date.julianCenturiesSinceJ2000
        let t = try? T - Date.J2000.julianCenturiesSinceJ2000
        XCTAssertNotNil(t)
        XCTAssertEqual(t!.scalarValue, 0.288670500, accuracy: 0.000000001)
        XCTAssertEqual(t!.unit, CoreMeasure.Unit.julianCentury)
    }
}
