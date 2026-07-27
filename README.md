<h1>
  <img src="./images/icon.svg" alt="icon" width="48px" height="48px" style="vertical-align: middle; margin-right: 10px;" />
  <b>Nu</b>shell <b>Pr</b>ompt <b>M</b>anager
</h1>

## Introduction

**NuPrm** is a Nushell theme framework and theme management script that allows you to easily switch between different prompt themes, customize the appearance of your Nushell prompt, and manage prompt configurations through environment variables. It is written using Nushell scripts and integrates with Nushell functionality, while providing common interfaces to make it easier to build prompts

## Installation

> You can change `~/.config/nuprm` to any directory you prefer, as long as the `$nuprm_path` constant correctly points to where you cloned the repository

- Clone this repository into your `.config` directory:
    ```nushell
    git clone -b stable https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

- Add the following to your Nushell configuration file (`config nu`):
    ```nushell
    const nuprm_path = "~/.config/nuprm"
    const nuprm_theme = $"($nuprm_path)/themes/simple-minimal.nu"
    source $"($nuprm_path)/nuprm.nu"
    ```

- Restart your Nushell session:
    ```nushell
    exec $nu.current-exe
    ```

## Configuration

Add the following to your Nushell environment variables file (`config env`):

```nushell
$env.NUPRMCONFIG = {
    enabled: true,
    use_full_name: true,
    directory_abbreviation: {
        enabled: true,
        start_from_end: 3,
        display_chars: 2,
        abbreviate_home: true,
        specific_mappings: {}
    },
    display_elements: {
        system_icon: false,
        hostname: true,
        git: true,
        shells: true,
        startup_time: true,
        execution_time: true,
        exit: true
    },
    compatibility: {
        enable_path_url: true,
        true_color: true,
        system_icon_with_space: true
    },
    git: {
        dirty: true,
        staged: true
    }
}
```

<details>
  <summary>(Click here for detailed configuration)</summary>

**Enable nuprm**
- `enabled: "yes"` - Enable nuprm
- `enabled: "no"` - Disable nuprm

**Display full name**
- `use_full_name: "yes"` - Display user's full name
- `use_full_name: "no"` - Display username

**True color support**
- `compatibility.true_color: "yes"` - Enable true color support
- `compatibility.true_color: "no"` - Disable true color support

**Path URL support**
- `compatibility.enable_path_url: "yes"` - Enable path URL support
- `compatibility.enable_path_url: "no"` - Disable path URL support

- `compatibility.system_icon_with_space: "yes"` - Add a space after the system icon
- `compatibility.system_icon_with_space: "no"` - Do not add a space after the system icon

**Directory abbreviation configuration**
nuprm supports intelligent directory abbreviation to make long paths more readable.

- `directory_abbreviation.enabled: "yes"` - Enable directory abbreviation
- `directory_abbreviation.enabled: "no"` - Disable directory abbreviation

- `directory_abbreviation.start_from_end: 3` - Start abbreviation from the Nth directory from the end
  - Set to `0` to disable abbreviation from the end, showing full path
  - Example: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` display effects with different settings:
    - 0: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`
    - 1: `~/.t/a/b/c/d/e/f/g`
    - 2: `~/.t/a/b/c/d/e/f/ggg`
    - 3: `~/.t/a/b/c/d/e/fff/ggg`
    - 4: `~/.t/a/b/c/d/eee/fff/ggg`
    - 5: `~/.t/a/b/c/ddd/eee/fff/ggg`

- `directory_abbreviation.display_chars: 2` - Number of characters to display after abbreviation
  - For example, set to 3: `/home/username/.test/123456/demo/path` will display as `~/.tes/123/demo/path`

- `directory_abbreviation.abbreviate_home: "yes"` - Enable home directory abbreviation to `~`
- `directory_abbreviation.abbreviate_home: "no"` - Disable home directory abbreviation

- `directory_abbreviation.specific_mappings: {}` - Custom special directory abbreviations
  - You can add custom directory abbreviations, for example set `~/Documents` to `📄`, set home directory to `🏠`
  > If you want to customize the home directory abbreviation display, you must disable `directory_abbreviation.abbreviate_home`

**Display elements configuration**
- `display_elements.system_icon: "yes"` - Display system icon
- `display_elements.system_icon: "no"` - Do not display system icon

- `display_elements.hostname: "yes"` - Display hostname
- `display_elements.hostname: "no"` - Do not display hostname

- `display_elements.git: "yes"` - Display Git repository information
- `display_elements.git: "no"` - Do not display Git repository information

- `display_elements.shells: "yes"` - Display Shells information
- `display_elements.shells: "no"` - Do not display Shells information

- `display_elements.startup_time: true` - Display startup time (on execution time information)
- `display_elements.startup_time: false` - Do not display startup time (on execution time information)

- `display_elements.execution_time: "yes"` - Display execution time information
- `display_elements.execution_time: "no"` - Do not display execution time information

- `display_elements.exit: "yes"` - Display exit code information
- `display_elements.exit: "no"` - Do not display exit code information

- `git.dirty: "yes"` - Appends the `*` indicator after the Git branch name if unstaged changes are detected.
- `git.dirty: "no"` - Does not append the `*` indicator after the Git branch name, even if unstaged changes are detected.

- `git.staged: "yes"` - Appends the `+` indicator after the branch name if staged changes are detected.
- `git.staged: "no"` - Does not append the `+` indicator after the branch name, even if staged changes are detected.

#### Theme Management
You can use the `nuprm theme list` command to view available themes:
> Using `nuprm theme list --preview` allows you to preview the prompt

```nushell
❯ nuprm theme list
# => ╭───┬───────────────────╮
# => │ # │       name        │
# => ├───┼───────────────────┤
# => │ 0 │ azure.nu          │
# => │ 1 │ circuit.nu        │
# => │ 2 │ galaxy-dream.nu   │
# => │ 3 │ gxy.nu            │
# => │ 4 │ neon-night.nu     │
# => │ 5 │ power-blocks.nu   │
# => │ 6 │ retro-console.nu  │
# => │ 7 │ simple-minimal.nu │
# => │ 8 │ sunset-ocean.nu   │
# => │ 9 │ violet-line.nu    │
# => ╰───┴───────────────────╯
```

To set a theme, configure the `nuprm_theme` constant in your environment file:

```nushell
# Set theme
const nuprm_theme = "~/.config/nuprm/themes/theme-name.nu"
```

After modifying the configuration, restart your Nushell session or re-enter to apply changes:

```nushell
exec $nu.current-exe
```

</details>

---

## Script Errors?

<details>
  <summary>(Click here if you encounter script errors)</summary>

```nushell
# => Error: nu::parser::unknown_flag
# => 
# =>   × The get command doesn't have flag -o.
# =>    ╭─[/home/username/.config/nuprm/utils/config-utils.nu:8:39]
# =>  7 │     let user_config = $env.NUPRMCONFIG
# =>  8 │     return ($user_config | get $item -o | default $default)
# =>    ·                                       ┬
# =>    ·                                       ╰── unknown flag
# =>  9 │ }
# =>    ╰────
# =>   help: Available flags: --help(-h), --ignore-errors(-i),
# =>         --sensitive(-s). Use --help for more information.
```

If you get the error<br>``The `get` command doesn't have flag `-o`.``<br>then your Nushell version is below 0.105.0

---

```nushell
# => Error: nu::parser::variable_not_found
# => 
# =>   × Variable not found.
# =>     ╭─[/home/username/.config/nuprm/nuprm.nu:14:17]
# =>  13 │         if $is_enable {
# =>  14 │             use $nuprm_theme nuprm-theme
# =>     ·                 ──────┬─────
# =>     ·                       ╰── variable not found. 
# =>  15 │ 
# =>     ╰────
```

If you get the error<br>``Variable not found.``<br>then you haven't set the `nuprm_theme` constant

---

```nushell
# => Error: nu::parser::error
# => 
# =>   × Error: nu::shell::not_a_constant
# =>   │ 
# =>   │   × Not a constant.
# =>   │     ╭─[/home/username/.config/nuprm/nuprm.nu:14:17]
# =>   │  13 │         if $is_enable {
# =>   │  14 │             use $nuprm_theme nuprm-theme
# =>   │     ·                 ──────┬─────
# =>   │     ·                       ╰── Value is not a parse-time constant
# =>   │  15 │
# =>   │     ╰────
# =>   │   help: Only a subset of expressions are allowed constants during parsing.
# =>   │ Try
# =>   │         using the 'const' command or typing the value literally.
# =>   │ 
# =>     ╭─[/home/username/.config/nuprm/nuprm.nu:14:17]
# =>  13 │         if $is_enable {
# =>  14 │             use $nuprm_theme nuprm-theme
# =>     ·                 ────────────┬───────────
# =>     ·                             ╰── Encountered error during parse-time evaluation
# =>  15 │ 
# =>     ╰────
```

If you get the error<br>``Encountered error during parse-time evaluation``<br>then you set the `nuprm_theme` constant as a variable

---

```nushell
# => Error: nu::parser::module_not_found
# => 
# =>   × Module not found.
# =>     ╭─[/home/username/.config/nuprm/nuprm.nu:14:17]
# =>  13 │         if $is_enable {
# =>  14 │             use $nuprm_theme nuprm-theme
# =>     ·                 ──────┬─────
# =>     ·                       ╰── module ~/.config/nuprm/themes/never-gonna-give-you-up.nu not found
# =>  15 │ 
# =>     ╰────
# =>   help: module files and their paths must be available before your script is
# =>         run as parsing occurs before anything is evaluated
```

If you get the error<br>``module ... not found``<br>then the file pointed to by your `nuprm_theme` constant doesn't exist

</details>
