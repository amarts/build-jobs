#!/usr/bin/env python

import subprocess
output = subprocess.check_output(["git-clang-format", "HEAD~", "--diff"])

if output not in ['no modified files to format\n',
        'clang-format did not modify any files\n']:
    print(output)
    print("The above patch to be applied to pass clang-format")
    exit(1)
else:
    exit(0)
