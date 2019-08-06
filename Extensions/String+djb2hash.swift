//
//  String+djb2hash.swift
//  XcodeRPC
//
//  Created by Jari on 06/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation

extension String {
    var djb2hash: String {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        let hash = unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
        
        return String(format: "%02X", hash).lowercased()
    }
}
