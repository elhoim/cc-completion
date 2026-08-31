# Claude Code CLI completions for Nushell
# Translated from bash completion script

def "nu-complete claude commands" [] {
    [agents attach logs stop kill rm respawn auto-mode auth mcp plugin plugins project setup-token doctor gateway import update upgrade install ultrareview]
}

def "nu-complete claude output-format" [] {
    [text json stream-json]
}

def "nu-complete claude input-format" [] {
    [text stream-json]
}

def "nu-complete claude permission-mode" [] {
    [acceptEdits bypassPermissions manual dontAsk plan auto]
}

def "nu-complete claude eval-ablation" [] {
    [none with-without]
}

def "nu-complete claude eval-mocks" [] {
    [record off]
}

def "nu-complete claude models" [] {
    [sonnet opus haiku fable best "sonnet[1m]" "opus[1m]" "fable[1m]" opusplan]
}

def "nu-complete claude effort" [] {
    [low medium high xhigh max]
}

def "nu-complete claude scope" [] {
    [local user project]
}

def "nu-complete claude scope-with-managed" [] {
    [local user project managed]
}

def "nu-complete claude transport" [] {
    [stdio sse http]
}

def "nu-complete claude install-channel" [] {
    [stable latest]
}

def "nu-complete claude import-source" [] {
    [codex gemini]
}

# `--autocompact <auto|tokens>` accepts "auto" or any window in the documented
# 100k-1M range (500k / 200000 / 200 shorthand all parse), so these are
# round-number hints rather than a closed choice list.
def "nu-complete claude autocompact" [] {
    [auto 100k 200k 500k 1m]
}

def "nu-complete claude bool" [] {
    [true false 1 0 yes no on off]
}

def "nu-complete claude plugin-component" [] {
    [skills agents hooks mcp lsp output-style channel]
}

# Built-in tool names accepted by --tools / --allowedTools / --disallowedTools.
# `--help` carries no full listing, so this mirrors the built-in tool set of the
# claude release named in the commit message. Canonical names only -- the older
# aliases (Task, BashOutput, KillShell, ...) still resolve at runtime but are not
# offered here. "default" comes from the --tools help text ('Use "" to disable
# all tools, "default" to use all tools').
def "nu-complete claude tools" [] {
    [
        Bash PowerShell REPL
        Read Write Edit NotebookEdit Glob Grep LSP
        WebFetch WebSearch
        Agent ListAgents Skill SendMessage Workflow ToolSearch
        TaskCreate TaskGet TaskList TaskOutput TaskStop TaskUpdate
        Monitor CronCreate CronDelete CronList ScheduleWakeup RemoteTrigger PushNotification ReadNotifications Poll
        EnterWorktree ExitWorktree
        TodoWrite AskUserQuestion EnterPlanMode ExitPlanMode ReportFindings ProposeGoal
        ListMcpResourcesTool ReadMcpResourceTool ReadMcpResourceDirTool RefreshMcpTools
        SearchMcpRegistry WaitForMcpServers ListConnectors SuggestConnectors
        Artifact ClaudeDesign DesignSync Projects
        SendUserFile SendFile SendFeedback SendUserMessage EndConversation
        ObserverReport StructuredOutput TestingPermission
        ShareOnboardingGuide ShowOnboardingRolePicker SuggestPluginInstall SuggestSkills
        default
    ]
}

# Nushell externs cannot express a named flag whose value is optional: giving a
# flag a type makes the value mandatory, omitting it makes the flag a switch. So
# the options `--help` writes as "[value]" (-d/--debug, -r/--resume, --from-pr,
# -w/--worktree, --remote-control, --prompt-suggestions, plugin eval --json) are
# declared here in whichever of the two forms matches their common usage. The
# bash and zsh scripts do model the optional value.

