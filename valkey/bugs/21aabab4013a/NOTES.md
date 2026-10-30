Runs `ACL DRYRUN` for a user with `-@all` on `set` and `get`. Clean build replies
"This user has no permissions to run the 'set'/'get' command". Buggy build names the
`acl` command (the running command) instead of the tested one.
