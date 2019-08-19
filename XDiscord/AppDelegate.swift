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

        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleGetURL(event:reply:)), forEventClass: UInt32(kInternetEventClass), andEventID: UInt32(kAEGetURL) )
    }

    @objc func handleGetURL(event: NSAppleEventDescriptor, reply:NSAppleEventDescriptor) {
        guard let pidDescriptor = event.attributeDescriptor(forKeyword: keyAddressAttr) else {
            return
        }
        
        let pid: pid_t = Int32(littleEndian: pidDescriptor.data[4...].withUnsafeBytes { $0.pointee })
        let cpath = UnsafeMutablePointer<CChar>.allocate(capacity:Int(MAXPATHLEN))
        
        proc_pidpath(pid, cpath, UInt32(MAXPATHLEN))
        let bundle = Bundle.main
        let path = String(cString: cpath)
        
        // extension does not get ran from our app bundle in debug environments, skip check
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        
        // check if application that called us is part of our bundle.
        // do note that this is not intended to be fully fool proof. executables that place themselves inside our bundle can still bypass this check.
        // however, this is a OK fix for drive by attempts and such, and that's more than enough.
        if debug || (path.count > 0 && path.starts(with: bundle.bundlePath)) {
            debugPrint("ya")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