# Claude Code - starts an interactive session by default, use -p/--print for non-interactive output
export extern claude [
    --debug(-d)                                             # Enable debug mode
    --debug-file: path                                      # Debug output file
    --verbose                                               # Verbose output
    --print(-p)                                             # Print mode
    --output-format: string@"nu-complete claude output-format"  # Output format
    --json-schema: string                                   # JSON schema
    --include-hook-events                                    # Include hook lifecycle events
    --include-partial-messages                               # Include partial messages
    --forward-subagent-text                                  # Forward subagent text and thinking blocks as assistant/user messages
    --input-format: string@"nu-complete claude input-format"    # Input format
    --dangerously-skip-permissions                          # Skip permissions (dangerous)
    --allow-dangerously-skip-permissions                    # Allow skip permissions
    --max-budget-usd: number                                # Max budget in USD
    --replay-user-messages                                  # Replay user messages
    --allowedTools: string@"nu-complete claude tools"       # Allowed tools (deprecated)
    --allowed-tools: string@"nu-complete claude tools"      # Allowed tools
    --tools: string@"nu-complete claude tools"              # Tools
    --disallowedTools: string@"nu-complete claude tools"    # Disallowed tools (deprecated)
    --disallowed-tools: string@"nu-complete claude tools"   # Disallowed tools
    --mcp-config: path                                      # MCP config file
    --system-prompt: string                                 # System prompt
    --append-system-prompt: string                          # Append system prompt
    --exclude-dynamic-system-prompt-sections                # Move per-machine sections to first user message (default system prompt only)
    --permission-mode: string@"nu-complete claude permission-mode"  # Permission mode
    --continue(-c)                                          # Continue last session
    --resume(-r): string                                    # Resume session by ID
    --fork-session                                          # Fork session
    --no-session-persistence                                # Disable session persistence
    --model: string@"nu-complete claude models"             # Model to use
    --agent: string                                         # Agent name
    --betas: string                                         # Beta features
    --fallback-model: string@"nu-complete claude models"    # Fallback model
    --settings: path                                        # Settings file
    --add-dir: path                                         # Additional directory
    --ide                                                    # Automatically connect to IDE on startup
    --strict-mcp-config                                     # Strict MCP config
    --session-id: string                                    # Session ID
    --agents: string                                        # Agents config
    --setting-sources: string@"nu-complete claude scope"    # Setting sources
    --plugin-dir: path                                      # Plugin directory
    --plugin-url: string                                    # Fetch a plugin .zip from a URL for this session only
    --disable-slash-commands                                 # Disable all skills
    --chrome                                                # Enable Chrome
    --no-chrome                                             # Disable Chrome
    --background                                            # Start the session as a background agent
    --bg                                                    # Start the session as a background agent (alias)
    --from-pr: string                                       # From PR
    --file: string                                          # File resources (file_id:relative_path)
    --worktree(-w): string                                  # Git worktree
    --tmux                                                  # Tmux mode
    --cloud: string                                         # Create a cloud session (description, session ID, or claude.ai/code URL)
    --environment: string                                   # Create a cloud session on the given self-hosted environment (ccpool_...)
    --teleport: string                                      # Resume a teleport session, optionally specify session ID
    --ax-screen-reader                                      # Render screen-reader friendly output (flat text, no decorative borders or animations)
    --bare                                                  # Minimal mode: skip hooks, LSP, and auto-discovery
    --safe-mode                                             # Start with all customizations disabled (troubleshooting)
    --restricted                                            # Restricted mode: drop code-running tools and WebFetch, ignore user/project/local settings
    --brief                                                 # Enable SendUserMessage tool for agent-to-user communication
    --prompt-suggestions: string@"nu-complete claude bool"  # Enable prompt suggestions
    --remote-control: string                                # Start an interactive session with Remote Control enabled (optionally named)
    --remote-control-session-name-prefix: string            # Remote Control session name prefix
    --autocompact: string@"nu-complete claude autocompact"  # Auto-compact window size (auto, or 100k-1M tokens)
    --effort: string@"nu-complete claude effort"            # Effort level
    --name(-n): string                                      # Name for the conversation
    --version(-v)                                           # Show version
    --help(-h)                                              # Show help
    ...args: string                                         # Command or prompt
]

# --- auth ---

# Manage authentication
export extern "claude auth" [
    --help(-h)
    ...args: string
]

# Sign in to your Anthropic account
export extern "claude auth login" [
    --claudeai          # Use Claude subscription (default)
    --console           # Use Anthropic Console (API usage billing)
    --email: string     # Pre-populate email address on the login page
    --sso               # Force SSO login flow
    --help(-h)
]

