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

## LaTeX syntax contract (2020+)

When editing the class or adding features, write **modern LaTeX only** (kernel 2020/10 or later; this class already requires 2022/06). Do not introduce old, legacy, or plain-TeX idioms in new or touched code.

**Prefer (required for new code):**
- `\NewDocumentCommand` / `\NewDocumentEnvironment` (kernel `ltcmd`; do not load `xparse`)
- `expl3` (`\ExplSyntaxOn`) for logic, data, string/seq/tl/bool work
- Kernel key=value: `\DeclareKeys`, `\ProcessKeyOptions`, `\keys_define:nn`
- `\NewDocumentCommand` argument specifiers (`o`, `O{}`, `m`, `+m`, `s`, …) instead of `\@ifnextchar` / `\@ifstar`
- `\bool_new:N` / `\bool_if:NTF` instead of `\newif`
- `\cs_new_protected:Npn` / `\cs_set:Npn` instead of `\def`/`\edef`/`\gdef`/`\let` for internals
- LuaLaTeX + Unicode (`fontspec`, `unicode-math`, `polyglossia`); no 8-bit encodings

**Do not add:**
- Plain TeX: `\def`, `\edef`, `\xdef`, `\let`, `\expandafter`, `\noexpand`, `\loop`/`\repeat`, `\if`/`\ifx`/`\ifnum`/`\ifdim` trees, `\csname`, `\catcode` hacks
- Legacy LaTeX2e internals: `\newcommand` with `@ifnextchar`, `\DeclareOption`/`\ProcessOptions`, `\@namedef`, `\makeatletter` patterns that `expl3` already covers
- Obsolete packages/engines: `inputenc`, `fontenc`, `babel` (use `polyglossia`), pdfLaTeX/XeLaTeX shims, `xparse` as a package, `etoolbox` for new logic if `expl3` suffices

When changing existing legacy snippets (`\newif`, `\newcommand`, `\immediate\write`, …), **modernize that region** rather than copying the old style. Public command names stay stable.

## When editing the class

- Preserve Portuguese as the document language (`polyglossia`).
- Keep PT/EN command aliases (`\universidade`/`\university`, `\disciplina`/`\course`, …).
- The `keys` option overlays answers on the exam. Student copies omit `keys`.
- The `gabarito` (or `answerkey`) option appends a separate answer-key page; it is independent of `keys` and is excluded from the exam page count.
- Put each answer once: `\qitem{…}` for `vf`/`me`/`subitens`; optional `questao[…]` only for dissertatives with no `\qitem`. Do not repeat the same key as `[4/8/60]` and `\qitem`.
- Point values use a comma (`1,5`). In pt-BR, *ponto* is used for values strictly less than 2 (`0,5`, `1`, `1,5`); *pontos* from `2` on.
- `twocols` starts at the first `questao`/`obs`, so `instrucoes` stays full width without breaking out of `multicols`.

## When writing an exam

Follow `exemplo.tex`: set header macros, call `\header`, then `instrucoes` and `questao` environments. Use `vf`/`me`/`subitens`/`obs` as in that file. Mark answers with `\qitem` (or the optional `questao` argument only when there are no items).
