# Claude Code Shell Completion

🇯🇵 [日本語版はこちら](README.ja.md)

Shell completion scripts for [Claude Code](https://claude.com/claude-code), providing tab completion for commands, subcommands, and options in bash, zsh, and [Nushell](https://www.nushell.sh/).

## Features

- **Command completion**: Tab complete `claude` subcommands (`agents`, `attach`, `logs`, `stop`, `kill`, `rm`, `respawn`, `auto-mode`, `auth`, `mcp`, `plugin`, `plugins`, `setup-token`, `doctor`, `gateway`, `import`, `update`, `upgrade`, `install`, `ultrareview`)
- **Option completion**: All CLI options and flags are completable
- **Contextual suggestions**: Option values are suggested where applicable
  - Output formats: `text`, `json`, `stream-json`
  - Permission modes: `acceptEdits`, `bypassPermissions`, `manual`, `dontAsk`, `plan`, `auto`
  - Models: `sonnet`, `opus`, `haiku`, etc.
  - Setting sources: `user`, `project`, `local`
  - Effort levels: `low`, `medium`, `high`, `xhigh`, `max`
  - Tool names: `Bash`, `Read`, `Edit`, `Agent`, `Skill`, etc. plus `default` (for `--tools`, `--allowedTools`, `--disallowedTools`)
- **File path completion**: For options that expect file paths (e.g., `--settings`, `--mcp-config`, `--add-dir`, `--file`, `--debug-file`)
- **Subcommand completion**: Full subcommand trees for `mcp` and `plugin` commands

## Quick Start

```bash
git clone https://github.com/hmmf022/cc-completion.git
cd cc-completion
```

### Bash

```bash
mkdir -p ~/.local/share/bash-completion/completions
ln -sf "$(pwd)/claude-completion.bash" ~/.local/share/bash-completion/completions/claude
source ~/.local/share/bash-completion/completions/claude
```

### Zsh

```bash
sudo ln -sf "$(pwd)/_claude" /usr/local/share/zsh/site-functions/_claude
autoload -Uz compinit && compinit
```

### Nushell

Add to your Nushell config file (`$nu.config-path`):
```nu
use /path/to/cc-completion/claude-completions.nu *
```

> For other installation methods (oh-my-zsh, system-wide bash, etc.), see [Installation Details](#installation-details) below.

<details>
<summary><h2>Installation Details</h2></summary>

### Bash

#### Method 1: System-wide installation

**Option A: Copy (simple)**
```bash
sudo cp claude-completion.bash /etc/bash_completion.d/claude
```
> Note: After updating the repository (e.g., `git pull`), you need to copy the file again.

**Option B: Symbolic link (recommended)**
```bash
sudo ln -sf "$(pwd)/claude-completion.bash" /etc/bash_completion.d/claude
```
> Note: Updates are reflected automatically via `git pull`. Do not delete or move the cloned repository.

Then reload your shell or run:
```bash
source /etc/bash_completion.d/claude
```

#### Method 2: User-level installation

```bash
mkdir -p ~/.local/share/bash-completion/completions
```

**Option A: Copy (simple)**
```bash
cp claude-completion.bash ~/.local/share/bash-completion/completions/claude
```
> Note: After updating the repository (e.g., `git pull`), you need to copy the file again.

**Option B: Symbolic link (recommended)**
```bash
ln -sf "$(pwd)/claude-completion.bash" ~/.local/share/bash-completion/completions/claude
```
> Note: Updates are reflected automatically via `git pull`. Do not delete or move the cloned repository.

Add to your `~/.bashrc`:
```bash
source ~/.local/share/bash-completion/completions/claude
```

#### Method 3: Manual sourcing

Add to your `~/.bashrc`:
```bash
source /path/to/claude-completion.bash
```

### Zsh

#### Method 1: System-wide installation

**Option A: Copy (simple)**
```bash
sudo cp _claude /usr/local/share/zsh/site-functions/_claude
```
> Note: After updating the repository (e.g., `git pull`), you need to copy the file again.

**Option B: Symbolic link (recommended)**
```bash
sudo ln -sf "$(pwd)/_claude" /usr/local/share/zsh/site-functions/_claude
```
> Note: Updates are reflected automatically via `git pull`. Do not delete or move the cloned repository.

Then reload completion:
```zsh
rm -f ~/.zcompdump; compinit
```

#### Method 2: User-level installation with oh-my-zsh

```bash
mkdir -p ~/.oh-my-zsh/custom/plugins/claude
```

**Option A: Copy (simple)**
```bash
cp _claude ~/.oh-my-zsh/custom/plugins/claude/_claude
```
> Note: After updating the repository (e.g., `git pull`), you need to copy the file again.

**Option B: Symbolic link (recommended)**
```bash
ln -sf "$(pwd)/_claude" ~/.oh-my-zsh/custom/plugins/claude/_claude
```
> Note: Updates are reflected automatically via `git pull`. Do not delete or move the cloned repository.

Add to your `~/.zshrc`:
```zsh
plugins=(... claude)
```

#### Method 3: Manual fpath

Add to your `~/.zshrc` before `compinit`:
```zsh
fpath=(/path/to/cc-completion $fpath)
autoload -Uz compinit && compinit
```

### Nushell

Add to your Nushell config file (`$nu.config-path`):
```nu
use /path/to/cc-completion/claude-completions.nu *
```
> Note: Replace `/path/to/cc-completion` with the actual path to this cloned repository.

</details>

## Usage Examples

After installation, you can use tab completion with the `claude` command:

```bash
# Complete subcommands
claude <TAB>
# Shows: agents attach logs stop kill rm respawn auto-mode auth mcp plugin plugins project setup-token doctor gateway import update upgrade install ultrareview

# Complete options
claude --<TAB>
# Shows: --debug --verbose --print --model --help ...

# Complete option values
claude --output-format <TAB>
# Shows: text json stream-json

claude --permission-mode <TAB>
# Shows: acceptEdits bypassPermissions manual dontAsk plan auto

claude --model <TAB>
# Shows: sonnet opus haiku fable best sonnet[1m] opus[1m] fable[1m] opusplan

claude --effort <TAB>
# Shows: low medium high xhigh max

claude --autocompact <TAB>
# Shows: auto 100k 200k 500k 1m

claude --system-prompt-snapshot <TAB>
# Shows: on off

claude --permission-prompts <TAB>
# Shows: host none

# Complete install targets
claude install <TAB>
# Shows: stable latest --force --help

# Complete import sources
claude import <TAB>
# Shows: codex gemini --dry-run --yes --help

# Complete auth subcommands
claude auth <TAB>
# Shows: login logout status

# Complete auth login options
claude auth login --<TAB>
# Shows: --claudeai --console --email --sso --help

# Complete auth status options
claude auth status --<TAB>
# Shows: --json --text --help

# Complete mcp subcommands
claude mcp <TAB>
# Shows: add add-from-claude-desktop add-json get list remove reset-project-choices serve login logout

# Complete mcp add options
claude mcp add --transport <TAB>
# Shows: stdio sse http

# Complete plugin subcommands
claude plugin <TAB>
# Shows: details disable enable eval init new install i list marketplace prune autoremove tag uninstall remove update validate

# File path completion
claude --settings <TAB>
# Shows files and directories
```

## Supported Commands

- `agents` - Manage background agents (with `--add-dir`, `--agent`, `--all`, `--allow-dangerously-skip-permissions`, `--cwd`, `--dangerously-skip-permissions`, `--effort`, `--json`, `--mcp-config`, `--model`, `--permission-mode`, `--plugin-dir`, `--restricted`, `--setting-sources`, `--settings`, `--strict-mcp-config` options)
- `attach` - Open a background session in this terminal
- `logs` - Print a background session's recent terminal output
- `stop` (`kill`) - Stop a background session, keeping its conversation
- `rm` - Delete a background session, and its worktree when that is safe (with `--discard-unpushed` option)
- `respawn` - Restart a background session so it runs the current Claude Code version (with `--all` option)
- `auto-mode` - Inspect or reset auto mode classifier configuration
  - `config` - Print the effective auto mode config as JSON
  - `critique` - Get AI feedback on your custom auto mode rules (with `--model` option)
  - `defaults` - Print the default auto mode environment, allow, soft_deny, and hard_deny rules as JSON (with `--label` option)
  - `reset` - Reset auto mode configuration to the shipped defaults (with `--yes` option)
- `auth` - Manage authentication
  - `login` - Sign in to your Anthropic account (with `--claudeai`, `--console`, `--email`, `--sso` options)
  - `logout` - Log out of your Anthropic account
  - `status` - Show current authentication status (with `--json`, `--text` options)
- `mcp` - Configure and manage MCP servers
  - `add` - Add an MCP server (with `--scope`, `--transport`, `--env`, `--header`, `--callback-port`, `--client-id`, `--client-secret` options)
  - `add-from-claude-desktop` - Import MCP servers from Claude Desktop (with `--scope` option)
  - `add-json` - Add an MCP server with a JSON string (with `--scope`, `--client-secret` options)
  - `get` - Get details about an MCP server
  - `list` - List configured MCP servers
  - `remove` - Remove an MCP server (with `--scope` option)
  - `reset-project-choices` - Reset all approved and rejected project-scoped servers
  - `serve` - Start the Claude Code MCP server
  - `login` - Authenticate with an MCP server (with `--no-browser` option)
  - `logout` - Clear stored OAuth credentials for an MCP server
- `plugin` - Manage Claude Code plugins
  - `details` - Show a plugin's component inventory and projected token cost
  - `disable` - Disable an enabled plugin (with `--all`, `--scope` options)
  - `enable` - Enable a disabled plugin (with `--scope` option)
  - `eval` - Run eval cases against a plugin and report scored results (with `--ablation`, `--allow-tools`, `--case`, `--eval-dir`, `--json`, `--judge-model`, `--keep-temp`, `--max-cost-usd`, `--mocks`, `--model`, `--no-publish`, `--no-scaffold`, `--output-dir`, `--publish-report`, `--report`, `--runs`, `--scaffold`, `--tag`, `--threshold`, `--verbose` options; `--json` optionally takes a `.json` output path)
    - `init` - Author an eval suite under the eval dir (`evals/` by default) via an interview (with `--bare`, `--eval-dir`, `--interactive` options)
  - `init` (`new`) - Scaffold a new plugin (with `--author`, `--author-email`, `--description`, `--force`, `--with` options)
  - `install` (`i`) - Install a plugin from available marketplaces (with `--config`, `--scope`, `--yes` options)
  - `list` - List installed plugins (with `--available`, `--json` options)
  - `marketplace` - Manage Claude Code marketplaces (`add`, `list`, `remove` (`rm`), `update`); `add` supports `--scope`, `--sparse`; `list` supports `--json`; `remove`/`rm` support `--scope`
  - `prune` (`autoremove`) - Remove auto-installed dependencies that are no longer needed (with `--dry-run`, `--scope`, `--yes` options)
  - `tag` - Create a `{name}--v{version}` git tag for a plugin release (with `--dry-run`, `--force`, `--message`, `--push`, `--remote` options)
  - `uninstall` (`remove`) - Uninstall an installed plugin (with `--keep-data`, `--prune`, `--scope`, `--yes` options)
  - `update` - Update a plugin to the latest version (with `--scope`, `--yes` options)
  - `validate` - Validate a plugin or marketplace manifest (with `--json`, `--strict` options)
- `project` - Manage Claude Code project state
  - `purge` - Delete all Claude Code state for a project (transcripts, tasks, file history, config entry) (with `--all`, `--dry-run`, `--interactive`, `--yes` options)
- `setup-token` - Set up a long-lived authentication token
- `doctor` - Check the health of your Claude Code installation
- `gateway` - Run the enterprise auth/telemetry gateway (with `--config` option)
- `import` - Import config from another AI coding agent (`codex`, `gemini`) into Claude Code (with `--dry-run`, `--yes` options)
- `update` - Check for updates and install if available
- `plugins` - Alias for `plugin`
- `upgrade` - Alias for `update`
- `install` - Install Claude Code native build (with `--force` option)
- `ultrareview` - Run a cloud-hosted multi-agent code review of the current branch (or a PR number / base branch) (with `--json`, `--post`, `--no-post`, `--timeout` options)

## Supported Options

All Claude Code CLI options are supported, including:

- Session management: `--continue`, `--resume`, `--fork-session`, `--from-pr`
- Model selection: `--model`, `--fallback-model`
- Output control: `--print`, `--output-format`, `--input-format`
- System prompt: `--system-prompt`, `--append-system-prompt`, `--system-prompt-snapshot`
- Permissions: `--permission-mode`, `--permission-prompts`, `--dangerously-skip-permissions`, `--restricted`
- Tools: `--tools`, `--allowed-tools`, `--disallowed-tools`
- MCP: `--mcp-config`, `--strict-mcp-config`
- File resources: `--file`
- Worktree: `--worktree`, `--tmux`
- Cloud sessions: `--cloud`, `--environment`, `--teleport`
- Background sessions: `--bg`, `--background` (and the `attach`, `logs`, `stop`, `rm`, `respawn` commands that take the id it prints)
- Context management: `--autocompact`
- Debugging: `--debug`, `--debug-file`
- And many more...

## Testing

To verify the installation:

```bash
# For bash
type _claude_completion

# For zsh
which _claude
```

For Nushell, verify the completions are loaded:
```nu
# Check if the external command is registered
help commands | where name =~ "claude"
```

Try tab completion:
```bash
claude --mod<TAB>
# Should complete to: claude --model
```

## Troubleshooting

### Bash completion not working

1. Ensure `bash-completion` package is installed:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install bash-completion

   # macOS (Homebrew)
   brew install bash-completion@2
   ```

2. Verify bash-completion is loaded in your shell:
   ```bash
   type _init_completion
   ```

### Zsh completion not working

1. Ensure `compinit` is called in your `~/.zshrc`:
   ```zsh
   autoload -Uz compinit && compinit
   ```

2. Rebuild completion cache:
   ```zsh
   rm -f ~/.zcompdump*; compinit
   ```

3. Verify the completion function is loaded:
   ```zsh
   which _claude
   ```

### Nushell completion not working

1. Ensure you are using Nushell 0.80 or later (required for `extern` completions):
   ```nu
   version
   ```

2. Check that the completions are registered:
   ```nu
   help commands | where name =~ "claude"
   ```

## Contributing

If you find missing commands or options, please update the completion scripts:

- For bash: Edit `claude-completion.bash`
- For zsh: Edit `_claude`
- For Nushell: Edit `claude-completions.nu`

## License

[MIT](LICENSE)
