//
//  CorePlot.swift
//  SwiftUICorePlot
//
//  Created by Fred Appelman on 14/12/2020.
//
import SwiftUI
import CorePlot

public struct CorePlot: NSViewRepresentable {
    @Binding var dataForPlot : [plotDataType]
    var xLabel: String = ""
    var yLabel: String = ""
    var xMax = 2.0
    var yMax = 2.0
    var yMin = -1.0
    var xMin = -1.0

    public func makeNSView(context: Context) -> CPTGraphHostingView {
        // self.plotData = newPlotData()

        // Create graph
        let newGraph = CPTXYGraph(frame: .zero)

        let theme = CPTTheme(named: .darkGradientTheme)
        newGraph.apply(theme)

        // if let host = self.hostView {
        //     host.hostedGraph = newGraph
        // }
        let hostView = CPTGraphHostingView()
        hostView.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 10.0
        newGraph.paddingRight  = 10.0
        newGraph.paddingTop    = 10.0
        newGraph.paddingBottom = 10.0

        // Plot space
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        plotSpace.yRange = CPTPlotRange(location: yMin as NSNumber, length: (yMax - yMin) as NSNumber)
        plotSpace.xRange = CPTPlotRange(location: xMin as NSNumber, length: (xMax - xMin) as NSNumber)
        
        // Anotation

        let theTextStyle = CPTMutableTextStyle()

        theTextStyle.color =  .white()

        let ann = CPTLayerAnnotation.init(anchorLayer: hostView.hostedGraph!.plotAreaFrame!)

        ann.rectAnchor = .bottom; // to make it the top centre of the plotFrame
        ann.displacement = CGPoint(x: 20.0, y: 20.0) // To move it down, below the title

        let textLayer = CPTTextLayer.init(text: xLabel, style: theTextStyle)

        ann.contentLayer = textLayer

        hostView.hostedGraph?.plotAreaFrame?.addAnnotation(ann)

        let annY = CPTLayerAnnotation.init(anchorLayer: hostView.hostedGraph!.plotAreaFrame!)

        annY.rectAnchor = .left; // to make it the top centre of the plotFrame
        annY.displacement = CGPoint(x: 50.0, y: 30.0) // To move it down, below the title

        let textLayerY = CPTTextLayer.init(text: yLabel, style: theTextStyle)
        let angle = CGFloat.pi/2.0

        annY.contentLayer = textLayerY
        annY.rotation = angle;
        
        
        hostView.hostedGraph?.plotAreaFrame?.addAnnotation(annY)

        // Axes
        let axisSet = newGraph.axisSet as! CPTXYAxisSet

        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 1.0
            x.orthogonalPosition    = 0.0
            x.minorTicksPerInterval = 3
        }

        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 0.5
            y.minorTicksPerInterval = 5
            y.orthogonalPosition    = 0.0
            y.delegate = context.coordinator
        }
        
        // Create a blue plot area
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.miterLimit    = 1.0
        blueLineStyle.lineWidth     = 3.0
        blueLineStyle.lineColor     = .blue()
        
        let linePlot = CPTScatterPlot(frame: .zero)
        linePlot.dataLineStyle = blueLineStyle
        linePlot.identifier    = "Blue Plot" as NSString
        linePlot.interpolation = .curved
        newGraph.add(linePlot)

        // Add plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = .black()
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill          = CPTFill(color: .blue())
        plotSymbol.lineStyle     = symbolLineStyle
        plotSymbol.size          = CGSize(width: 10.0, height: 10.0)
        linePlot.plotSymbol = plotSymbol

        // dataSourceLinePlot.dataSource = self
        linePlot.dataSource    = context.coordinator
    
        newGraph.add(linePlot)

        // self.graph = newGraph
        return hostView
    }

    public func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self, data: dataForPlot)
        }

    public func updateNSView(_ nsView: CPTGraphHostingView, context: Context) {
        
        print("in update")
        print(dataForPlot[0])
       // context.coordinator.parent.dataForPlot = dataForPlot
        
        guard let graph = nsView.hostedGraph as? CPTXYGraph else { return }
        context.coordinator.data = dataForPlot
        graph.reloadData()
        print(context.coordinator.data[0])
        
       /* let graph = nsView.hostedGraph
        let plot = graph?.plot(at: 0)
                
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        
        let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(0.0)), lengthDecimal: CPTDecimalFromDouble(Double(2.0)))
        let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(0.0)), lengthDecimal: CPTDecimalFromDouble(Double(2.0)))
            
        CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
        plot?.insertData(at: UInt(0.0), numberOfRecords: UInt(dataForPlot.count))*/
        
     //   let newView = self.makeNSView(context: context)
     //   nsView.hostedGraph = newView.hostedGraph
        }

    public class Coordinator: NSObject, CPTScatterPlotDataSource, CPTAxisDelegate {

        var parent: CorePlot
        var data: [plotDataType]

        init(parent: CorePlot, data: [plotDataType]) {
            self.parent = parent
            self.data = data
        }

        // MARK: - Plot Data Source Methods
        public func numberOfRecords(for plot: CPTPlot) -> UInt
        {
            return UInt(parent.dataForPlot.count)
        }

        public func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
        {
            let plotField = CPTScatterPlotField(rawValue: Int(field))

            if let num = parent.dataForPlot[Int(record)][plotField!] {
                return num as NSNumber
            }
            else {
                return nil
            }
        }

        // MARK: - Axis Delegate Methods
        public func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: Set<NSNumber>) -> Bool
        {
            if let formatter = axis.labelFormatter {
                let labelOffset = axis.labelOffset

                var newLabels = Set<CPTAxisLabel>()

                for location in locations {
                    if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
                        if location.doubleValue >= 0.0 {
                            labelTextStyle.color = .green()
                        }
                        else {
                            labelTextStyle.color = .red()
                        }

                        let labelString   = formatter.string(for:location)
                        let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)

                        let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                        newLabel.tickLocation = location
                        newLabel.offset       = labelOffset
                        
                        newLabels.insert(newLabel)
                    }
                    
                    axis.axisLabels = newLabels
                }
            }
            
            return false
        }
        
        
        
        
        
    }
}
