# Show theme
def show-theme [
    theme_path: string # Theme path
    --preview (-p)     # Preview theme
] {
    let utils_path = (($nuprm_path | path expand | path split) ++ ["utils" "prompt-utils.nu"] | path join | path expand)
    let config_json = $env.NUPRMCONFIG | to json
    let preview_prompt = if $preview {
        try {
            ^$nu.current-exe --no-config-file -c $"
                $env.NUPRMCONFIG = '($config_json)' | from json
                $env.config.edit_mode = '($env | get -o $.config.edit_mode | default emacs)'
                use ($utils_path) *
                use ($theme_path) nuprm-theme
                let command_l = do {|| nuprm-theme get-prompt-command-left } | default ''
                let command_r = do {|| nuprm-theme get-prompt-command-right } | default ''
                let indicator = if $env.config.edit_mode == 'vi' {
                    do {|| nuprm-theme get-prompt-indicator-vi-insert } | default ''
                } else {
                    do {|| nuprm-theme get-prompt-indicator } | default ''
                }
                let multiline = do {|| nuprm-theme get-prompt-multiline-indicator } | default ''
                let preview_json = {
                    command_l: $command_l,
                    indicator: $indicator
                    multiline: $multiline
                    command_r: $command_r
                } | to json

                print $preview_json
            " | complete | get -o "stdout"
        }
    } else { null }

    let preview_command_l = if $preview { $preview_prompt | from json | get -o "command_l" | default "" } else { null }
    let preview_indicator = if $preview { $preview_prompt | from json | get -o "indicator" | default "" } else { null }
    let preview_multiline = if $preview { $preview_prompt | from json | get -o "multiline" | default "" } else { null }
    let preview_command_r = if $preview { $preview_prompt | from json | get -o "command_r" | default "" } else { null }
    let preview_record = if $preview {
        {
            left: $"($preview_command_l)($preview_indicator)",
            right: $preview_command_r
        }
    } else {
        { }
    }

    return $preview_record
}

export module nuprm {
    export def main [
        --version (-v) # Show version
    ] {
        if not $version {
            let color = "\e[32m"
            let reset = (ansi reset)
            let info = [
                $"Run ($color)nuprm load($reset) load NuPrm!"
                $"Run ($color)nuprm theme list -p($reset) preview theme!"
            ]
            $info | str join "\n" | [$in] | table --collapse | print
        } else if $version {
            $nuprm_path | path expand | path split | $in ++ ["nuprm-version.txt"] | path join | open $in | print
        }
    }

    # Load nuprm
    export def --env load [] {
        use utils/prompt-utils.nu *

        try {
            let is_enable = get-prompt-info nuprm-enabled

            if (get-prompt-info full-name-enabled) {
                if ($env.FULLNAME? == null) {
                    $env.FULLNAME = get-prompt-info full-name
                }
            }

            if $is_enable {
                use $nuprm_theme nuprm-theme

                $env.PROMPT_COMMAND = {|| nuprm-theme get-prompt-command-left }
                $env.PROMPT_COMMAND_RIGHT = {|| nuprm-theme get-prompt-command-right }
                $env.PROMPT_INDICATOR = {|| nuprm-theme get-prompt-indicator }
                $env.PROMPT_MULTILINE_INDICATOR = {|| nuprm-theme get-prompt-multiline-indicator }
                $env.PROMPT_INDICATOR_VI_INSERT = {|| nuprm-theme get-prompt-indicator-vi-insert }
                $env.PROMPT_INDICATOR_VI_NORMAL = {|| nuprm-theme get-prompt-indicator-vi-normal }
                $env.TRANSIENT_PROMPT_COMMAND = {|| nuprm-theme get-transient-prompt-command }
                $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| nuprm-theme get-transient-prompt-command-right }
                $env.TRANSIENT_PROMPT_INDICATOR = {|| nuprm-theme get-transient-prompt-indicator }
                $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| nuprm-theme get-transient-prompt-multiline-indicator }
                $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| nuprm-theme get-transient-prompt-indicator-vi-insert }
                $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| nuprm-theme get-transient-prompt-indicator-vi-normal }
            }
        } catch {|e|
            print "\e[31mNuPrm ERROR!\e[0m\n" $e
        }
    }

    export module theme {
        # List all available prompt themes
        export def list [
            --preview (-p) # Preview theme
        ] {
            use theme-list.nu theme_info

            let theme_name_list = $theme_info | sort-by "name"
            $theme_name_list | each {|i|
                let theme_name = $i.name
                let theme_tags = $i.tag
                let theme_path = (($nuprm_path | path expand | path split) ++ ["themes", $theme_name] | path join | path expand)
                let preview_record = if $preview { show-theme $theme_path --preview=$preview } else { { } }

                let list =  {
                    tags: $theme_tags
                    ...$preview_record
                } | table --theme thin

                return {
                    name: $theme_name,
                    information: $list
                }
            }
        }

        # Show theme
        export alias show = show-theme
    }
}
