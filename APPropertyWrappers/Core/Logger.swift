//
//  Logger.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Simple logger that allows redirection.
public enum Logger {
    
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd HH:mm:ss.SSS"
        
        return dateFormatter
    }()
    
    /// Error log hadnler.
    /// - parameter message: Message to log.
    /// - parameter error: Error to report.
    /// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
    public static var logError: (_ message: () -> (String),
                                 _ error: Any?,
                                 _ data: [String : Any?]?,
                                 _ file: String,
                                 _ function: String,
                                 _ line: UInt) -> Void = _logError
    
    /// Info log handler.
    public static var logInfo: (_ message: () -> (String),
                                _ file: String,
                                _ function: String,
                                _ line: UInt) -> Void = logMessage
    
    /// Debug log handler.
    public static var logDebug: (_ message: () -> (String),
                                 _ file: String,
                                 _ function: String,
                                 _ line: UInt) -> Void = logMessage
    
    /// Verbose log handler.
    public static var logVerbose: (_ message: () -> (String),
                                   _ file: String,
                                   _ function: String,
                                   _ line: UInt) -> Void = logMessage
    
    /// Data log handler.
    public static var logData: (_ message: () -> (String),
                                _ file: String,
                                _ function: String,
                                _ line: UInt) -> Void = logMessage
    
    /// Info, debug, verbose and data message logs go here if not redirected.
    public static var logMessage: (_ message: () -> (String),
                                   _ file: String,
                                   _ function: String,
                                   _ line: UInt) -> Void = _consoleLog
    
    private static func _logError(_ message: @autoclosure () -> String,
                          error: Any?,
                          data: [String : Any?]?,
                          file: String = #file,
                          function: String = #function,
                          line: UInt = #line) {
        
        let message = message()
        let errorString: String
        if let normalizedError = normalizeError(error) {
            errorString = "\n\(normalizedError)"
        } else {
            errorString = ""
        }
        
        let dataString: String
        if let normalizedData = normalizeData(data) {
            dataString = "\n\(normalizedData)"
        } else {
            dataString = ""
        }
        
        let timeString = dateFormatter.string(from: Date())
        let logString = "\(timeString) | \(message)\(errorString)\(dataString)"
        
        print(logString)
    }
    
    /// Method to normalize error.
    private static func normalizeError(_ error: Any?) -> String? {
        guard let error = error else { return nil }
        return String(describing: error)
    }
    
    /// Method to normalize data.
    private static func normalizeData(_ data: [String: Any?]?) -> [String: String]? {
        guard let data = data else { return nil }
        
        var normalizedData = [String: String]()
        for (key, value) in data {
            let description: String
            if let value = value as? Data {
                description = value.asString
            } else if let value = value {
                description = String(describing: value)
            } else {
                description = "nil"
            }
            
            normalizedData[key] = description
        }
        
        return normalizedData
    }
    
    private static func _consoleLog(_ message: @autoclosure () -> String,
                                    file: String = #file,
                                    function: String = #function,
                                    line: UInt = #line) {
        
        let message = message()
        let timeString = dateFormatter.string(from: Date())
        let logString = "\(timeString) | \(message)"
        
        print(logString)
    }
}

private extension Data {
    /// Try to convert data to ASCII string
    var asciiString: String? {
        String(data: self, encoding: String.Encoding.ascii)
    }
    
    /// Try to convert data to UTF8 string
    var utf8String: String? {
        String(data: self, encoding: String.Encoding.utf8)
    }
    
    /// Get HEX string from data. Can be used for sending APNS token to backend.
    var hexString: String {
        reduce("") { $0 + String(format: "%02X", $1) }
    }
    
    /// String representation for data.
    /// Try to decode as UTF8 string at first.
    /// Try to decode as ASCII string at second.
    /// Uses hex representation if data can not be represented as UTF8 or ASCII string.
    var asString: String {
        utf8String ?? asciiString ?? hexString
    }
}

/// Error log function.
/// - parameter message: Message to log.
/// - parameter error: Error to report.
/// - parameter data: Additional data. Pass all parameters that can help to diagnose error.
func logError(_ message: @autoclosure () -> String,
                     error: Any? = nil,
                     data: [String: Any?]? = nil,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
    
    Logger.logError(message,
                    error,
                    data,
                    file,
                    function,
                    line)
}

/// Info log function.
/// - parameter message: Message to log.
func logInfo(_ message: @autoclosure () -> String,
             file: String = #file,
             function: String = #function,
             line: UInt = #line) {
    
    Logger.logInfo(message,
                   file,
                   function,
                   line)
}


/// Debug log function.
/// - parameter message: Message to log.
func logDebug(_ message: @autoclosure () -> String,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
    
    Logger.logDebug(message,
                    file,
                    function,
                    line)
}

/// Verbose log function. This level of logs usually is excessive but may be helpful in some cases.
/// Use it for repeated logs or logs that are usually not needed to understand what's going on.
/// - parameter message: Message to log.
func logVerbose(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: UInt = #line) {
    
    Logger.logVerbose(message,
                      file,
                      function,
                      line)
}

/// Data log function. This one is to log big chunks of data like network responses.
/// - parameter message: Message to log.
func logData(_ message: @autoclosure () -> String,
                    file: String = #file,
                    function: String = #function,
                    line: UInt = #line) {
    
    Logger.logData(message,
                   file,
                   function,
                   line)
}
