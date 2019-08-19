//
//  SourceEditorExtension.swift
//  Extension
//
//  Created by Jari on 07/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation
import XcodeKit
import Cocoa

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        if let url = URL(string: "xdiscord:") {
            NSWorkspace.shared.open(url)
        } else {
            debugPrint("Unable to find url scheme")
        }
    }

}
