use rusqlite::{Connection, Result};

// use crate::fs::FileEntry;

pub fn init_db(db_path: &str) -> Result<Connection, String> {
    let conn = read_db(db_path).unwrap();
    // 创建文件列表表，包括父目录路径
    conn.execute(
        "CREATE TABLE IF NOT EXISTS files (
          id INTEGER PRIMARY KEY, 
          path TEXT NOT NULL, 
          parent_path TEXT NOT NULL, 
          is_directory BOOLEAN NOT NULL
        )",
        [],
    )
    .unwrap();
    Ok(conn)
}

pub fn insert(conn: &Connection, file_path: &str, parent_path: &str) -> () {
    conn.execute(
        "INSERT INTO files (path, parent_path, is_directory) VALUES (?, ?, ?)",
        &[file_path, parent_path, "False"],
    )
    .unwrap();
}

pub fn read_db(db_path: &str) -> Result<Connection, String> {
    let conn = Connection::open(db_path).unwrap();
    Ok(conn)
}

// pub fn insert_file_entry(conn: &Connection, entry: &FileEntry) -> Result<()> {
//     let is_directory = if entry.is_directory { "True" } else { "False" };
//     conn.execute(
//         "INSERT INTO files (path, parent_path, is_directory) VALUES (?, ?, ?)",
//         &[
//             &entry.path.to_string_lossy(),
//             &entry.parent_path.to_string_lossy(),
//             is_directory,
//         ],
//     )?;
//     Ok(())
// }
