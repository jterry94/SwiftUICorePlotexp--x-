//
//  ContentView.swift
//  SwiftUICorePlot
//
//  Created by Fred Appelman on 14/12/2020.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    

    var body: some View {
        
        VStack{
      //      CorePlot(dataForPlot: newPlotData(), xLabel: "x", yLabel: "exp(-x)")
            CorePlot(dataForPlot: $plotDataModel.plotData , xLabel: "x", yLabel: "exp(-x)")
                .focusable()
                
                .padding()
            Button("Calculate", action: {self.calculateNewPlotData()} )
                .padding()
        }
        
    }
    
    func calculateNewPlotData(){
        
        plotDataModel.newPlotData()
    }
   
    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
