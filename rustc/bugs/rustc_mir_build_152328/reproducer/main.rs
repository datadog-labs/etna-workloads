#![deny(deprecated_safe_2024)]
use std::os::unix::process::CommandExt;
use std::process::Command;
fn main() {
    let mut cmd = Command::new("echo");
    cmd.before_exec(|| Ok(()));
}
