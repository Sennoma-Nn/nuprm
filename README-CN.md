<h1>
  <img src="./images/icon.svg" alt="图标" width="48px" height="48px" style="vertical-align: middle; margin-right: 10px;" />
  <b>Nu</b>shell <b>Pr</b>ompt <b>M</b>anager
</h1>

## 介绍

**NuPrm** 是一个 Nushell 的主题框架以及主题管理脚本，它让您可以轻松地在不同的提示符主题之间切换，自定义 Nushell 提示符的外观，并通过环境变量管理提示符配置，同时使用 Nushell 脚本编写并且集成了 Nushell 的一些功能，并且提供了一些常用的接口让你能更方便的构建提示符

## 安装

> `~/.config/nuprm` 目录可以修改为你想指定的任意目录，只要你的 `$nuprm_path` 常量正确的指向 `git clone` 到的位置

- 将此仓库克隆到您的 `.config` 目录：
    ```nushell
    git clone -b stable https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

- 在您的 Nushell 配置文件（`config nu`）中添加以下内容：
    ```nushell
    const nuprm_path = "~/.config/nuprm"
    const nuprm_theme = $"($nuprm_path)/themes/simple-minimal.nu"
    use $"($nuprm_path)/nuprm-module.nu" nuprm
    nuprm load
    ```

- 重启您的 Nushell 会话。
    ```nushell
    exec $nu.current-exe
    ```

## 配置

在您的 Nushell 环境变量文件（`config env`）中添加以下内容：

```nushell
$env.NUPRMCONFIG = {
    enabled: true,
    use_full_name: true,
    directory_abbreviation: {
        enabled: true,
        start_from_end: 3,
        display_chars: 2,
        abbreviate_home: true,
        custom_abbreviate_mappings: {}
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
        path_url: true,
        true_color: true,
        icon_with_space: true
    },
    git: {
        dirty: true,
        staged: true
    }
}
```

<details>
  <summary>（详细配置请预览这里）</summary>

**启用 nuprm**
- `enabled: true` - 启用 nuprm
- `enabled: false` - 禁用 nuprm

**显示全名**
- `use_full_name: true` - 显示用户全名
- `use_full_name: false` - 显示用户名

**真彩色支持**
- `compatibility.true_color: true` - 启用真彩色支持
- `compatibility.true_color: false` - 禁用真彩色支持

**路径 URL 支持**
- `compatibility.enable_path_url: true` - 启用路径 URL 支持
- `compatibility.enable_path_url: false` - 禁用路径 URL 支持

- `compatibility.icon_with_space: true` - 在 Power Line 图标后添加空格
- `compatibility.icon_with_space: false` - 在 Power Line 图标后不添加空格
  > `compatibility.icon_with_space` 之所以被需要是因为 Power Line 图标的显示宽度并非始终为 1 个字符，但是图标的实际体积却是 1 个字符，这可能会造成显示重叠。如果你正在使用 Nerd Font 的 Mono 变体，那么每个图标的显示宽度都是 1，你不须要开启它

**目录缩写配置**
nuprm 支持智能目录缩写功能，让长路径显示更加短。

- `directory_abbreviation.enabled: true` - 启用目录缩写
- `directory_abbreviation.enabled: false` - 禁用目录缩写

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
  - 例如设置为 3：`/home/username/.test/123456/demo/path` 会显示为 `~/.tes/123/demo/path`

- `directory_abbreviation.abbreviate_home: true` - 启用家目录缩写为 `~`
- `directory_abbreviation.abbreviate_home: false` - 禁用家目录缩写

- `directory_abbreviation.specific_mappings: {}` - 自定义特殊目录缩写
  - 您可以添加自定义目录缩写，例如将 `~/Documents` 设置为 `📄`，将家目录设置为 `🏠`
  > 如果你想要把家目录重新设置缩写显示，你必须禁用 `directory_abbreviation.abbreviate_home`

**显示元素配置**
- `display_elements.system_icon: true` - 显示系统图标
- `display_elements.system_icon: false` - 不显示系统图标

- `display_elements.hostname: true` - 显示主机名
- `display_elements.hostname: false` - 不显示主机名

- `display_elements.git: true` - 显示 Git 仓库信息
- `display_elements.git: false` - 不显示 Git 仓库信息

- `display_elements.shells: true` - 显示 Shells 信息
- `display_elements.shells: false` - 不显示 Shells 信息

- `display_elements.startup_time: true` - 显示启动时间（在运行时间信息的位置）
- `display_elements.startup_time: false` - 不显示启动时间（在运行时间信息的位置）

- `display_elements.execution_time: true` - 显示运行时间信息
- `display_elements.execution_time: false` - 不显示运行时间信息

- `display_elements.exit: true` - 显示退出码信息
- `display_elements.exit: false` - 不显示退出码信息

- `git.dirty: true` - 如果检测到未暂存的更改，在 Git 分支名称后附加 `*` 指示符。
- `git.dirty: false` - 即使检测到未暂存的更改，也不在 Git 分支名称后附加 `*` 指示符。

- `git.staged: true` - 如果检测到已暂存的更改，在分支名称后附加 `+` 指示符。
- `git.staged: false` - 即使检测到已暂存的更改，也不分支名称后附加 `+` 指示符。

#### 主题管理
您可以使用 `nuprm theme list` 命令来查看可用的主题：
> 使用 `nuprm theme list --preview` 可以预览提示符

```nushell
❯ nuprm theme list
# => ╭────┬───────────────────╮
# => │ #  │       name        │
# => ├────┼───────────────────┤
# => │ 0  │ azure.nu          │
# => │ 1  │ bubble.nu         │
# => │ 2  │ circuit.nu        │
# => │ 3  │ galaxy-dream.nu   │
# => │ 4  │ gxy.nu            │
# => │ 5  │ neon-night.nu     │
# => │ 6  │ power-blocks.nu   │
# => │ 7  │ retro-console.nu  │
# => │ 8  │ simple-minimal.nu │
# => │ 9  │ sunset-ocean.nu   │
# => │ 10 │ violet-line.nu    │
# => ╰────┴───────────────────╯
```

要设置主题，在您的环境配置文件中设置 `nuprm_theme` 常量：

```nushell
# 设置主题
const nuprm_theme = "~/.config/nuprm/themes/主题名称.nu"
```

修改配置后，重启 Nushell 会话或重新进入以使更改生效：

```nushell
exec $nu.current-exe
```

</details>

## 脚本报错？

<details>
  <summary>（如果脚本出现了报错请预览这里）</summary>

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

如果报错<br>``The `get` command doesn't have flag `-o`.``<br>那就是你的 Nushell 版本低于 0.105.0，你需要升级 Nushell 版本

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

如果报错<br>``Variable not found.``<br>那就是你没有设置 `nuprm_theme` 常量

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

如果报错<br>``Encountered error during parse-time evaluation``<br>那就是你把常量 `nuprm_theme` 设置为了变量

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

如果报错<br>``module ... not found``<br>那就是你常量 `nuprm_theme` 指向的文件不存在

</details>