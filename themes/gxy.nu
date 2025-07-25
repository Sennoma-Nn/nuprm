let black_fg = "\e[30m"
let black_bg = "\e[40m"
let blue_fg = "\e[38;2;129;169;254m"
let blue_bg = "\e[48;2;129;169;254m"
let dark_blue_fg = "\e[38;2;59;66;97m"
let dark_blue_bg = "\e[48;2;59;66;97m"
let pink_fg = "\e[38;2;197;134;192m"
let bold = "\e[1m"
let reset = "\e[0m"

let user = (get-user-name)

def format-path [path: string] {
    if $path == "/" {
        "/"
    } else {
        let home = if (is-windows) { $env.HOMEPATH } else { $env.HOME }
        let relative_path = (home-to-tilde $path)
        let path_parts = ($relative_path | split row (if (is-windows) { "\\" } else { "/" }))
        let path_parts_count = ($path_parts | length)

        if $path_parts_count < 2 {
            $relative_path
        } else {
            let abbreviated_parts = ($path_parts | each {|part| 
                if $part in ($path_parts | skip ($path_parts_count - 2)) {
                    $part
                } else {
                    ($part | str substring 0..0)
                }
            })

            let formatted_path = ($abbreviated_parts | str join ($" ($black_fg)" + "" + $"($blue_fg) "))

            if ($relative_path | str starts-with "/") {
                "/" + $formatted_path
            } else {
                $formatted_path
            }
        }
    }
}

def create-prompt [] {
    let path = (format-path (pwd))
    let git_info = (get-git-info)
    let shells_info = (get-where-shells -dl $" ($dark_blue_bg + $blue_fg) №")

    mut prompt = $"($reset)┌ "
    $prompt += $"($blue_fg)($reset)"
    $prompt += $"($blue_bg)($black_fg) (get-system-icon -r ' ▕ ')($user)($shells_info) ($reset)"
    $prompt += $"(if $shells_info != "" { $dark_blue_fg } else { $blue_fg })($reset)"
    $prompt += $"($dark_blue_fg)"
    $prompt += $"($dark_blue_bg)($blue_fg) ($path) ($reset)"
    $prompt += $"($dark_blue_fg)($reset)"

    if $git_info != "" {
        $prompt += $" ($pink_fg) ($git_info)($reset)"
        if $env.LAST_EXIT_CODE == 0 {
            $prompt += " "
        }
    }

    if $env.LAST_EXIT_CODE != 0 {
        $prompt += $"($bold + $dark_blue_fg) ($env.LAST_EXIT_CODE) ($reset)"
    }

    $prompt += $"($blue_fg)($reset)"

    $prompt += "\n└ "
    return $prompt
}

def transient-create-left-prompt [] {
    let path = (format-path (pwd))

    mut prompt = ""
    $prompt += $"($dark_blue_bg + $blue_fg) ($path) ($reset)"
    $prompt += $"($dark_blue_fg)($reset)"

    $prompt += $"($blue_fg)($reset)"
    return $prompt
}

$env.PROMPT_COMMAND = { create-prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = $reset + "> "
$env.PROMPT_MULTILINE_INDICATOR = "┆ - "
$env.PROMPT_INDICATOR_VI_INSERT = $reset + ": "
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {|| transient-create-left-prompt}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = " "
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = " "
