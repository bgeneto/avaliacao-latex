# Agent notes

This repository is a **LuaLaTeX** document class for printed exams (`avaliacao.cls`) plus a usage example (`exemplo.tex`).

## Build

- Engine: **LuaLaTeX** (required). pdfLaTeX and XeLaTeX will fail.
- From the repo root: `latexmk -lualatex exemplo.tex` (see `.latexmkrc`).
- Do not commit LaTeX aux files; they are gitignored.

## Layout of work

| File | Role |
|------|------|
| `avaliacao.cls` | Class implementation. Keep the public API stable. |
| `exemplo.tex` | Canonical usage example. Mirror its patterns in new exams. |

## When editing the class

- Preserve Portuguese as the document language (`polyglossia`).
- Keep PT/EN command aliases (`\universidade`/`\university`, `\disciplina`/`\course`, …).
- The `keys` option controls whether `\qitem` and the optional `questao` argument print answers; student copies omit `keys`.
- Point values use a comma (`1,5`). In pt-BR, *ponto* is used for values strictly less than 2 (`0,5`, `1`, `1,5`); *pontos* from `2` on.
- `twocols` starts at the first `questao`/`obs`, so `instrucoes` stays full width without breaking out of `multicols`.

## When writing an exam

Follow `exemplo.tex`: set header macros, call `\header`, then `instrucoes` and `questao` environments. Use `vf`/`me`/`subitens`/`obs` as in that file.
