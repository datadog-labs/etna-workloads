# Contributing

Thanks for your interest in etna-workloads. Issues and pull requests are
welcome.

## Reporting a problem with a bug entry

Open an issue with the workload and bug id (for example `sqlite/7f91834658ab`)
and what you saw: an injection that does not apply, a reproducer that does not
differ from the clean build, or an injection that does not match the upstream
fix it cites. Include your build options; the expected outputs come from the
build each workload's README describes.

## Adding or changing bugs

Every bug must trace to a real upstream fix, and its injection must touch only
implementation files (never tests). Before opening a pull request, check that:

- the injection applies to the workload's pinned release and reverses back to
  it byte for byte;
- with the injection, at least one of the upstream test cases that the fix
  added fails, and without it they all pass;
- a reproducer, if any, gives the expected output on the clean build and a
  different one with the injection.

The `sqlite/tool/` pipeline runs these checks; its README lists the stages.

## Adding a workload

Add one directory per target, with a README that names the pinned release, the
build used for the expected outputs, and how bugs were found and verified.
List it in the table in the top-level README.

## Pull requests

Keep each pull request to one workload, describe how the change was verified,
and do not include generated build products or local paths.
