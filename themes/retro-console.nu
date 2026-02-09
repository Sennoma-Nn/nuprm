export module nuprm-theme {
    def get-color [color] {
        let colors = {
            terminal_green: (prompt-make-utils color-to-ansi 57 255 20 "fg" "92"),
            error_red: (prompt-make-utils color-to-ansi 255 0 0 "fg" "31"),
            dim_green: (prompt-make-utils color-to-ansi 40 180 20 "fg" "32"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let shells_index = get-prompt-info shells -dl $"(get-color terminal_green)#" -r $"(get-color dim_green) : "
        let path_str = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -u -d (get-color terminal_green) -s (get-color dim_green)
        let git_branch = (get-prompt-info git)
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" (get-color dim_green)(get-prompt-info exec-time)sec(get-color reset)" } else { "" }
        let git_str = if not ($git_branch | is-empty) { $" (get-color dim_green)($git_branch)(get-color reset)" } else { "" }

        return $"($shells_index)(get-color terminal_green)($path_str)($git_str)($execution_time)(get-color reset) "
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        if (get-prompt-info exit-code) == "0" {
            return $"(get-color terminal_green)> (get-color reset)"
        } else {
            return $"(get-color error_red)! (get-color reset)"
        }
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color dim_green)» (get-color reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        if (get-prompt-info exit-code) == "0" {
            return $"(get-color terminal_green): (get-color reset)"
        } else {
            return $"(get-color error_red): (get-color reset)"
        }
    }

    export def get-prompt-indicator-vi-normal [] {
        if (get-prompt-info exit-code) == "0" {
        return $"(get-color terminal_green)> (get-color reset)"
        } else {
            return $"(get-color error_red)> (get-color reset)"
        }
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