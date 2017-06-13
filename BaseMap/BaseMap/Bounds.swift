//
//  Bounds.swift
//  BaseMap
//
//  Created by Samip Neupane on 6/10/17.
//  Copyright © 2017 Samip Neupane. All rights reserved.
//

import Foundation
import CoreGraphics

public class Bounds{
    
    private var minX: Double
    private var minY: Double
    private var maxX: Double
    private var maxY: Double
    private var width: Double
    private var height: Double
    
    private let viewWidth = 500
    private let viewHeight = 280

    public init(minX: Double, minY: Double, maxX: Double, maxY: Double){
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
        self.height = maxY - minY
        self.width = maxX - minX
    }
    
    public func setMinX(x: Double){
        self.minX = x
    }
    
    public func setMaxX(x: Double){
        self.maxX = x
    }
    
    public func seMinY(y: Double){
        self.minY = y
    }
    
    public func seMaxY(y: Double){
        self.minX = y
    }
    
    public func getMaxX()-> Double{
        return self.maxX
    }
    
    public func getMinX()-> Double{
        return self.minX
    }
    
    public func getMaxY()-> Double{
        return self.maxY
    }
    
    public func getMinY()-> Double{
        return self.minY
    }
    
    public func getWidth()-> Double{
        return self.width
    }
    
    public func getHeight()-> Double{
        return self.height
    }
    
    
    /*
     This function converts the given lat lon to pixel value, based on the current zoom scale
     */
    public func getPixelFromXY(x: Double, y: Double)-> CGPoint{
        
        let xScale = Double(viewWidth) / self.width
        let yScale = Double(viewHeight) / self.height
        
        let deltaY = maxY - y
        let deltaX = x - minX
        
        let xN = deltaX * xScale
        let yN = deltaY * yScale
        
        return CGPoint(x: xN, y: yN)
        
    }
    
    public func getPixelFromXY(points:[CGPoint])-> [CGPoint]{
        var pixelPoints: [CGPoint] = []
        for point: CGPoint in points{
            pixelPoints.append(getPixelFromXY(x: Double(point.x), y: Double(point.y)))
        }
        return pixelPoints
    }
    
    /*
     This function converts the given pixel value to lat lon, based on the current zoom scale
     */
    public func getXYfromPixel(x: Double, y: Double)-> [Double]{

        let xScale = Double(viewWidth) / self.width
        let yScale = Double(viewHeight) / self.height
        
        let deltaX: Double = x / xScale
        let deltaY: Double = y / yScale
        let yRet: Double = maxY - deltaY
        let xRet: Double = minX + deltaX
        
        return [xRet, yRet]
        
    }
    
    
    public func ZoomIn(scale: Double){
        
        let nHeight = self.height / scale;
        let nWidth  = self.width  / scale;
        
        // choose an origin so as to get the right center.
        let x = (maxX + minX) / 2 - (nWidth  / 2.0);
        let y = (maxY + minY) / 2 - (nHeight / 2.0);
        
        let newMinX = x
        let newMinY = y
        let newMaxX = newMinX + nWidth
        let newMaxY = y + nHeight
        
        print("\(newMinX) \(newMaxX) \(newMinY) \(newMaxY)")
        
        if((newMaxY - newMinY) > 0 && (newMaxX - newMinX) > 0){
            
            if(newMinX >= -180 && newMinX <= 180){
                self.minX = newMinX
            }
            if(newMaxY >= -90 && newMaxY <= 90){
                self.maxY = newMaxY
            }
            if(newMaxX >= -180 && newMaxX <= 180 ){
                self.maxX = newMaxX
            }
            if(newMinY >= -90 && newMinY <= 90){
                self.minY = newMinY
            }
            updateBounds()
        }
    }
    
    public func ZoomOut(scale: Double){
        
        
        let nHeight = self.height * scale;
        let nWidth  = self.width  * scale;
     
        let x = (maxX + minX) / 2 - (nWidth  / 2.0);
        let y = (maxY + minY) / 2 - (nHeight / 2.0);
        
        let newMinX = x
        let newMinY = y
        let newMaxX = newMinX + nWidth
        let newMaxY = y + nHeight
        
        if(newMinX >= -180 && newMinX <= 180){
            self.minX = newMinX
        }else{
            self.minX = -180.0
        }
        
        if(newMaxY >= -90 && newMaxY <= 89.9){
            self.maxY = newMaxY
        }else{
            self.maxY = 90.0
        }
        
        
        if(newMaxX >= -180 && newMaxX <= 180 ){
            self.maxX = newMaxX
        }else{
            self.maxX = 180.0
        }
        
        
        if(newMinY >= -90 && newMinY <= 90){
            self.minY = newMinY
        }else{
            self.minY = -90.0
        }
        
        updateBounds()
        
    }
    
    public func updateBounds(){
        self.width = abs(self.maxX - self.minX)
        self.height = abs(self.maxY - self.minY)
        
    }
    
    
    public func pan(type: Int){
        if(type == 1){//right
            let panValue = (self.maxX - self.minX) / 36
            if(self.minX >= -180 && self.maxX + panValue <= 180){
                self.minX = self.minX + panValue
                self.maxX = self.maxX + panValue
            }else{
                self.minX = minX + (180 - abs(self.maxX))
                self.maxX = 180
            }
        }
        
        if(type == 0){//left
            let panValue = (self.maxX - self.minX) / 36
            if(self.minX - panValue >= -180 && self.maxX <= 180){
                self.minX = self.minX - panValue
                self.maxX = self.maxX - panValue
            }else{
                self.maxX = maxX - (180 - abs(self.minX))
                self.minX = -180
            }
        }
        
        if(type == 2){//up
            let panValue = (self.maxY - self.minY) / 18
            if(self.maxY + panValue <= 90 && self.minY >= -90){
                self.maxY = self.maxY + panValue
                self.minY = self.minY + panValue
            }else{
                self.minY = self.minY + (90 - abs(self.maxY))
                self.maxY = 90
            }
        }
        
        if(type == 3){//down
            let panValue = (self.maxY - self.minY) / 18
            
            if(self.minY - panValue >= -90 && self.maxY  <= 90){
                self.maxY = self.maxY - panValue
                self.minY = self.minY - panValue
            }else{
                self.maxY = maxY - (90 - abs(self.minY))
                self.minY = -90
                
            }
        }
        updateBounds()
        
    }
}
