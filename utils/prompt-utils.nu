# Get user config
def get-config [
    item: cell-path
    default: any
]: nothing -> any {
    let user_config = $env.NUPRMCONFIG
    return ($user_config | get $item -o | default $default)
}

def specific-abbreviations []: string -> string {
    let path = $in
    let path_list = $path | path split
    let abbr_config = get-config $.directory_abbreviation {}
    let abbr_enable = $abbr_config | get -o "enabled" | default "no" | $in == "yes"
    let abbr_home = $abbr_config | get -o "abbreviate_home" | default "no" | $in == "yes"
    let specific_abbr = $abbr_config | get -o "specific_mappings" | default {}
    let specific_abbr_record = $specific_abbr | transpose key value | update key {|r| $r.key | path expand } | transpose -rd
    let specific_abbr_key = $specific_abbr_record | columns
    let home_dir = $nu.home-path? | default $nu.home-dir? | default ("~" | path expand)
    
    if not $abbr_enable {
        return $path
    }
        
    if ($specific_abbr | is-empty) and not $abbr_home {
        return $path
    }

    mut new_path_list = []
    for i in ($path_list | length)..1 {
        let test_path = $path_list | take $i | path join
        if $test_path == $home_dir {
            if $abbr_home {
                $new_path_list ++= ["~"]
                break
            }
        }
        if $test_path in $specific_abbr_key {
            let abbr = $specific_abbr_record | get -o $test_path | default ""
            $new_path_list ++= [$abbr]
            break
        } else {
            $new_path_list ++= [($path_list | get -o ($i - 1) | default "")]
        }
    }
    let new_path = $new_path_list | reverse | path join
    return $new_path
}

# Retrieves current git branch information with optional formatting
def get-git-info []: nothing -> string {
    let is_show_git = get-config $.display_elements.git {} | $in == "yes"

    if not $is_show_git {
        return ""
    }

    try {
        let branch = do -i { ^git symbolic-ref --short HEAD | complete | get -o "stdout" | str trim }
        return $branch
    } catch {
        return ""
    }
}

# Gets current shells index from directory stack with display options
def get-where-shells [
    --dont_display_shells_if_not_used_shells (-d)  # Suppress output when only 1 shell exists
]: nothing -> string {
    let is_show_shells = get-config $.display_elements.shells {} | $in == "yes"

    if not $is_show_shells { return "" }

    try {
        if (((which "dirs") ++ (which "shells")) | length) > 0 {
            let shells_data = if (which "dirs" | length) > 0 { dirs } else { shells }
            if $dont_display_shells_if_not_used_shells and ($shells_data | length) == 1 {
                return ""
            } else {
                let shells_index = $shells_data
                    | enumerate
                    | where $it.item.active == true
                    | get -o 0.index
                    | default ""

                return $shells_index
            }
        } else {
            return ""
        }
    } catch { return "" }
}

# Converts RGB values to ANSI escape sequences for terminal colors
def color2ansi [
    r: int              # Red component (0-255)
    g: int              # Green component (0-255)
    b: int              # Blue component (0-255)
    color_type: string  # Color type: "fg" (foreground) or "bg" (background)
    ansi_color: string  # If not enabled true_color use this (ansi m's arg (\e[?m))
]: nothing -> string {
    let is_true_color = get-config $.compatibility.true_color {} | default "yes" | $in == "yes"
    if $is_true_color {
        let ansi_str = match $color_type {
            "fg" => { $"\e[38;2;($r);($g);($b)m" }
            "bg" => { $"\e[48;2;($r);($g);($b)m" }
            _    => { "" }
        }
        return $"($ansi_str)"
    } else {
        let ansi_str = ansi -e $"($ansi_color)m"
        return $ansi_str
    }
}

# Checks system
def is-os [
    system: string
]: nothing -> bool {
    let test = $nu.os-info.name == $system
    return $test
}

# Get user name
def get-user-name []: nothing -> string {
    if (get-config $.use_full_name "no" | $in == "yes") {
        return ($env | get "FULLNAME" -o | default "")
    } else {
        let username = get-username
        return $username
    }
}

# Retrieves current username from environment variables
def get-username []: nothing -> string {
    let username = $env.USERNAME?
        | default $env.USER?
        | default (whoami)
    return $username
}

# Get full name
def get-full-name []: nothing -> string {
    let username = get-username

    mut full_name = ""

    try {
        if (is-os "android") {
            # Not supported
            $full_name = $username
        } else if (is-os "macos") {
            $full_name = ^id -F
        } else if (is-os "windows") {
            $full_name = ^powershell -c "(Get-LocalUser -Name $env:USERNAME).FullName"
        } else if (is-os "freebsd") {
            $full_name = ^id -P
                | split column ":"
                | get "column8"
                | first
                | str replace "," " " --all
                | str trim
        } else {
            $full_name = open "/etc/passwd"
                | lines
                | split column ":"
                | where "column1" == $username
                | get "column5"
                | first
                | str replace "," " " --all
                | str trim
        }
    } catch {
        return $username
    }

    if not ($full_name | is-empty) {
        return $full_name
    } else {
        return $username
    }
}

