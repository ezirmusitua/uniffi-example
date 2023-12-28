//
//  FetchExampleView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/27.
//

import SwiftUI

struct Code<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    content
      .font(.system(size: 14, weight: .regular, design: .monospaced))
      .foregroundColor(Color.green)
      .padding()
      .background(Color.black)
      .cornerRadius(8)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct FetchExampleView: View {
  @State var url = ""
  @State var content = "尚未加载"
  var body: some View {
    VStack {
      HStack {
        TextField(
          "输入网址，如 https://httpbin.org/json",
          text: $url
        )
        Button("浏览") {
          Task {
            content = await fetchUrl(url: url)
          }
        }
        .disabled(url == "" || (!url.starts(with: /http:\/\//) && !url.starts(with: /https:\/\//)))
      }
      Divider()
      HStack {
        Code {
          Text (content).padding().frame(maxWidth: .infinity)
        }
      }.padding()
      Spacer()
    }.padding()
  }
}

#Preview {
  FetchExampleView()
}
