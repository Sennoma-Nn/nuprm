const nu_prompt_const = {
    exe_path: (["~" ".config" "nuprm"] | path join | path expand)
    config_path: (["~" ".config" "nuprm" "config.yml"] | path join | path expand)
    load_path: (["~" ".config" "nuprm" "load.nu"] | path join | path expand)
    prompt_utils_path: (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
}

do --env {
    use $nu_prompt_const.prompt_utils_path *
    if not ($nu_prompt_const.config_path | path exists) {
        touch $nu_prompt_const.config_path
        let config = {
            enable: "off"
            theme: "simple-minimal"
        }
        $config | to yaml | save $nu_prompt_const.config_path -f
    }

    let config_table = (open $nu_prompt_const.config_path)
    let is_enable = ($config_table | get "enable")
    let theme_name = ($config_table | get "theme")

    let theme_path = ([$nu_prompt_const.exe_path "themes" $"($theme_name).nu"] | path join)
    $"source ($theme_path)" | save $nu_prompt_const.load_path -f
    if $is_enable == "on" {
        source $nu_prompt_const.load_path
    }
}

# Set prompt theme
def "nuprm set" [
    theme_name # Theme name
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.theme = $theme_name
    
    let theme_path = ([$nu_prompt_const.exe_path "themes" $"($theme_name).nu"] | path join)
    if ($theme_path | path exists) {
        $config | to yaml | save $nu_prompt_const.config_path -f
        $"source ($theme_path)" | save $nu_prompt_const.load_path -f
        exec $nu.current-exe
    } else {
        print "\e[31mThe Theme File Is Not Exists."
    }
}

# Enable prompt
def "nuprm on" [] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = "on"
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}

# Disable prompt
def "nuprm off" [] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = "off"
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}

# List prompt
def "nuprm list" [] {
    let description_path = ([$nu_prompt_const.exe_path "themes" ".description.yml"] | path join)
    open $description_path
}

# Show help information
def nuprm [] {
    print "nuprm - Nushell Prompt Manager"
    print ""
    print "USAGE:"
    print "    nuprm <COMMAND>"
    print ""
    print "COMMANDS:"
    print "    list                List prompt"
    print "    off                 Disable prompt"
    print "    on                  Enable prompt"
    print "    set <theme_name>    Set prompt theme"
    print ""
}
