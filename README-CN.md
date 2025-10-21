# Nushell Prompt Manager (nuprm)

### 概述
**nuprm** 是一个 Nushell 提示符主题管理器。它让您可以轻松地在不同的提示符主题之间切换，自定义 Nushell 提示符的外观，并通过简单的命令管理提示符配置。

### 安装
1. 将此仓库克隆到您的 .config 目录：
    ```nu
    git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

2. 在您的 Nushell 配置文件（`config nu`）中添加以下行：
    ```nu
    source ~/.config/nuprm/nuprm.nu
    ```

3. 在您的 Nushell 环境变量文件（`config env`）中添加以下行：
    ```nu
    const nuprm_theme = "~/.config/nuprm/themes/simple-minimal.nu"
    ```

4. 重启您的 Nushell 会话。
    ```nu
    exec $nu.current-exe
    ```

### 配置 nuprm
nuprm 现在通过环境变量进行配置。您需要在您的 Nushell 环境配置文件（`~/.config/nushell/env.nu`）中添加配置。

#### 基本配置结构
```nu
# 你可以使用这个 Nuprm 配置作为模板
const nuprm_theme = "~/.config/nuprm/themes/simple-minimal.nu"

$env.NUPRMCONFIG = {
    enabled: "yes",
    use_full_name: "yes",
    true_color: "yes",
    enable_path_url: "yes",
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
        shells: "yes"
    }
}
```

#### 配置选项说明

**启用 nuprm**
- `enabled: "yes"` - 启用 nuprm
- `enabled: "no"` - 禁用 nuprm

**显示全名**
- `use_full_name: "yes"` - 显示用户全名
- `use_full_name: "no"` - 显示用户名

**真彩色支持**
- `true_color: "yes"` - 启用真彩色支持
- `true_color: "no"` - 禁用真彩色支持

**路径 URL 支持**
- `enable_path_url: "yes"` - 启用路径 URL 支持
- `enable_path_url: "no"` - 禁用路径 URL 支持

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

#### 主题管理
您可以使用 `nuprm theme list` 命令来查看可用的主题：

```nu
❯ nuprm theme list
 #        name                   tag
─────────────────────────────────────────────────
 0   azure            Minimalist
 1   circuit          Multiple Lines
 2   galaxy-dream     Emoji, Multiple Lines
 3   gxy              Power Line, Multiple Lines
 4   neon-night       Multiple Lines
 5   power-blocks     Power Line
 6   retro-console    Retro
 7   simple-minimal   Minimalist
 8   sunset-ocean     Power Line, Multiple Lines
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
