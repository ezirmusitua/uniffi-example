//
//  ContentView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/25.
//

import Combine
import SwiftUI

struct DbAndFsExampleView: View {
  @ObservedObject var dbFolderPicker = DocumentSelectionViewModel()
  @ObservedObject var scanFolderPicker = DocumentSelectionViewModel()
  @State private var cancellables: Set<AnyCancellable> = []
  @State private var dbPath: String = "未选择"
  @State private var scanPath: String = "未选择"
  @State private var keyword: String = ""
  @State private var items: [FileEntry] = []
  
  var body: some View {
    VStack {
      HStack {
        Text("sqlite 路径：")
        Text(dbPath)
        Spacer()
        Button("选择") {
          dbFolderPicker.showDialog(contentTypes: [.folder], allowsMultiple: true)
        }.onAppear {
          dbFolderPicker.$selectedPath.sink { path in
            let path = path.first ?? ""
            if path != "" {
              dbPath = path == "" ? "未选择" : (path + "/test.db")
              let result = initSqlite(dbPath: dbPath)
              print(result)
            }
            
          }.store(in: &self.cancellables)
        }
      }
      Divider()
      HStack {
        Text("扫描路径：")
        Text(scanPath)
        Spacer()
        Button("选择") {
          scanFolderPicker.showDialog(contentTypes: [.folder], allowsMultiple: true)
        }.onAppear {
          scanFolderPicker.$selectedPath.sink { path in
            if path.first != nil {
              scanPath = path.first ?? "未选择"
              let result = walkAndInsert(dbPath: dbPath, dir: scanPath)
              print(result)
            }
          }.store(in: &self.cancellables)
        }.disabled(dbPath == "未选择")
      }
      Divider()
      HStack {
        TextField("输入关键词", text: $keyword).textFieldStyle(RoundedBorderTextFieldStyle())
        Button("搜索") {
          items = searchSqlite(dbPath: dbPath, keyword: keyword);
        }.disabled(dbPath=="未选择" || scanPath == "未选择")
      }
      List {
        ForEach($items, id: \.self.path) { item in
          HStack {
            Text(item.path.wrappedValue)
            Text(item.parentPath.wrappedValue)
            Text(String(item.isDirectory.wrappedValue))
          }
        }
        
      }
      Spacer()
    }
    .padding()
  }
}

#Preview {
  DbAndFsExampleView()
}
