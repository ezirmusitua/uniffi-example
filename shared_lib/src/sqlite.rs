use rusqlite::{Connection, Result};

use crate::fs::FileEntry;

// use crate::fs::FileEntry;

pub fn init_db(db_path: &str) -> Result<Connection, String> {
    let conn = read_db(db_path).unwrap();
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

pub fn search(db_path: &str, keyword: &str) -> Vec<FileEntry> {
    let conn = read_db(db_path).unwrap();
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

pub fn insert(conn: &Connection, entry: &FileEntry) -> () {
    let is_directory_str = if entry.is_directory { "True" } else { "False" };
    conn.execute(
        "INSERT INTO files (path, parent_path, is_directory) VALUES (?, ?, ?)",
        &[&entry.path, &entry.parent_path, is_directory_str],
    )
    .unwrap();
}

pub fn read_db(db_path: &str) -> Result<Connection, String> {
    let conn = Connection::open(db_path).unwrap();
    Ok(conn)
}

#[test]
fn test_search() {
    let conn = init_db("../test_data/test.db").unwrap();
    insert(
        &conn,
        &FileEntry {
            path: String::from("test.txt"),
            parent_path: String::from("/users/jz"),
            is_directory: false,
        },
    );
    insert(
        &conn,
        &FileEntry {
            path: String::from("1.txt"),
            parent_path: String::from("/users/jz"),
            is_directory: false,
        },
    );
    let entries = search("../test_data/test.db", "test");
    assert!(entries[0].path == "test.txt");
}
