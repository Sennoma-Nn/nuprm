export module nuprm-theme {
    def get-color [color] {
        let colors = {
            cyan: (prompt-make-utils color-to-ansi 0 255 255 "fg" "36"),
            magenta: (prompt-make-utils color-to-ansi 255 0 255 "fg" "35"),
            yellow: (prompt-make-utils color-to-ansi 255 255 0 "fg" "33"),
            white: (prompt-make-utils color-to-ansi 220 220 220 "fg" "37"),
            red: (prompt-make-utils color-to-ansi 255 80 80 "fg" "31"),
            grey: (prompt-make-utils color-to-ansi 128 128 128 "fg" "97"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let user_name = get-prompt-info user-name -l (get-color cyan)
        let host_name = get-prompt-info host-name -l $"(get-color magenta) at (get-color cyan)"
        let user_host = $"($user_name)($host_name)"
        let user_info = $"($user_host)(ansi reset)"
        let path_info = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d (ansi reset) -s (get-color grey) -r (get-color white) -u
        let git_branch = (get-prompt-info git)
        let shells_index = get-prompt-info shells -dl $"(get-color grey) | (get-color cyan)dirs: (get-color magenta)№"
        let git_info = if not ($git_branch | is-empty) { $"(get-color grey) | (get-color cyan)git: (get-color magenta)($git_branch)(ansi reset)" } else { "" }
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $"(get-color grey) | (get-color cyan)exec time: (get-color magenta)(get-prompt-info exec-time)sec(ansi reset)" } else { "" }

        return $"($user_info) (get-color grey)in ($path_info)($git_info)($shells_index)($execution_time)\n"
    }

    export def get-prompt-command-right [] {
        let exit_code = get-prompt-info exit-code
        if $exit_code != "0" {
            return $"(get-color red)status: ($exit_code)(get-color reset)"
        } else {
            return ""
        }
    }

    export def get-prompt-indicator [] {
        return $"(get-color cyan)❯ (get-color reset)"
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color grey)· (get-color reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-color cyan): (get-color reset)"
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
        let indicator = get-prompt-multiline-indicator
        return $indicator
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