# Get host name
def get-host []: nothing -> string {
    let is_show_host = get-config $.display_elements.hostname {} | $in == "yes"
    if $is_show_host {
        let host_name = sys host | get hostname
        return $host_name
    } else { return "" }
}

# Formats path
def format-path [
    new_separators: string          # Custom separator
    --keep_root (-k)                # Keep root directory ( on: / > aaa > bbb | off: > aaa > bbb)
    --dir_style: string (-d) = ""   # Directory styling (ANSI codes)
    --sep_style: string (-s) = ""   # Separator styling (ANSI codes)
    --file_url (-u)                 # Format as clickable terminal hyperlink
]: string -> string {
    let path = $in
    let input_path = $path | specific-abbreviations
    let input_separators = $sep_style + $new_separators

    mut path_list = $input_path | path split
    mut unix_root_start = false

    if not $keep_root {
        match (get-path-mode) {
            "UNIX" => {
                if $path_list.0 == "/" {
                    $unix_root_start = true
                    $path_list = $path_list | skip 1
                }
            }
            "DOS" => {
                if "\\" in $path_list.0 {
                    $path_list.0 = $path_list.0 | split row "\\" | first
                }
            }
        }
    }

    mut new_path = $path_list | abbr_path | each {|it| $dir_style + $it } | str join $input_separators
    if $unix_root_start {
        $new_path = $input_separators + $new_path
    }

    let new_path_str = $new_path
    
    if $file_url {
        return ($new_path_str | make-file-url $path)
    } else {
        return $new_path_str
    }
}

# Abbreviate the path list
def abbr_path []: list -> list {
    let path_list = $in
    let abbreviation_config = get-config $.directory_abbreviation {}
    let abbreviation_enable = $abbreviation_config | get -o "enabled" | default "no" | $in == "yes"

    let abbreviated_path_list = if $abbreviation_enable {
        let start_from_end = $abbreviation_config | get -o "start_from_end" | default 3 | into int
        let display_chars = $abbreviation_config | get -o "display_chars" | default 1 | into int
        let path_len = $path_list | length

        let get_each_of_abbr_display_chars = {|item|
            let substring_offset = if ($item.item | str starts-with ".") { 1 } else { 0 }
            let substring_range = $display_chars + $substring_offset - 1 | [0, $in] | math max | 0..$in

            if ($path_len - $item.index >= $start_from_end) and ($start_from_end > 0) {
                $item.item | str substring -g $substring_range
            } else { $item.item }
        }

        $path_list | enumerate | each $get_each_of_abbr_display_chars
    } else {
        $path_list
    }

    return $abbreviated_path_list
}

# Get last directory of path
def get-path-last [
    --file_url (-u)                # Format as clickable terminal hyperlink
]: string -> string {
    let path = $in
    let last_path = $path | specific-abbreviations | path split | last

    if $file_url {
        return ($last_path | make-file-url $path)
    }

    return $last_path
}

# Make hyperlink for path
def make-file-url [
    file_path: string # Actual path for the link
]: string -> string {
    let display_path = $in
    let enable_path_url = get-config $.compatibility.enable_path_url {} | default "yes" | $in == "yes"

    if not $enable_path_url {
        return $display_path
    }

    return (
        [
            "\e]8;;file://", $file_path, "\a", $display_path, "\e]8;;\a"
        ] | str join ""
    )
}

# Get execution time (ms)
def get-execution-time-ms []: nothing -> number {
    let is_show_execution_time = get-config $.display_elements.execution_time {} | $in == "yes"
    let time = $env.CMD_DURATION_MS? | default 0

    if not $is_show_execution_time {
        return (-1)
    }

    if $time != "0823" {
        return ($time | into int)
    } else { return 0 }
}

# Get execution time (s)
def get-execution-time-s []: nothing -> number {
    let time_s = get-execution-time-ms
        | $in / 1000
        | math round --precision 2

    return $time_s
}

# Get exit code
def get-exit-code []: nothing -> number {
    let is_show_exit = get-config $.display_elements.exit {} | $in == "yes"
    if not $is_show_exit { return 0 }

    return $env.LAST_EXIT_CODE
}

# Get system icon (Nerd Font)
def get-system-icon []: nothing -> string {
    let system_icon = get-config $.display_elements.system_icon {} | $in == "yes"

    if $system_icon {
        let system_type = $nu.os-info.name
        let system_name = sys host | get name | str downcase

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
                    "opensuse tumbleweed"   => "" # Tested
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
            "freebsd"   => { "" }
            _           => { "" }
        }

        return $icon
    } else { "" }
}

# Get path mode, DOS (?:\???\???\???), UNIX (/???/???/???)
def get-path-mode []: nothing -> string {
    if (is-os "windows") {
        return "DOS"
    } else {
        return "UNIX"
    }
}

