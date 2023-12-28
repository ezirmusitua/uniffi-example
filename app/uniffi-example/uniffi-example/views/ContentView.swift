//
//  ContentView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      DbAndFsExampleView()
        .tabItem {
          Image(systemName: "1.circle")
          Text("数据库和文件")
        }
      FetchExampleView()
        .tabItem {
          Image(systemName: "2.circle")
          Text("网络请求")
        }
      
    }
    .navigationTitle("TabView Example")
  }
}

#Preview {
  ContentView()
}
