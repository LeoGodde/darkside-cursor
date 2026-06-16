# Guia de Migração: Claude Code → Cursor

Este documento descreve todas as diferenças entre o plugin Darkside para Claude Code e a adaptação para Cursor. Use como checklist ao portar alterações de um projeto para o outro.

---

## Formato dos arquivos

| Claude Code | Cursor |
|-------------|--------|
| `skills/<nome>/SKILL.md` | `.cursor/rules/<nome>.mdc` |
| Frontmatter: `name`, `description` | Frontmatter: `description`, `globs`, `alwaysApply` |
| Arquivo de regras compartilhadas: `skills/_shared-rules.md` referenciado por texto | Shared rules embutidas no topo de cada `.mdc` (Cursor não suporta include) |

### Frontmatter — de/para

**Claude Code:**
```yaml
---
name: explore
description: Deep exploration of the project...
---
```

**Cursor:**
```yaml
---
description: "Darkside /explore — Deep exploration of the project..."
globs:
alwaysApply: false
---
```

Regras:
- `name` não existe no Cursor — o nome do arquivo é o identificador
- `description` no Cursor deve começar com `"Darkside /nome —"` para facilitar o roteamento
- `globs` fica vazio (as skills não são atreladas a tipos de arquivo)
- `alwaysApply: false` para todas as skills, exceto `darkside.mdc` que usa `alwaysApply: true`

---

## Shared Rules

No Claude Code, cada skill referencia `skills/_shared-rules.md` com a frase:

```
**Follow Shared Rules** from `skills/_shared-rules.md`.
```

No Cursor, essa referência é substituída pelo conteúdo completo das shared rules, colado como seção `## Shared Rules` logo após o título principal de cada skill.

**Ao atualizar `_shared-rules.md` no Claude Code, copie as alterações para dentro de cada `.mdc` no Cursor.**

O bloco a ser replicado:

```markdown
## Shared Rules

- All messages to the user are in Brazilian Portuguese
- All generated files are written in English
- One question or block at a time — never ask two questions in the same message
- Wait for the user's answer before continuing
- One follow-up allowed if the answer is ambiguous — do not interrogate
- Never propose code during discovery conversations
- If the user stops mid-session, preserve the partial file with its "in progress" header — do not delete it
- Always write each section to the file before moving to the next
- Communication is simple, direct, and easy to understand — no unnecessary jargon, without compromising technical precision

### Filename Derivation

When a skill says "derive filename", apply these steps:

1. Lowercase
2. Remove accents (`ã` → `a`, `ç` → `c`)
3. Spaces → `-`
4. Remove non-alphanumeric except `-`
5. Collapse consecutive `-`
6. Prepend `YYYY-MM-DD-`
7. Append the suffix specified by the skill

### Prerequisite Check

When a skill says "check prerequisite [path]", do:

- If the file/directory does not exist: say the message specified by the skill and stop
- If it exists: read it in full and use as context throughout the session
```

Nota: a regra `Never propose code during discovery conversations` só aparece nas skills de discovery (quest, war-room, interrogate, mission). Nas skills de execução (order66, inquisitor, sith-agents, verdict) ela é omitida.

---

## Roteamento de comandos /skill-name

No Claude Code, os slash commands são nativos — o sistema registra cada skill em `~/.claude/commands/` e oferece autocomplete.

No Cursor, a `darkside.mdc` (`alwaysApply: true`) contém uma tabela de roteamento que instrui o modelo a tratar mensagens com `/nome` como invocação de skills. **Não há autocomplete** — o usuário precisa saber o nome ou usar `/guide`.

Se uma nova skill for adicionada ao Claude Code:
1. Criar o `.mdc` correspondente
2. Adicionar uma linha na tabela de roteamento em `darkside.mdc`
3. Adicionar na tabela de skills em `darkside.mdc` e `guide.mdc`
4. Adicionar o nome no array `SKILLS` em `uninstall.sh`

---

