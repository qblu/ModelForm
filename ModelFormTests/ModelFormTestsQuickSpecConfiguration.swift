//
//  ModelFormTestsQuickSpecConfiguration.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Quick
import ModelForm

public class ModelFormTestsQuickSpecConfiguration: QuickConfiguration {
    override public class func configure(configuration: Configuration) {
        if let logger = Logger as? ModelFormDefaultLogger {
            logger.enableLogging(LogSeverity.verbose)
            logger.logVerbose("Logging enabled in ModelFormTestsQuickSpecConfiguration.configure()")
        }
    }
}