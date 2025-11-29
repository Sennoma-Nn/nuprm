# --- Color Palette ---
let colors = {
    cyan: (prompt-make-utils color-to-ansi 0 255 255 "fg" "36"),
    magenta: (prompt-make-utils color-to-ansi 255 0 255 "fg" "35"),
    yellow: (prompt-make-utils color-to-ansi 255 255 0 "fg" "33"),
    white: (prompt-make-utils color-to-ansi 220 220 220 "fg" "37"),
    red: (prompt-make-utils color-to-ansi 255 80 80 "fg" "31"),
    grey: (prompt-make-utils color-to-ansi 128 128 128 "fg" "97"),
    reset: (ansi reset)
}

# --- Left Prompt (Top Line) ---
def create-left-prompt [] {
    let user_name = get-prompt-info user-name -l $colors.cyan
    let host_name = get-prompt-info host-name -l $"($colors.magenta) at ($colors.cyan)"
    let user_host = $"($user_name)($host_name)"
    let user_info = $"($user_host)(ansi reset)"
    let path_info = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d (ansi reset) -s $colors.grey -r $colors.white -u
    let git_branch = (get-prompt-info git)
    let shells_index = get-prompt-info shells -Dl $"($colors.grey) | ($colors.cyan)dirs: ($colors.magenta)№"
    let git_info = if not ($git_branch | is-empty) { $"($colors.grey) | ($colors.cyan)git: ($colors.magenta)($git_branch)(ansi reset)" } else { "" }
    let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $"($colors.grey) | ($colors.cyan)exec time: ($colors.magenta)(get-prompt-info exec-time)sec(ansi reset)" } else { "" }

    return $"($user_info) ($colors.grey)in ($path_info)($git_info)($shells_index)($execution_time)\n"
}

# --- Right Prompt (Top Line) ---
def create-right-prompt [] {
    let exit_code = get-prompt-info exit-code
    if $exit_code != "0" {
        return $"($colors.red)status: ($exit_code)($colors.reset)"
    } else {
        return ""
    }
}

# --- Assign components to environment variables ---
$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create-right-prompt }
$env.PROMPT_INDICATOR = $"($colors.cyan)❯ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.grey)· ($colors.reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.cyan): ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
