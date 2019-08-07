//
//  XcodeState.swift
//  XcodeRPC
//
//  Created by Jari on 05/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation
import SwordRPC

// collects metadata from XcodeApplication & generates RPC's based on it
class XcodeState {
    init (_ xcodeApp: XcodeApplication) {
        if let workspace = xcodeApp.activeWorkspaceDocument {
            self.activeWorkspaceName = workspace.name
            
            if let loaded = workspace.loaded {
                if loaded, let scheme = workspace.activeScheme {
                    self.activeSchemeName = scheme.name
                }
                
                self.workspaceLoaded = loaded
            }
        }
        for var windowObject in xcodeApp.windows!() {
            let window = (windowObject as! XcodeWindow)
            
            if window.visible! && window.document != nil {
                if var title = window.name {
                    // strip '— Edited' part from window title as it's of no relevance to us
                    // xcode only uses english locale, so we can just hardcode this.
                    let editSuffix = " — Edited"
                    if title.hasSuffix(editSuffix) {
                        title = String(title.prefix(title.count - editSuffix.count))
                    }
                    activeWindowTitle = title
                }
                
                break
            }
        }
    }
    
    func getContentType () -> String? {
        guard let title = activeWindowTitle else {
            return nil
        }
        
        let fileUrl = URL(fileURLWithPath: title)
        if let contentType = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            fileUrl.pathExtension as CFString,
            nil
        )?.takeRetainedValue() {
            return contentType as String
        }
        
        return nil
    }
    
    func toRichPresence (lastTitleChange: Date) -> RichPresence {
        var presence = RichPresence()
        
        if let workspaceName = activeWorkspaceName {
            var workspaceUrl = URL(fileURLWithPath: workspaceName)
            workspaceUrl.deletePathExtension()
            
            presence.state = "Working on \(workspaceUrl.lastPathComponent)"
            
            if let scheme = activeSchemeName, scheme != "" {
                presence.state += " (\(scheme))"
            }
        }
        
        if let title = activeWindowTitle {
            presence.details = title
            if let contentType = getContentType() {
                presence.assets.largeImage = contentType.djb2hash
            }
            
            presence.timestamps.start = lastTitleChange
        }
        
        return presence
    }
    
    // current scheme name
    var activeSchemeName: String?
    
    // is the current workspace loaded
    var workspaceLoaded: Bool?
    
    // current workspace title
    var activeWorkspaceName: String?
    
    // frontmost window title
    var activeWindowTitle: String?
}
