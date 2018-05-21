def _use_bash_impl(ctx):
    output = ctx.actions.declare_file(
        ctx.label.name + ".out")

    ctx.actions.run_shell(
        inputs = [],
        outputs = [output],
        command = """
#!/bin/bash
set -euo pipefail
which which
! which zip
! which unzip

grep --version  | grep GNU
egrep --version | grep GNU
awk --version   | grep GNU
sed --version   | grep GNU

which jq

touch {output}
        """.format(output = output.path))

    return [DefaultInfo(
        files = depset(direct = [output])
    )]

use_bash = rule(
    implementation = _use_bash_impl,
    attrs = dict({
    }),
)
