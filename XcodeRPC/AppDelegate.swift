//
//  AppDelegate.swift
//  XcodeRPC
//
//  Created by Jari on 04/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Cocoa
import ScriptingBridge
import SwordRPC

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate{

    @IBOutlet weak var window: NSWindow!
    
    var rpc: XcodeRPC?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rpc = XcodeRPC()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

