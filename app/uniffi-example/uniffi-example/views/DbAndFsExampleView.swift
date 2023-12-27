//
//  ContentView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/25.
//

import Combine
import SwiftUI

struct DbAndFsExampleView: View {
  @ObservedObject var folderPicker = DocumentSelectionViewModel()
  @State private var cancellables: Set<AnyCancellable> = []
  @State private var dbPath: String = "未选择"
  @State private var scanPath: String = "未选择"
  @State private var keyword: String = ""
  struct ListItem: Identifiable {
    var id = UUID()
    var title: String
  }
  
  // 数据源
  let items: [ListItem] = [
    ListItem(title: "Item 1"),
    ListItem(title: "Item 2"),
    ListItem(title: "Item 3")
  ]
  
  var body: some View {
    VStack {
      HStack {
        Text("sqlite 路径：")
        Text(dbPath)
        Spacer()
        Button("选择") {
          folderPicker.showDialog(contentTypes: [.folder], allowsMultiple: true)
        }.onAppear {
          folderPicker.$selectedPath.sink { path in
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
          folderPicker.showDialog(contentTypes: [.folder], allowsMultiple: true)
        }.onAppear {
          folderPicker.$selectedPath.sink { path in
            if path.first != nil {
              scanPath = path.first ?? "未选择"
              let result = walkAndInsert(dbPath: dbPath, root: scanPath)
              print(result)
            }
          }.store(in: &self.cancellables)
        }
      }
      Divider()
      HStack {
        TextField("输入关键词", text: $keyword).textFieldStyle(RoundedBorderTextFieldStyle())
        Button("搜索") {
          // let result = searchDb(keyword);
          // print(result2)
          // update items
        }
      }
      List(items) { item in
        HStack {
          Text(item.title)
          Text("文件名")
          Text("类型")
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
