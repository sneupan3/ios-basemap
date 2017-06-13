//
//  States.swift
//  BaseMap
//
//  Created by Samip Neupane on 6/13/17.
//  Copyright © 2017 Samip Neupane. All rights reserved.
//

import Foundation

public class States{
    
    private let allStates: [State]
    
    public init(allStates: [State]){
        self.allStates = allStates
    }
    
    public func getStates()-> [State]{
        return self.allStates
    }
    
}
