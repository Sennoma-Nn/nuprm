export module nuprm-theme {
    def get-color [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi

        let colors = {
            green: (color-to-ansi 100 200 100 "fg" "32"),
            white: (color-to-ansi 240 240 240 "fg" "37"),
            grey: (color-to-ansi 128 128 128 "fg" "97"),
            red: (color-to-ansi 255 80 80 "fg" "31"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let system_icon = surround (get-prompt-info system-icon) -l $"(get-color white)" -r " "
        let user_name = get-prompt-info user-name
        let host_name = surround (get-prompt-info host-name) -l $"((get-color white)) @ ((get-color green))"
        let user_info = $"((get-color green))($user_name)($host_name)((get-color reset))"
        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let path_info = surround (get-prompt-info path $path_sep -d (get-color white) -s (get-color grey) -u) -r (get-color reset)
        let shells_index = surround (get-prompt-info shells -d) -l $"((get-color white))#" -r $"((get-color green)) : "
        let git_info = surround (get-prompt-info git -d $"(get-color white)*" -s $"(get-color white)+") -l $" (get-color green)\(" -r $"(get-color green)\)(get-color reset)"
        let execution_time = if (get-prompt-info exec-time) > 0.5 { $" ((get-color green))(get-prompt-info exec-time)sec((get-color reset))" } else { "" }
        let exit_code = if (get-prompt-info exit-code) != 0 { $" ((get-color red))[(get-prompt-info exit-code)]" } else { "" }

        return $"($system_icon)($user_info) ($shells_index)($path_info)($git_info)($execution_time)($exit_code) "
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        return $"((get-color green))❯ ((get-color reset))"
    }

    export def get-prompt-multiline-indicator [] {
        return $"((get-color green))::: ((get-color reset))"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"((get-color green)): ((get-color reset))"
    }

    export alias get-prompt-indicator-vi-normal = get-prompt-indicator

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export alias get-transient-prompt-indicator = get-prompt-indicator

    export def get-transient-prompt-multiline-indicator [] {
        return $"((get-color green)): ((get-color reset))"
    }

    export alias get-transient-prompt-indicator-vi-insert = get-prompt-indicator-vi-insert

    export alias get-transient-prompt-indicator-vi-normal = get-prompt-indicator-vi-normal
}
