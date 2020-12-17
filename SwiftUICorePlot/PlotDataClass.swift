//
//  PlotDataClass.swift
//  SwiftUICorePlot
//
//  Created by Jeff Terry on 12/16/20.
//

import Foundation
import SwiftUI
import CorePlot

class PlotDataClass: NSObject, ObservableObject {
    
    @Published var plotData = [plotDataType]()
    
    init(fromLine line: Bool) {
        
        super.init()
        
        self.newLineData()
        
       }
    
    func newPlotData() //-> [plotDataType]
    {
        plotData = []
        for i in 0 ..< 60 {

            //create x values here

            let x = -2.0 + Double(i) * 0.2

        //create y values here

        let y = exp(-x)


            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(dataPoint)
        }
        
        return //newData
    }
    
    func newLineData() // -> [plotDataType]
    {
        plotData = []
        
        
        for i in 0 ..< 60 {

            //create x values here

            let x = -2.0 + Double(i) * 0.2

        //create y values here

        let y = x


            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(dataPoint)
        
        }

    }
    
    

}

