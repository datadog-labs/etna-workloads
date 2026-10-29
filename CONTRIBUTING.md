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

Licensing: the patches and reproducers are derived from the upstream project,
so they keep its license (see the top-level README). A new workload needs:

- `LICENSE`: which files are derived from the upstream and under what
  terms (include the upstream's license text), and that the rest is Apache-2.0;
- `NOTICE` with the upstream's copyright notice, and `LICENSE-3rdparty.csv`;
- a line for the upstream in the root `LICENSE-3rdparty.csv`, and its
  license in the README table.

Upstreams under permissive licenses (MIT, BSD, Apache-2.0, PostgreSQL, public
domain) need nothing more. Copyleft or source-available upstreams (GPL, LGPL,
AGPL, SSPL, RSAL) need sign-off before they are added; prefer a permissively
licensed release or fork where one exists. Never add a workload built from
code that is not public.

## Pull requests

Keep each pull request to one workload, describe how the change was verified,
and do not include generated build products or local paths.
