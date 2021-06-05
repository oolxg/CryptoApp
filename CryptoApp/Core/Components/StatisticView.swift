//
//  StatisticView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 05.06.2021.
//

import SwiftUI

struct StatisticView: View {
    var stat: Statistic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))

                Text((stat.percentageChange?.asPercentString() ?? ""))
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? .theme.green : .theme.red)
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.statistic)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.statistic1)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.statistic2)
                .previewLayout(.sizeThatFits)
        }
    }
}
