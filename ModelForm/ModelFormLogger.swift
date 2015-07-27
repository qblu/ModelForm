//
//  Logger.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import CleanroomLogger

public enum LogSeverity {
    case verbose
    case info
    case warning
    case error
    
    internal func cleanroomLogSeverity() -> CleanroomLogger.LogSeverity {
        switch self {
        case .verbose:
            return CleanroomLogger.LogSeverity.Verbose
        case .info:
            return CleanroomLogger.LogSeverity.Info
        case .warning:
            return CleanroomLogger.LogSeverity.Warning
        case .error:
            return CleanroomLogger.LogSeverity.Error
            
        }
    }
}

public protocol ModelFormLogger {
    func logError(message: String, error:NSError?)
    func logInfo(message: String)
    func logWarning(message: String)
    func logVerbose(message: String)
}

// global Logger used by library.  Can be replaced by consumer to user their preferred logger
public var Logger: ModelFormLogger = ModelFormDefaultLogger()

public class ModelFormDefaultLogger : ModelFormLogger {
    public func enableLogging(minimumSeverity: LogSeverity) {
        Log.enable(minimumSeverity:.Verbose)
    }
    
    public func logError(message: String, error:NSError? = nil) {
        Log.error?.message(message)
    }
    
    public func logWarning(message: String) {
        Log.warning?.message(message)
    }
    
    public func logInfo(message: String) {
        Log.info?.message(message)
    }
    
    public func logVerbose(message: String) {
        Log.verbose?.message(message)
    }
}
