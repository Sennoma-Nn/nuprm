use utils/prompt-utils.nu *

# Show theme
def show-theme [
    theme_path: string # Theme path
] {
    let utils_path = (($nuprm_path | path expand | path split) ++ ["utils", "prompt-utils.nu"] | path join | path expand)
    let config_json = $env | get -o NUPRMCONFIG | default {} | to json
    let shells_index = get-prompt-info shells | if $in == "" { 0 } else { $in | into int }
    let shells_json = 0..$shells_index | each { { active: false } } | update $shells_index { active: true } | to json
    let utils_nuon_path = $utils_path | to nuon
    let theme_nuon_path = $theme_path | to nuon
    let preview_prompt = with-env {
        CONFIG_JSON: $config_json
        SHELLS_JSON: $shells_json
        EDIT_MODE: ($env | get -o $.config.edit_mode | default emacs)
    } {
        let run_code = "
            $env.NUPRMCONFIG = $env.CONFIG_JSON | from json
            $env.config.edit_mode = $env.EDIT_MODE
            let shells_data = $env.SHELLS_JSON | from json

            alias shells = echo $shells_data

            use " + $utils_nuon_path + " *
            use " + $theme_nuon_path + " nuprm-theme

            let command_l = do {|| nuprm-theme get-prompt-command-left } | default ''
            let command_r = do {|| nuprm-theme get-prompt-command-right } | default ''
            let theme_info = do {|| nuprm-theme get-info } | default ''
            let indicator = if $env.config.edit_mode == 'vi' {
                do {|| nuprm-theme get-prompt-indicator-vi-normal } | default ''
            } else {
                do {|| nuprm-theme get-prompt-indicator } | default ''
            }
            let multiline = do {|| nuprm-theme get-prompt-multiline-indicator } | default ''
            let preview_json = {
                command_l: $command_l,
                indicator: $indicator
                multiline: $multiline
                command_r: $command_r
                theme_info: $theme_info
            } | to json

            print $preview_json
        "

        ^$nu.current-exe --no-config-file -c $run_code
            | complete
            | get -o "stdout"
    }

    let preview_command_l = $preview_prompt | from json | get -o "command_l" | default ""
    let preview_indicator = $preview_prompt | from json | get -o "indicator" | default ""
    let preview_multiline = $preview_prompt | from json | get -o "multiline" | default ""
    let preview_command_r = $preview_prompt | from json | get -o "command_r" | default ""
    let preview_theme_info = $preview_prompt | from json | get -o "theme_info" | default { }

    let preview_record = {
        tags: ($preview_theme_info | get -o "tags" | default [] | sort | str join $"(ansi d),(ansi rst) ")
        left: $"($preview_command_l)($preview_indicator)",
        right: $preview_command_r
    }

    return $preview_record
}

# Configuration check in load
def config-check [] {
    use utils/config-utils.nu *

    if ($env.NUPRMCONFIG? | describe) == "nothing" {
        error make --unspanned { msg: "Config not defined." }
    }

    def make-error-labels [cfg_path, type] {
        return [
            {
                text: $"Expected value is ($type)",
                span: ($env.NUPRMCONFIG | get $cfg_path -o | metadata $in | get "span")
            }
        ]
    }

    mut labels = []

    let record_configs = [
        $.
        $.directory_abbreviation, $.directory_abbreviation.custom_abbreviate_mappings,
        $.compatibility,
        $.display_elements,
        $.elements, $.elements.git, $.elements.time
    ]
    let record_configs_error_list = find-config-type-error -n $record_configs ["record"]
    if ($record_configs_error_list | length) > 0 {
        for cfg_path in $record_configs_error_list {
            $labels ++= (make-error-labels $cfg_path "record")
        }
    }

    let int_configs = [$.directory_abbreviation.start_from_end, $.directory_abbreviation.display_chars]
    let int_configs_error_list = find-config-type-error -n $int_configs ["int"]
    if ($int_configs_error_list | length) > 0 {
        for cfg_path in $int_configs_error_list {
            $labels ++= (make-error-labels $cfg_path "int")
        }
    }

    let duration_configs = [$.elements.time.startup_threshold, $.elements.time.execution_threshold]
    let duration_configs_error_list = find-config-type-error -n $duration_configs ["duration"]
    if ($duration_configs_error_list | length) > 0 {
        for cfg_path in $duration_configs_error_list {
            $labels ++= (make-error-labels $cfg_path "duration")
        }
    }

    let bool_configs = [
        $.enabled, $.use_full_name,
        $.directory_abbreviation.enabled, $.directory_abbreviation.abbreviate_home,
        $.display_elements.system_icon, $.display_elements.hostname, $.display_elements.git,
        $.display_elements.shells, $.display_elements.startup_time, $.display_elements.execution_time, $.display_elements.exit,
        $.compatibility.path_url, $.compatibility.true_color, $.compatibility.icon_with_space,
        $.elements.git.dirty, $.elements.git.staged
    ]
    let bool_configs_error_list = find-config-type-error -n $bool_configs ["bool"]
    if ($bool_configs_error_list | length) > 0 {
        for cfg_path in $bool_configs_error_list {
            $labels ++= (make-error-labels $cfg_path "bool")
        }
    }

    let custom_abbr_path = $.directory_abbreviation.custom_abbreviate_mappings
    let custom_abbr_map = get-config $custom_abbr_path
    if (check-config-type $custom_abbr_path ["record"]) {
        let other_type_list = $custom_abbr_map | items {|k, v| $v | describe | if $in != "string" { $k } else { null } } | where $it != null
        if ($other_type_list | length) > 0 {
            for i in $other_type_list {
                let cfg_path = ["directory_abbreviation", "custom_abbreviate_mappings", $i] | into cell-path
                $labels ++= (make-error-labels $cfg_path "string")
            }
        }
    }

    if ($labels | length) > 0 {
        error make {
            msg: "Config type mismatch",
            labels: $labels
        }
    }
}

export module nuprm {
    # Nushell Prompt Manager
    export def main [
        --version (-v) # Show version
    ] {
        if not $version {
            let green = ansi g
            let reset = ansi rst
            let info = [
                $"Run ($green)nuprm load($reset) load NuPrm!"
                $"Run ($green)nuprm theme list -p($reset) preview theme!"
            ]
            $info | str join "\n" | [$in] | table --collapse | print
        } else if $version {
            $nuprm_path | path expand | path split | $in ++ ["nuprm-version.txt"] | path join | open $in | print
        }
    }

    # Load nuprm
    export def --env load [] {
        try {
            config-check

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
            print $"(ansi r)NuPrm ERROR!(ansi rst)\n" $e.rendered
        }
    }

    export module theme {
        # List all available prompt themes
        export def list [
            --preview (-p) # Preview theme
        ] {
            try {
                if $preview { config-check }
            } catch {|e|
                print $"(ansi r)NuPrm ERROR!(ansi rst)\n" $e.rendered
                return
            }

            use theme-list.nu theme_list

            let theme_name_list = $theme_list | sort
            $theme_name_list | each {|i|
                let theme_name = $i
                let theme_path = (($nuprm_path | path expand | path split) ++ ["themes", $theme_name] | path join | path expand)
                let preview_info = if $preview { show-theme $theme_path }
                let table = $preview_info | table --theme thin
                let info_table = if $preview { { information: $table } } else { { } }

                return {
                    name: $theme_name,
                    ...$info_table
                }
            }
        }

        # Show theme
        export alias show = show-theme
    }

    export use theme
}
