use rusqlite::{Connection, Result};

use crate::fs::FileEntry;

/// 初始化 sqlite 数据库
///
/// # Arguments
///
/// * db_path - sqlite 数据库的保存路径
pub fn init_db(db_path: &str) -> Result<Connection, String> {
    let conn = Connection::open(db_path).unwrap();
    // 创建文件列表表，包括父目录路径
    conn.execute(
        "CREATE TABLE IF NOT EXISTS files (
          id INTEGER PRIMARY KEY, 
          path TEXT NOT NULL, 
          parent_path TEXT NOT NULL, 
          is_directory TEXT NOT NULL
        )",
        [],
    )
    .unwrap();
    Ok(conn)
}

/// 批量插入文件信息
///
/// # Arguments
///
/// * db_path - 数据库路径
/// * entry - 待插入的文件信息列表
pub fn batch_insert(db_path: &str, entries: Vec<FileEntry>) -> () {
    let conn = Connection::open(db_path).unwrap();
    for entry in entries {
        let is_directory_str = if entry.is_directory { "True" } else { "False" };
        conn.execute(
            "INSERT INTO files (path, parent_path, is_directory) VALUES (?, ?, ?)",
            &[&entry.path, &entry.parent_path, is_directory_str],
        )
        .unwrap();
    }
}

/// 根据关键字搜索文件
///
/// # Arguments
///
/// * db_path - 数据库路径
/// * keyword - 关键字
///
/// # Returns
///
/// * Vec<FileEntry> - 文件列表
pub fn search(db_path: &str, keyword: &str) -> Vec<FileEntry> {
    let conn = Connection::open(db_path).unwrap();
    let mut stmt = conn
        .prepare("SELECT * FROM files WHERE path LIKE ?1")
        .unwrap();
    let result = stmt
        .query_map(&[&format!("%{}%", keyword)], |row| {
            let path: String = row.get(1).unwrap();
            let parent_path: String = row.get(2).unwrap();
            let is_directory: String = row.get(3).unwrap();
            Ok(FileEntry {
                path,
                parent_path,
                is_directory: is_directory == "True",
            })
        })
        .unwrap();
    result.map(|item| item.unwrap()).collect()
}
