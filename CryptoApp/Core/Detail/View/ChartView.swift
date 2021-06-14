//
//  ChartView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 14.06.2021.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY, minY: Double
    private let lineColor: Color
    private let startingDate, endingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)

        lineColor = priceChange > 0 ? .theme.green : .theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    var body: some View {
        VStack {
            chart
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chart: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPos = CGFloat(1 - (data[index] - minY) / yAxis) * geometry.size.height
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPos, y: yPos))
                    }
                    
                    path.addLine(to: CGPoint(x: xPos, y: yPos))
                    
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.linear(duration: 2)) {
                        self.percentage = 1
                    }
                }
            }
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            
            Spacer()
            
            Text(endingDate.asShortDateString())
        }
    }
}
