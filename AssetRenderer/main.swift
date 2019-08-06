//
//  main.swift
//  AssetRenderer
//
//  Created by Jari on 05/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation
import Cocoa

// this script extracts all file types that xcode supports, and renders their icons to png files,
// ready to be uploaded to discord.

func main () throws {
    let fileManager = FileManager.default
    let outDir = fileManager.currentDirectoryPath + "/assets"
    
    if !fileManager.fileExists(atPath: outDir) {
        try fileManager.createDirectory(atPath: outDir, withIntermediateDirectories: false, attributes: [:])
    }
    
    print("Using \(outDir) as output directory.")
    
    guard let plist = NSDictionary(contentsOfFile: "/Applications/Xcode.app/Contents/Info.plist") else{
        print("Failed to read from xcode app. Ensure it's installed.")
        return
    }
    
    let fileTypes = plist["CFBundleDocumentTypes"] as! Array<NSDictionary>
    
    for var fileType in fileTypes {
        let name = fileType["CFBundleTypeName"] as! String
        if let contentTypes = fileType["LSItemContentTypes"] as! Optional<Array<String>> {
            
            var icon: NSImage?
            var iconSource = "Unknown"
            
            if let iconFile = fileType["CFBundleTypeIconFile"] as! Optional<String> {
                let path = "/Applications/Xcode.app/Contents/Resources/\(iconFile).icns"
                
                if fileManager.fileExists(atPath: path) {
                    icon = NSImage(byReferencingFile: path)
                    iconSource = "Xcode resources folder"
                }
            }
            
            if icon == nil {
                // unable to get icon from xcode resources, so fall back to system resolver
                icon = NSWorkspace.shared.icon(forFileType: contentTypes[0])
                iconSource = "System"
            }
            
            icon!.size.width = 512
            icon!.size.height = 512
            
            if let rep = icon!.tiffRepresentation {
                let bitmap = NSBitmapImageRep(data: rep)
                let pngRep = bitmap?.representation(using: .png, properties: [:])
                for var contentType in contentTypes {
                    let path = "\(contentType.djb2hash).png"
                    let pathUrl = URL(fileURLWithPath: outDir + "/" + path)
                    
                    print("Writing \(contentType) (\(name)) imported from \(iconSource) to \(path)")
                    try pngRep?.write(to: pathUrl)
                }

            } else {
                print("WARN: skipped \(name)");
            }
        } else {
            print("WARN: skipped \(name)");
        }
    }
}

try main()
