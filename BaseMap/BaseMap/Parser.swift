//
//  Parser.swift
//  BaseMap
//
//  Created by Samip Neupane on 6/13/17.
//  Copyright © 2017 Samip Neupane. All rights reserved.
//

import Foundation
import SWXMLHash
import CoreGraphics

public class Parser{
    
    public static func parse()-> States{
        var states: States?
         if let filePath = Bundle.main.path(forResource: "states.xml.".components(separatedBy: ".")[0], ofType: "xml") {
            do{
                let contents = try String.init(contentsOfFile: filePath)
                
                let xml: XMLIndexer = SWXMLHash.config {
                    config in
                    }.parse(contents)
                
                states =  createStates(xml: xml["states"])
            } catch {
                print("Error: Contents Could not be Loaded")
            }
         } else {
            print("Error: File Not Found")
            
        }
        return states!
    }
    
    public static func createStates(xml: XMLIndexer)-> States{
        var states: [State] = []
        for elements: XMLIndexer in xml["state"]{
            states.append(createState(xml: elements))
        }
        return States(allStates: states)
    }
    
    public static func createState(xml: XMLIndexer)-> State{
        let color = (xml.element?.attribute(by: "colour")?.text)
        let name = (xml.element?.attribute(by: "name")?.text)
        var points: [CGPoint] = []
        for elements: XMLIndexer in xml["point"]{
            points.append(makePoint(xml: elements))
        }
        return State(name: name!, point: points, color: color!)
    }
    
    public static func makePoint(xml: XMLIndexer)-> CGPoint{
        let lat = Double((xml.element?.attribute(by: "lat")?.text)!)
        let lon = Double((xml.element?.attribute(by: "lng")?.text)!)
        return CGPoint(x: lon!, y: lat!)
        
    }
}
