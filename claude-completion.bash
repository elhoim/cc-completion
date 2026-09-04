#!/usr/bin/env bash
# Bash completion script for Claude Code
# Install: source this file or place it in /etc/bash_completion.d/

_claude_completion() {
    local cur prev words cword
    _init_completion || return

    # Commands
    local commands="agents attach logs stop kill rm respawn auto-mode auth mcp plugin plugins project setup-token doctor gateway import update upgrade install ultrareview"

    # Global options
    local global_opts="
        --debug --debug-file --verbose --print --output-format --json-schema
        --include-hook-events --include-partial-messages --input-format --forward-subagent-text
        --dangerously-skip-permissions --allow-dangerously-skip-permissions
        --max-budget-usd --replay-user-messages --allowedTools --allowed-tools
        --tools --disallowedTools --disallowed-tools --mcp-config
        --system-prompt --append-system-prompt --system-prompt-snapshot
        --exclude-dynamic-system-prompt-sections
        --permission-mode --permission-prompts
        --continue --resume --fork-session --no-session-persistence
        --model --agent --betas --fallback-model --settings --add-dir
        --ide --strict-mcp-config --session-id --agents --setting-sources
        --plugin-dir --plugin-url --disable-slash-commands --chrome --no-chrome
        --from-pr --file --worktree --tmux --remote-control --remote-control-session-name-prefix
        --cloud --environment --teleport
        --ax-screen-reader --bare --brief --prompt-suggestions --safe-mode
        --restricted
        --autocompact --effort --version --help
        --bg --background
        --name
        -d -p -c -r -v -w -n -h
    "

    # Global options that consume the NEXT token as a value. Keep in sync with
    # the `case "$prev"` block below. Used to skip an option's value when
    # detecting the subcommand, so e.g. `claude --model opus mcp` finds `mcp`
    # rather than mistaking the value `opus` for the subcommand.
    local value_flags="
        --output-format --input-format --permission-mode --permission-prompts
        --model --fallback-model
        --setting-sources --effort --mcp-config --settings --plugin-dir --add-dir
        --file --debug-file --tools --allowedTools --allowed-tools
        --disallowedTools --disallowed-tools --json-schema --system-prompt
        --append-system-prompt --system-prompt-snapshot --agents --max-budget-usd --session-id
        --agent --betas --name -n --plugin-url --remote-control-session-name-prefix
        -d --debug --from-pr -r --resume -w --worktree --remote-control
        --prompt-suggestions --autocompact
        --cloud --environment --teleport
    "

    # Built-in tool names accepted by --tools / --allowedTools / --disallowedTools.
    # `--help` carries no full listing, so this mirrors the built-in tool set of
    # the claude release named in the commit message. Canonical names only -- the
    # older aliases (Task, BashOutput, KillShell, ...) still resolve at runtime
    # but are not offered here. "default" comes from the --tools help text
    # ('Use "" to disable all tools, "default" to use all tools').
    local tool_names="
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
        Artifact ArtifactCheck ArtifactComments ArtifactData ClaudeDesign DesignSync Projects
        SendUserFile SendFile SendFeedback SendUserMessage EndConversation
        ObserverReport StructuredOutput TestingPermission
        ShareOnboardingGuide ShowOnboardingRolePicker SuggestPluginInstall SuggestSkills
        default
    "

    # Handle subcommands. Skip the value of value-taking options so it is not
    # mistaken for the subcommand, and record where the subcommand was found
    # (cmd_idx) so the per-subcommand loops below start scanning after it.
    # Normalize newlines/tabs to spaces so end-of-line flags match the test.
    local _vf=" ${value_flags//[$'\n\t']/ } "
    local i cmd w cmd_idx=0
    for ((i=1; i < cword; i++)); do
        w=${words[i]}
        if [[ $w == -* ]]; then
            if [[ $_vf == *" $w "* ]] && [[ ${words[i+1]:-} != -* ]]; then
                ((++i))
            fi
            continue
        fi
        cmd=$w; cmd_idx=$i
        break
    done

    # Options whose value `--help` marks optional ("[value]" rather than
    # "<value>"). When the word at the cursor already starts with "-" the user is
    # typing the next option, not the value, so blank out prev: no case arm below
    # matches "", and completion falls through to the normal option dispatch.
    local optional_value_flags="
        -d --debug --from-pr -r --resume -w --worktree
        --remote-control --prompt-suggestions --json
        --cloud --teleport
    "
    local _ovf=" ${optional_value_flags//[$'\n\t']/ } "
    if [[ "$cur" == -* ]] && [[ $_ovf == *" $prev "* ]]; then
        prev=""
    fi

    # Option-specific value completion (must run before subcommand/global dispatch
    # to avoid the [[ -z $cmd ]] early-return short-circuiting these cases)
    case "$prev" in
        --output-format)
            COMPREPLY=($(compgen -W "text json stream-json" -- "$cur"))
            return 0
            ;;
        --input-format)
            COMPREPLY=($(compgen -W "text stream-json" -- "$cur"))
            return 0
            ;;
        --permission-mode)
            COMPREPLY=($(compgen -W "acceptEdits bypassPermissions manual dontAsk plan auto" -- "$cur"))
            return 0
            ;;
        # `--permission-prompts <target>` -- who answers permission prompts under
        # --print. A closed choice list; the permission mode still decides the rest.
        --permission-prompts)
            COMPREPLY=($(compgen -W "host none" -- "$cur"))
            return 0
            ;;
        --model|--fallback-model)
            COMPREPLY=($(compgen -W "sonnet opus haiku fable best sonnet[1m] opus[1m] fable[1m] opusplan" -- "$cur"))
            return 0
            ;;
        --setting-sources)
            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
            return 0
            ;;
        --effort)
            COMPREPLY=($(compgen -W "low medium high xhigh max" -- "$cur"))
            compopt -o nosort 2>/dev/null
            return 0
            ;;
        # `--autocompact <auto|tokens>` -- "auto, or 100k-1M tokens". Any value in
        # that range is accepted (500k / 200000 / 200 shorthand all parse), so
        # these are round-number hints, not an exhaustive choice list.
        --autocompact)
            COMPREPLY=($(compgen -W "auto 100k 200k 500k 1m" -- "$cur"))
            compopt -o nosort 2>/dev/null
            return 0
            ;;
        --prompt-suggestions)
            COMPREPLY=($(compgen -W "true false 1 0 yes no on off" -- "$cur"))
            return 0
            ;;
        --system-prompt-snapshot)
            COMPREPLY=($(compgen -W "on off" -- "$cur"))
            return 0
            ;;
        --mcp-config|--settings|--plugin-dir|--debug-file)
            _filedir
            return 0
            ;;
        --add-dir)
            # `--add-dir <directories...>` -- directories only.
            _filedir -d
            return 0
            ;;
        --tools|--allowedTools|--allowed-tools|--disallowedTools|--disallowed-tools)
            COMPREPLY=($(compgen -W "$tool_names" -- "$cur"))
            return 0
            ;;
        # --file takes "file_id:relative_path" specs, where file_id is a remote
        # resource id and relative_path is a download destination that does not
        # exist yet. Local path completion would be misleading, so offer none.
        --json-schema|--system-prompt|--append-system-prompt|--agents|\
        --worktree|--max-budget-usd|--session-id|--debug|-d|--from-pr|\
        -r|--resume|--agent|--betas|--name|-n|--plugin-url|--remote-control|\
        --cloud|--environment|--teleport|\
        --file)
            COMPREPLY=()
            return 0
            ;;
    esac

    # Variadic continuation: if the most recent option was a variadic file/tool
    # flag and the current word doesn't start with "-", keep completing values.
    # Handles both `--add-dir /a /b` and `--add-dir /a --add-dir /b`.
    if [[ "$cur" != -* ]]; then
        local j recent_flag=""
        for ((j=cword-1; j>=1; j--)); do
            if [[ ${words[j]} == -* ]]; then
                recent_flag=${words[j]}
                break
            fi
        done
        case "$recent_flag" in
            --mcp-config|--plugin-dir)
                _filedir
                return 0
                ;;
            --add-dir)
                _filedir -d
                return 0
                ;;
            --file)
                COMPREPLY=()
                return 0
                ;;
            --tools|--allowedTools|--allowed-tools|--disallowedTools|--disallowed-tools)
                COMPREPLY=($(compgen -W "$tool_names" -- "$cur"))
                return 0
                ;;
        esac
    fi

    # If we're completing the first argument (command or option)
    if [[ $cword -eq 1 ]] || [[ -z $cmd ]]; then
        case "$cur" in
            -*)
                COMPREPLY=($(compgen -W "$global_opts" -- "$cur"))
                return 0
                ;;
            *)
                COMPREPLY=($(compgen -W "$commands" -- "$cur"))
                return 0
                ;;
        esac
    fi

    # Subcommand-specific completion
    case "$cmd" in
        auth)
            local auth_cmds="login logout status"
            local auth_subcmd
            for ((i=cmd_idx+1; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    auth_subcmd=${words[i]}
                    break
                fi
            done
            case "$auth_subcmd" in
                login)
                    case "$prev" in
                        --email)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--claudeai --console --email --sso --help -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                logout)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                status)
                    COMPREPLY=($(compgen -W "--json --text --help -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$auth_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        mcp)
            local mcp_cmds="add add-from-claude-desktop add-json get list remove reset-project-choices serve login logout"
            local mcp_subcmd
            for ((i=cmd_idx+1; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    mcp_subcmd=${words[i]}
                    break
                fi
            done
            case "$mcp_subcmd" in
                add)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        -t|--transport)
                            COMPREPLY=($(compgen -W "stdio sse http" -- "$cur"))
                            ;;
                        -e|--env|-H|--header|--callback-port|--client-id)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --transport --env --header --callback-port --client-id --client-secret --help -s -t -e -H -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                add-from-claude-desktop)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                add-json)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --client-secret --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                get)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                remove)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "local user project" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                list)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                reset-project-choices)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                serve)
                    COMPREPLY=($(compgen -W "--debug --verbose --help -d -h" -- "$cur"))
                    ;;
                login)
                    COMPREPLY=($(compgen -W "--no-browser --help -h" -- "$cur"))
                    ;;
                logout)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$mcp_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        plugin|plugins)
            local plugin_cmds="details disable enable eval init new install i list marketplace prune autoremove tag uninstall remove update validate"
            local plugin_subcmd psub_idx=0
            for ((i=cmd_idx+1; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    plugin_subcmd=${words[i]}
                    psub_idx=$i
                    break
                fi
            done
            case "$plugin_subcmd" in
                marketplace)
                    local mp_subcmd
                    for ((i=psub_idx+1; i < cword; i++)); do
                        if [[ ${words[i]} != -* ]]; then
                            mp_subcmd=${words[i]}
                            break
                        fi
                    done
                    case "$mp_subcmd" in
                        "")
                            COMPREPLY=($(compgen -W "add list remove rm update --help -h" -- "$cur"))
                            ;;
                        add)
                            case "$prev" in
                                --scope)
                                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                                    ;;
                                --sparse)
                                    COMPREPLY=()
                                    ;;
                                *)
                                    COMPREPLY=($(compgen -W "--scope --sparse --help -h" -- "$cur"))
                                    ;;
                            esac
                            ;;
                        list)
                            COMPREPLY=($(compgen -W "--json --help -h" -- "$cur"))
                            ;;
                        remove|rm)
                            case "$prev" in
                                --scope)
                                    COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                                    ;;
                                *)
                                    COMPREPLY=($(compgen -W "--scope --help -h" -- "$cur"))
                                    ;;
                            esac
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                eval)
                    # Options that consume the next token as a value. Skipped so
                    # `claude plugin eval --eval-dir cases init` finds `init`
                    # rather than mistaking the value `cases` for the subcommand.
                    local eval_value_flags="
                        --ablation --allow-tools --case --eval-dir --json --judge-model
                        --max-cost-usd --mocks --model --output-dir --report --runs --tag --threshold
                    "
                    local _evf=" ${eval_value_flags//[$'\n\t']/ } "
                    local eval_subcmd
                    for ((i=psub_idx+1; i < cword; i++)); do
                        if [[ ${words[i]} == -* ]]; then
                            if [[ $_evf == *" ${words[i]} "* ]] && [[ ${words[i+1]:-} != -* ]]; then
                                ((++i))
                            fi
                            continue
                        fi
                        eval_subcmd=${words[i]}
                        break
                    done
                    case "$eval_subcmd" in
                        init)
                            case "$prev" in
                                --eval-dir)
                                    _filedir -d
                                    ;;
                                *)
                                    COMPREPLY=($(compgen -W "--bare --eval-dir --interactive --help -i -h" -- "$cur"))
                                    ;;
                            esac
                            ;;
                        *)
                            case "$prev" in
                                --ablation)
                                    COMPREPLY=($(compgen -W "none with-without" -- "$cur"))
                                    ;;
                                --mocks)
                                    COMPREPLY=($(compgen -W "record off" -- "$cur"))
                                    ;;
                                --model|--judge-model)
                                    COMPREPLY=($(compgen -W "sonnet opus haiku fable best sonnet[1m] opus[1m] fable[1m] opusplan" -- "$cur"))
                                    ;;
                                --output-dir|--eval-dir)
                                    _filedir -d
                                    ;;
                                --json|--report)
                                    _filedir
                                    ;;
                                --case|--tag|--allow-tools|--runs|--threshold|--max-cost-usd)
                                    COMPREPLY=()
                                    ;;
                                *)
                                    COMPREPLY=($(compgen -W "init --ablation --allow-tools --case --eval-dir --json --judge-model --keep-temp --max-cost-usd --mocks --model --no-publish --no-scaffold --output-dir --publish-report --report --runs --scaffold --tag --threshold --verbose --help -h" -- "$cur"))
                                    ;;
                            esac
                            ;;
                    esac
                    ;;
                install|i)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        --config)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--config --scope --yes --help -s -y -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                init|new)
                    case "$prev" in
                        --with)
                            COMPREPLY=($(compgen -W "skills agents hooks mcp lsp output-style channel" -- "$cur"))
                            ;;
                        --author|--author-email|--description)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--author --author-email --description --force --with --help -f -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                list)
                    COMPREPLY=($(compgen -W "--available --json --help -h" -- "$cur"))
                    ;;
                disable)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--all --scope --help -a -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                enable)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --help -s -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                uninstall|remove)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--keep-data --prune --scope --yes --help -s -y -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                prune|autoremove)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--dry-run --scope --yes --help -s -y -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                update)
                    case "$prev" in
                        -s|--scope)
                            COMPREPLY=($(compgen -W "user project local managed" -- "$cur"))
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--scope --yes --help -s -y -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                details)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                validate)
                    if [[ "$cur" == -* ]]; then
                        COMPREPLY=($(compgen -W "--json --strict --help -h" -- "$cur"))
                    else
                        # <path> is a plugin/marketplace manifest or its directory.
                        _filedir
                    fi
                    ;;
                tag)
                    case "$prev" in
                        -m|--message|--remote)
                            COMPREPLY=()
                            ;;
                        *)
                            if [[ "$cur" == -* ]]; then
                                COMPREPLY=($(compgen -W "--dry-run --force --message --push --remote --help -f -m -h" -- "$cur"))
                            else
                                _filedir -d
                            fi
                            ;;
                    esac
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$plugin_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        project)
            local project_cmds="purge"
            local project_subcmd
            for ((i=cmd_idx+1; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    project_subcmd=${words[i]}
                    break
                fi
            done
            case "$project_subcmd" in
                purge)
                    if [[ "$cur" == -* ]]; then
                        COMPREPLY=($(compgen -W "--all --dry-run --interactive --yes --help -i -y -h" -- "$cur"))
                    else
                        _filedir -d
                    fi
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$project_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        setup-token)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        doctor)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        gateway)
            case "$prev" in
                --config)
                    _filedir
                    ;;
                *)
                    COMPREPLY=($(compgen -W "--config --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        ultrareview)
            case "$prev" in
                --timeout)
                    COMPREPLY=()
                    ;;
                *)
                    COMPREPLY=($(compgen -W "--json --no-post --post --timeout --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        update|upgrade)
            COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
            ;;
        import)
            COMPREPLY=($(compgen -W "codex gemini --dry-run --yes --help -h" -- "$cur"))
            ;;
        install)
            COMPREPLY=($(compgen -W "stable latest --force --help -h" -- "$cur"))
            ;;
        agents)
            case "$prev" in
                --cwd)
                    _filedir -d
                    ;;
                *)
                    COMPREPLY=($(compgen -W "--add-dir --agent --all --allow-dangerously-skip-permissions --cwd --dangerously-skip-permissions --effort --json --mcp-config --model --permission-mode --plugin-dir --restricted --setting-sources --settings --strict-mcp-config --help -h" -- "$cur"))
                    ;;
            esac
            ;;
        # Background session commands. Their `--help` output is a hand-written
        # usage line with no `Options:` section, so the only flags any of them
        # documents are the ones spelled out in that usage line (`respawn --all`,
        # `rm --discard-unpushed`) -- not even -h/--help. <id> is the short id
        # `claude --bg` prints; it is runtime state, so no candidates.
        attach|logs|stop|kill)
            COMPREPLY=()
            ;;
        rm)
            case "$prev" in
                # `<commit>@<worktree-id>`, echoed by an earlier `claude rm <id>`.
                # Runtime state, so no candidates.
                --discard-unpushed)
                    COMPREPLY=()
                    ;;
                *)
                    if [[ "$cur" == -* ]]; then
                        COMPREPLY=($(compgen -W "--discard-unpushed" -- "$cur"))
                    else
                        COMPREPLY=()
                    fi
                    ;;
            esac
            ;;
        respawn)
            COMPREPLY=($(compgen -W "--all" -- "$cur"))
            ;;
        auto-mode)
            local automode_cmds="config critique defaults reset"
            local automode_subcmd
            for ((i=cmd_idx+1; i < cword; i++)); do
                if [[ ${words[i]} != -* ]]; then
                    automode_subcmd=${words[i]}
                    break
                fi
            done
            case "$automode_subcmd" in
                critique)
                    COMPREPLY=($(compgen -W "--model --help -h" -- "$cur"))
                    ;;
                defaults)
                    case "$prev" in
                        --label)
                            COMPREPLY=()
                            ;;
                        *)
                            COMPREPLY=($(compgen -W "--label --help -h" -- "$cur"))
                            ;;
                    esac
                    ;;
                config)
                    COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
                    ;;
                reset)
                    COMPREPLY=($(compgen -W "--yes --help -y -h" -- "$cur"))
                    ;;
                *)
                    COMPREPLY=($(compgen -W "$automode_cmds --help -h" -- "$cur"))
                    ;;
            esac
            ;;
    esac

    return 0
}

complete -F _claude_completion claude
# Support common alias 'cc'
complete -F _claude_completion cc