## Features do Claude Code não disponíveis no Cursor

### TaskCreate / TaskUpdate

O Claude Code tem um sistema nativo de tarefas (TaskCreate, TaskUpdate, TaskList). O Cursor não tem equivalente.

**O que fazer:** remover qualquer referência a TaskCreate/TaskUpdate ao portar. Se a skill usa tarefas para tracking interno (como order66 nas fases), substituir por instruções textuais diretas.

### Agent (subagentes)

O Claude Code permite disparar subagentes com contexto isolado via a tool `Agent`. O Cursor não tem esse mecanismo.

**O que fazer:** substituir chamadas a subagentes por instruções inline. Onde o Claude Code diz "use o Agent tool para X", o Cursor deve dizer "execute X diretamente".

### Skill tool (invocação programática)

No Claude Code, uma skill pode invocar outra via `Skill` tool. No Cursor, não existe invocação programática entre rules.

**O que fazer:** substituir `invoke the order66 skill` por `follow the order66 rule instructions` ou `siga as instruções da rule `/order66``. O modelo do Cursor vai carregar a rule correspondente pelo contexto.

---

## MCP (Model Context Protocol)

Ambos suportam MCP. A diferença é a configuração:

| Claude Code | Cursor |
|-------------|--------|
| `claude mcp add --transport http <url>` | Configurar em `Settings > MCP` ou `.cursor/mcp.json` |

No conteúdo das skills, referências a tools MCP específicas como `mcp__claude_ai_Atlassian__getJiraIssue` devem ser generalizadas. No Cursor, o nome da tool pode variar dependendo de como o MCP foi configurado.

**O que fazer:** usar referências genéricas como "use o MCP do Atlassian para ler o issue" em vez de nomear a tool exatamente.

---

## Instalação

| Claude Code | Cursor |
|-------------|--------|
| `claude plugin marketplace add /caminho` + `claude plugin install darkside@darkside` | `bash install.sh` na raiz do projeto alvo |
| Escopo global (`~/.claude/commands/`) | Escopo por projeto (`.cursor/rules/`) |
| `install.sh` copia SKILL.md para `~/.claude/commands/` | `install.sh` copia .mdc para `.cursor/rules/` do diretório atual |

Se o mecanismo de instalação do Claude Code mudar, o `install.sh` do Cursor provavelmente não precisa mudar — ele é independente.

---

## Checklist de migração

Ao portar uma alteração do Claude Code para o Cursor:

- [ ] Identificar quais `SKILL.md` foram alterados
- [ ] Para cada skill alterada:
  - [ ] Copiar o conteúdo novo para o `.mdc` correspondente
  - [ ] Substituir `**Follow Shared Rules** from \`skills/_shared-rules.md\`.` pelo bloco de shared rules embutido
  - [ ] Converter o frontmatter (remover `name`, adicionar `globs` e `alwaysApply: false`, prefixar description com `"Darkside /nome — "`)
  - [ ] Remover referências a TaskCreate/TaskUpdate
  - [ ] Remover referências a Agent/subagentes
  - [ ] Substituir `invoke the X skill` por `follow the X rule instructions`
  - [ ] Generalizar nomes de tools MCP específicas
- [ ] Se `_shared-rules.md` foi alterado: replicar em todos os `.mdc`
- [ ] Se skill nova foi adicionada:
  - [ ] Criar o `.mdc` com frontmatter Cursor
  - [ ] Adicionar na tabela de roteamento em `darkside.mdc`
  - [ ] Adicionar na tabela de skills em `darkside.mdc` e `guide.mdc`
  - [ ] Adicionar no array `SKILLS` em `uninstall.sh`
- [ ] Se skill foi removida:
  - [ ] Deletar o `.mdc`
  - [ ] Remover da tabela de roteamento em `darkside.mdc`
  - [ ] Remover da tabela de skills em `darkside.mdc` e `guide.mdc`
  - [ ] Remover do array `SKILLS` em `uninstall.sh`
