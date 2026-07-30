export module nuprm-theme {
    alias make-block = prompt-make-utils power-line make-block
    alias icon-with-space = prompt-make-utils power-line icon-with-space

    def get-prompt-chars [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias dividers-char = prompt-make-utils power-line dividers-char

        let prompt_chars = {
            reset: (ansi reset)

            white_fg: (color-to-ansi 255 255 255 "fg" "37")
            black_fg: (color-to-ansi 0 0 0 "fg" "30")
            grey_fg: (color-to-ansi  64 64 64 "fg" "90"),

            purple1_fg: (color-to-ansi 170 100 220 "fg" "94")
            purple1_bg: (color-to-ansi 170 100 220 "bg" "104")
            purple2_fg: (color-to-ansi 120 100 220 "fg" "34")
            purple2_bg: (color-to-ansi 120 100 220 "bg" "44")

            pink1_fg: (color-to-ansi 255 130 190 "fg" "95")
            pink1_bg: (color-to-ansi 255 130 190 "bg" "105")
            pink2_fg: (color-to-ansi 255 90 190 "fg" "35")
            pink2_bg: (color-to-ansi 255 90 190 "bg" "45")

            orange_fg: (color-to-ansi 255 160 100 "fg" "33")
            orange_bg: (color-to-ansi 255 160 100 "bg" "43")

            yellow_fg: (color-to-ansi 255 220 100 "fg" "93")
            yellow_bg: (color-to-ansi 255 220 100 "bg" "103")

            green_fg: (color-to-ansi 190 255 60 "fg" "92")
            green_bg: (color-to-ansi 190 255 60 "bg" "102")

            left_half_circle: (dividers-char "left_half_circle_thick")   # 
            right_half_circle: (dividers-char "right_half_circle_thick") # 
            upper_left_triangle: (dividers-char "upper_left_triangle")   # 
        }
        
        let return_prompt_chars = $prompt_chars | get -o $color | default ""
        return $return_prompt_chars
    }

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let status = {
            icon: (get-prompt-info system-icon)
            user: (get-prompt-info user-name)
            host: (get-prompt-info host-name)
            path: (get-prompt-info pwd $path_sep -u -d (get-prompt-chars black_fg) -s (get-prompt-chars grey_fg))
            git: (get-prompt-info git)
        }

        let user_and_host_prompt = [
            (
                make-block
                    -Ii (icon-with-space "")
                    -s (get-prompt-chars left_half_circle)
                    -e (get-prompt-chars upper_left_triangle)
                    -E (get-prompt-chars purple2_bg)
                    (get-prompt-chars purple1_fg)
                    (get-prompt-chars purple1_bg)
                    $status.user
                    (get-prompt-chars black_fg)
            ),
            (
                make-block
                    --display_if ($"($status.icon)($status.host)" != "")
                    --force_display_dividers
                    -Ii ($status.icon | if $in != "" { $in } else { icon-with-space "󰍹" })
                    -e (get-prompt-chars right_half_circle)
                    (get-prompt-chars purple2_fg)
                    (get-prompt-chars purple2_bg)
                    $status.host
                    (get-prompt-chars black_fg)
            )
        ] | str join

        let shells_and_path = [
            (
                make-block
                    -Ii (icon-with-space "")
                    -s (get-prompt-chars left_half_circle)
                    -e (get-prompt-chars upper_left_triangle)
                    -E (get-prompt-chars pink2_bg)
                    (get-prompt-chars pink1_fg)
                    (get-prompt-chars pink1_bg)
                    $status.path
                    (get-prompt-chars black_fg)
            ),
            (
                make-block
                    --display_if ($status.git != "")
                    --force_display_dividers
                    -Ii (icon-with-space "" 0)
                    -e (get-prompt-chars right_half_circle)
                    (get-prompt-chars pink2_fg)
                    (get-prompt-chars pink2_bg)
                    $status.git
                    (get-prompt-chars black_fg)
            )
        ] | str join

        let prompt = [
            $user_and_host_prompt
            $shells_and_path
        ] | str join " " | $in + "\n\r"

        return $prompt
    }

    export def get-prompt-command-right [] {
        let status = {
            exit: (get-prompt-info exit-code)
            shells: (get-prompt-info shells -d)
            time: (get-prompt-info exec-time)
        }

        let shells = (
            make-block
                --display_if ($status.shells != "")
                -Ii (icon-with-space "󰙁")
                -s (get-prompt-chars left_half_circle)
                -e (get-prompt-chars right_half_circle)
                (get-prompt-chars green_fg)
                (get-prompt-chars green_bg)
                $"#($status.shells)"
                (get-prompt-chars black_fg)
        )

        let exec_time = (
            make-block
                --display_if ($status.time > 0.5)
                -Ii (icon-with-space "󱎫")
                -s (get-prompt-chars left_half_circle)
                -e (get-prompt-chars right_half_circle)
                (get-prompt-chars yellow_fg)
                (get-prompt-chars yellow_bg)
                $"($status.time)s"
                (get-prompt-chars black_fg)
        )

        let exit_code = (
            make-block
                --display_if ($status.exit != 0)
                -Ii (icon-with-space "")
                -s (get-prompt-chars left_half_circle)
                -e (get-prompt-chars right_half_circle)
                (get-prompt-chars orange_fg)
                (get-prompt-chars orange_bg)
                $status.exit
                (get-prompt-chars black_fg)
        )

        let prompt = [
            $shells
            $exec_time
            $exit_code
        ] | str join " "

        return $prompt
    }

    export def get-prompt-indicator [] {
        let indicator = (get-prompt-chars reset) + (icon-with-space "") + " "
        return $indicator
    }

    export alias get-prompt-multiline-indicator = get-prompt-indicator

    export def get-prompt-indicator-vi-insert [] {
        let indicator = (get-prompt-chars reset) + (icon-with-space "") + " "
        return $indicator
    }

    export alias get-prompt-indicator-vi-normal = get-prompt-indicator

    export def get-transient-prompt-command [] {
        let last_path = get-prompt-info last-pwd -u

        let prompt = (
            make-block
                -i (icon-with-space "")
                -s (get-prompt-chars left_half_circle)
                -e (get-prompt-chars right_half_circle)
                (get-prompt-chars pink1_fg)
                (get-prompt-chars pink1_bg)
                $last_path
                (get-prompt-chars black_fg)
        ) + " "

        return $prompt
    }

    export def get-transient-prompt-command-right [] { }

    export alias get-transient-prompt-indicator = get-prompt-indicator

    export alias get-transient-prompt-multiline-indicator = get-prompt-indicator

    export alias get-transient-prompt-indicator-vi-insert = get-prompt-indicator-vi-insert

    export alias get-transient-prompt-indicator-vi-normal = get-prompt-indicator-vi-normal

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