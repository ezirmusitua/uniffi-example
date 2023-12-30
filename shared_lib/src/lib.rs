uniffi::setup_scaffolding!();

mod fs;
mod request;
mod sqlite;

#[uniffi::export]
pub fn init_sqlite(db_path: String) -> String {
    sqlite::init_db(&db_path).unwrap();
    String::from(db_path)
}

#[uniffi::export]
pub fn fetch_url(url: String) -> String {
    match request::get(url) {
        Ok(body) => return body,
        Err(err) => return err,
    };
}

#[uniffi::export]
pub fn search_sqlite(db_path: String, keyword: String) -> Vec<fs::FileEntry> {
    sqlite::search(&db_path, &keyword)
}

#[uniffi::export]
pub fn walk_and_insert(db_path: String, dir: String) -> String {
    let entries = fs::walk_dir(&dir, "").unwrap();
    sqlite::batch_insert(&db_path, entries);
    String::from("inserted")
}
