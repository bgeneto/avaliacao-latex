# avaliacao-latex

Classe **LuaLaTeX** para provas e avaliações impressas (cabeçalho institucional, instruções, V/F, múltipla escolha, subitens e dissertativas, com gabarito opcional).

## Requisitos

- [LuaLaTeX](https://www.luatex.org/) (TeX Live ou MiKTeX)
- Pacotes usados pela classe: `fontspec`, `unicode-math`, `libertine`, `polyglossia`, `tcolorbox`, `hyperref`, entre outros (uma instalação completa do TeX Live cobre isso)
- LaTeX 2022/06/01 ou posterior (opções da classe via `\DeclareKeys`)

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
| `twocols` | Duas colunas a partir da primeira `questao`/`obs` |
| `keys` | Imprime o gabarito *na prova* |
| `gabarito` (ou `answerkey`) | Folha de gabarito ao final (página extra; fora da numeração da prova) |
| `10pt`, `11pt`, `12pt` | Tamanho da fonte |
| `font={…}` | Substitui a fonte do texto (padrão: Linux Libertine) |
| `sansfont={…}` | Substitui a fonte sem serifa (cabeçalho) |
| `mathfont={…}` | Substitui a fonte matemática (`unicode-math`) |
| demais | Encaminhadas ao `geometry` (`a4paper`, `margin=...`, etc.) |

`keys` e `gabarito` são independentes: use uma, a outra, as duas (prova do professor) ou nenhuma (prova do aluno).

Logo padrão: `logo_unb_vert` (arquivo de imagem no caminho de busca). Redefina com `\logo{arquivo}`.

## Fontes

A classe carrega **Linux Libertine** por padrão. Para usar outra fonte OpenType do TeX Live ou do sistema, chame `\fonte` (ou `\examfont`) **depois** de `\documentclass`, ou passe a opção `font`:

```tex
\documentclass[12pt,a4paper]{avaliacao}

% Palatino (clone no TeX Live):
\fonte{TeX Gyre Pagella}

% Mesma família também no cabeçalho (\sffamily):
% \fonte*{TeX Gyre Pagella}

% Fonte instalada no sistema (nome que o LuaLaTeX reconhece):
% \fonte{Palatino Linotype}

% Arquivo OTF (caminho ou nome do ficheiro no path de fontes):
% \fonte{texgyrepagella-regular.otf}

% Opções do fontspec (escala, negrito, etc.):
% \fonte[Scale=0.95]{TeX Gyre Pagella}

% Fórmulas alinhadas à Pagella:
% \setmathfont{TeX Gyre Pagella Math}

\begin{document}
...
\end{document}
```

Equivalente na opção da classe (chaves com espaços entre `{…}`):

```tex
\documentclass[12pt,a4paper,font={TeX Gyre Pagella}]{avaliacao}
```

O cabeçalho institucional usa `\sffamily` (Biolinum, enquanto o padrão Libertine estiver ativo). `\fonte{…}` troca só o texto da prova; `\fonte*{…}` (ou `sansfont={…}`) troca também o cabeçalho.

Para listar nomes que o LuaLaTeX encontra: `luaotfload-tool --find="Palatino"` ou `fc-list : family | sort`.

## Gabarito

Indique a resposta **uma vez**, no lugar certo:

| Tipo | Onde marcar | Folha (`gabarito`) | Na prova (`keys`) |
|------|-------------|--------------------|-------------------|
| V/F | `\qitem{V}` / `\qitem{F}` | `a) V  b) F …` | letra na caixa `($ $)` |
| Múltipla escolha | `\qitem{X}` na correta; `\qitem{}` nas demais | letra da alternativa (`B`) | `X` na caixa |
| Subitens | `\qitem{4}` em cada item | `a) 4  b) 8  c) 60` | valor em caixa ao lado do item |
| Dissertativa (sem itens) | `\begin{questao}[075]{1}` | `075` | valor em caixa no cabeçalho da questão |

Se a questão tem `\qitem`, **não** use o argumento opcional de `questao` (`[4/8/60]` e afins): a folha e o `keys` saem dos `\qitem`. O `[…]` de `questao` é só para dissertativa sem lista.

```tex
% dissertativa
\begin{questao}[075]{1}
  Enunciado.
\end{questao}

% subitens: respostas só no \qitem
\begin{questao}{2}
  Enunciado.
  \begin{subitens}
    \qitem{4} Primeiro item.
    \qitem{8} Segundo item.
  \end{subitens}
\end{questao}
```

## Ambientes e comandos

- `instrucoes` — caixa de instruções (itens com `\item`)
- `questao{pontos}` — questão; opcional `[resposta]` só se não houver `\qitem`
- `vf` + `\qitem{V}` / `\qitem{F}` — verdadeiro/falso
- `me` / `me[n]` — múltipla escolha em `n` colunas; `\qitem{X}` marca a correta
- `subitens` — itens (a), (b), …; `\qitem{…}` em cada resposta
- `obs` — texto compartilhado entre questões
- `\valor{80}{km/h}`, `\unidade{m/s}` — grandezas com unidade em romano
- `\href{url}` ou `\href{url}{texto}`, `\url{url}` — links (a classe carrega `hyperref`)
- `\fonte{Nome}` / `\examfont{Nome}` — troca a fonte do texto; `\fonte*` também a sem serifa

Há aliases em português e inglês para o cabeçalho (`\universidade`/`\university`, `\disciplina`/`\course`, …).

O arquivo `exemplo.tex` é a referência completa.
