export const nu_prompt_const = {
    exe_path: (["~" ".config" "nuprm"] | path join | path expand)
    config_path: (["~" ".config" "nuprm" "config.yml"] | path join | path expand)
    load_path: (["~" ".config" "nuprm" "load.nu"] | path join | path expand)
}

const poss_err_alrt = "ERROR (If you see it, please file an issue)"

# Get user config
def get-config [
    item: string
    default: any
]: nothing -> any {
    let user_config = open $nu_prompt_const.config_path
    return ($user_config | get $item -i | default $default)
}

# Replaces the home directory path in a given string with a tilde (~)
export def home-to-tilde []: string -> string {
    let path = $in
    let abbreviation_config = (get-config "directory_abbreviation" {})
    let abbreviation_enable = (($abbreviation_config | get "enable"? | default "no") == "yes")
    let abbreviation_home = (($abbreviation_config | get "home"? | default "no") == "yes")

    if $abbreviation_enable and $abbreviation_home {
        if ($path == $nu.home-path) {
            return "~"
        } else if ($path | str starts-with $nu.home-path) {
            let split_slash = if (is-windows) { "\\" } else { "/" }
            return ($path | str replace $"($nu.home-path)($split_slash)" $"~($split_slash)")
        } else {
            return $path
        }
    } else {
        return $path
    }
}

export def specific-abbreviations []: string -> string {
    let path = $in
    let path_list = $path | path split
    let abbr_config = (get-config "directory_abbreviation" {})
    let abbr_enable = (($abbr_config | get "enable"? | default "no") == "yes")
    let abbr_home = (($abbr_config | get "home"? | default "no") == "yes")
    let specific_abbr = ($abbr_config | get "specific"? | default {})
    let specific_abbr_record = ($specific_abbr | transpose key value | update key { |r| $r.key | path expand } | transpose -rd)
    let specific_abbr_key = $specific_abbr_record | columns
    
    if not $abbr_enable {
        return $path
    }
        
    if ($specific_abbr | is-empty) and not $abbr_home {
        return $path
    }

    mut new_path_list = []
    for i in ($path_list | length)..1 {
        let test_path = $path_list | take $i | path join
        if $test_path == $nu.home-path {
            if $abbr_home {
                $new_path_list ++= ["~"]
                break
            }
        }
        if $test_path in $specific_abbr_key {
            let abbr = $specific_abbr_record | get -i $test_path | default $poss_err_alrt
            $new_path_list ++= [$abbr]
            break
        } else {
            $new_path_list ++= [($path_list | get -i ($i - 1) | default $poss_err_alrt)]
        }
    }
    let new_path = $new_path_list | reverse | path join
    return $new_path
}

# Retrieves current git branch information with optional formatting
export def get-git-info [
    --left_char: string (-l) = ""   # Left decorator for branch name
    --right_char: string (-r) = ""  # Right decorator for branch name
]: nothing -> string {
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
]: nothing -> string {
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
]: nothing -> string {
    let ansi_str = match $color_type {
        "fg" => { $"\e[38;2;($r);($g);($b)m" }
        "bg" => { $"\e[48;2;($r);($g);($b)m" }
        _    => { "" }
    }
    return $"($ansi_str)"
}

# Checks if the current operating system is Windows
export def is-windows []: nothing -> bool {
    let is_windows = if $nu.os-info.name == "windows" { true } else { false }
    return $is_windows
}

# Checks if the current operating system is android
export def is-android []: nothing -> bool {
    let is_android = if $nu.os-info.name == "android" { true } else { false }
    return $is_android
}

# Retrieves current username from environment variables
export def get-user-name []: nothing -> string {
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
    new_separators: string          # Custom separator
    --keep_root (-k)                # Keep root directory ( on: / > aaa > bbb | off: > aaa > bbb)
    --left_char: string (-l) = ""   # Left decorator for path
    --right_char: string (-r) = ""  # Right decorator for path
    --dir_style: string (-d) = ""   # Directory styling (ANSI codes)
    --sep_style: string (-s) = ""   # Separator styling (ANSI codes)
    --file_url (-u)                 # Format as clickable terminal hyperlink
]: string -> string {
    let path = $in
    let abbreviation_config = (get-config "directory_abbreviation" {})
    let abbreviation_enable = (($abbreviation_config | get "enable"? | default "no") == "yes")
    let input_path = ($path | specific-abbreviations)
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
            if ($path_len - $item.index >= $start_from_end) and ($start_from_end > 0) {
                $item.item | str substring --grapheme-clusters 0..([0, ($display_chars - 1 + (
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
        return ($new_path_str | make-file-url $path)
    } else {
        return $new_path_str
    }
}

# Get last directory of path
export def get-path-last [
    --file_url (-u)                # Format as clickable terminal hyperlink
    --left_char: string (-l) = ""  # Left decorator for path
    --right_char: string (-r) = "" # Right decorator for path
]: string -> string {
    let path = $in
    let last_path = ($path | specific-abbreviations | path split | last)
    let last_path_str = ([$left_char, $last_path, $right_char] | str join "")

    if $file_url {
        return ($last_path_str | make-file-url $path)
    }

    return $last_path_str
}

# Make hyperlink for path
export def make-file-url [
    file_path: string # Actual path for the link
]: string -> string {
    let display_path = $in
    return (
        [
            "\e]8;;file://", $file_path, "\a", $display_path, "\e]8;;\a"
        ] | str join ""
    )
}

# Get execution time (ms)
export def get-execution-time-ms []: nothing -> number {
    if $env.CMD_DURATION_MS != "0823" {
        return $env.CMD_DURATION_MS | into int
    } else { return 0 }
}

# Get execution time (s)
export def get-execution-time-s []: nothing -> number {
    let time_ms = (get-execution-time-ms) | into int
    let time_s = $time_ms / 1000 | math round --precision 2

    return $time_s
}

# Get system icon (Nerd Font)
export def get-system-icon [
    --left_char: string (-l) = ""   # Left decorator for system icon
    --right_char: string (-r) = ""  # Right decorator for system icon
]: nothing -> string {
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
