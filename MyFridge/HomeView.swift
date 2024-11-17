//
//  HomeView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI


struct HomeView: View {
    
    var body: some View {
        VStack {
            Text("What's in my fridge")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()


            Image(systemName: "refrigerator")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding(40)


            Text("Oh no! Some things are about to expire")
                .font(.title)
        }
    }
    
}
