\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{avaliacao}[2026/08/15 Avaliacao LaTeXclass v1.02 for LuaLaTeX
^^JCreated by Bernhard Enders]

\newif\if@twocols\@twocolsfalse
\DeclareOption{twocols}{\@twocolstrue}
\newif\if@keys\@keysfalse
\DeclareOption{keys}{\@keystrue}
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{letter}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{letter}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{letter}}
\PassOptionsToPackage{includefoot}{geometry}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{geometry}}
\ProcessOptions\relax\LoadClass{letter}

% -----------------------------------------------------
% Pacotes necessários
% -----------------------------------------------------
\RequirePackage{fontspec}
\RequirePackage{luacode}
\RequirePackage{unicode-math}
\RequirePackage{geometry}
\RequirePackage{polyglossia}
\setmainlanguage{portuguese}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\RequirePackage{fancyhdr} % header and footer setup
\RequirePackage{twoopt}
\RequirePackage{ifthen}
\RequirePackage{xstring}
\RequirePackage{hhline}
\RequirePackage{array,calc}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{lastpage}
\RequirePackage{colortbl}
%\RequirePackage{arydshln} % load after array, longtable, colortab, and colortbl packages!
\RequirePackage{multicol}
    \raggedcolumns
    \setlength{\columnsep}{1.5pc}
    \setlength\columnseprule{.4pt}
