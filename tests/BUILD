load(":rules.bzl", "use_bash")

use_bash(
    name = "minimal",
    code = "",
)

use_bash(
    name = "env",
    code = "env",
)

use_bash(
    name = "ls",
    code = "ls",
)

use_bash(
    name = "echo",
    code = "echo hello world",
)

use_bash(
    name = "grep",
    code = """
echo test123 > testing.txt
grep test testing.txt
grep 123 testing.txt
! grep foo testing.txt
"""
)

use_bash(
    name = "gnu_grep",
    code = "grep --version | grep GNU",
)

use_bash(
    name = "gnu_bash",
    code = "bash --version | grep GNU",
)


use_bash(
    name = "gnu_egrep",
    code = "egrep --version | grep GNU",
)

use_bash(
    name = "gnu_awk",
    code = "awk --version | grep GNU",
)

use_bash(
    name = "gnu_sed",
    code = "sed --version | grep GNU",
)
