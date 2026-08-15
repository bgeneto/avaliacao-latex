\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{avaliacao}[2026/08/15 v1.11 Avaliacao class for LuaLaTeX
^^JCreated by Bernhard Enders]

% -----------------------------------------------------
% Engine and options (kernel key=value, 2022+)
% -----------------------------------------------------
\RequirePackage{iftex}
\ifluatex\else
  \ClassError{avaliacao}{This class requires LuaLaTeX}{Compile with lualatex.}
\fi

\newif\ifavaliacao@twocols
\newif\ifavaliacao@keys
\newif\ifavaliacao@gabarito
\newif\ifavaliacao@colsstarted
\newif\ifavaliacao@suspended
\newif\ifavaliacao@inchoices

\DeclareKeys[avaliacao]{
  twocols    .code = \avaliacao@twocolstrue,
  keys       .code = \avaliacao@keystrue,
  gabarito   .code = \avaliacao@gabaritotrue,
  answerkey  .code = \avaliacao@gabaritotrue,
  10pt    .code = \PassOptionsToClass{10pt}{article},
  11pt    .code = \PassOptionsToClass{11pt}{article},
  12pt    .code = \PassOptionsToClass{12pt}{article},
}
\DeclareUnknownKeyHandler[avaliacao]{%
  \if\relax\detokenize{#2}\relax
    \PassOptionsToPackage{#1}{geometry}%
  \else
    \PassOptionsToPackage{#1=#2}{geometry}%
  \fi
}
\PassOptionsToPackage{includefoot}{geometry}
\ProcessKeyOptions[avaliacao]
\LoadClass{article}

% -----------------------------------------------------
% Packages
% -----------------------------------------------------
\RequirePackage{fontspec}
\RequirePackage{unicode-math}
\RequirePackage{geometry}
\RequirePackage{polyglossia}
\setmainlanguage{portuguese}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\RequirePackage{fancyhdr}
\RequirePackage{hhline}
\RequirePackage{array}
\RequirePackage{colortbl}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{lastpage}
\RequirePackage{multicol}
  \raggedcolumns
  \setlength{\columnsep}{1.5pc}
  \setlength{\columnseprule}{.4pt}
\RequirePackage{enumitem}
\RequirePackage{microtype}
\RequirePackage{libertine}

% -----------------------------------------------------
% Page chrome
% -----------------------------------------------------
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhf{}
\ifavaliacao@gabarito
  \newcommand{\avaliacao@lastn}{??}
  \fancyfoot[R]{\itshape\scriptsize página \thepage\ de \avaliacao@lastn}
\else
  \fancyfoot[R]{\itshape\scriptsize página \thepage\ de \pageref{LastPage}}
\fi
\fancypagestyle{avaliacao@gabarito}{%
  \fancyhf{}%
  \fancyfoot[C]{\itshape\scriptsize gabarito}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\setlength{\parskip}{0pt}
\setlength{\parsep}{0pt}
\setlength{\parindent}{0pt}
\setlength{\tabcolsep}{1pt}
\newcolumntype{C}{>{\centering\arraybackslash}m{3cm}}
\setlist[enumerate,itemize]{nosep}
\definecolor{mygray}{gray}{0.85}

\AddToHook{begindocument}{\frenchspacing}
\AddToHook{begindocument}{\RequirePackage{ziffer}}

% \i/\j in math → ı/ȷ (unicode-math); text \i/\j unchanged
\AddToHook{begindocument}{%
  \NewCommandCopy\avaliacao@i\i
  \NewCommandCopy\avaliacao@j\j
  \DeclareRobustCommand{\i}{\ifmmode\imath\else\avaliacao@i\fi}%
  \DeclareRobustCommand{\j}{\ifmmode\jmath\else\avaliacao@j\fi}%
}

% -----------------------------------------------------
% Header metadata (PT/EN aliases)
% -----------------------------------------------------
\newcommand*{\avaliacao@logo}{logo_unb_vert}
\newcommand*{\avaliacao@univ}{\ClassError{avaliacao}{No \protect\university\space defined}{}}
\newcommand*{\avaliacao@facul}{\ClassError{avaliacao}{No \protect\faculty\space defined}{}}
\newcommand*{\avaliacao@major}{Ciências Naturais}
\newcommand*{\avaliacao@course}{\ClassError{avaliacao}{No \protect\course\space defined}{}}
\newcommand*{\avaliacao@semester}{\ClassError{avaliacao}{No \protect\semester\space defined}{}}
\newcommand*{\avaliacao@subject}{\ClassError{avaliacao}{No \protect\subject\space defined}{}}
\newcommand*{\avaliacao@shift}{\ClassError{avaliacao}{No \protect\shift\space defined}{}}
\newcommand*{\avaliacao@prof}{\ClassError{avaliacao}{No \protect\professor\space defined}{}}

\NewDocumentCommand{\logo}{m}{\gdef\avaliacao@logo{#1}}
\NewDocumentCommand{\university}{m}{\gdef\avaliacao@univ{#1}}
\NewDocumentCommand{\faculty}{m}{\gdef\avaliacao@facul{#1}}
\NewDocumentCommand{\major}{m}{\gdef\avaliacao@major{#1}}
\NewDocumentCommand{\course}{m}{\gdef\avaliacao@course{#1}}
\NewDocumentCommand{\semester}{m}{\gdef\avaliacao@semester{#1}}
\NewDocumentCommand{\subject}{m}{\gdef\avaliacao@subject{#1}}
\NewDocumentCommand{\shift}{m}{\gdef\avaliacao@shift{#1}}
\NewDocumentCommand{\professor}{m}{\gdef\avaliacao@prof{#1}}

\NewCommandCopy{\college}{\university}
\NewCommandCopy{\universidade}{\university}
\NewCommandCopy{\school}{\faculty}
\NewCommandCopy{\faculdade}{\faculty}
\NewCommandCopy{\institute}{\faculty}
\NewCommandCopy{\instituto}{\faculty}
\NewCommandCopy{\department}{\faculty}
\NewCommandCopy{\departamento}{\faculty}
\NewCommandCopy{\program}{\major}
\NewCommandCopy{\curso}{\major}
\NewCommandCopy{\disciplina}{\course}
\NewCommandCopy{\semestre}{\semester}
\NewCommandCopy{\assunto}{\subject}
\NewCommandCopy{\turno}{\shift}

% -----------------------------------------------------
% Two-column body: start at first question/obs, not in \header
% -----------------------------------------------------
\newcommand{\avaliacao@ensurecols}{%
  \ifavaliacao@twocols
    \ifavaliacao@colsstarted
    \else
      \global\avaliacao@colsstartedtrue
      \begin{multicols*}{2}%
    \fi
  \fi
}
\newcommand{\avaliacao@endcols}{%
  \ifavaliacao@colsstarted
    \global\avaliacao@colsstartedfalse
    \end{multicols*}%
  \fi
}
\AddToHook{enddocument}{\avaliacao@endmatter}
\AddToHook{env/questao/before}{\avaliacao@ensurecols}
\AddToHook{env/obs/before}{\avaliacao@ensurecols}

% Full-width instructions even if columns already started
\AddToHook{env/instrucoes/before}{%
  \global\avaliacao@suspendedfalse
  \ifavaliacao@twocols
    \ifavaliacao@colsstarted
      \global\avaliacao@suspendedtrue
      \avaliacao@endcols
    \fi
  \fi
}
\AddToHook{env/instrucoes/after}{%
  \ifavaliacao@suspended
    \avaliacao@ensurecols
  \fi
}

% -----------------------------------------------------
% Institutional header (full width; does not start columns)
% -----------------------------------------------------
\NewDocumentCommand{\header}{}{%
  {\sffamily
    \noindent
    \begin{tabularx}{\textwidth}{cX|C|}%
    \cline{3-3}%
    \multirow{6}{*}{\parbox[t]{3.2cm}{\includegraphics[width=2.8cm]{\avaliacao@logo}}} &
      \Large{\avaliacao@univ} & \\%
    & \large{\avaliacao@facul} & \\%
    & \begin{tabular}[b]{@{}ll}%
        \textit{Curso:} & \avaliacao@major\\%
        \textit{Disciplina:} & \avaliacao@course\space(\avaliacao@semester)\\%
        \textit{Assunto:} & \avaliacao@subject\space (\avaliacao@shift)\\%
        \textit{Professor:} & \avaliacao@prof\\%
      \end{tabular} &
      \footnotesize\textcolor{lightgray}{Nota}\\\hline
    \end{tabularx}\par
  }%
  {\scriptsize
    \noindent
    \begin{tabularx}{\textwidth}{p{.65\linewidth}p{2em}X}%
    \textbf{Nome:} && \textbf{Matrícula:}\\[1.5em]\hhline{-~-}%
    \end{tabularx}\par
  }%
}

% -----------------------------------------------------
% Question banner (gray “Questão N” cell + points; same look as before)
% -----------------------------------------------------
\newcounter{questao}

\ExplSyntaxOn
\cs_new:Npn \avaliacao@ptslabel #1
  {
    \tl_set:Nn \l_tmpa_tl {#1}
    \tl_replace_all:Nnn \l_tmpa_tl { , } { . }
    \fp_compare:nTF { \l_tmpa_tl < 2 } { ponto } { pontos }
  }
\NewDocumentCommand { \avaliacao@points } { m }
  {
    \tl_if_eq:nnF {#1} {0}
      { \textit { #1 ~ \avaliacao@ptslabel {#1} } }
  }
\ExplSyntaxOff

\newcommand{\avaliacao@qhead}[2]{%
  \refstepcounter{questao}%
  \par\nobreak
  \noindent
  \begin{tabular*}{\linewidth}{%
      |>{\centering\arraybackslash}p{6.2em}|
      @{\extracolsep{\fill}}r}%
    \hhline{-}%
    \cellcolor{mygray}\rule{0pt}{2.6ex}Questão~\thequestao &
    \avaliacao@keybox{#1}\avaliacao@points{#2}\rule[-1.2ex]{0pt}{0pt}\\
    \hline
  \end{tabular*}\par\nobreak
  \vspace{2\lineskip}%
  \nobreak
}

\newcommand{\avaliacao@keybox}[1]{%
  \ifavaliacao@keys
    \if\relax\detokenize{#1}\relax
    \else
      \fbox{#1}\quad
    \fi
  \fi
}

\NewDocumentEnvironment{questao}{O{} m}{%
  \avaliacao@questao@ini{#1}%
  \avaliacao@qhead{#1}{#2}%
}{%
  \avaliacao@questao@fin
  \par\medskip
}

\NewDocumentEnvironment{instrucoes}{}{%
  \begin{tcolorbox}[
    colback=mygray,
    arc=8pt,
    outer arc=8pt,
    left=1pt,
    right=1pt,
    top=2pt,
    bottom=2pt,
    boxrule=0.5pt,
    width=\linewidth,
    colframe=black,
    before upper={\sloppy},
  ]
  {\centering\bfseries INSTRUÇÕES\par}
  \begin{itemize}[leftmargin=*]
}{%
  \end{itemize}%
  \end{tcolorbox}%
}

\NewDocumentEnvironment{obs}{}{%
  \begin{tcolorbox}[
    colback=mygray,
    arc=0pt,
    outer arc=0pt,
    left=1pt,
    right=1pt,
    top=2pt,
    bottom=2pt,
    boxrule=0pt,
    bottomrule=0.75pt,
    toprule=0.75pt,
    boxsep=1ex,
    width=\linewidth,
    before upper={\sloppy},
  ]
}{\end{tcolorbox}\medskip}

% -----------------------------------------------------
% Choice lists
% -----------------------------------------------------
\newlist{avaliacao@choices}{enumerate}{1}
\setlist[avaliacao@choices]{
  align=left,
  leftmargin=*,
  widest=a,
  label=\alph*.($\quad\:$),
  nosep,
  topsep=0pt,
  partopsep=0pt,
}

\newlength{\avaliacao@qitemwd}
\AddToHook{begindocument}{\settowidth{\avaliacao@qitemwd}{($\quad$)}}

\NewDocumentCommand{\qitem}{m}{%
  \item
  \avaliacao@recordqitem{#1}%
  \ifavaliacao@keys
    \ifavaliacao@inchoices
      \hspace{-0.95\avaliacao@qitemwd}%
      \makebox[0pt][l]{#1}%
      \hspace{0.95\avaliacao@qitemwd}%
    \else
      \if\relax\detokenize{#1}\relax
      \else
        \mbox{\fbox{\strut#1}}\enspace
      \fi
    \fi
  \fi
}

\NewDocumentEnvironment{vf}{}{%
  \avaliacao@inchoicestrue
  \begin{avaliacao@choices}%
}{%
  \end{avaliacao@choices}%
  \avaliacao@inchoicesfalse
}

\NewDocumentEnvironment{me}{O{1}}{%
  \avaliacao@inchoicestrue
  \setlength{\columnseprule}{0pt}%
  \setlength{\multicolsep}{0pt}%
  \ifnum#1>1
    \begin{multicols}{#1}%
  \fi
  \begin{avaliacao@choices}%
}{%
  \end{avaliacao@choices}%
  \ifnum#1>1
    \end{multicols}%
  \fi
  \avaliacao@inchoicesfalse
}

\NewDocumentEnvironment{subitens}{}{%
  \begin{enumerate}[align=left,leftmargin=*,widest=a,label=(\alph{enumi})]%
}{\end{enumerate}}

% -----------------------------------------------------
% Answer key collection and optional end-matter sheet
% -----------------------------------------------------
\ExplSyntaxOn
\seq_new:N \g_avaliacao_gabarito_seq
\seq_new:N \g_avaliacao_thisq_seq
\tl_new:N \g_avaliacao_thisq_opt_tl
\tl_new:N \l_avaliacao_gabs_tl
\seq_new:N \l_avaliacao_fmt_vf_seq
\seq_new:N \l_avaliacao_fmt_mark_seq
\seq_new:N \l_avaliacao_fmt_other_seq
\bool_new:N \l_avaliacao_all_vf_bool
\bool_new:N \l_avaliacao_all_mark_bool

\cs_new:Npn \avaliacao@currentletter:
  {
    \ifavaliacao@inchoices
      \alph { avaliacao@choicesi }
    \else
      \alph { enumi }
    \fi
  }

\NewDocumentCommand { \avaliacao@questao@ini } { m }
  {
    \seq_gclear:N \g_avaliacao_thisq_seq
    \tl_gset:Nn \g_avaliacao_thisq_opt_tl {#1}
  }

\NewDocumentCommand { \avaliacao@recordqitem } { m }
  {
    \tl_if_blank:nF {#1}
      {
        \seq_gput_right:Ne \g_avaliacao_thisq_seq
          { { \avaliacao@currentletter: } { \exp_not:n {#1} } }
      }
  }

\cs_new_protected:Npn \avaliacao@classify_pair:nn #1#2
  {
    \seq_put_right:Ne \l_avaliacao_fmt_vf_seq
      { #1)~ \exp_not:n {#2} }
    \seq_put_right:Ne \l_avaliacao_fmt_mark_seq { \str_uppercase:n {#1} }
    \seq_put_right:Ne \l_avaliacao_fmt_other_seq
      { #1)~ \exp_not:n {#2} }
    \str_case:nnF {#2}
      {
        {V} { \bool_set_false:N \l_avaliacao_all_mark_bool }
        {F} { \bool_set_false:N \l_avaliacao_all_mark_bool }
        {X} { \bool_set_false:N \l_avaliacao_all_vf_bool }
        {x} { \bool_set_false:N \l_avaliacao_all_vf_bool }
        {*} { \bool_set_false:N \l_avaliacao_all_vf_bool }
      }
      {
        \bool_set_false:N \l_avaliacao_all_vf_bool
        \bool_set_false:N \l_avaliacao_all_mark_bool
      }
  }

\cs_new_protected:Npn \avaliacao@format_qitems:
  {
    \bool_set_true:N \l_avaliacao_all_vf_bool
    \bool_set_true:N \l_avaliacao_all_mark_bool
    \seq_clear:N \l_avaliacao_fmt_vf_seq
    \seq_clear:N \l_avaliacao_fmt_mark_seq
    \seq_clear:N \l_avaliacao_fmt_other_seq
    \seq_map_inline:Nn \g_avaliacao_thisq_seq
      { \avaliacao@classify_pair:nn ##1 }
    \bool_if:NTF \l_avaliacao_all_vf_bool
      { \tl_set:Ne \l_avaliacao_gabs_tl { \seq_use:Nn \l_avaliacao_fmt_vf_seq { \quad } } }
      {
        \bool_if:NTF \l_avaliacao_all_mark_bool
          { \tl_set:Ne \l_avaliacao_gabs_tl { \seq_use:Nn \l_avaliacao_fmt_mark_seq { ,~ } } }
          { \tl_set:Ne \l_avaliacao_gabs_tl { \seq_use:Nn \l_avaliacao_fmt_other_seq { \quad } } }
      }
  }

\cs_new_protected:Npn \avaliacao@commit_keys:
  {
    \tl_set:Nn \l_avaliacao_gabs_tl { -- }
    \seq_if_empty:NTF \g_avaliacao_thisq_seq
      {
        \tl_if_empty:NF \g_avaliacao_thisq_opt_tl
          { \tl_set_eq:NN \l_avaliacao_gabs_tl \g_avaliacao_thisq_opt_tl }
      }
      { \avaliacao@format_qitems: }
    \seq_gput_right:Ne \g_avaliacao_gabarito_seq
      { { \thequestao } { \exp_not:V \l_avaliacao_gabs_tl } }
  }

\NewDocumentCommand { \avaliacao@questao@fin } { }
  { \avaliacao@commit_keys: }

\cs_new_protected:Npn \avaliacao@gabrow:nn #1#2
  { \textbf{#1} & #2 \\[0.7ex] }

\NewDocumentCommand { \avaliacao@gabarito@rows } { }
  {
    \seq_map_inline:Nn \g_avaliacao_gabarito_seq
      { \avaliacao@gabrow:nn ##1 }
  }
\ExplSyntaxOff

\newcommand{\avaliacao@endmatter}{%
  \ifavaliacao@gabarito
    \immediate\write\@auxout{\string\gdef\string\avaliacao@lastn{\thepage}}%
  \fi
  \avaliacao@endcols
  \avaliacao@printgabarito
}

\newcommand{\avaliacao@printgabarito}{%
  \ifavaliacao@gabarito
    \clearpage
    \pagestyle{avaliacao@gabarito}%
    {\sffamily
      \noindent{\Large\bfseries Gabarito}\par
      \vspace{0.45em}%
      {\small
        \avaliacao@univ\par
        \avaliacao@facul\par
        \avaliacao@major\par
        \avaliacao@course\ (\avaliacao@semester)
        \textemdash{} \avaliacao@subject\ (\avaliacao@shift)\par
      }%
    }%
    \medskip
    \noindent
    \begin{tabularx}{\linewidth}{%
        @{}>{\centering\arraybackslash}p{4.5em}@{\hspace{1.25em}}%
        >{\raggedright\arraybackslash}X@{}}%
      \textbf{Questão} & \textbf{Resposta} \\
      \hline
      \avaliacao@gabarito@rows
    \end{tabularx}%
  \fi
}

\NewDocumentCommand{\valor}{mm}{#1\,\ensuremath{\mathrm{#2}}}
\NewDocumentCommand{\unidade}{m}{\ensuremath{\,\mathrm{#1}}}
\NewDocumentCommand{\outracoluna}{}{\avaliacao@ensurecols\vfill\columnbreak}

\DeclareMathOperator{\sen}{sen}

% -----------------------------------------------------
% Hyperlinks (optional display text)
% -----------------------------------------------------
\def\avaliacao@href@graburl#{%
  \hyper@normalise\avaliacao@href@afterurl
}
\def\avaliacao@href@afterurl#1{%
  \@ifnextchar\bgroup
    {\href@{#1}}%
    {\href@{#1}{\nolinkurl{#1}}}%
}
\newcommand{\avaliacao@patch@href}{%
  \DeclareRobustCommand*{\href}[1][]{%
    \begingroup
    \setkeys{href}{##1}%
    \@ifnextchar\bgroup\avaliacao@href@graburl{\hyper@normalise\href@}%
  }%
}
\AddToHook{begindocument/before}{%
  \@ifpackageloaded{hyperref}{}{%
    \RequirePackage{hyperref}%
    \hypersetup{
      colorlinks=true,
      urlcolor=blue,
      linkcolor=black,
      citecolor=black,
      filecolor=blue,
    }%
  }%
  \@ifpackageloaded{xurl}{}{\RequirePackage{xurl}}%
  \urlstyle{same}%
  \avaliacao@patch@href
}

\endinput
