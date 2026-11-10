pub fn write_stuff<W: std::io::Write>(mut w: W) -> std::io::Result<()> { writeln!(w, "x") }
