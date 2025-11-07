# Simple Minimal Theme
let colors = {
    green: (color2ansi 100 200 100 fg 32),
    white: (color2ansi 240 240 240 fg 37),
    grey: (color2ansi 128 128 128 fg 97),
    red: (color2ansi 255 80 80 fg 31),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user_name = get-user-name
    let host_name = get-host -l $"($colors.white) @ ($colors.green)"
    let user_info = $"($colors.green)($user_name)($host_name)($colors.reset)"
    let path_info = $env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -d $colors.white -s $colors.grey -r $colors.reset -u
    let shells_index = get-where-shells -dl $"($colors.white)#" -r $"($colors.green) : "
    let git_info = (get-git-info -l $" ($colors.green)\(" -r $"\)($colors.reset)")
    let execution_time = if (get-execution-time-s) > 0.5 { $" ($colors.green)(get-execution-time-s)sec($colors.reset)" } else { "" }
    let exit_code = if (get-exit-code) != 0 { $" ($colors.red)[(get-exit-code)]" } else { "" }

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
