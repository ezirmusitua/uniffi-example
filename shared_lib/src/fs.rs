use std::fs::{self};
use std::path::{Path, PathBuf};

#[derive(Debug)]
pub struct FileEntry {
    pub path: PathBuf,
    pub parent_path: PathBuf,
    pub is_directory: bool,
}

pub fn walk_dir(dir: &str, parent_path: &str) -> Result<Vec<FileEntry>, String> {
    let dir = Path::new(dir);
    let parent_path = Path::new(parent_path);
    let mut file_entries = Vec::new();

    file_entries.push(FileEntry {
        path: dir.to_path_buf(),
        parent_path: parent_path.to_path_buf(),
        is_directory: true,
    });

    let entries = fs::read_dir(dir).unwrap();

    for entry in entries {
        let entry = entry.unwrap();
        let path = entry.path();

        if path.is_file() {
            // 将文件信息和父目录信息添加到列表中
            file_entries.push(FileEntry {
                path: path.clone(),
                parent_path: parent_path.to_path_buf(),
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
