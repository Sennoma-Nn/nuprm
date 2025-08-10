# --- Color Palette ---
let colors = {
    cyan: (color2ansi 0 255 255 fg),
    magenta: (color2ansi 255 0 255 fg),
    yellow: (color2ansi 255 255 0 fg),
    white: (color2ansi 220 220 220 fg),
    red: (color2ansi 255 80 80 fg),
    grey: (color2ansi 128 128 128 fg),
    reset: (ansi reset)
}

# --- Left Prompt (Top Line) ---
def create-left-prompt [] {
    let user_info = $"($colors.cyan)(get-user-name)(ansi reset)"
    let path_info = $env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -l (ansi reset) -r $colors.white -u

    let git_branch = (get-git-info)
    let git_info = if not ($git_branch | is-empty) {
        $"($colors.grey) | ($colors.magenta)git:($git_branch)(ansi reset)"
    } else {
        ""
    }

    return $"($user_info) ($colors.grey)in ($path_info)($git_info)\n"
}

# --- Right Prompt (Top Line) ---
def create-right-prompt [] {
    if $env.LAST_EXIT_CODE != 0 {
        return $"($colors.red)[status: ($env.LAST_EXIT_CODE)]($colors.reset)"
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
