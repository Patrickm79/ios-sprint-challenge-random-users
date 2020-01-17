//
//  URL+Secure.swift
//  Random Users
//
//  Created by Patrick Millet on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
