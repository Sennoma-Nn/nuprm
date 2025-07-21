const nu_prompt_const = {
    exe_path: (["~" ".config" "nupm"] | path join | path expand)
    config_path: (["~" ".config" "nupm" "config.yml"] | path join | path expand)
    load_path: (["~" ".config" "nupm" "load.nu"] | path join | path expand)
    prompt_utils_path: (["~" ".config" "nupm" "utils" "prompt-utils.nu"] | path join | path expand)
}

use $nu_prompt_const.prompt_utils_path *

do --env {
    if not ($nu_prompt_const.config_path | path exists) {
        touch $nu_prompt_const.config_path
        let config = {
            enable: "off"
            theme: "azure"
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
def "nupm set" [
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
def "nupm on" [] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = "on"
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}

# Disable prompt
def "nupm off" [] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = "off"
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}