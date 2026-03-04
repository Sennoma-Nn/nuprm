<h1>
  <img src="./images/icon.svg" alt="icon" width="48px" height="48px" style="vertical-align: middle; margin-right: 10px;" />
  <b>Nu</b>shell <b>Pr</b>ompt <b>M</b>anager
</h1>

## Introduction

**NuPrm** is a Nushell theme framework and theme management script that allows you to easily switch between different prompt themes, customize the appearance of your Nushell prompt, and manage prompt configurations through environment variables. It is written using Nushell scripts and integrates with Nushell functionality, while providing common interfaces to make it easier to build prompts

## Installation

- Clone this repository to your .config directory:
    ```nu
    git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

- Add the following to your Nushell configuration file (`config nu`):
    ```nu
    const nuprm_path = "~/.config/nuprm"
    const nuprm_theme = "~/.config/nuprm/themes/simple-minimal.nu"
    source ~/.config/nuprm/nuprm.nu
    ```

- Restart your Nushell session:
    ```nu
    exec $nu.current-exe
    ```

## Configuration

Add the following to your Nushell environment variables file (`config env`):

```nu
$env.NUPRMCONFIG = {
    enabled: "yes",
    use_full_name: "yes",
    directory_abbreviation: {
        enabled: "yes",
        start_from_end: 3,
        display_chars: 2,
        abbreviate_home: "yes",
        specific_mappings: {}
    },
    display_elements: {
        system_icon: "no",
        hostname: "yes",
        git: "yes",
        shells: "yes",
        execution_time: "yes",
        exit: "yes"
    },
    compatibility: {
        enable_path_url: "yes",
        true_color: "yes",
        system_icon_with_space: "yes"
    },
    git: {
        dirty: "yes",
        staged: "yes"
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
  - For example, set to 3: `/home/laism/.test/123456/demo/path` will display as `~/.tes/123/demo/path`

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

```nu
❯ nuprm theme list
╭───┬───────────────────┬───────────────────────────────────────╮
│ # │       name        │              information              │
├───┼───────────────────┼───────────────────────────────────────┤
│ 0 │ azure.nu          │ ┌──────┬────────────┐                 │
│   │                   │ │ tags │ Minimalist │                 │
│   │                   │ └──────┴────────────┘                 │
│ 1 │ circuit.nu        │ ┌──────┬────────────────────────────┐ │
│   │                   │ │ tags │ Minimalist, Multiple Lines │ │
│   │                   │ └──────┴────────────────────────────┘ │
│ 2 │ galaxy-dream.nu   │ ┌──────┬───────────────────────┐      │
│   │                   │ │ tags │ Emoji, Multiple Lines │      │
│   │                   │ └──────┴───────────────────────┘      │
│ 3 │ gxy.nu            │ ┌──────┬────────────────────────────┐ │
│   │                   │ │ tags │ Power Line, Multiple Lines │ │
│   │                   │ └──────┴────────────────────────────┘ │
│ 4 │ neon-night.nu     │ ┌──────┬────────────────────────────┐ │
│   │                   │ │ tags │ Minimalist, Multiple Lines │ │
│   │                   │ └──────┴────────────────────────────┘ │
│ 5 │ power-blocks.nu   │ ┌──────┬────────────┐                 │
│   │                   │ │ tags │ Power Line │                 │
│   │                   │ └──────┴────────────┘                 │
│ 6 │ retro-console.nu  │ ┌──────┬────────────┐                 │
│   │                   │ │ tags │ Minimalist │                 │
│   │                   │ └──────┴────────────┘                 │
│ 7 │ simple-minimal.nu │ ┌──────┬────────────┐                 │
│   │                   │ │ tags │ Minimalist │                 │
│   │                   │ └──────┴────────────┘                 │
│ 8 │ sunset-ocean.nu   │ ┌──────┬────────────────────────────┐ │
│   │                   │ │ tags │ Power Line, Multiple Lines │ │
│   │                   │ └──────┴────────────────────────────┘ │
╰───┴───────────────────┴───────────────────────────────────────╯
```

To set a theme, configure the `nuprm_theme` constant in your environment file:

```nu
# Set theme
const nuprm_theme = "~/.config/nuprm/themes/theme-name.nu"
```

After modifying the configuration, restart your Nushell session or re-enter to apply changes:

```nu
exec $nu.current-exe
```

</details>

---

## Script Errors?

<details>
  <summary>(Click here if you encounter script errors)</summary>

```nu
Error: nu::parser::unknown_flag

  × The `get` command doesn't have flag `-o`.
    ╭─[/home/username/.config/nuprm/utils/prompt-utils.nu:14:39]
 13 │     let user_config = $env.NUPRMCONFIG
 14 │     return ($user_config | get $item -o | default $default)
    ·                                       ┬
    ·                                       ╰── unknown flag
 15 │ }
    ╰────
  help: Available flags: --help(-h), --ignore-errors(-i), --sensitive(-s). Use
        `--help` for more information.
```

If you get the error<br>``The `get` command doesn't have flag `-o`.``<br>then your Nushell version is below 0.105.0

---

```nu
Error: nu::parser::variable_not_found

  × Variable not found.
    ╭─[/home/username/.config/nuprm/nuprm.nu:18:20]
 17 │         if $is_enable == "yes" {
 18 │             source $nuprm_theme
    ·                    ──────┬─────
    ·                          ╰── variable not found. 
 19 │         }
    ╰────
```

If you get the error<br>``Variable not found.``<br>then you haven't set the `nuprm_theme` constant

---

```
Error: nu::parser::error

  × Error: nu::shell::not_a_constant
  │ 
  │   × Not a constant.
  │     ╭─[/home/username/.config/nuprm/nuprm.nu:18:20]
  │  17 │         if $is_enable == "yes" {
  │  18 │             source $nuprm_theme
  │     ·                    ──────┬─────
  │     ·                          ╰── Value is not a parse-time constant
  │  19 │         }
  │     ╰────
  │   help: Only a subset of expressions are allowed constants during parsing.
  │ Try
  │         using the 'const' command or typing the value literally.
  │ 
    ╭─[/home/username/.config/nuprm/nuprm.nu:18:20]
 17 │         if $is_enable == "yes" {
 18 │             source $nuprm_theme
    ·                    ──────┬─────
    ·                          ╰── Encountered error during parse-time evaluation
 19 │         }
    ╰────
```

If you get the error<br>``Encountered error during parse-time evaluation``<br>then you set the `nuprm_theme` constant as a variable

---

```
Error: nu::parser::sourced_file_not_found

  × File not found
    ╭─[/home/username/.config/nuprm/nuprm.nu:18:20]
 17 │         if $is_enable == "yes" {
 18 │             source $nuprm_theme
    ·                    ──────┬─────
    ·                          ╰── File not found: ~/.config/nuprm/themes/never-gonna-give-you-up.nu
 19 │         }
    ╰────
  help: sourced files need to be available before your script is run
```

If you get the error<br>``File not found: ...``<br>then the file pointed to by your `nuprm_theme` constant doesn't exist

</details>
