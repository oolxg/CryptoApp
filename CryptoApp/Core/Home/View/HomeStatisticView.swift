//
//  HomeStatisticView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 05.06.2021.
//

import SwiftUI

struct HomeStatisticView: View {
    @Binding var showPortfolio: Bool
    @EnvironmentObject var vm: HomeViewModel

    var body: some View {
        HStack {
            ForEach(vm.stats) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
