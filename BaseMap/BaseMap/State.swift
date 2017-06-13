//
//  State.swift
//  BaseMap
//
//  Created by Samip Neupane on 6/13/17.
//  Copyright © 2017 Samip Neupane. All rights reserved.
//

import Foundation
import CoreGraphics

public class State{
    
    private let points: [CGPoint]
    private let color: String
    private let name: String
    
    public init(name: String, point: [CGPoint], color: String){
        self.name = name
        self.points = point
        self.color = color
    }
    
    public func getPoint()-> [CGPoint]{
        return self.points
    }
    
    public func getColor()-> String{
        return self.color
    }
    
    public func getName()-> String{
        return self.name
    }
}
