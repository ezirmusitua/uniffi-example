//
//  FetchExampleView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/27.
//

import SwiftUI

struct FetchExampleView: View {
  @State var url = ""
  @State var content = "尚未加载"
  var body: some View {
    VStack {
      HStack {
        TextField("输入网址，如 https://httpbin.org/json", text: $url)
        Button("查看") {
          // let result2 = fetchUrl(url: "https://httpbin.org/json")
        }
      }
      Divider()
      Text(content).padding()
      Spacer()
    }.padding()
  }
}

#Preview {
  FetchExampleView()
}
