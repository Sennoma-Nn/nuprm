const prompt_utils_path = (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
use $prompt_utils_path nu_prompt_const

do --env {
    use $prompt_utils_path *
    if not ($nu_prompt_const.config_path | path exists) {
        touch $nu_prompt_const.config_path
        let config = {
            enable: "off"
            theme: "simple-minimal"
            use_full_name: "no"
            disable_system_icon: "no"
            directory_abbreviation: {
                enable: yes
                start_from_end: 3
                display_chars: 1
            }
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
def "nuprm set theme" [
    theme_name: string # Theme name
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

# List prompt
def "nuprm list" [] {
    let description_path = ([$nu_prompt_const.exe_path "themes" ".description.yml"] | path join)
    open $description_path
}

# Enable / Disable use full name
def "nuprm set full-name" [
    enable: bool # Use `true` or `false` to enable or disable full name
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.use_full_name = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}

# Enable / Disable use system icon
def "nuprm set system-icon" [
    enable: bool # Use `true` or `false` to enable or disable full name
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.disable_system_icon = if not $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}

# Enable / Disable prompt
def nuprm [
    enable: bool # Use `true` or `false` to enable or disable nuprm
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = if $enable { "on" } else { "off" }
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}
