# --- Color Palette ---
let colors = {
    terminal_green: (prompt-make-utils color-to-ansi 57 255 20 "fg" "92"),
    error_red: (prompt-make-utils color-to-ansi 255 0 0 "fg" "31"),
    dim_green: (prompt-make-utils color-to-ansi 40 180 20 "fg" "32"),
    reset: (ansi reset)
}

# --- Main Prompt Command ---
def create-prompt [] {
    let shells_index = get-prompt-info shells -Dl $"($colors.terminal_green)#" -r $"($colors.dim_green) : "
    let path_str = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -u -d $colors.terminal_green -s $colors.dim_green
    let git_branch = (get-prompt-info git)
    let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ($colors.dim_green)(get-prompt-info exec-time)sec($colors.reset)" } else { "" }
    let git_str = if not ($git_branch | is-empty) { $" ($colors.dim_green)($git_branch)($colors.reset)" } else { "" }

    return $"($shells_index)($colors.terminal_green)($path_str)($git_str)($execution_time)($colors.reset) "
}

# --- Prompt Indicator ---
def create-indicator [] {
    if (get-prompt-info exit-code) == "0" {
        return $"($colors.terminal_green)> ($colors.reset)"
    } else {
        return $"($colors.error_red)! ($colors.reset)"
    }
}

def vi-ins-prompt [] {
    if (get-prompt-info exit-code) == "0" {
        return $"($colors.terminal_green): ($colors.reset)"
    } else {
        return $"($colors.error_red): ($colors.reset)"
    }
}

def vi-nor-prompt [] {
    if (get-prompt-info exit-code) == "0" {
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
