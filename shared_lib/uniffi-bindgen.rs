fn main() {
    let udl_file = "./src/lib.udl";
    let out_dir = "./bindings/";
    uniffi::generate_bindings(
        udl_file.into(),
        None,
        vec![uniffi::TargetLanguage::Swift],
        Some(out_dir.into()),
        None,
        None,
        true,
    )
    .unwrap();
}