\RequirePackage{enumitem}
    \setlist{nosep} % removes all vertical spacing in enumerate or itemize etc...
    \newcommand*\mylstlabel{($\quad$)}
    \newlength\mylstlabelwidth
    \settowidth\mylstlabelwidth{\mylstlabel}
    \if@keys
        \newcommand\qitem[1]{\item\hskip-0.95\mylstlabelwidth\makebox[0pt][l]{#1}\hskip0.95\mylstlabelwidth}
    \else
        \newcommand\qitem[1]{\item}
    \fi
\RequirePackage{soul}
\RequirePackage[full]{textcomp}
\RequirePackage{amsthm}
\RequirePackage{amsmath}
\RequirePackage{etoolbox}
\RequirePackage{libertine}
\RequirePackage{tikz}

% -----------------------------------------------------
% Header and footer setup
% -----------------------------------------------------
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0.0pt}
\renewcommand{\footrulewidth}{0.0pt}
%\setlength{\footskip}{2ex}
\lhead{} \chead{} \rhead{} \lfoot{} \cfoot{}
\rfoot{\itshape\scriptsize página \thepage\ de \pageref{LastPage}}

% -----------------------------------------------------
% No larger space after a period
% -----------------------------------------------------
\AtBeginDocument{\frenchspacing}
\AtBeginDocument{\usepackage{ziffer}} % don't know why \RequirePackage{ziffer} does not work here!
%\AtBeginDocument{\everymath={\displaystyle}} % use \displaystyle\frac all over the document

% -----------------------------------------------------
% Opções do leiaute
% -----------------------------------------------------
\setlength{\tabcolsep}{1pt}
\newcolumntype{C}{>{\centering\arraybackslash}m{3cm}}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\setlength{\parskip}{0pt}
\setlength{\parsep}{0pt}
\setlength{\parindent}{0pt}

% -----------------------------------------------------
% Novos comandos da classe
% -----------------------------------------------------
\def\logo#1{\gdef\@logo{#1}}
\def\@logo{logo_unb_vert} % default logo filename
\def\university#1{\gdef\@univ{#1}}
\def\@univ{\@latex@error{No \noexpand\university defined}\@ehc}
\let\college=\university
\let\universidade=\university
\def\faculty#1{\gdef\@facul{#1}}
\def\@facul{\@latex@error{No \noexpand\faculty defined}\@ehc}
\let\school=\faculty
\let\faculdade=\faculty
\let\institute=\faculty
\let\instituto=\faculty
\let\department=\faculty
\let\departamento=\faculty
\def\major#1{\gdef\@major{#1}}
\def\@major{Ciências Naturais}
\let\program=\major
\let\curso=\major
\def\course#1{\gdef\@course{#1}}
\def\@course{\@latex@error{No \noexpand\course defined}\@ehc}
\let\disciplina=\course
\def\semester#1{\gdef\@semester{#1}}
\def\@semester{\@latex@error{No \noexpand\semester defined}\@ehc}
\let\semestre=\semester
\def\subject#1{\gdef\@subject{#1}}
\def\@subject{\@latex@error{No \noexpand\subject defined}\@ehc}
\let\assunto=\subject
\def\shift#1{\gdef\@shift{#1}}
\def\@shift{\@latex@error{No \noexpand\shift defined}\@ehc}
\let\turno=\shift
\def\professor#1{\gdef\@prof{#1}}
\def\@prof{\@latex@error{No \noexpand\professor defined}\@ehc}

% extra vertical space for tabular cells
\newcommand*\TopStrut{\rule{0pt}{2.6ex}}       % Top strut
\newcommand*\BottomStrut{\rule[-1.2ex]{0pt}{0pt}} % Bottom strut

\definecolor{mygray}{gray}{0.85}

% -----------------------------------------------------
% Cabeçalho da atividade com logo
% -----------------------------------------------------
\newcommand{\header}{%
    {\sffamily%
    \begin{tabularx}{\textwidth}{cX|C|}%
    \cline{3-3}%
    \multirow{6}{*}{\parbox[t]{3.2cm}{\includegraphics[width=2.8cm]{\@logo}}} & \Large{\@univ} & \\%
    & \large{\@facul} & \\%
    & \begin{tabular}[b]{@{}ll}%
    \textit{Curso:} & \@major\\%
    \textit{Disciplina:} & \@course\space(\@semester)\\%
    \textit{Assunto:} & \@subject\space (\@shift)\\%
    \textit{Professor:} & \@prof\\%
    \end{tabular} & \footnotesize\textcolor{lightgray}{Nota}\\\hline%
    \end{tabularx}\par}%
    % -----------------------------------------------------
    % Formulário: Nome e Matrícula
    % -----------------------------------------------------
    {\scriptsize%
    \begin{tabularx}{\textwidth}{p{.65\linewidth}p{2em}X}%
    %\hdasline%
    \textbf{Nome:} & \space & \textbf{Matr\'{i}cula:}\\[1.5em]\hhline{-~-}%
    \end{tabularx}\par%
    }%
    \if@twocols%
        \begin{multicols*}{2}%
        \AtEndDocument{\end{multicols*}}%
    \fi%
}% fim do cabecalho

% -----------------------------------------------------
% Encontra o primeiro caractere de uma string
% -----------------------------------------------------
\def\firstchar#1{\expandafter\FirstChar#1\FirstChar}
\def\FirstChar#1#2\FirstChar{#1}

% -----------------------------------------------------
% Cabeçalho das questões
% -----------------------------------------------------
\newcounter{questao}
\newlength{\colA}
\setlength{\colA}{6.2em} % largura da primeira coluna, contendo o texto ``Questão <num>''
\newlength{\colB} % largura da segunda coluna calculada em função da largura da linha
\newcommand*{\pts}{pontos}

\newcommand{\questionheader}[2]{%
    \newcommand*{\val}{#2}%
    \newcommand*{\primeirocaractere}{\firstchar\val}%
    \ifthenelse{\equal{\primeirocaractere}{0}\OR\equal{\primeirocaractere}{1}}{\renewcommand*{\pts}{ponto}}{}%
    \setlength\colB{\linewidth-\the\colA-\tabcolsep*4-\arrayrulewidth*2}%
    \stepcounter{questao}%
    \begin{tabular*}{\linewidth}{|>{\centering\hspace{0pt}\arraybackslash}b{\the\colA}|>
        {\raggedleft\hspace{0pt}\arraybackslash}b{\the\colB}}%
        \hhline{-}\cellcolor{mygray}%
         Questão \arabic{questao} & \if@keys\hfill\fbox{#1}\hfill\fi\itshape\ifthenelse{\equal{#2}{0}}{}{#2 \pts}\TopStrut\BottomStrut\\\hline%
    \end{tabular*}%
    \par\vspace*{2\lineskip}\par%%
}

% -----------------------------------------------------
% Sair do ambiente duas colunas
% -----------------------------------------------------
\makeatletter

\newcount\saved@colnumber
\newenvironment{instrucoes}
  {%
    \begin{tcolorbox}[%
      colback=mygray, arc=8pt, outer arc=8pt,
      left=1pt, right=1pt, top=2pt, bottom=2pt,
      boxrule=0.5pt, width=\linewidth,
      colframe=black,
      before upper={\sloppy}
    ]%
    {\centering\bfseries INSTRUÇÕES\par}
    \begin{itemize}[leftmargin=*]
  }%
  {%
    \end{itemize}%
    \end{tcolorbox}%
    \aftergroup\restore@multicols%
  }

\BeforeBeginEnvironment{instrucoes}{%
  \if@twocols%
    \global\saved@colnumber=\col@number%
    \end{multicols*}%
  \fi%
}

\def\restore@multicols{%
  \if@twocols%
    \begin{multicols*}{\saved@colnumber}%
  \fi
}

\newenvironment{me}[1][1]{%
  \setlength\columnseprule{0pt}%
  \def\me@cols{#1}%
  \ifnum\me@cols=1
    \enumerate[align=left, leftmargin=*, widest=a,
               label=\alph*.~($\quad\:$)]
  \else
    \vspace{-2ex}%
    \begin{multicols}{\me@cols}%
    \enumerate[align=left, leftmargin=*, widest=a,
               label=\alph*.~($\quad\:$)]
  \fi
}{%
  \ifnum\me@cols=1
    \endenumerate
  \else
    \endenumerate
    \end{multicols}%
  \fi
}

\makeatother

% -----------------------------------------------------
% Questão dissertativa
% -----------------------------------------------------
%\newenvironment{questao}[2][0]% pontuação opcional, valor padrão = 1 ponto
%    {}%
%    {\par\medskip}

\newenvironment{questao}[2][]{%
    \questionheader{#1}{#2}%
}{\par\medskip}

% -----------------------------------------------------
% Questão de multípla escolha
% -----------------------------------------------------
\newenvironment{multicol}[2][0]%
    {\questionheader{#1}{#2}%
}{\medskip}

% -----------------------------------------------------
% Itens de V ou F
% -----------------------------------------------------
\newenvironment{vf}
  {\renewcommand\theenumi{\alph{enumi}.($\quad\:$)}%
   \renewcommand\labelenumi{\theenumi}%
   \begin{enumerate}[align=left,leftmargin=*,widest=a]}
  {\end{enumerate}}

%% Ambiente para itens de múltipla escolha (com ou sem resposta marcada)
%\newenvironment{me}[1][2]{%
%   \setlength\columnseprule{0pt}%
%   \vspace*{-2ex}%
%   \renewcommand\theenumi{\alph{enumi}.($\quad\:$)}%
%   \renewcommand\labelenumi{\theenumi}%
%   \begin{multicols*}{#1}%
%   \begin{enumerate}[align=left,leftmargin=*,widest=a]}
%  {\end{enumerate}\end{multicols*}}



\newenvironment{subitens}{%
    \begin{enumerate}[align=left,leftmargin=*,widest=a,label=(\alph{enumi})]}{\end{enumerate}}

\newenvironment{obs}{%
  \begin{tcolorbox}[colback=mygray,arc=0pt,outer arc=0pt, left=1pt,right=1pt,top=2pt,bottom=2pt,%
      boxrule=0pt,bottomrule=0.75pt,toprule=0.75pt,boxsep=1ex,width=\linewidth,
      before upper={\sloppy}]%
}{\end{tcolorbox}\medskip}

\providecommand*{\valor}[2]{#1\,\ensuremath{\mathrm{#2}}}
\providecommand*{\unidade}[1]{\ensuremath{\,\mathrm{#1}}}
\providecommand{\outracoluna}{\vfill\columnbreak}

\DeclareMathOperator{\sen}{sen}

% -----------------------------------------------------
% Hyperlinks: load late so the preamble can still pass options.
% \href{url} prints the URL; \href{url}{text} keeps hyperref's two-arg form.
% -----------------------------------------------------
\makeatletter
\def\avaliacao@href@graburl#{%
  \hyper@normalise\avaliacao@href@afterurl
}
\def\avaliacao@href@afterurl#1{%
  \@ifnextchar\bgroup
    {\href@{#1}}%
    {\href@{#1}{\nolinkurl{#1}}}%
}
\def\avaliacao@patch@href{%
  \DeclareRobustCommand*{\href}[1][]{%
    \begingroup
    \setkeys{href}{##1}%
    \@ifnextchar\bgroup\avaliacao@href@graburl{\hyper@normalise\href@}%
  }%
}
\AtEndPreamble{%
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
\makeatother

\endinput
