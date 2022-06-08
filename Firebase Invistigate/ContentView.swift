//
//  ContentView.swift
//  Firebase Invistigate
//
//  Created by 齊藤健司 on 2022/06/08.
//

import SwiftUI

struct ContentView: View {
    @StateObject var remoteConfigState = RemoteConfigState()

    var body: some View {
        ZStack {

            //
            // 📲 Remote Config読み込み中画面
            //
            if remoteConfigState.isFetchAndActivating {

                ZStack {
                    Rectangle()
                        .fill(.gray.opacity(0.8))
                        .ignoresSafeArea()

                    Text("Remote Config\n読み込み中")
                }
            } else {
                Text(remoteConfigState.group)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
