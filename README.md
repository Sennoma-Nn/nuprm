# Nushell Prompt Manager (nuprm)

[English](#english) | [中文](#中文)

---

## English

### Overview

**nuprm** (Nushell Prompt Manager) is a powerful and flexible prompt theme manager for Nushell. It allows you to easily switch between different prompt themes, customize your terminal appearance, and manage prompt configurations with simple commands.

### Features

- 🎨 **Multiple Themes**: Choose from 8 beautiful pre-built themes
- 🔧 **Easy Management**: Simple commands to enable, disable, and switch themes
- ⚡ **Fast Switching**: Instant theme switching with automatic shell restart
- 📝 **Theme Descriptions**: View detailed information about each theme
- 🛠️ **Utility Functions**: Built-in helper functions for prompt customization
- 🎯 **VI Mode Support**: Full support for Nushell's VI editing mode
- 🖥️ **System Icons**: Display system-specific icons (Nerd Font required)
- 👤 **Full Name Display**: Option to show full user name instead of username

### Installation

1. Clone this repository to your Nushell configuration directory:
```bash
git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
```

2. Add the following line to your Nushell configuration file (`~/.config/nushell/config.nu`):
```nushell
source ~/.config/nuprm/nuprm.nu
```

3. Restart your Nushell session.

### Available Themes

| Theme Name | Author | Style |
|------------|--------|-------|
| `azure` | Sennoma-Nn | Minimalist |
| `power-blocks` | Sennoma-Nn | Power Line |
| `gxy` | Sennoma-Nn | Power Line, Multiple Lines |
| `neon-night` | Sennoma-Nn | Multiple Lines |
| `retro-console` | Sennoma-Nn | Retro |
| `simple-minimal` | Sennoma-Nn | Minimalist |
| `galaxy-dream` | Sennoma-Nn | Emoji, Multiple Lines |
| `sunset-ocean` | Sennoma-Nn | Power Line, Multiple Lines |

### Usage

#### Basic Commands

```nushell
# Show help information
nuprm --help

# List all available themes
nuprm list

# Set a specific theme
nuprm set theme <theme_name>

# Enable prompt themes
nuprm true

# Disable prompt themes
nuprm false

# Enable full name display
nuprm set full-name true

# Disable full name display
nuprm set full-name false

# Enable system icon display
nuprm set system-icon true

# Disable system icon display
nuprm set system-icon false
```

#### Examples

```nushell
# Switch to the neon-night theme
nuprm set theme neon-night

# Enable prompt theming
nuprm true

# View all available themes
nuprm list

# Disable prompt theming (use default)
nuprm false

# Enable full name display
nuprm set full-name true

# Enable system icon display
nuprm set system-icon true
```

### Configuration

The configuration file is automatically created at `~/.config/nuprm/config.yml` with the following structure:

```yaml
enable: "off"  # "on" or "off"
theme: "simple-minimal"  # default theme
use_full_name: "no"  # "yes" or "no"
disable_system_icon: "no"  # "yes" or "no"
```

### Utility Functions

The package includes several utility functions in `utils/prompt-utils.nu`:

- `home-to-tilde`: Convert home directory paths to tilde notation
- `get-git-info`: Retrieve current git branch information
- `get-where-shells`: Get current shell index information
- `color2ansi`: Convert RGB values to ANSI color codes
- `is-windows`: Check if running on Windows
- `is-android`: Check if running on Android
- `get-user-name`: Get current username (with full name support)
- `get-system-icon`: Get system-specific icons (Nerd Font) ⚠️ *Not fully tested*
- `get-config`: Get user configuration values

### Contributing

Contributions are welcome! Feel free to:
- Submit bug reports
- Request new themes
- Contribute new theme designs
- Improve documentation

---

## 中文

### 概述

**nuprm**（Nushell 提示符管理器）是一个强大而灵活的 Nushell 提示符主题管理器。它让您可以轻松地在不同的提示符主题之间切换，自定义终端外观，并通过简单的命令管理提示符配置。

### 特性

- 🎨 **多种主题**: 从 8 个精美的预制主题中选择
- 🔧 **简易管理**: 使用简单命令启用、禁用和切换主题
- ⚡ **快速切换**: 即时主题切换，自动重启 shell
- 📝 **主题描述**: 查看每个主题的详细信息
- 🛠️ **实用函数**: 内置的提示符自定义辅助函数
- 🎯 **VI 模式支持**: 完全支持 Nushell 的 VI 编辑模式
- 🖥️ **系统图标**: 显示系统特定图标（需要 Nerd Font）
- 👤 **全名显示**: 可选择显示完整用户名而非用户名

### 安装

1. 将此仓库克隆到您的 Nushell 配置目录：
```bash
git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
```

2. 在您的 Nushell 配置文件（`~/.config/nushell/config.nu`）中添加以下行：
```nushell
source ~/.config/nuprm/nuprm.nu
```

3. 重启您的 Nushell 会话。

### 可用主题

| 主题名称 | 作者 | 风格 |
|----------|------|------|
| `azure` | Sennoma-Nn | 极简主义 |
| `power-blocks` | Sennoma-Nn | Power Line |
| `gxy` | Sennoma-Nn | Power Line, 多行 |
| `neon-night` | Sennoma-Nn | 多行 |
| `retro-console` | Sennoma-Nn | 复古 |
| `simple-minimal` | Sennoma-Nn | 极简主义 |
| `galaxy-dream` | Sennoma-Nn | 表情符号, 多行 |
| `sunset-ocean` | Sennoma-Nn | Power Line, 多行 |

### 使用方法

#### 基本命令

```nushell
# 显示帮助信息
nuprm --help

# 列出所有可用主题
nuprm list

# 设置特定主题
nuprm set theme <主题名称>

# 启用提示符主题
nuprm true

# 禁用提示符主题
nuprm false

# 启用全名显示
nuprm set full-name true

# 禁用全名显示
nuprm set full-name false

# 启用系统图标显示
nuprm set system-icon true

# 禁用系统图标显示
nuprm set system-icon false
```

#### 示例

```nushell
# 切换到 neon-night 主题
nuprm set theme neon-night

# 启用提示符主题
nuprm true

# 查看所有可用主题
nuprm list

# 禁用提示符主题（使用默认）
nuprm false

# 启用全名显示
nuprm set full-name true

# 启用系统图标显示
nuprm set system-icon true
```

### 配置

配置文件会自动创建在 `~/.config/nuprm/config.yml`，结构如下：

```yaml
enable: "off"  # "on" 或 "off"
theme: "simple-minimal"  # 默认主题
use_full_name: "no"  # "yes" 或 "no"
disable_system_icon: "no"  # "yes" 或 "no"
```

### 实用函数

该包在 `utils/prompt-utils.nu` 中包含了几个实用函数：

- `home-to-tilde`: 将家目录路径转换为波浪号表示法
- `get-git-info`: 获取当前 git 分支信息
- `get-where-shells`: 获取当前 shell 索引信息
- `color2ansi`: 将 RGB 值转换为 ANSI 颜色代码
- `is-windows`: 检查是否在 Windows 上运行
- `is-android`: 检查是否在 Android 上运行
- `get-user-name`: 获取当前用户名（支持全名显示）
- `get-system-icon`: 获取系统特定图标（Nerd Font）⚠️ *未完全测试*
- `get-config`: 获取用户配置值

### 贡献

欢迎贡献！您可以：
- 提交错误报告
- 请求新主题
- 贡献新的主题设计
- 改进文档

---

## Repository

🔗 **GitHub**: [https://github.com/Sennoma-Nn/nuprm](https://github.com/Sennoma-Nn/nuprm)

---

*Made with ❤️ for the Nushell community*
