//
//  XcodeRPC.swift
//  XcodeRPC
//
//  Created by Jari on 05/08/2019.
//  Copyright © 2019 JARI.IO. All rights reserved.
//

import Foundation
import ScriptingBridge
import SwordRPC

class XcodeRPC: SBApplicationDelegate, SwordRPCDelegate {
    
    // MARK: internal vars
    
    let rpc: SwordRPC
    var rpcConnected = false
    var xcodeApp: XcodeApplication?
    var state: XcodeState?
    var lastWindowTitleChange = Date();
    var timer: Timer?
    
    // MARK: -
    // MARK: ScriptingBridge delegate methods
    
    func eventDidFail(_ event: UnsafePointer<AppleEvent>, withError error: Error) -> Any? {
        // TODO
        debugPrint(error)
        return nil
    }
    
    // MARK: -
    // MARK: RPC delegate methods
    
    func swordRPCDidConnect(_ rpc: SwordRPC) {
        print("rpc: connected")
        rpcConnected = true
        
        publishState()
    }
    
    func swordRPCDidDisconnect(_ rpc: SwordRPC, code: Int?, message msg: String?) {
        print("rpc: disconnected")
        rpcConnected = false
    }
    
    func swordRPCDidReceiveError(_ rpc: SwordRPC, code: Int, message msg: String) {
        debugPrint(msg)
        // TODO
    }
    
    // MARK: -
    // MARK: Initialization methods
    
    init () {
        // init discord
        self.rpc = SwordRPC(appId: "607689035665637387")
        rpc.delegate = self
        rpc.connect()
        
        // init bridge
        if let xcodeApp = SBApplication(bundleIdentifier: "com.apple.dt.Xcode") {
            xcodeApp.delegate = self
            self.xcodeApp = xcodeApp
        }
        
        // start polling
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: true, block: { _ in
            guard let app = self.xcodeApp else {
                return
            }
            
            if !app.isRunning {
                print("ERROR: xcode appears to not be running (anymore?), quitting...")
                self.timer?.invalidate()
                NSApplication.shared.terminate(nil)
                return
            }
            
            let newState = XcodeState(app)
            
            if self.state != nil
                && newState.activeWindowTitle != self.state?.activeWindowTitle {
                self.lastWindowTitleChange = Date()
            }
            self.state = newState
            
            
            self.publishState()
        })
    }
    
    func publishState () {
        if let state = self.state, rpcConnected {
            rpc.setPresence(state.toRichPresence(lastTitleChange: self.lastWindowTitleChange))
        }
    }
    
}