# Log out from your Anthropic account
export extern "claude auth logout" [
    --help(-h)
]

def "nu-complete claude auth-status-format" [] {
    [json text]
}

# Show authentication status
export extern "claude auth status" [
    --json               # Output as JSON
    --text               # Output as text
    --help(-h)
]

# --- mcp ---

# Configure and manage MCP servers
export extern "claude mcp" [
    --help(-h)
    ...args: string
]

# Add an MCP server to Claude Code
export extern "claude mcp add" [
    --scope(-s): string@"nu-complete claude scope"              # Scope
    --transport(-t): string@"nu-complete claude transport"      # Transport type
    --env(-e): string                                           # Environment variable
    --header(-H): string                                        # Header
    --callback-port: int                                        # Callback port
    --client-id: string                                         # Client ID
    --client-secret                                              # Client secret (interactive prompt)
    --help(-h)
    ...args: string
]

# Import MCP servers from Claude Desktop (Mac and WSL only)
export extern "claude mcp add-from-claude-desktop" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Add an MCP server (stdio or SSE) with a JSON string
export extern "claude mcp add-json" [
    --scope(-s): string@"nu-complete claude scope"
    --client-secret                                              # Client secret (interactive prompt)
    --help(-h)
    ...args: string
]

# Get details about an MCP server
export extern "claude mcp get" [
    --help(-h)
    ...args: string
]

# List configured MCP servers
export extern "claude mcp list" [
    --help(-h)
]

# Remove an MCP server
export extern "claude mcp remove" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Reset all approved and rejected project-scoped (.mcp.json) servers
export extern "claude mcp reset-project-choices" [
    --help(-h)
]

# Start the Claude Code MCP server
export extern "claude mcp serve" [
    --debug(-d)
    --verbose
    --help(-h)
]

# Authenticate with an MCP server (HTTP, SSE, or claude.ai connector)
export extern "claude mcp login" [
    --no-browser                                            # Print the authorization URL instead of opening a browser
    --help(-h)
    ...args: string
]

# Clear stored OAuth credentials for an MCP server
export extern "claude mcp logout" [
    --help(-h)
    ...args: string
]

# --- plugin ---

# Manage Claude Code plugins
export extern "claude plugin" [
    --help(-h)
    ...args: string
]

# Show a plugin's component inventory and projected token cost
export extern "claude plugin details" [
    --help(-h)
    ...args: string
]

