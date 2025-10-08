# --- Color Palette ---
let colors = {
    cyan: (color2ansi 0 255 255 fg 36),
    magenta: (color2ansi 255 0 255 fg 35),
    yellow: (color2ansi 255 255 0 fg 33),
    white: (color2ansi 220 220 220 fg 37),
    red: (color2ansi 255 80 80 fg 31),
    grey: (color2ansi 128 128 128 fg 97),
    reset: (ansi reset)
}

# --- Left Prompt (Top Line) ---
def create-left-prompt [] {
    let user_name = $colors.cyan + (get-user-name)
    let host_name = get-host -l $"($colors.magenta) at ($colors.cyan)"
    let user_host = $"($user_name)($host_name)"
    let user_info = $"($user_host)(ansi reset)"
    let path_info = $env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -d (ansi reset) -s $colors.grey -r $colors.white -u
    let shells_index = get-where-shells -dl $"($colors.grey) | ($colors.magenta)№"

    let git_branch = (get-git-info)
    let git_info = if not ($git_branch | is-empty) {
        $"($colors.grey) | ($colors.magenta)($git_branch)(ansi reset)"
    } else {
        ""
    }

    return $"($user_info) ($colors.grey)in ($path_info)($git_info)($shells_index)\n"
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
