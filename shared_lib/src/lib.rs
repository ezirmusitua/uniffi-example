
mod fs;
mod sqlite;

use reqwest;

pub fn init_sqlite(db_path: &str) -> String {
    sqlite::init_db(&db_path).unwrap();
    String::from(db_path)
}

pub fn insert_record(db_path: &str, file_path: &str, parent_path: &str) {
    print!("{} {} {}", db_path, file_path, parent_path);
    let conn = sqlite::read_db(db_path).unwrap();
    sqlite::insert(&conn, file_path, parent_path)
}

pub fn walk_and_insert(db_path: &str, dir: &str) -> String {
    let conn = sqlite::init_db(db_path).unwrap();
    let entries = fs::walk_dir(dir, "").unwrap();
    for entry in entries {
        sqlite::insert(
            &conn,
            &entry.path.to_string_lossy(),
            &entry.parent_path.to_string_lossy(),
        );
    }
    String::from("inserted")
}
#[uniffi::export(async_runtime = "tokio")]
pub async fn fetch_url(url: String) -> String {
    let client = reqwest::Client::new();
    let resp = client
        .get(url)
        .header("Content-Type", "application/json")
        .send()
        .await;
    if resp.is_err() {
        String::from("Fetch failed")
    } else {
        let body = resp.unwrap().text().await;
        body.unwrap()
    }
}

#[test]
fn test() {
    assert!(init_sqlite("/Users/jz/Inbox/test.db") == "/Users/jz/Inbox/test.db");
    insert_record("/Users/jz/Inbox/test.db", "sample.txt", "/Users/jz/Inbox/");
}

// #[test]
// fn test() {
//     walk_and_insert("./test_data/test.db", "./test_data/folder");
// }

uniffi::include_scaffolding!("lib");