# Disable an enabled plugin
export extern "claude plugin disable" [
    --all(-a)                                               # Disable all enabled plugins
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Enable a disabled plugin
export extern "claude plugin enable" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Run eval cases against a plugin and report scored results
export extern "claude plugin eval" [
    --ablation: string@"nu-complete claude eval-ablation"   # Run a no-plugin baseline arm and report the score delta
    --allow-tools: string@"nu-complete claude tools"        # Operator grant for gated tools (repeatable)
    --case: string                                          # Filter cases by name glob
    --eval-dir: path                                        # Directory (below the plugin) that holds the eval cases
    --json                                                  # Print the full run result as JSON to stdout
    --judge-model: string@"nu-complete claude models"       # Override LLM-grader model (default: haiku)
    --keep-temp                                             # Preserve scaffold dirs for debugging
    --max-cost-usd: string                                  # Optional hard cost ceiling
    --mocks: string@"nu-complete claude eval-mocks"         # Mock stand-ins for MCP servers, from the eval dir mocks/
    --model: string@"nu-complete claude models"             # Override model for all cases
    --no-publish                                           # Keep the HTML report local only; skip publishing to claude.ai
    --no-scaffold                                          # Explicitly skip scaffold_script
    --output-dir: path                                      # Directory for aggregate-result.json
    --publish-report                                        # Also require publishing the report to claude.ai (already the default)
    --report: path                                          # Write a self-contained HTML report
    --runs: int                                             # Override per-case runs (default: case.runs ?? 3)
    --scaffold                                             # Run each case's scaffold_script
    --tag: string                                          # Filter cases by tag (repeatable)
    --threshold: string                                     # Exit 1 if any case score is below this threshold
    --verbose                                              # Log per-message trace events to the debug log
    --help(-h)
    target?: string                                         # Path, plugin name, or plugin@marketplace id
]

# Author an eval suite under the eval dir via an interview
export extern "claude plugin eval init" [
    --bare                                                 # Write a blank template instead of running the interview
    --eval-dir: path                                        # Directory to write cases into
    --interactive(-i)                                      # Run the authoring interview (already the default in a terminal)
    --help(-h)
    name?: string                                           # Eval suite name
]

# Scaffold a new plugin
export extern "claude plugin init" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Scaffold a new plugin (alias for init)
export extern "claude plugin new" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Install a plugin from available marketplaces
export extern "claude plugin install" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# List installed plugins
export extern "claude plugin list" [
    --available                                             # Include available plugins from marketplaces (requires --json)
    --json                                                  # Output as JSON
    --help(-h)
]

# Manage Claude Code marketplaces
export extern "claude plugin marketplace" [
    --help(-h)
    ...args: string
]

# Add a marketplace
export extern "claude plugin marketplace add" [
    --scope: string@"nu-complete claude scope"              # Where to declare the marketplace
    --sparse: string                                         # Limit checkout to specific directories
    --help(-h)
    ...args: string
]

# List configured marketplaces
export extern "claude plugin marketplace list" [
    --json
    --help(-h)
]

# Remove a marketplace
export extern "claude plugin marketplace remove" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# Update a marketplace
export extern "claude plugin marketplace update" [
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin
export extern "claude plugin uninstall" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove auto-installed dependencies that are no longer needed
export extern "claude plugin prune" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Remove auto-installed dependencies (alias for prune)
export extern "claude plugin autoremove" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Update a plugin to the latest version
export extern "claude plugin update" [
    --scope(-s): string@"nu-complete claude scope-with-managed"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (changed install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# Validate a plugin or marketplace manifest
export extern "claude plugin validate" [
    --strict                                                # Treat warnings as errors (exit 1)
    --help(-h)
    path: path                                              # Plugin or marketplace manifest path
]

# Create a {name}--v{version} git tag for a plugin release
export extern "claude plugin tag" [
    --dry-run                                               # Print what would be tagged without creating it
    --force(-f)                                             # Skip dirty-working-tree and tag-already-exists checks
    --message(-m): string                                   # Tag annotation message (use %s for the version)
    --push                                                  # Push the tag to --remote after creating it
    --remote: string                                        # Remote to push to with --push (default: "origin")
    --help(-h)
    path?: path                                             # Plugin directory path
]

# Install a plugin (alias for install)
export extern "claude plugin i" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin (alias for uninstall)
export extern "claude plugin remove" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove a marketplace (alias for remove)
export extern "claude plugin marketplace rm" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# --- plugins (alias for plugin) ---

# Manage Claude Code plugins
export extern "claude plugins" [
    --help(-h)
    ...args: string
]

# Show a plugin's component inventory and projected token cost
export extern "claude plugins details" [
    --help(-h)
    ...args: string
]

# Disable an enabled plugin
export extern "claude plugins disable" [
    --all(-a)                                               # Disable all enabled plugins
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Enable a disabled plugin
export extern "claude plugins enable" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Run eval cases against a plugin and report scored results
export extern "claude plugins eval" [
    --ablation: string@"nu-complete claude eval-ablation"   # Run a no-plugin baseline arm and report the score delta
    --allow-tools: string@"nu-complete claude tools"        # Operator grant for gated tools (repeatable)
    --case: string                                          # Filter cases by name glob
    --eval-dir: path                                        # Directory (below the plugin) that holds the eval cases
    --json                                                  # Print the full run result as JSON to stdout
    --judge-model: string@"nu-complete claude models"       # Override LLM-grader model (default: haiku)
    --keep-temp                                             # Preserve scaffold dirs for debugging
    --max-cost-usd: string                                  # Optional hard cost ceiling
    --mocks: string@"nu-complete claude eval-mocks"         # Mock stand-ins for MCP servers, from the eval dir mocks/
    --model: string@"nu-complete claude models"             # Override model for all cases
    --no-publish                                           # Keep the HTML report local only; skip publishing to claude.ai
    --no-scaffold                                          # Explicitly skip scaffold_script
    --output-dir: path                                      # Directory for aggregate-result.json
    --publish-report                                        # Also require publishing the report to claude.ai (already the default)
    --report: path                                          # Write a self-contained HTML report
    --runs: int                                             # Override per-case runs (default: case.runs ?? 3)
    --scaffold                                             # Run each case's scaffold_script
    --tag: string                                          # Filter cases by tag (repeatable)
    --threshold: string                                     # Exit 1 if any case score is below this threshold
    --verbose                                              # Log per-message trace events to the debug log
    --help(-h)
    target?: string                                         # Path, plugin name, or plugin@marketplace id
]

# Author an eval suite under the eval dir via an interview
export extern "claude plugins eval init" [
    --bare                                                 # Write a blank template instead of running the interview
    --eval-dir: path                                        # Directory to write cases into
    --interactive(-i)                                      # Run the authoring interview (already the default in a terminal)
    --help(-h)
    name?: string                                           # Eval suite name
]

# Scaffold a new plugin
export extern "claude plugins init" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Scaffold a new plugin (alias for init)
export extern "claude plugins new" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Install a plugin from available marketplaces
export extern "claude plugins install" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# List installed plugins
export extern "claude plugins list" [
    --available                                             # Include available plugins from marketplaces (requires --json)
    --json                                                  # Output as JSON
    --help(-h)
]

# Manage Claude Code marketplaces
export extern "claude plugins marketplace" [
    --help(-h)
    ...args: string
]

# Add a marketplace
export extern "claude plugins marketplace add" [
    --scope: string@"nu-complete claude scope"              # Where to declare the marketplace
    --sparse: string                                         # Limit checkout to specific directories
    --help(-h)
    ...args: string
]

# List configured marketplaces
export extern "claude plugins marketplace list" [
    --json
    --help(-h)
]

# Remove a marketplace
export extern "claude plugins marketplace remove" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# Update a marketplace
export extern "claude plugins marketplace update" [
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin
export extern "claude plugins uninstall" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove auto-installed dependencies that are no longer needed
export extern "claude plugins prune" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Remove auto-installed dependencies (alias for prune)
export extern "claude plugins autoremove" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Update a plugin to the latest version
export extern "claude plugins update" [
    --scope(-s): string@"nu-complete claude scope-with-managed"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (changed install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# Validate a plugin or marketplace manifest
export extern "claude plugins validate" [
    --strict                                                # Treat warnings as errors (exit 1)
    --help(-h)
    path: path                                              # Plugin or marketplace manifest path
]

# Create a {name}--v{version} git tag for a plugin release
export extern "claude plugins tag" [
    --dry-run                                               # Print what would be tagged without creating it
    --force(-f)                                             # Skip dirty-working-tree and tag-already-exists checks
    --message(-m): string                                   # Tag annotation message (use %s for the version)
    --push                                                  # Push the tag to --remote after creating it
    --remote: string                                        # Remote to push to with --push (default: "origin")
    --help(-h)
    path?: path                                             # Plugin directory path
]

# Install a plugin (alias for install)
export extern "claude plugins i" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Accept the displayed marketplace-declared command (install or headersHelper) without the confirmation prompt
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin (alias for uninstall)
export extern "claude plugins remove" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove a marketplace (alias for remove)
export extern "claude plugins marketplace rm" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# --- project ---

# Manage Claude Code project state
export extern "claude project" [
    --help(-h)
    ...args: string
]

# Delete all Claude Code state for a project (transcripts, tasks, file history, config entry)
export extern "claude project purge" [
    --all                  # Purge state for every project (mutually exclusive with [path])
    --dry-run              # List what would be deleted without deleting anything
    --interactive(-i)      # Prompt for each item before deleting
    --yes(-y)              # Skip confirmation prompt
    --help(-h)
    path?: path            # Project directory path
]

# --- agents ---

# Manage background agents
export extern "claude agents" [
    --add-dir: path                                         # Additional directory to allow tool access (repeatable)
    --agent: string                                         # Default agent for dispatched sessions
    --all                                                   # With --json: also include completed background sessions
    --allow-dangerously-skip-permissions                    # Make bypass-permissions mode available to dispatched sessions
    --cwd: path                                             # Show only background sessions started under path
    --dangerously-skip-permissions                          # Alias for --permission-mode bypassPermissions
    --effort: string@"nu-complete claude effort"            # Default effort level for dispatched sessions
    --json                                                  # Print active sessions (interactive and background) as a JSON array and exit
    --mcp-config: path                                      # MCP server configuration (repeatable)
    --model: string@"nu-complete claude models"             # Default model for dispatched sessions
    --permission-mode: string@"nu-complete claude permission-mode"  # Default permission mode for dispatched sessions
    --plugin-dir: path                                      # Load plugins from directory (repeatable)
    --restricted                                            # Start dispatched sessions in restricted mode
    --setting-sources: string@"nu-complete claude scope"    # Setting sources
    --settings: path                                        # Settings file or JSON string
    --strict-mcp-config                                     # Only use MCP servers from --mcp-config
    --help(-h)
]

# --- background sessions ---
# `--help` for these is a hand-written usage line with no `Options:` section, so
# `respawn --all` is the only flag any of them documents. <id> is the short id
# that `claude --bg` prints and `claude agents` lists.

# Open a background session in this terminal
export extern "claude attach" [
    --help(-h)
    id?: string                                             # Background session id
]

# Print the recent terminal output of a background session
export extern "claude logs" [
    --help(-h)
    id?: string                                             # Background session id
]

# Stop a background session, keeping its conversation
export extern "claude stop" [
    --help(-h)
    id?: string                                             # Background session id
]

# Stop a background session, keeping its conversation (alias for stop)
export extern "claude kill" [
    --help(-h)
    id?: string                                             # Background session id
]

# Delete a background session, and its worktree when that is safe
export extern "claude rm" [
    --help(-h)
    id?: string                                             # Background session id
]

# Restart a background session so it runs the current Claude Code version
export extern "claude respawn" [
    --all                                                   # Restart every background session
    --help(-h)
    id?: string                                             # Background session id
]

# --- setup-token ---

# Set up a long-lived authentication token (requires Claude subscription)
export extern "claude setup-token" [
    --help(-h)
]

# --- doctor ---

# Check the health of your Claude Code installation
export extern "claude doctor" [
    --help(-h)
]

# --- gateway ---

# Run the enterprise auth/telemetry gateway
export extern "claude gateway" [
    --config: path                                          # Path to gateway YAML config
    --help(-h)
]

# --- import ---

# Import config from another AI coding agent into Claude Code
export extern "claude import" [
    --dry-run                                               # Show what would be imported without writing anything
    --yes                                                   # Skip the interactive picker
    --help(-h)
    source?: string@"nu-complete claude import-source"      # Which agent to import from
]

# --- update / upgrade ---

# Check for updates and install if available
export extern "claude update" [
    --help(-h)
]

# Check for updates and install if available
export extern "claude upgrade" [
    --help(-h)
]

# --- install ---

# Install Claude Code native build
export extern "claude install" [
    --force
    --help(-h)
    channel?: string@"nu-complete claude install-channel"   # Install channel
]

# --- auto-mode ---

# Inspect or reset auto mode classifier configuration
export extern "claude auto-mode" [
    --help(-h)
    ...args: string
]

# Print the effective auto mode config as JSON
export extern "claude auto-mode config" [
    --help(-h)
]

# Get AI feedback on your custom auto mode rules
export extern "claude auto-mode critique" [
    --model: string@"nu-complete claude models"             # Model for the critique
    --help(-h)
]

# Print the default auto mode environment, allow, soft_deny, and hard_deny rules as JSON
export extern "claude auto-mode defaults" [
    --label: string                                         # Show only rules whose label starts with this prefix
    --help(-h)
]

# Reset auto mode configuration to the shipped defaults
export extern "claude auto-mode reset" [
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# --- ultrareview ---

# Run a cloud-hosted multi-agent code review of the current branch (or a PR number / base branch)
export extern "claude ultrareview" [
    --json                                                  # Print the raw bugs.json payload instead of formatted findings
    --no-post                                               # Do not post the findings to the PR (the default)
    --post                                                  # Post the finished review's findings to the PR as you (PR targets only)
    --timeout: int                                          # Maximum minutes to wait for the review to finish (default: 30)
    --help(-h)
    target?: string                                         # PR number, branch, or other target
]
