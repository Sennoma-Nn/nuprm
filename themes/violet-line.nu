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
            normal_fg: (prompt-make-utils color-to-ansi 255 255 255 "fg" "33")
            normal_bg: (prompt-make-utils color-to-ansi 255 255 255 "bg" "43")
            path_fg: (prompt-make-utils color-to-ansi 191 90 218 "fg" "34")
            path_bg: (prompt-make-utils color-to-ansi 191 90 218 "bg" "34")
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
            user: (get-prompt-info user-name -r " ")
            host: (get-prompt-info host-name)
            path: (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"\e[0;1m(get-color white_fg)(get-color path_bg)" -s $"\e[0;2m(get-color path_bg)" -u)
            git: (get-prompt-info git)
            exit: (get-prompt-info exit-code)
            shells: (get-prompt-info shells -dl "#")
            time: (get-prompt-info exec-time | into float)
        }
        return (
            [
                (get-color white_fg)
                "╭── ",
                $status.user
                (if not ($"($status.icon)($status.host)" | is-empty) { "at \e[2m\e[22m " } else { "" }),
                    (
                        [
                            $status.icon,
                            $status.host,
                        ] | str join " " | str trim
                    )
                (if not ($"($status.icon)($status.host)" | is-empty) { " \e[2m\e[22m " } else { "" })
                $status.git,
                ...(
                    if $status.exit != "0" {
                        [
                            (if not ($"($status.git)" | is-empty) { " \e[2m\e[22m " } else { "" }),
                            $status.exit,
                            (if ($status.time > 0.5) { " \e[2m\e[22m " } else { "" })
                        ]
                    } else { [] }
                ),
                (
                    if $status.time > 0.5 {
                        $"($status.time)s"
                    }
                ),
                "\n",
                "│ ",
                (prompt-block (get-color power_line1) (get-color power_line3) (get-color path_fg) (get-color path_bg) $status.path (get-color white_fg)),
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
            (prompt-block (get-color power_line1) (get-color power_line3) (get-color path_fg) (get-color path_bg) $path (get-color white_fg))
        )
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        return " "
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-color path_fg)󰔰 (get-color reset)"
    }

    export def get-transient-prompt-indicator-vi-insert [] { }

    export def get-transient-prompt-indicator-vi-normal [] { }
}