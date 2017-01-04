//
//  QKLog.swift
//  SWeChat
//
//  Created by ChiCo on 17/1/4.
//  Copyright © 2017年 ChiCo. All rights reserved.
//

import Foundation
import XCGLogger

let XCCacheDirectory: URL = {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

let  log: XCGLogger = {

    let log = XCGLogger.default
    
    #if USE_NSLOG
        log.remove(destinationWithIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Constants.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: URL = XCCacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
        
        // Add colour (using the ANSI format) to our file log, you can see the colour when `cat`ing or `tail`ing the file in Terminal on macOS
        // This is mostly useful when testing in the simulator, or if you have the app sending you log files remotely
        if let fileDestination: FileDestination = log.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
            let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
            ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
            ansiColorLogFormatter.colorize(level: .debug, with: .black)
            ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
            ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
            ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
            ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
            fileDestination.formatters = [ansiColorLogFormatter]
        }
    #endif

    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    log.formatters = [emojiLogFormatter]

    
    return log
    
}()