# Get characters from Power Line
def get-power-line-char [
    name: string # Char name
]: nothing -> string {
    let char = match $name {
        "left_hard_divider"                 => { char -u "e0b0" } # 
        "left_soft_divider"                 => { char -u "e0b1" } # 
        "right_hard_divider"                => { char -u "e0b2" } # 
        "right_soft_divider"                => { char -u "e0b3" } # 
        "right_half_circle_thick"           => { char -u "e0b4" } # 
        "right_half_circle_thin"            => { char -u "e0b5" } # 
        "left_half_circle_thick"            => { char -u "e0b6" } # 
        "left_half_circle_thin"             => { char -u "e0b7" } # 
        "lower_left_triangle"               => { char -u "e0b8" } # 
        "backslash_separator"               => { char -u "e0b9" } # 
        "lower_right_triangle"              => { char -u "e0ba" } # 
        "forwardslash_separator"            => { char -u "e0bb" } # 
        "upper_left_triangle"               => { char -u "e0bc" } # 
        "forwardslash_separator_redundant"  => { char -u "e0bd" } # 
        "upper_right_triangle"              => { char -u "e0be" } # 
        "backslash_separator_redundant"     => { char -u "e0bf" } # 
        "flame_thick"                       => { char -u "e0c0" } # 
        "flame_thin"                        => { char -u "e0c1" } # 
        "flame_thick_mirrored"              => { char -u "e0c2" } # 
        "flame_thin_mirrored"               => { char -u "e0c3" } # 
        "pixelated_squares_small"           => { char -u "e0c4" } # 
        "pixelated_squares_small_mirrored"  => { char -u "e0c5" } # 
        "pixelated_squares_big"             => { char -u "e0c6" } # 
        "pixelated_squares_big_mirrored"    => { char -u "e0c7" } # 
        "ice_waveform"                      => { char -u "e0c8" } # 
        "ice_waveform_mirrored"             => { char -u "e0ca" } # 
        "honeycomb"                         => { char -u "e0cc" } # 
        "honeycomb_outline"                 => { char -u "e0cd" } # 
        "lego_block_sideways"               => { char -u "e0d1" } # 
        "trapezoid_top_bottom"              => { char -u "e0d2" } # 
        "trapezoid_top_bottom_mirrored"     => { char -u "e0d4" } # 
        "right_hard_divider_inverse"        => { char -u "e0d6" } # 
        "left_hard_divider_inverse"         => { char -u "e0d7" } # 
        _                                   => { "" }
    }

    return $char
}

############################################################################### export functions

# Get prompt information
export module get-prompt-info {
    # Get git branch information for prompt
    export def git [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-git-info

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get shells index information for prompt
    export def shells [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
        --dont_display_shells_if_not_used_shells (-d)  # Suppress output when only 1 shell exists in `shells` info
    ]: nothing -> string {
        let info = get-where-shells --dont_display_shells_if_not_used_shells=$dont_display_shells_if_not_used_shells

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get user name information for prompt
    export def user-name [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-user-name

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get host name information for prompt
    export def host-name [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-host

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get full name information for prompt
    export def full-name [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-full-name

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get formatted path information for prompt
    export def path [
        new_separators: string                         # Custom separator
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
        --keep_root (-k)                               # Keep root directory ( on: / > aaa > bbb | off: > aaa > bbb) in `path` info
        --dir_style: string (-d) = ""                  # Directory styling (ANSI codes) in `path` info
        --sep_style: string (-s) = ""                  # Separator styling (ANSI codes) in `path` info
        --file_url (-u)                                # Format as clickable terminal hyperlink in `path` or `last-path` info
    ]: nothing -> string {
        let info = $env.PWD | format-path $new_separators --keep_root=$keep_root --dir_style=$dir_style --sep_style=$sep_style --file_url=$file_url

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get last directory of path information for prompt
    export def last-path [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
        --file_url (-u)                                # Format as clickable terminal hyperlink in `path` or `last-path` info
    ]: nothing -> string {
        let info = $env.PWD | get-path-last --file_url=$file_url

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get execution time information for prompt
    export def exec-time [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-execution-time-s

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get exit code information for prompt
    export def exit-code [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-exit-code

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get system icon information for prompt
    export def system-icon [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-system-icon

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }

    # Get path mode information for prompt
    export def path-mode [
        --left_char: string (-l) = ""                  # Left decorator for info
        --right_char: string (-r) = ""                 # Right decorator for info
    ]: nothing -> string {
        let info = get-path-mode

        if $info == "" { return "" }
        let out = [ $left_char, $info, $right_char ] | str join ""
        return $out
    }
}

# Prompt make utils
export module prompt-make-utils {
    # Convert RGB values to ANSI escape sequences for terminal colors
    export def color-to-ansi [
        r: int              # Red component (0-255)
        g: int              # Green component (0-255)
        b: int              # Blue component (0-255)
        color_type: string  # Color type: "fg" (foreground) or "bg" (background)
        ansi_color: string  # If not enabled true_color use this (ansi m's arg (\e[?m))
    ]: nothing -> string {
        color2ansi $r $g $b $color_type $ansi_color
    }

    # Get Power Line characters for prompt styling
    export def power-line-char [
        name: string # Char name
    ]: nothing -> string {
        get-power-line-char $name
    }
}