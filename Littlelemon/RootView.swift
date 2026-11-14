//
//  RootView.swift
//  Littlelemon
//
//  Created by Kanchana Panditha on 12/11/2026.
//
import SwiftUI

struct RootView: View {

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView()
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    RootView()
}
