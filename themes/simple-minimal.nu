export module nuprm-theme {
    def get-color [color] {
        let colors = {
            green: (prompt-make-utils color-to-ansi 100 200 100 "fg" "32"),
            white: (prompt-make-utils color-to-ansi 240 240 240 "fg" "37"),
            grey: (prompt-make-utils color-to-ansi 128 128 128 "fg" "97"),
            red: (prompt-make-utils color-to-ansi 255 80 80 "fg" "31"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let user_name = get-prompt-info user-name
        let host_name = get-prompt-info host-name -l $"((get-color white)) @ ((get-color green))"
        let user_info = $"((get-color green))($user_name)($host_name)((get-color reset))"
        let path_info = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d (get-color white) -s (get-color grey) -r (get-color reset) -u
        let shells_index = get-prompt-info shells -dl $"((get-color white))#" -r $"((get-color green)) : "
        let git_info = (get-prompt-info git -l $" ((get-color green))\(" -r $"\)((get-color reset))")
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ((get-color green))(get-prompt-info exec-time)sec((get-color reset))" } else { "" }
        let exit_code = if (get-prompt-info exit-code) != "0" { $" ((get-color red))[(get-prompt-info exit-code)]" } else { "" }

        return $"($user_info) ($shells_index)($path_info)($git_info)($execution_time)($exit_code) "
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

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"((get-color green)): ((get-color reset))"
    }

    export def get-transient-prompt-indicator-vi-insert [] {
        let indicator = get-prompt-indicator-vi-insert
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator-vi-normal
        return $indicator
    }
}
