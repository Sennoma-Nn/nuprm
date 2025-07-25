let colors = {
    black_fg:       "\e[30m",
    black_bg:       "\e[40m",
    light_black_fg: "\e[90m",
    white_fg:       "\e[37m",
    red_fg:         "\e[31m",
    color1_fg:      (color2ansi 253 172  65 "fg"),
    color1_bg:      (color2ansi 253 172  65 "bg"),
    color2_fg:      (color2ansi 245 114  46 "fg"),
    color2_bg:      (color2ansi 245 114  46 "bg"),
    color3_fg:      (color2ansi 135 188 215 "fg"),
    color3_bg:      (color2ansi 135 188 215 "bg"),
    color4_fg:      (color2ansi  51 102 137 "fg"),
    color4_bg:      (color2ansi  51 102 137 "bg"),
    color5_fg:      (color2ansi  35  70  94 "fg"),
    color5_bg:      (color2ansi  35  70  94 "bg"),
    reset_bg:       "\e[49m",
    bold:           "\e[1m"
    italic:         "\e[3m",
    reset:          "\e[0m",
}


def create-prompt-left [] {
    let path = (home-to-tilde $env.PWD)
    let user = (get-user-name)

    let prompt_list = [
        $colors.color1_fg, "", $colors.reset,
        $colors.color1_bg, $colors.black_fg, " ", $colors.italic, $user, " ", $colors.reset,
        $colors.color2_bg, $colors.color1_fg, "",
        $colors.color2_bg, $colors.black_fg, " ", $path, " ", $colors.reset,
        $colors.color2_fg, "",
        $colors.reset, "\n"
    ]
    let prompt = ($prompt_list | str join "")
    return $prompt
}

def create-prompt-right [] {
    let git_info = (get-git-info -l "  " -r " ") | if $in != "" { $"($in)" }
    let root_symbol = if (is-admin) { "  " } else { "" }
    let status_symbol = (
        if $env.LAST_EXIT_CODE != 0 {
            [$colors.color5_fg, " ", $env.LAST_EXIT_CODE] | str join ""
        } else {
            [$colors.color5_fg, ""] | str join ""
        }
    )

    let prompt_list = [
        $colors.color3_fg, "", $colors.reset, $colors.color3_bg, " ", $status_symbol, " ", $colors.reset, $colors.color3_fg, $colors.color3_bg,
        $colors.color4_fg, "", $colors.reset, $colors.color4_bg, $colors.white_fg, $git_info, $colors.reset, $colors.color4_fg, $colors.color4_bg,
        $colors.color5_fg, "", $colors.color5_bg, $colors.white_fg, $root_symbol, $colors.reset, $colors.color5_fg, $colors.color5_bg,
        $colors.reset_bg, "", $colors.reset
    ]

    let prompt = ($prompt_list | str join "")
    return $prompt
}

$env.PROMPT_COMMAND = {|| create-prompt-left }
$env.PROMPT_COMMAND_RIGHT = {|| create-prompt-right}
$env.PROMPT_INDICATOR = $"($colors.color2_fg)❯ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $env.PROMPT_INDICATOR
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.color2_fg)($colors.bold): ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
