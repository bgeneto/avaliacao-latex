\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{avaliacao}[2026/08/15 v1.10 Avaliacao class for LuaLaTeX
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
\newif\ifavaliacao@colsstarted
\newif\ifavaliacao@suspended

\DeclareKeys[avaliacao]{
  twocols .code = \avaliacao@twocolstrue,
  keys    .code = \avaliacao@keystrue,
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
\fancyfoot[R]{\itshape\scriptsize página \thepage\ de \pageref{LastPage}}
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
\AddToHook{enddocument}{\avaliacao@endcols}
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
  \avaliacao@qhead{#1}{#2}%
}{\par\medskip}

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
  \ifavaliacao@keys
    \hspace{-0.95\avaliacao@qitemwd}%
    \makebox[0pt][l]{#1}%
    \hspace{0.95\avaliacao@qitemwd}%
  \fi
}

\NewDocumentEnvironment{vf}{}{%
  \begin{avaliacao@choices}%
}{\end{avaliacao@choices}}

\NewDocumentEnvironment{me}{O{1}}{%
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
}

\NewDocumentEnvironment{subitens}{}{%
  \begin{enumerate}[align=left,leftmargin=*,widest=a,label=(\alph{enumi})]%
}{\end{enumerate}}

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
