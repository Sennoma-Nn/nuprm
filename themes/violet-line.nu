export module nuprm-theme {
    def get-prompt-chars [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias dividers-char = prompt-make-utils power-line dividers-char

        let prompt_chars = {
            bold: (ansi bo),
            italic: (ansi i),
            reset: (ansi rst),
            dimmed: (ansi d),
            power_line1: (dividers-char "right_hard_divider"),         # 
            power_line2: (dividers-char "right_hard_divider_inverse"), # 
            power_line3: (dividers-char "left_hard_divider"),          # 
            power_line4: (dividers-char "left_hard_divider_inverse"),  # 
            white_fg: (color-to-ansi 255 255 255 "fg" "37"),
            black_fg: (color-to-ansi 0 0 0 "fg" "30"),
            normal_fg: (color-to-ansi 255 255 255 "fg" "37"),
            normal_bg: (color-to-ansi 255 255 255 "bg" "47"),
            purple_fg: (color-to-ansi 191 90 218 "fg" "35"),
            purple_bg: (color-to-ansi 191 90 218 "bg" "45"),
        }
        
        let return_prompt_chars = $prompt_chars | get -o $color | default ""
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
            path: (
                surround (
                    get-prompt-info pwd $path_sep -u
                        -d $"(get-prompt-chars reset)(get-prompt-chars bold)(get-prompt-chars white_fg)(get-prompt-chars purple_bg)"
                        -s $"(get-prompt-chars reset)(get-prompt-chars dimmed)(get-prompt-chars purple_bg)"
                )
            )
            git: (surround (get-prompt-info git) -l "󰊢 ")
            exit: (get-prompt-info exit-code)
            shells: (get-prompt-info shells -d)
            time: (get-prompt-info exec-time)
        }
        return (
            [
                (get-prompt-chars white_fg)
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
                        | str replace --all "󰤃" $"(get-prompt-chars purple_fg)󰤃(get-prompt-chars reset)(get-prompt-chars white_fg)"
                        | str replace --all "" $"(get-prompt-chars purple_fg)(get-prompt-chars bold)(get-prompt-chars reset)(get-prompt-chars white_fg)"
                        | str replace --all "" $"(get-prompt-chars purple_fg)(get-prompt-chars bold)(get-prompt-chars reset)(get-prompt-chars white_fg)"
                )
                "\n",
                "│ ",
                (
                    make-block
                        --display_if ($status.shells != "")
                        -i "󰞷 "
                        -s (get-prompt-chars power_line1)
                        -e (get-prompt-chars power_line2)
                        (get-prompt-chars normal_fg)
                        (get-prompt-chars normal_bg)
                        $status.shells
                        (get-prompt-chars black_fg)
                ),
                (
                    make-block
                        -s (get-prompt-chars power_line1)
                        -e (get-prompt-chars power_line3)
                        (get-prompt-chars purple_fg)
                        (get-prompt-chars purple_bg)
                        $status.path
                        (get-prompt-chars white_fg)
                ),
                (
                    make-block
                        --display_if ($status.exit != 0)
                        -i " "
                        -s (get-prompt-chars power_line4)
                        -e (get-prompt-chars power_line3)
                        (get-prompt-chars normal_fg)
                        (get-prompt-chars normal_bg)
                        $status.exit
                        (get-prompt-chars black_fg)
                ),
                "\n",
                "╰─"
            ] | str join ""
        )
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        return $"(get-prompt-chars white_fg)󰔰 "
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-prompt-chars white_fg)  󰔰 (get-prompt-chars reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-prompt-chars white_fg)(get-prompt-chars bold): (get-prompt-chars reset)"
    }

    export def get-prompt-indicator-vi-normal [] {
        return $"(get-prompt-chars white_fg)󰔰 (get-prompt-chars reset)"
    }

    export def get-transient-prompt-command [] {
        let path = (get-prompt-info last-pwd -u)
        
        let prompt = (
            make-block
                -s (get-prompt-chars power_line1)
                -e (get-prompt-chars power_line3)
                (get-prompt-chars purple_fg)
                (get-prompt-chars purple_bg)
                $path
                (get-prompt-chars white_fg)
        ) + " "

        return $prompt
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        return " "
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-prompt-chars purple_fg)󰔰 (get-prompt-chars reset)"
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