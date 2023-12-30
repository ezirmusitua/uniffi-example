/// GET 请求
///
/// # Arguments
///
/// * url - 请求目标
pub fn get(url: String) -> Result<String, String> {
    let resp = ureq::get(&url)
        .set("Content-Type", "json/application")
        .call();
    if resp.is_err() {
        return Err(resp.unwrap_err().to_string());
    }
    let body = resp.unwrap().into_string();
    if body.is_err() {
        return Err(body.unwrap_err().to_string());
    }
    Ok(body.unwrap())
}
