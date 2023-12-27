//
//  FolderPickerViewModel.swift
//  rust-swift.interop.sample
//
//  Created by 林介夫 on 2023/12/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
#if os(macOS)
import Cocoa
#else
import UIKit
import MobileCoreServices
#endif

#if os(iOS)
class DocumentSelectionViewModel: NSObject, ObservableObject, UIDocumentPickerDelegate {
  @Published var selectedPath: [String] = []

  func showDialog(contentTypes: [UTType], allowsMultiple: Bool) {
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
    documentPicker.delegate = self // FolderSelectionDelegate(viewModel: self)
    documentPicker.allowsMultipleSelection = allowsMultiple
    let connectedScenes = UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .compactMap { $0 as? UIWindowScene }
    let window = connectedScenes.first?
      .windows
      .first { $0.isKeyWindow }
    window?.rootViewController?.present(documentPicker, animated: true, completion: nil)
  }
 
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    urls.forEach({ url in
      selectedPath.append(url.path)
    })
  }
}
#endif

#if os(macOS)
class DocumentSelectionViewModel: NSObject, ObservableObject {
  @Published var selectedPath: [String] = []
  
  func showDialog(contentTypes: [UTType], allowsMultiple: Bool) {
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = contentTypes.contains(UTType.folder)
    openPanel.canChooseFiles = contentTypes.filter { $0 != UTType.folder }.count > 0
    openPanel.allowsMultipleSelection = allowsMultiple
    openPanel.begin { response in
      if response != .OK { return }
      self.selectedPath = openPanel.urls.map({ $0.path })
    }
  }
}
#endif
