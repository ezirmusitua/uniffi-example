use std::fs::{self};
use std::path::Path;

/// FileEntry 文件基本信息
/// 
/// # Notes
/// * 使用过程宏声明 FileEntry 这个结构体将被导出到绑定文件中
#[derive(Debug, uniffi::Record)]
pub struct FileEntry {
    pub path: String,
    pub parent_path: String,
    pub is_directory: bool,
}

/// 使用递归遍历文件夹
///
/// # Arguments
/// 
/// * dir - 文件夹路径
/// * parent_path - 父目录路径
/// 
/// # Returns
/// 
/// * Vec<FileEntry> - 文件列表
pub fn walk_dir(dir: &str, parent_path: &str) -> Result<Vec<FileEntry>, String> {
    let dir = Path::new(dir);
    let parent_path = Path::new(parent_path);
    let mut file_entries = Vec::new();

    file_entries.push(FileEntry {
        path: String::from(dir.to_string_lossy()),
        parent_path: String::from(parent_path.to_string_lossy()),
        is_directory: true,
    });

    let entries = fs::read_dir(dir).unwrap();

    for entry in entries {
        let entry = entry.unwrap();
        let path = entry.path();

        if path.is_file() {
            // 将文件信息和父目录信息添加到列表中
            file_entries.push(FileEntry {
                path: String::from(path.to_string_lossy()),
                parent_path: String::from(parent_path.to_string_lossy()),
                is_directory: false,
            });
        } else if path.is_dir() {
            // 递归处理目录，并将结果合并到当前列表
            let mut sub_entries =
                walk_dir(&path.to_str().unwrap(), &path.to_str().unwrap()).unwrap();
            file_entries.append(&mut sub_entries);
        }
    }

    Ok(file_entries)
}
