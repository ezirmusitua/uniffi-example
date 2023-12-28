uniffi::setup_scaffolding!();

mod fs;
mod sqlite;

#[uniffi::export]
pub fn init_sqlite(db_path: String) -> String {
    sqlite::init_db(&db_path).unwrap();
    String::from(db_path)
}

#[uniffi::export]
pub fn walk_and_insert(db_path: String, dir: String) -> String {
    let conn = sqlite::init_db(&db_path).unwrap();
    let entries = fs::walk_dir(&dir, "").unwrap();
    for entry in entries {
        sqlite::insert(
            &conn,
            &entry.path.to_string_lossy(),
            &entry.parent_path.to_string_lossy(),
        );
    }
    String::from("inserted")
}

#[uniffi::export]
pub fn fetch_url(url: String) -> String {
    let body: String = ureq::get(&url)
        .set("Content-Type", "json/application")
        .call()
        .unwrap()
        .into_string()
        .unwrap();
    body
}
