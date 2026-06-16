# darkside-cursor

```
██████╗  █████╗ ██████╗ ██╗  ██╗███████╗██╗██████╗ ███████╗
██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔════╝██║██╔══██╗██╔════╝
██║  ██║███████║██████╔╝█████╔╝ ███████╗██║██║  ██║█████╗
██║  ██║██╔══██║██╔══██╗██╔═██╗ ╚════██║██║██║  ██║██╔══╝
██████╔╝██║  ██║██║  ██║██║  ██╗███████║██║██████╔╝███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚══════╝
```

Plugin Darkside para Cursor — workflows padronizados de desenvolvimento para o time.

Adaptação do [darkside](https://github.com/leogodde/darkside) (Claude Code) para Cursor Rules.

## Instalação

Na raiz do projeto onde quer usar o Darkside:

```bash
bash /caminho/para/darkside-cursor/install.sh
```

As rules são copiadas para `.cursor/rules/` do projeto atual.

## Desinstalar

```bash
bash /caminho/para/darkside-cursor/uninstall.sh
```

## Como usar

No chat do Cursor, digite o nome da skill:

```
/explore
/quest
/war-room
/order66
/darkside
```

A rule `darkside.mdc` está sempre ativa e intercepta os comandos `/nome-da-skill`, direcionando para a rule correspondente.

## Skills

| Skill | Descrição |
|-------|-----------|
| `/darkside` | Exibe o logo e lista todas as skills disponíveis |
| `/explore` | Análise profunda do projeto |
| `/quest` | Conversa estruturada de discovery |
| `/war-room` | Engineering discovery estruturado |
| `/interrogate` | Interroga e refina o plano do war-room |
| `/sith-agents` | Edita os system prompts dos sith-agents |
| `/order66` | Orquestração completa de desenvolvimento |
| `/inquisitor` | Inspeção profunda de código |
| `/mission` | Quest compacto para tarefas menores |
| `/verdict` | Verifica critérios de aceite de cards contra o código |
| `/guide` | Ajuda |

## Fluxo recomendado

```
/explore → /quest (opcional) → /war-room → /order66 → /inquisitor
```

| Etapa | Skill | O que produz |
|-------|-------|--------------|
| 1. Mapear o projeto | `/explore` | `tech.md` + sith-agents |
| 2. Discovery da tarefa | `/quest` | holomap |
| 3. Plano técnico | `/war-room` | plan.md |
| 4. Implementação | `/order66` | ordem imperial + tarefas + código revisado |
| 5. Auditoria | `/inquisitor` | relatório com julgamento final |

> `/order66` executa o `/war-room` automaticamente se nenhum plano for encontrado.

## Armazenamento

Todos os arquivos gerados ficam em `.darkside/` na raiz de cada projeto (mesma estrutura do plugin Claude Code).

## Diferenças em relação ao Claude Code

| Aspecto | Claude Code | Cursor |
|---------|-------------|--------|
| Invocação | Slash commands nativos com autocomplete | Digitar `/nome` no chat (sem autocomplete) |
| Escopo | Global (`~/.claude/commands/`) | Por projeto (`.cursor/rules/`) |
| Instalação | `claude plugin install` | `bash install.sh` na raiz do projeto |
| TaskCreate/TaskUpdate | Suportado nativamente | Não disponível — removido das skills |
| Subagentes | Suportado nativamente | Não disponível — instruções inline |
| MCP | Suportado | Suportado (configurar separadamente) |
