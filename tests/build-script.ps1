param(
    [string] $p1
)

task LogScript {
    "script"
}

task LogFramework {
    "framework"
}

task LogParameters {
    "p1 = [${p1}]"
}

task . LogScript, LogFramework, LogParameters