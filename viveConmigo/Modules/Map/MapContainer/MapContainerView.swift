//
//  MapContainerView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct MapContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var is3DView = false
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @StateObject private var viewModel = Map3DViewModel(appState: AppState())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                

                if is3DView {
                    Map3DView(selectedSpot: $selectedSpot, selectedReward: $selectedReward, viewModel: viewModel)
                        .edgesIgnoringSafeArea([.top, .bottom])
                } else {
                    Map2DView()
                        .edgesIgnoringSafeArea([.top, .bottom])
                }
            }
            

            Button(action: {
                is3DView.toggle()
            }) {
                Text(is3DView ? "2D" : "3D")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
            }
            .padding(.bottom, 250)

            .sheet(item: $selectedSpot) { spot in
                MapCallOutView(spot: spot, viewModel: viewModel)
                    .environmentObject(appState)
            }
            .sheet(item: $selectedReward) { reward in
                CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                    .environmentObject(appState)
            }
        }
    }
}
