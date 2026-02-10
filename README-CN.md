<h1>
  <img src="./images/icon.svg" alt="图标" width="48px" height="48px" style="vertical-align: middle; margin-right: 10px;" />
  <b>Nu</b>shell <b>Pr</b>ompt <b>M</b>anager
</h1>

## 介绍

**NuPrm** 是一个 Nushell 的主题框架以及主题管理脚本，它让您可以轻松地在不同的提示符主题之间切换，自定义 Nushell 提示符的外观，并通过环境变量管理提示符配置，同时使用 Nushell 脚本编写并且集成了 Nushell 的一些功能，并且提供了一些常用的接口让你能更方便的构建提示符

## 安装

- 将此仓库克隆到您的 .config 目录：
    ```nu
    git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

- 在您的 Nushell 配置文件（`config nu`）中添加以下内容：
    ```nu
    const nuprm_path = "~/.config/nuprm"
    const nuprm_theme = "~/.config/nuprm/themes/simple-minimal.nu"
    source ~/.config/nuprm/nuprm.nu
    ```

- 重启您的 Nushell 会话。
    ```nu
    exec $nu.current-exe
    ```

## 配置

在您的 Nushell 环境变量文件（`config env`）中添加以下内容：

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
    }
}
```

<details>
  <summary>（详细配置请预览这里）</summary>

**启用 nuprm**
- `enabled: "yes"` - 启用 nuprm
- `enabled: "no"` - 禁用 nuprm

**显示全名**
- `use_full_name: "yes"` - 显示用户全名
- `use_full_name: "no"` - 显示用户名

**真彩色支持**
- `compatibility.true_color: "yes"` - 启用真彩色支持
- `compatibility.true_color: "no"` - 禁用真彩色支持

**路径 URL 支持**
- `compatibility.enable_path_url: "yes"` - 启用路径 URL 支持
- `compatibility.enable_path_url: "no"` - 禁用路径 URL 支持

**目录缩写配置**
nuprm 支持智能目录缩写功能，让长路径显示更加短。

- `directory_abbreviation.enabled: "yes"` - 启用目录缩写
- `directory_abbreviation.enabled: "no"` - 禁用目录缩写

- `directory_abbreviation.start_from_end: 3` - 从倒数第几个目录开始缩写
  - 设置为 `0` 禁用从倒数开始缩写，显示完整路径
  - 例如：`~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` 在不同设置下的显示效果：
    - 0: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`
    - 1: `~/.t/a/b/c/d/e/f/g`
    - 2: `~/.t/a/b/c/d/e/f/ggg`
    - 3: `~/.t/a/b/c/d/e/fff/ggg`
    - 4: `~/.t/a/b/c/d/eee/fff/ggg`
    - 5: `~/.t/a/b/c/ddd/eee/fff/ggg`

- `directory_abbreviation.display_chars: 2` - 缩写后显示几个字符
  - 例如设置为 3：`/home/laism/.test/123456/demo/path` 会显示为 `~/.tes/123/demo/path`

- `directory_abbreviation.abbreviate_home: "yes"` - 启用家目录缩写为 `~`
- `directory_abbreviation.abbreviate_home: "no"` - 禁用家目录缩写

- `directory_abbreviation.specific_mappings: {}` - 自定义特殊目录缩写
  - 您可以添加自定义目录缩写，例如将 `~/Documents` 设置为 `📄`，将家目录设置为 `🏠`
  > 如果你想要把家目录重新设置缩写显示，你必须禁用 `directory_abbreviation.abbreviate_home`

**显示元素配置**
- `display_elements.system_icon: "yes"` - 显示系统图标
- `display_elements.system_icon: "no"` - 不显示系统图标

- `display_elements.hostname: "yes"` - 显示主机名
- `display_elements.hostname: "no"` - 不显示主机名

- `display_elements.git: "yes"` - 显示 Git 仓库信息
- `display_elements.git: "no"` - 不显示 Git 仓库信息

- `display_elements.shells: "yes"` - 显示 Shells 信息
- `display_elements.shells: "no"` - 不显示 Shells 信息

- `display_elements.execution_time: "yes"` - 显示运行时间信息
- `display_elements.execution_time: "no"` - 不显示运行时间信息

- `display_elements.exit: "yes"` - 显示退出码信息
- `display_elements.exit: "no"` - 不显示退出码信息

#### 主题管理
您可以使用 `nuprm theme list` 命令来查看可用的主题：
> 使用 `nuprm theme list --preview` 可以预览提示符

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

要设置主题，在您的环境配置文件中设置 `nuprm_theme` 常量：

```nu
# 设置主题
const nuprm_theme = "~/.config/nuprm/themes/主题名称.nu"
```

修改配置后，重启 Nushell 会话或重新进入以使更改生效：

```nu
exec $nu.current-exe
```

</details>

## 脚本报错？

<details>
  <summary>（如果脚本出现了报错请预览这里）</summary>

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

如果报错<br>``The `get` command doesn't have flag `-o`.``<br>那就是你的 Nushell 版本低于 0.105.0，你需要升级 Nushell 版本

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

如果报错<br>``Variable not found.``<br>那就是你没有设置 `nuprm_theme` 常量

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

如果报错<br>``Encountered error during parse-time evaluation``<br>那就是你把常量 `nuprm_theme` 设置为了变量

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

如果报错<br>``File not found: ...``<br>那就是你常量 `nuprm_theme` 指向的文件不存在

</details>