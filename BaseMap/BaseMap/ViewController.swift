//
//  ViewController.swift
//  BaseMap
//
//  Created by Samip Neupane on 6/10/17.
//  Copyright © 2017 Samip Neupane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var bounds = Bounds(minX: -180.0, minY: -90.0, maxX: 180.0, maxY: 90.0)
    @IBOutlet var myView: UIView!
    var imgView: UIImageView?
    let states: States = Parser.parse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.bounds = CGRect(x: 0, y: 0, width: 503, height: 280)
        imgView = UIImageView(frame: myView.bounds)
        myView.addSubview(imgView!)
        addButtons()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        myView.addGestureRecognizer(tapGesture)
        draw()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func draw(){
        UIGraphicsBeginImageContext((imgView?.bounds.size)!)
        let context = UIGraphicsGetCurrentContext()
        imgView?.image = nil
        
        for x: State in states.getStates(){
            context?.addLines(between: bounds.getPixelFromXY(points: x.getPoint()))
            context?.setFillColor(getCGColor(hexString: x.getColor()))
            context?.fillPath()
        }
        
        
//        let x = bounds.getPixelFromXY(x: 0.0, y: 0.0)
//        let y = bounds.getPixelFromXY(x: 10.0, y: 40.0)
//        
//        var points: [CGPoint] = []
//        points.append(x)
//        points.append(y)
//        context?.addLines(between: points)
//        context?.setStrokeColor(UIColor.red.cgColor)
//        context?.strokePath()
        imgView?.image = UIGraphicsGetImageFromCurrentImageContext()

        
    }
    
    public func getCGColor(hexString: String)-> CGColor{
        var  newHexString: String = hexString
        newHexString.remove(at: newHexString.startIndex)
        if let rgbValue = UInt(newHexString, radix: 16) {
            let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
            let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
            let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        }
        return UIColor.black.cgColor
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        let location = (sender.location(in: myView))
        print(String(describing: bounds.getXYfromPixel(x: Double(location.x), y: Double(location.y))))
    }

    
    func handleZoomIn(sender: UIPress){
        //print("zoom in")
        bounds.ZoomIn(scale: 1.2)
        draw()
        
    }
    func handleZoomOut(sender: UIPress){
        //print("zoom out")
        bounds.ZoomOut(scale: 1.2)
        draw()
    }
    func handlePanLeft(sender: UIPress){
        //print("left")
        bounds.pan(type: 0)
        draw()
    }
    func handlePanRight(sender: UIPress){
        //print("right")
        bounds.pan(type: 1)
        draw()
    }
    func handlePanUp(sender: UIPress){
        //print("up")
        bounds.pan(type: 2)
        draw()
    }
    func handlePanDown(sender: UIPress){
        //print("down")
        bounds.pan(type: 3)
        draw()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addButtons(){
        let zoomIn = UIButton()
        zoomIn.frame = CGRect(x: 50, y: 300, width: 40, height: 40)
        zoomIn.layer.borderColor = UIColor.white.cgColor
        zoomIn.layer.borderWidth = 2
        zoomIn.layer.cornerRadius = 15
        zoomIn.setTitle("In", for: .normal)
        zoomIn.backgroundColor = UIColor.darkGray
        zoomIn.addTarget(self, action: #selector(handleZoomIn(sender:)), for: .touchUpInside)
        zoomIn.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(zoomIn)
        
        let zoomOut = UIButton()
        zoomOut.frame = CGRect(x: 570, y: 300, width: 40, height: 40)
        zoomOut.layer.borderColor = UIColor.white.cgColor
        zoomOut.layer.borderWidth = 2
        zoomOut.layer.cornerRadius = 15
        zoomOut.setTitle("Out", for: .normal)
        zoomOut.backgroundColor = UIColor.darkGray
        zoomOut.addTarget(self, action: #selector(handleZoomOut(sender:)), for: .touchUpInside)
        zoomOut.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(zoomOut)
        
        
        let panLeft = UIButton(frame: CGRect(x: 290, y: 310, width: 25, height: 25))
        panLeft.layer.borderColor = UIColor.white.cgColor
        panLeft.layer.borderWidth = 2
        panLeft.layer.cornerRadius = 10
        panLeft.setTitle("◀", for: .normal)
        panLeft.backgroundColor = UIColor.darkGray
        panLeft.addTarget(self, action: #selector(handlePanLeft(sender:)), for: .touchUpInside)
        panLeft.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(panLeft)
        
        let panRight = UIButton(frame: CGRect(x: 362, y: 310, width: 25, height: 25))
        panRight.layer.borderColor = UIColor.white.cgColor
        panRight.layer.borderWidth = 2
        panRight.layer.cornerRadius = 10
        panRight.setTitle("▶", for: .normal)
        panRight.backgroundColor = UIColor.darkGray
        panRight.addTarget(self, action: #selector(handlePanRight(sender:)), for: .touchUpInside)
        panRight.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(panRight)
        
        let panUp = UIButton(frame: CGRect(x: 327, y: 290, width: 25, height: 25))
        panUp.layer.borderColor = UIColor.white.cgColor
        panUp.layer.borderWidth = 2
        panUp.layer.cornerRadius = 10
        panUp.setTitle("▲", for: .normal)
        panUp.backgroundColor = UIColor.darkGray
        panUp.addTarget(self, action: #selector(handlePanUp(sender:)), for: .touchUpInside)
        panUp.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(panUp)
        
        let panDown = UIButton(frame: CGRect(x: 327, y: 330, width: 25, height: 25))
        panDown.layer.borderColor = UIColor.white.cgColor
        panDown.layer.borderWidth = 2
        panDown.layer.cornerRadius = 10
        panDown.setTitle("▼", for: .normal)
        panDown.backgroundColor = UIColor.darkGray
        panDown.addTarget(self, action: #selector(handlePanDown(sender:)), for: .touchUpInside)
        panDown.setTitleColor(UIColor(red: 233/255, green: 64/255, blue: 87/255, alpha: 1), for: UIControlState.normal)
        self.view.addSubview(panDown)
        

    }


}

