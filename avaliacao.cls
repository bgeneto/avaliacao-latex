\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{avaliacao}[2026/08/15 v1.13 Avaliacao class for LuaLaTeX
  ^^JCreated by bgeneto]

% -----------------------------------------------------
% Engine and options (kernel key=value + expl3, 2022+)
% -----------------------------------------------------
\ExplSyntaxOn
\sys_if_engine_luatex:F
{
  \ClassError { avaliacao }
  { This~class~requires~LuaLaTeX }
  { Compile~with~lualatex. }
}

\bool_new:N \g_avaliacao_twocols_bool
\bool_new:N \g_avaliacao_keys_bool
\bool_new:N \g_avaliacao_gabarito_bool
\bool_new:N \g_avaliacao_colsstarted_bool
\bool_new:N \g_avaliacao_suspended_bool
\bool_new:N \g_avaliacao_inchoices_bool
\tl_new:N \g_avaliacao_font_tl
\tl_new:N \g_avaliacao_sansfont_tl
\tl_new:N \g_avaliacao_mathfont_tl

\DeclareKeys [ avaliacao ]
{
  twocols    .code = \bool_gset_true:N \g_avaliacao_twocols_bool ,
  keys       .code = \bool_gset_true:N \g_avaliacao_keys_bool ,
  gabarito   .code = \bool_gset_true:N \g_avaliacao_gabarito_bool ,
  answerkey  .code = \bool_gset_true:N \g_avaliacao_gabarito_bool ,
  font       .tl_gset:N = \g_avaliacao_font_tl ,
  sansfont   .tl_gset:N = \g_avaliacao_sansfont_tl ,
  mathfont   .tl_gset:N = \g_avaliacao_mathfont_tl ,
  10pt       .code = \PassOptionsToClass { 10pt } { article } ,
  11pt       .code = \PassOptionsToClass { 11pt } { article } ,
  12pt       .code = \PassOptionsToClass { 12pt } { article } ,
}
\DeclareUnknownKeyHandler [ avaliacao ]
{
  \IfBlankTF {#2}
  { \PassOptionsToPackage {#1} { geometry } }
  { \PassOptionsToPackage {#1=#2} { geometry } }
}
\ExplSyntaxOff
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
\RequirePackage{booktabs}
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

% Default: Linux Libertine. Optional class keys / \fonte overwrite after this.
\ExplSyntaxOn
\tl_if_empty:NF \g_avaliacao_font_tl
{ \exp_args:NV \setmainfont \g_avaliacao_font_tl }
\tl_if_empty:NF \g_avaliacao_sansfont_tl
{ \exp_args:NV \setsansfont \g_avaliacao_sansfont_tl }
\tl_if_empty:NF \g_avaliacao_mathfont_tl
{ \exp_args:NV \setmathfont \g_avaliacao_mathfont_tl }
\ExplSyntaxOff

\NewDocumentCommand{\fonte}{s O{} m}{%
  \setmainfont[#2]{#3}%
  \IfBooleanT{#1}{\setsansfont[#2]{#3}}%
}
\NewCommandCopy{\examfont}{\fonte}

% Exam page count before an appended gabarito sheet (kernel properties)
\NewProperty{avaliacao/exampages}{now}{??}{\thepage}

% -----------------------------------------------------
% Page chrome
% -----------------------------------------------------
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhf{}
\ExplSyntaxOn
\bool_if:NTF \g_avaliacao_gabarito_bool
{
  \fancyfoot [ R ]
  {
    \itshape \scriptsize
    página~ \thepage \ de~
    \RefProperty { avaliacao@examend } { avaliacao/exampages }
  }
}
{
  \fancyfoot [ R ]
  {
    \itshape \scriptsize
    página~ \thepage \ de~ \pageref { LastPage }
  }
}
\ExplSyntaxOff
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
\ExplSyntaxOn
\cs_new_protected:Npn \avaliacao@dotlessi
{ \mode_if_math:TF { \imath } { \avaliacao@i } }
\cs_new_protected:Npn \avaliacao@dotlessj
{ \mode_if_math:TF { \jmath } { \avaliacao@j } }
\ExplSyntaxOff
\AddToHook{begindocument}{%
  \NewCommandCopy\avaliacao@i\i
  \NewCommandCopy\avaliacao@j\j
  \RenewDocumentCommand{\i}{}{\avaliacao@dotlessi}%
  \RenewDocumentCommand{\j}{}{\avaliacao@dotlessj}%
}

% -----------------------------------------------------
% Header metadata (PT/EN aliases)
% -----------------------------------------------------
\ExplSyntaxOn
\tl_new:N \g_avaliacao_logo_tl
\tl_new:N \g_avaliacao_univ_tl
\tl_new:N \g_avaliacao_facul_tl
\tl_new:N \g_avaliacao_major_tl
\tl_new:N \g_avaliacao_course_tl
\tl_new:N \g_avaliacao_semester_tl
\tl_new:N \g_avaliacao_subject_tl
\tl_new:N \g_avaliacao_shift_tl
\tl_new:N \g_avaliacao_prof_tl

\tl_gset:Nn \g_avaliacao_logo_tl { logo_unb_vert }
\tl_gset:Nn \g_avaliacao_major_tl { Ciências~Naturais }
\tl_gset:Nn \g_avaliacao_univ_tl
{ \ClassError { avaliacao } { No~\protect\university\space defined } { } }
\tl_gset:Nn \g_avaliacao_facul_tl
{ \ClassError { avaliacao } { No~\protect\faculty\space defined } { } }
\tl_gset:Nn \g_avaliacao_course_tl
{ \ClassError { avaliacao } { No~\protect\course\space defined } { } }
\tl_gset:Nn \g_avaliacao_semester_tl
{ \ClassError { avaliacao } { No~\protect\semester\space defined } { } }
\tl_gset:Nn \g_avaliacao_subject_tl
{ \ClassError { avaliacao } { No~\protect\subject\space defined } { } }
\tl_gset:Nn \g_avaliacao_shift_tl
{ \ClassError { avaliacao } { No~\protect\shift\space defined } { } }
\tl_gset:Nn \g_avaliacao_prof_tl
{ \ClassError { avaliacao } { No~\protect\professor\space defined } { } }

% Expandable from document-level (catcodes frozen here)
\cs_new:Npn \avaliacao@logo { \g_avaliacao_logo_tl }
\cs_new:Npn \avaliacao@univ { \g_avaliacao_univ_tl }
\cs_new:Npn \avaliacao@facul { \g_avaliacao_facul_tl }
\cs_new:Npn \avaliacao@major { \g_avaliacao_major_tl }
\cs_new:Npn \avaliacao@course { \g_avaliacao_course_tl }
\cs_new:Npn \avaliacao@semester { \g_avaliacao_semester_tl }
\cs_new:Npn \avaliacao@subject { \g_avaliacao_subject_tl }
\cs_new:Npn \avaliacao@shift { \g_avaliacao_shift_tl }
\cs_new:Npn \avaliacao@prof { \g_avaliacao_prof_tl }

\NewDocumentCommand { \logo } { m }
{ \tl_gset:Nn \g_avaliacao_logo_tl {#1} }
\NewDocumentCommand { \university } { m }
{ \tl_gset:Nn \g_avaliacao_univ_tl {#1} }
\NewDocumentCommand { \faculty } { m }
{ \tl_gset:Nn \g_avaliacao_facul_tl {#1} }
\NewDocumentCommand { \major } { m }
{ \tl_gset:Nn \g_avaliacao_major_tl {#1} }
\NewDocumentCommand { \course } { m }
{ \tl_gset:Nn \g_avaliacao_course_tl {#1} }
\NewDocumentCommand { \semester } { m }
{ \tl_gset:Nn \g_avaliacao_semester_tl {#1} }
\NewDocumentCommand { \subject } { m }
{ \tl_gset:Nn \g_avaliacao_subject_tl {#1} }
\NewDocumentCommand { \shift } { m }
{ \tl_gset:Nn \g_avaliacao_shift_tl {#1} }
\NewDocumentCommand { \professor } { m }
{ \tl_gset:Nn \g_avaliacao_prof_tl {#1} }
\ExplSyntaxOff

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
\ExplSyntaxOn
\cs_new_protected:Npn \avaliacao@ensurecols
{
  \bool_if:NT \g_avaliacao_twocols_bool
  {
    \bool_if:NF \g_avaliacao_colsstarted_bool
    {
      \bool_gset_true:N \g_avaliacao_colsstarted_bool
      \begin { multicols* } { 2 }
    }
  }
}
\cs_new_protected:Npn \avaliacao@endcols
{
  \bool_if:NT \g_avaliacao_colsstarted_bool
  {
    \bool_gset_false:N \g_avaliacao_colsstarted_bool
    \end { multicols* }
  }
}
\cs_new_protected:Npn \avaliacao@instrucoesbefore
{
  \bool_gset_false:N \g_avaliacao_suspended_bool
  \bool_if:NT \g_avaliacao_twocols_bool
  {
    \bool_if:NT \g_avaliacao_colsstarted_bool
    {
      \bool_gset_true:N \g_avaliacao_suspended_bool
      \avaliacao@endcols
    }
  }
}
\cs_new_protected:Npn \avaliacao@instrucoesafter
{
  \bool_if:NT \g_avaliacao_suspended_bool
  { \avaliacao@ensurecols }
}
\ExplSyntaxOff
\AddToHook{enddocument}{\avaliacao@endmatter}
\AddToHook{env/questao/before}{\avaliacao@ensurecols}
\AddToHook{env/obs/before}{\avaliacao@ensurecols}
\AddToHook{env/instrucoes/before}{\avaliacao@instrucoesbefore}
\AddToHook{env/instrucoes/after}{\avaliacao@instrucoesafter}

% -----------------------------------------------------
% Institutional header (full width; does not start columns)
% -----------------------------------------------------
\NewDocumentCommand{\header}{}{%
  {\sffamily
      \noindent
      \begin{tabularx}{\textwidth}{cX|C|}%
        \cline{3-3}%
        \multirow{6}{*}{\parbox[t]{3.2cm}{\includegraphics[width=2.8cm]{\avaliacao@logo}}} &
        \Large{\avaliacao@univ}                                                            &                                                                                        \\%
                                                                                           & \large{\avaliacao@facul}                                                             & \\%
                                                                                           & \begin{tabular}[b]{@{}ll}%
                                                                                               \textit{Curso:}      & \avaliacao@major                             \\%
                                                                                               \textit{Disciplina:} & \avaliacao@course\space(\avaliacao@semester) \\%
                                                                                               \textit{Assunto:}    & \avaliacao@subject\space (\avaliacao@shift)  \\%
                                                                                               \textit{Professor:}  & \avaliacao@prof                              \\%
                                                                                             \end{tabular} &
        \footnotesize\textcolor{lightgray}{Nota}                                                                                                                                    \\\hline
      \end{tabularx}\par
    }%
    {\scriptsize
      \noindent
      \begin{tabularx}{\textwidth}{p{.65\linewidth}p{2em}X}%
        \textbf{Nome:} &  & \textbf{Matrícula:} \\[1.5em]\hhline{-~-}%
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
\cs_new_protected:Npn \avaliacao@points #1
{
  \tl_if_eq:nnF {#1} { 0 }
  { \textit { #1 ~ \avaliacao@ptslabel {#1} } }
}
\cs_new_protected:Npn \avaliacao@keybox #1
{
  \bool_if:NT \g_avaliacao_keys_bool
  {
    \tl_if_blank:nF {#1}
    { \fbox {#1} \quad }
  }
}
\cs_new_protected:Npn \avaliacao@qhead #1#2
{
  \refstepcounter { questao }
  \par \nobreak
  \noindent
  \begin { tabular* } { \linewidth }
  {
    | > { \centering \arraybackslash } p { 6.2em } |
    @ { \extracolsep { \fill } } r
  }
  \hhline { - }
  \cellcolor { mygray } \rule { 0pt } { 2.6ex } Questão~ \thequestao &
  \avaliacao@keybox {#1} \avaliacao@points {#2} \rule [ -1.2ex ] { 0pt } { 0pt } \\
  \hline
  \end { tabular* } \par \nobreak
  \vspace { 2 \lineskip }
  \nobreak
}
\ExplSyntaxOff

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
    \begin{itemize}[leftmargin=*,label={{\libertine ✔}}]
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

\ExplSyntaxOn
\NewDocumentCommand { \qitem } { m }
{
  \item
  \avaliacao@recordqitem {#1}
  \bool_if:NT \g_avaliacao_keys_bool
  {
    \bool_if:NTF \g_avaliacao_inchoices_bool
    {
      \hspace { -0.95 \avaliacao@qitemwd }
      \makebox [ 0pt ] [ l ] {#1}
      \hspace { 0.95 \avaliacao@qitemwd }
    }
    {
      \tl_if_blank:nF {#1}
      { \mbox { \fbox { \strut #1 } } \enspace }
    }
  }
}

\NewDocumentEnvironment { vf } { }
{
  \bool_gset_true:N \g_avaliacao_inchoices_bool
  \begin { avaliacao@choices }
}
{
  \end { avaliacao@choices }
  \bool_gset_false:N \g_avaliacao_inchoices_bool
}

\cs_new_protected:Npn \avaliacao@mebegin #1
{
  \bool_gset_true:N \g_avaliacao_inchoices_bool
  \setlength { \columnseprule } { 0pt }
  \setlength { \multicolsep } { 0pt }
  \int_compare:nNnT {#1} > { 1 }
    { \begin { multicols } {#1} }
  \begin { avaliacao@choices }
}
\cs_new_protected:Npn \avaliacao@meend #1
{
  \end { avaliacao@choices }
  \int_compare:nNnT {#1} > { 1 }
    { \end { multicols } }
  \bool_gset_false:N \g_avaliacao_inchoices_bool
}
\ExplSyntaxOff

\NewDocumentEnvironment{me}{O{1}}{%
  \avaliacao@mebegin{#1}%
}{%
  \avaliacao@meend{#1}%
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
  \bool_if:NTF \g_avaliacao_inchoices_bool
  { \alph { avaliacao@choicesi } }
  { \alph { enumi } }
}

\cs_new_protected:Npn \avaliacao@questao@ini #1
{
  \seq_gclear:N \g_avaliacao_thisq_seq
  \tl_gset:Nn \g_avaliacao_thisq_opt_tl {#1}
}

\cs_new_protected:Npn \avaliacao@recordqitem #1
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

\cs_new_protected:Npn \avaliacao@questao@fin
{ \avaliacao@commit_keys: }

\cs_new_protected:Npn \avaliacao@gabrow:nn #1#2
{ \textbf {#1} & #2 \\ [ 0.7ex ] }

\cs_new_protected:Npn \avaliacao@gabarito@rows
{
  \seq_map_inline:Nn \g_avaliacao_gabarito_seq
  { \avaliacao@gabrow:nn ##1 }
}

\cs_new_protected:Npn \avaliacao@endmatter
{
  \bool_if:NT \g_avaliacao_gabarito_bool
  { \RecordProperties { avaliacao@examend } { avaliacao/exampages } }
  \avaliacao@endcols
  \avaliacao@printgabarito
}

\cs_new_protected:Npn \avaliacao@printgabarito
{
  \bool_if:NT \g_avaliacao_gabarito_bool
  {
    \clearpage
    \pagestyle { avaliacao@gabarito }
    { \sffamily
      \noindent { \Large \bfseries Gabarito } \par
      \vspace { 0.45em }
      { \small
        \avaliacao@univ \par
        \avaliacao@facul \par
        \avaliacao@major \par
        \avaliacao@course ~ ( \avaliacao@semester )
        \textemdash {} ~ \avaliacao@subject ~ ( \avaliacao@shift ) \par
      }
    }
    \medskip
    \noindent
    \begin { tabularx } { \linewidth }
    {
      @ { } > { \centering \arraybackslash } p { 4.5em } @ { \hspace { 1.25em } }
      > { \raggedright \arraybackslash } X @ { }
    }
    \textbf { Questão } & \textbf { Resposta } \\
    \hline
    \avaliacao@gabarito@rows
    \end { tabularx }
  }
}
\ExplSyntaxOff

\NewDocumentCommand{\valor}{mm}{#1\,\ensuremath{\mathrm{#2}}}
\NewDocumentCommand{\unidade}{m}{\ensuremath{\,\mathrm{#1}}}
\NewDocumentCommand{\outracoluna}{}{\avaliacao@ensurecols\vfill\columnbreak}

\DeclareMathOperator{\sen}{sen}

% -----------------------------------------------------
% Hyperlinks (optional display text)
% hyperref still delimits the URL with # after \hyper@normalise
% -----------------------------------------------------
\ExplSyntaxOn
\cs_new_protected:Npn \avaliacao@hrefafterurl #1
{
  \peek_meaning:NTF \bgroup
  { \href@ {#1} }
  { \href@ {#1} { \nolinkurl {#1} } }
}
% Trailing # in the parameter text: next token must be `{` (TeX / hyperref).
\cs_new_protected:Npn \avaliacao@hrefgraburl #
{ \hyper@normalise \avaliacao@hrefafterurl }
\cs_new_protected:Npn \avaliacao@patchhref
{
  \RenewDocumentCommand { \href } { O { } }
  {
    \begingroup
    \setkeys { href } {##1}
    \peek_meaning:NTF \bgroup
    { \avaliacao@hrefgraburl }
    { \hyper@normalise \href@ }
  }
}
\ExplSyntaxOff
\AddToHook{begindocument/before}{%
  \IfPackageLoadedTF{hyperref}{}{%
    \RequirePackage{hyperref}%
    \hypersetup{
      colorlinks=true,
      urlcolor=blue,
      linkcolor=black,
      citecolor=black,
      filecolor=blue,
    }%
  }%
  \IfPackageLoadedTF{xurl}{}{\RequirePackage{xurl}}%
  \urlstyle{same}%
  \avaliacao@patchhref
}

\endinput
