//
//  Dog.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/24/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation

public struct Dog {
    public var breed: String = ""
    public var heightInInches: Int = 0
    public var profilePhotoUrl: NSURL?
    
    public init() {}
    
    public init( breed: String, heightInInches: Int, profilePhotoUrl: NSURL) {
        self.breed = breed
        self.heightInInches = heightInInches
        self.profilePhotoUrl = profilePhotoUrl
    }
}