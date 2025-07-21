# Replaces the home directory path in a given string with a tilde (~)
export def home-to-tilde [
    path: string  # The input path to process
] {
    if ($path | str starts-with $nu.home-path) {
        return ($path | str replace $nu.home-path "~")
    } else {
        return $path
    }
}

# Retrieves current git branch information with optional formatting
export def get-git-info [
    --left_char: string (-l) = ""   # Left decorator for branch name
    --right_char: string (-r) = ""  # Right decorator for branch name
] {
    try {
        let branch = (
            do -i {  # Safely attempt git command
                ^git symbolic-ref --short HEAD
            } | complete
        ).stdout | str trim
        if $branch != "" {
            return $"($left_char)($branch)($right_char)"
        } else {
            return ""
        }
    } catch { "" }
}

# Gets current shell index from directory stack with display options
export def get-where-shells [
    --dont_display_shells_if_not_used_shells (-d)  # Suppress output when only 1 shell exists
    --left_char: string (-l) = ""                  # Left decorator for shell index
    --right_char: string (-r) = ""                 # Right decorator for shell index
] {
    try {
        if (((which "dirs") ++ (which "shells")) | length) > 0 {
            let shells_data = if (which "dirs" | length) > 0 { dirs } else { shells }
            if $dont_display_shells_if_not_used_shells and ($shells_data | length) == 1 {
                return ""
            } else {
                let shells_index = (
                    (
                        $shells_data | enumerate | where $it.item.active == true
                    ).0.index
                )
                let show_string = ([$left_char, $shells_index, $right_char] | str join "")
                return $show_string
            }
        } else {
            return ""
        }
    } catch { return "" }
}

# Converts RGB values to ANSI escape sequences for terminal colors
export def color2ansi [
    r: int              # Red component (0-255)
    g: int              # Green component (0-255)
    b: int              # Blue component (0-255)
    color_type: string  # Color type: "fg" (foreground) or "bg" (background)
] {
    let ansi_str = match $color_type {
        "fg" => { $"\e[38;2;($r);($g);($b)m" }
        "bg" => { $"\e[48;2;($r);($g);($b)m" }
        _    => { "" }
    }
    return $"($ansi_str)"
}

# Checks if the current operating system is Windows
export def is-windows [] {
    let is_windows = if $nu.os-info.name == "windows" { true } else { false }
    return $is_windows
}

# Retrieves current username from environment variables
export def get-user-name [] {
    let username = ($env.USERNAME? | default $env.USER? | default (whoami))
    return $username
}