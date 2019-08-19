//
//  SourceEditorCommand.swift
//  Extension
//
//  Created by Jari on 07/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation
import XcodeKit
import Cocoa

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        if let url = URL(string: "xdiscord:options") {
            NSWorkspace.shared.open(url)
        } else {
            debugPrint("Unable to find url scheme")
        }
        
        completionHandler(nil)
    }
    
}
