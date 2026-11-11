use std::io::Write;
fn main() -> std::io::Result<()> {
    let mut stdout = std::io::stdout();
    aux::write_stuff(stdout)?;
    writeln!(stdout, "second line")?;
    Ok(())
}
