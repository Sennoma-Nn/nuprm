# Simple Minimal Theme
let colors = {
    green: (prompt-make-utils color-to-ansi 100 200 100 "fg" "32"),
    white: (prompt-make-utils color-to-ansi 240 240 240 "fg" "37"),
    grey: (prompt-make-utils color-to-ansi 128 128 128 "fg" "97"),
    red: (prompt-make-utils color-to-ansi 255 80 80 "fg" "31"),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user_name = get-prompt-info user-name
    let host_name = get-prompt-info host-name -l $"($colors.white) @ ($colors.green)"
    let user_info = $"($colors.green)($user_name)($host_name)($colors.reset)"
    let path_info = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $colors.white -s $colors.grey -r $colors.reset -u
    let shells_index = get-prompt-info shells -Dl $"($colors.white)#" -r $"($colors.green) : "
    let git_info = (get-prompt-info git -l $" ($colors.green)\(" -r $"\)($colors.reset)")
    let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ($colors.green)(get-prompt-info exec-time)sec($colors.reset)" } else { "" }
    let exit_code = if (get-prompt-info exit-code) != "0" { $" ($colors.red)[(get-prompt-info exit-code)]" } else { "" }

    return $"($user_info) ($shells_index)($path_info)($git_info)($execution_time)($exit_code) "
}

$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = $"($colors.green)❯ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.green)::: ($colors.reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.green): ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
