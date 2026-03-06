export module nuprm-theme {
    def get-color [color] {
        let colors = {
            bold: "\e[1m",
            italic: "\e[3m"
            reset: "\e[0m"
            power_line1: (prompt-make-utils power-line-char "right_hard_divider") # 
            power_line2: (prompt-make-utils power-line-char "right_hard_divider_inverse") # 
            power_line3: (prompt-make-utils power-line-char "left_hard_divider") # 
            power_line4: (prompt-make-utils power-line-char "left_hard_divider_inverse") # 
            white_fg: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37")
            black_fg: (prompt-make-utils color-to-ansi 0 0 0 "fg" "30")
            normal_fg: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37")
            normal_bg: (prompt-make-utils color-to-ansi 255 255 255 "bg" "47")
            purple_fg: (prompt-make-utils color-to-ansi 191 90 218 "fg" "35")
            purple_bg: (prompt-make-utils color-to-ansi 191 90 218 "bg" "45")
        }
        
        let return_prompt_chars = $colors | get -o $color | default ""
        return $return_prompt_chars
    }

    def prompt-block [
        start_char: string
        end_char: string
        block_fg: string
        block_bg: string
        block_text: string
        text_fg: string
        icon?: string
        --display_if (-d) = true
    ] {
        let block = if $display_if {
            [
                (get-color reset)
                $block_fg
                $start_char
                (get-color reset)
                $block_bg
                $text_fg
                $" ($icon)($block_text) "
                (get-color reset)
                $block_fg
                $end_char
                (get-color reset)
            ] | str join ""
        } else { "" }

        return $block
    }

    export def get-prompt-command-left [] {
        let status = {
            icon: (get-prompt-info system-icon)
            user: (get-prompt-info user-name)
            host: (get-prompt-info host-name)
            path: (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"\e[0;1m(get-color white_fg)(get-color purple_bg)" -s $"\e[0;2m(get-color purple_bg)" -u)
            git: (get-prompt-info git -l "󰊢 ")
            exit: (get-prompt-info exit-code)
            shells: (get-prompt-info shells -d)
            time: (get-prompt-info exec-time | into float)
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
                                    if $status.exit != "0" {
                                        $" ($status.exit)"
                                    } else { "" }
                                ),
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
                (prompt-block --display_if=($status.shells != "") (get-color power_line1) (get-color power_line2) (get-color normal_fg) (get-color normal_bg) $status.shells (get-color black_fg) "󰞷 "),
                (prompt-block (get-color power_line1) (get-color power_line3) (get-color purple_fg) (get-color purple_bg) $status.path (get-color white_fg)),
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
        let path = (get-prompt-info last-path -u)
        
        return (
            (prompt-block (get-color power_line1) (get-color power_line3) (get-color purple_fg) (get-color purple_bg) $path (get-color white_fg))
        )
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
}