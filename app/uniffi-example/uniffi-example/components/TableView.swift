//
//  TableView.swift
//  uniffi-example
//
//  Created by 林介夫 on 2023/12/27.
//

import Cocoa
import SwiftUI

#if os(macOS)
class MyTableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
  
  @IBOutlet weak var tableView: NSTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return 5 // 返回表格的行数
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    // 返回每个单元格的视图
    let cell = tableView.makeView(
      withIdentifier: NSUserInterfaceItemIdentifier("MyCell"),
      owner: self
    ) as? NSTextField
    cell?.stringValue = "Row \(row)"
    return cell
  }
}

struct TableViewRepresentable: NSViewControllerRepresentable {
  func makeNSViewController(context: Context) -> MyTableViewController {
    let myTableViewController = MyTableViewController()
    // 进行其他配置，如果需要
    return myTableViewController
  }
  
  func updateNSViewController(_ nsViewController: MyTableViewController, context: Context) {
    // 更新视图控制器，如果需要
  }
}
#endif


struct TableView: View {
  init() {
  }
    var body: some View {
      TableViewRepresentable().ignoresSafeArea()
    }
}

#Preview {
    TableView()
}
