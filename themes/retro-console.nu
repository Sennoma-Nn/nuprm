# --- Color Palette ---
let colors = {
    terminal_green: (color2ansi 57 255 20 fg),
    error_red: (color2ansi 255 0 0 fg),
    dim_green: (color2ansi 40 180 20 fg),
    reset: (ansi reset)
}

# --- Main Prompt Command ---
def create-prompt [] {
    let path_str = (home-to-tilde $env.PWD)

    let git_branch = (get-git-info)
    let git_str = if not ($git_branch | is-empty) {
        $" ($colors.dim_green)(($git_branch))($colors.reset)"
    } else {
        ""
    }

    return $"($colors.terminal_green)($path_str)($git_str)($colors.reset) "
}

# --- Prompt Indicator ---
def create-indicator [] {
    if $env.LAST_EXIT_CODE == 0 {
        return $"($colors.terminal_green)> ($colors.reset)"
    } else {
        return $"($colors.error_red)! ($colors.reset)"
    }
}

def vi-ins-prompt [] {
    if $env.LAST_EXIT_CODE == 0 {
        return $"($colors.terminal_green): ($colors.reset)"
    } else {
        return $"($colors.error_red): ($colors.reset)"
    }
}

def vi-nor-prompt [] {
    if $env.LAST_EXIT_CODE == 0 {
        return $"($colors.terminal_green)> ($colors.reset)"
    } else {
        return $"($colors.error_red)> ($colors.reset)"
    }
}

# --- Assign components to environment variables ---
$env.PROMPT_COMMAND = {|| create-prompt }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = {|| create-indicator }
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.dim_green)» ($colors.reset)"
$env.PROMPT_INDICATOR_VI_INSERT = {|| vi-ins-prompt }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| vi-nor-prompt }
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
