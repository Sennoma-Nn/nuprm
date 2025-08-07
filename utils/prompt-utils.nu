export const nu_prompt_const = {
    exe_path: (["~" ".config" "nuprm"] | path join | path expand)
    config_path: (["~" ".config" "nuprm" "config.yml"] | path join | path expand)
    load_path: (["~" ".config" "nuprm" "load.nu"] | path join | path expand)
}

# Get user config
def get-config [
    item: string
    default: any
] {
    let user_config = open $nu_prompt_const.config_path
    if $item in $user_config {
        return ($user_config | get $item)
    } else {
        return $default
    }
}

# Replaces the home directory path in a given string with a tilde (~)
export def home-to-tilde [
    path: string  # The input path to process
] {
    if ($path == $nu.home-path) {
        return "~"
    } else if ($path | str starts-with $nu.home-path) {
        let split_slash = if (is-windows) { "\\" } else { "/" }
        return ($path | str replace $"($nu.home-path)($split_slash)" $"~($split_slash)")
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
    } catch { return "" }
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

# Checks if the current operating system is android
export def is-android [] {
    let is_android = if $nu.os-info.name == "android" { true } else { false }
    return $is_android
}

# Retrieves current username from environment variables
export def get-user-name [] {
    let username = ($env.USERNAME? | default $env.USER? | default (whoami))
    try {
        if ((get-config "use_full_name" "no") == "yes") {
            if not (is-windows) {
                if not (is-android) {
                    let full_name = open /etc/passwd
                        | lines
                        | split column ":"
                        | where column1 == $username
                        | get column5
                        | first
                        | str replace "," " " --all
                        | str trim
                    return $full_name
                }
            }
        }
    } catch { }
    return $username
}

# Formats path
export def format-path [
    path: string                    # Input path
    new_separators: string          # Custom separator
    --keep_root (-k)                # Keep root directory ( on: / > aaa > bbb | off: > aaa > bbb)
    --left_char: string (-l) = ""   # Left decorator for path
    --right_char: string (-r) = ""  # Right decorator for path
    --home_to_tilde (-h)            # Replace home directory with '~'
    --dir_style: string (-d) = ""   # Directory styling (ANSI codes)
    --sep_style: string (-s) = ""   # Separator styling (ANSI codes)
    --file_url (-u)                 # Format as clickable terminal hyperlink
] {
    let abbreviation_config = (get-config "directory_abbreviation" {})
    let abbreviation_enable = (($abbreviation_config | get "enable"? | default "no") == "yes")

    let input_path = if $home_to_tilde and $abbreviation_enable and (($abbreviation_config | get "home"? | default "no") == "yes") {
        home-to-tilde $path
    } else { $path }

    let input_separators = ($sep_style + $new_separators)

    mut path_list = ($input_path | path split)
    mut unix_root_start = false

    if not $keep_root {
        if not (is-windows) {
            if $path_list.0 == "/" {
                $unix_root_start = true
                $path_list = $path_list | skip 1
            }
        } else {
            if "\\" in $path_list.0 {
                $path_list.0 = ($path_list.0 | split row "\\" | first)
            }
        }
    }

    if $abbreviation_enable {
        let start_from_end = $abbreviation_config | get "start_from_end"? | default 3 | into int
        let display_chars = $abbreviation_config | get "display_chars"? | default 1 | into int
        let path_len = $path_list | length
        mut counter = $path_list | length

        $path_list = $path_list | enumerate | each { | item |
            if ($path_len - $item.index >= $start_from_end) {
                $item.item | str substring 0..([0, ($display_chars - 1 + (
                    if ($item.item | str starts-with ".") { 1 } else { 0 }
                ))] | math max)
            } else { $item.item }
        }
    }

    mut new_path = $path_list | each { |it| $dir_style + $it } | str join $input_separators
    if $unix_root_start {
        $new_path = $input_separators + $new_path
    }

    let new_path_str = ([$left_char, $new_path, $right_char] | str join "")
    
    if $file_url {
        return (
            [
                "\e]8;;file://", $path, "\a", $new_path_str, "\e]8;;\a"
            ] | str join ""
        )
    } else {
        return $new_path_str
    }
}

# Get system icon (Nerd Font)
export def get-system-icon [
    --left_char: string (-l) = ""   # Left decorator for system icon
    --right_char: string (-r) = ""  # Right decorator for system icon
] {
    let disable_system_icon = (get-config "disable_system_icon" "yes")

    if $disable_system_icon == no {
        let system_type = $nu.os-info.name
        let system_name = (sys host | get name | str downcase)

        let icon = match $system_type {
            "windows"   => { "" }
            "linux"     => {
                match $system_name {
                    "alma"                  => ""
                    "almalinux"             => ""
                    "almalinux9"            => ""
                    "alpine"                => ""
                    "aosc"                  => ""
                    "arch linux"            => "" # Tested
                    "centos"                => ""
                    "coreos"                => ""
                    "debian"                => ""
                    "deepin"                => "" # Tested
                    "devuan"                => ""
                    "elementary"            => ""
                    "endeavouros"           => ""
                    "fedora linux"          => ""
                    "gentoo"                => ""
                    "mageia"                => ""
                    "manjaro"               => ""
                    "mint"                  => ""
                    "nixos"                 => "" # Tested
                    "opensuse"              => ""
                    "opensuse-tumbleweed"   => ""
                    "raspbian"              => ""
                    "redhat"                => ""
                    "rocky"                 => ""
                    "sabayon"               => ""
                    "slackware"             => ""
                    "ubuntu"                => "" # Tested
                    _                       => "" # Tested
                }
            }
            "android"   => { "" }
            "macos"     => { "" }
            _           => { "" }
        }

        return (
            if $icon != "" {
                (
                    [$left_char, $icon, $right_char] | str join ""
                )
            } else { "" }
        )
    } else { "" }
}