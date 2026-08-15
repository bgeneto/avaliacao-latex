# avaliacao-latex

Classe **LuaLaTeX** para provas e avaliações impressas (cabeçalho institucional, instruções, questões dissertativas, V/F e múltipla escolha).

## Requisitos

- [LuaLaTeX](https://www.luatex.org/) (TeX Live ou MiKTeX)
- Pacotes usados pela classe: `fontspec`, `unicode-math`, `libertine`, `polyglossia`, `tcolorbox`, `tikz`, entre outros (instalação completa do TeX Live cobre isso)

## Compilar o exemplo

```bash
latexmk -lualatex exemplo.tex
```

Ou: `lualatex exemplo.tex` (duas vezes, para o número de páginas no rodapé).

## Uso mínimo

```tex
\documentclass[12pt,a4paper,twocols,margin=1.20cm]{avaliacao}

\begin{document}
\universidade{Universidade de Brasília}
\faculdade{Faculdade UnB Planaltina}
\curso{Ciências Naturais}
\disciplina{Física 1}
\semestre{2026/1}
\assunto{1a. Avaliação}
\turno{Diurno}
\professor{Nome}
\header

\begin{instrucoes}
  \item Responda todas as questões.
\end{instrucoes}

\begin{questao}{1}
Enunciado.
\end{questao}
\end{document}
```

Coloque `avaliacao.cls` (e o logo, se usar um arquivo próprio) no mesmo diretório do `.tex`, ou em um caminho conhecido pelo LuaLaTeX.

## Opções da classe

| Opção | Efeito |
|-------|--------|
| `twocols` | Duas colunas após o cabeçalho |
| `keys` | Imprime gabarito (`\qitem` e argumento opcional de `questao`) |
| `10pt`, `11pt`, `12pt` | Tamanho da fonte |
| demais | Encaminhadas ao `geometry` (`a4paper`, `margin=...`, etc.) |

Logo padrão: `logo_unb_vert` (arquivo de imagem no caminho de busca). Redefina com `\logo{arquivo}`.

## Ambientes e comandos

- `instrucoes` — caixa de instruções (itens com `\item`)
- `questao{pontos}` — questão; opcional `[gabarito]` (visível só com `keys`)
- `vf` + `\qitem{V}` / `\qitem{F}` — verdadeiro/falso
- `me` / `me[n]` — múltipla escolha em `n` colunas; `\qitem{X}` marca a correta
- `subitens` — itens (a), (b), …
- `obs` — texto compartilhado entre questões
- `\valor{80}{km/h}`, `\unidade{m/s}` — grandezas com unidade em romano
- `\href{url}` ou `\href{url}{texto}`, `\url{url}` — links (a classe carrega `hyperref`)

Há aliases em português e inglês para o cabeçalho (`\universidade`/`\university`, `\disciplina`/`\course`, …).

O arquivo `exemplo.tex` é a referência completa.
