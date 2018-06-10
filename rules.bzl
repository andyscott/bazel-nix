def _use_bash_impl(ctx):
    output = ctx.actions.declare_file(
        ctx.label.name + ".out")

    ctx.actions.run_shell(
        inputs = [],
        outputs = [output],
        command = """
#!/bin/bash
set -euo pipefail
{code}
touch {output}
        """.format(
            code = ctx.attr.code,
            output = output.path,
        ))

    return [DefaultInfo(
        files = depset(direct = [output])
    )]

use_bash = rule(
    implementation = _use_bash_impl,
    attrs = dict({
        "code": attr.string(),
    }),
)
