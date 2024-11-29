//
//  TimeZone+Location.swift
//  swift-tzlocation
//
//  Created by Hung Nguyen on 11/29/24.
//
//  Logic from https://github.com/atomicbird/TZLocation ; see License.

import CoreLocation

public extension TimeZone {
    func location() throws -> CLLocation? {
        let url = URL(filePath: "/usr/share/zoneinfo/zone.tab")
        let zonetabContents = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)
        let searchResult = zonetabContents.first { $0.contains(self.identifier) }
        guard case .some(let found) = searchResult else { return .none } // old identifier
        let components = found.split(separator: "\t")
//        let countryCode = components[0]
        let location = components[1]
        guard let longitudeRange = location.rangeOfCharacter(
            from: .init(charactersIn: "+-"),
            range: location.index(location.startIndex, offsetBy: 1)..<location.endIndex
        ) else { return .none }
        let latitude = String(location[..<longitudeRange.lowerBound])
        let longitude = String(location[longitudeRange.lowerBound...])
        return CLLocation(latitude: Self.degrees(latitude), longitude: Self.degrees(longitude))
    }

    private static func degrees(_ latLong: String) -> CLLocationDegrees {
        var degrees: CLLocationDegrees = .zero
        switch latLong.count {
        case 5: // +-DDMM
            degrees = Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 1))
                .prefix(2))!
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 3))
                .prefix(2))! / 60.0
        case 6:
            degrees = Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 1))
                .prefix(3))!
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 4))
                .prefix(2))! / 60.0
        case 7:
            degrees = Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 1))
                .prefix(2))!
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 3))
                .prefix(2))! / 60.0
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 5))
                .prefix(2))! / 3600.0
        case 8:
            degrees = Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 1))
                .prefix(3))!
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 4))
                .prefix(2))! / 60.0
            degrees += Double(latLong
                .suffix(from: latLong.index(latLong.startIndex, offsetBy: 6))
                .prefix(2))! / 3600.0
        default:
            break
        }
        if latLong.first == "-" {
            degrees *= -1
        }
        return degrees
    }

}
