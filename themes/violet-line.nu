export module nuprm-theme {
    def get-color [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias dividers-char = prompt-make-utils power-line dividers-char

        let colors = {
            bold: "\e[1m",
            italic: "\e[3m"
            reset: "\e[0m"
            power_line1: (dividers-char "right_hard_divider") # 
            power_line2: (dividers-char "right_hard_divider_inverse") # 
            power_line3: (dividers-char "left_hard_divider") # 
            power_line4: (dividers-char "left_hard_divider_inverse") # 
            white_fg: (color-to-ansi 255 255 255 "fg" "37")
            black_fg: (color-to-ansi 0 0 0 "fg" "30")
            normal_fg: (color-to-ansi 255 255 255 "fg" "37")
            normal_bg: (color-to-ansi 255 255 255 "bg" "47")
            purple_fg: (color-to-ansi 191 90 218 "fg" "35")
            purple_bg: (color-to-ansi 191 90 218 "bg" "45")
        }
        
        let return_prompt_chars = $colors | get -o $color | default ""
        return $return_prompt_chars
    }

    alias make-block = prompt-make-utils power-line make-block

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let status = {
            icon: (get-prompt-info system-icon)
            user: (get-prompt-info user-name)
            host: (get-prompt-info host-name)
            path: (surround (get-prompt-info pwd $path_sep -d $"\e[0;1m(get-color white_fg)(get-color purple_bg)" -s $"\e[0;2m(get-color purple_bg)" -u))
            git: (surround (get-prompt-info git) -l "󰊢 ")
            exit: (get-prompt-info exit-code)
            shells: (get-prompt-info shells -d)
            time: (get-prompt-info exec-time)
        }
        return (
            [
                (get-color white_fg)
                "╭── ",
                (
                    [
                        (
                            [
                                $status.user,
                                (if not ($"($status.icon)($status.host)" | is-empty) { "at " } else { "" }),
                                (
                                    [
                                        $status.icon,
                                        $status.host,
                                    ] | where $it != "" | str join " "
                                ),
                                (if not ($"($status.icon)($status.host)" | is-empty) { "" } else { "" })
                            ] | where $it != "" | str join " "
                        ),
                        (
                            if ($"($status.icon)($status.host)" | is-empty) { "󰤃" } else { "" }
                        )
                        (
                            [
                                $status.git,
                                (
                                    if $status.time > 0.5 {
                                        $"󰔛 ($status.time)s"
                                    } else { "" }
                                ),
                            ] | where $it != "" | str join " 󰤃 "
                        ),
                    ]
                        | where $it != ""
                        | str join " "
                        | str trim -c "󰤃"
                        | str replace --all "󰤃" $"(get-color purple_fg)󰤃(get-color reset)(get-color white_fg)"
                        | str replace --all "" $"(get-color purple_fg)(get-color bold)(get-color reset)(get-color white_fg)"
                        | str replace --all "" $"(get-color purple_fg)(get-color bold)(get-color reset)(get-color white_fg)"
                )
                "\n",
                "│ ",
                (
                    make-block
                        --display_if ($status.shells != "")
                        -i "󰞷 "
                        -s (get-color power_line1)
                        -e (get-color power_line2)
                        (get-color normal_fg)
                        (get-color normal_bg)
                        $status.shells
                        (get-color black_fg)
                ),
                (
                    make-block
                        -s (get-color power_line1)
                        -e (get-color power_line3)
                        (get-color purple_fg)
                        (get-color purple_bg)
                        $status.path
                        (get-color white_fg)
                ),
                (
                    make-block
                        --display_if ($status.exit != 0)
                        -i " "
                        -s (get-color power_line4)
                        -e (get-color power_line3)
                        (get-color normal_fg)
                        (get-color normal_bg)
                        $status.exit
                        (get-color black_fg)
                ),
                "\n",
                "╰─"
            ] | str join ""
        )
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        return $"(get-color white_fg)󰔰 "
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color white_fg)  󰔰 (get-color reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-color white_fg)(get-color bold): (get-color reset)"
    }

    export def get-prompt-indicator-vi-normal [] {
        return $"(get-color white_fg)󰔰 (get-color reset)"
    }

    export def get-transient-prompt-command [] {
        let path = (get-prompt-info last-pwd -u)
        
        let prompt = (
            make-block
                -s (get-color power_line1)
                -e (get-color power_line3)
                (get-color purple_fg)
                (get-color purple_bg)
                $path
                (get-color white_fg)
        ) + " "

        return $prompt
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        return " "
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-color purple_fg)󰔰 (get-color reset)"
    }

    export def get-transient-prompt-indicator-vi-insert [] { }

    export def get-transient-prompt-indicator-vi-normal [] { }

    export def get-info [] {
        return {
            by: "Sennoma-Nn",
            tags: [
                "Power Line",
                "Multiple Lines"
            ]
        }
    }
}