% Adapted from github.com/gijs-pennings/latex-homework

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2024/01/26 Richard's Homework Template]


% --------[ OPTIONS ]-----------------------------------------------------------

\newif\if@altquants
\newif\if@localnums \@localnumstrue
\newif\if@narrowmargins \@narrowmarginstrue
\newif\if@officialeuro


\DeclareOption{altquants}{\@altquantstrue} % While github.com/alerque/libertinus/issues/346 remains open
\DeclareOption{globalnums}{\@localnumsfalse}
\DeclareOption{officialeuro}{\@officialeurotrue}
\DeclareOption{widemargins}{\@narrowmarginsfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt]{article}


% --------[ PACKAGES: FONTS ]---------------------------------------------------

\RequirePackage[extrasp=0pt, mono, scale=.94, varqu]{inconsolata}
% extrasp=0pt          Disables extra space after sentence-ending period
% mono                 Disables space stretching and shrinking
% scale=.94            Scales size to roughly match Libertinus's x-height
% varqu                Replaces slanted by upright quotes (for code)

\RequirePackage[mono=false]{libertinus-type1}
% mono=false           Disables Libertinus Mono (would replace Inconsolata)

\RequirePackage[amsthm, lcgreekalpha, subscriptcorrection]{libertinust1math}
% amsthm               Loads amsthm package (in addition to amsmath)
% lcgreekalpha         Enables e.g. \mathbf for lower case Greek letters
% subscriptcorrection  Improves kerning of 'j' and others in subscripts

% Using tex.stackexchange.com/a/254626 and fonttable package
\DeclareFontEncoding{LS1}{}{}
\DeclareFontSubstitution{LS1}{stix2}{m}{n}
\DeclareSymbolFont{stix2-operators}{LS1}{stix2}{m}{n}
\DeclareSymbolFont{stix2-symbols3}{LS1}{stix2bb}{m}{n}

% Fonts are loaded before fontenc (tex.stackexchange.com/a/2869), and fontenc
% before inputenc (tex.stackexchange.com/a/44699). Loading inputenc is unneces-
% sary, but it's kept for compatibility (latexref.xyz/inputenc-package.html).
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% Typesets the title etc. in Libertinus Display. These declarations were copied
% from ltsect.dtx and modified. Since hyperref also redefines them (to make the
% pdfusetitle option work, among others), we do it before hyperref is loaded.
% TODO: could be applied to sections as well
\DeclareRobustCommand\title[1]{\gdef\@title{\LibertinusDisplay#1}}
\DeclareRobustCommand*\author[1]{\gdef\@author{\LibertinusDisplay#1}}
\DeclareRobustCommand*\date[1]{\gdef\@date{\LibertinusDisplay#1}}
\date\today % reinitializes \date with default value, so correct font is used


% --------[ PACKAGES: LANGUAGE ]------------------------------------------------

% Load early: tex.stackexchange.com/a/151864
\RequirePackage[american]{babel}


% --------[ PACKAGES: MATH ]----------------------------------------------------

\RequirePackage{mathtools}
\RequirePackage{mleftright}

% \left and \right introduce extra space around the delimiters. To remove this,
% we need to insert opening (\mathopen) and closing (\mathclose) atoms. The
% package mleftright defines commands that do this automatically (\mleft and
% \mright). The command below redefines the normal \left and \right as well.
% tex.stackexchange.com/a/2610
\mleftright


% --------[ PACKAGES: OTHER ]---------------------------------------------------

\RequirePackage[a4paper]{geometry}  % For margins etc.
\RequirePackage{aliascnt}           % Fixes autoref labels for shared counters
\RequirePackage{graphicx}           % For images and scale text
\RequirePackage{microtype}          % Improves typography
\RequirePackage[parfill]{parskip}   % Separates paragraphs by whitespace
\RequirePackage{xurl}               % Allows URLs to break (almost) anywhere

\if@officialeuro
    \RequirePackage[left]{eurosym}
    \let\@euro\euro
    \def\euro{\raisebox{.0027em}{\scalebox{.87}{\@euro}}}
    \DeclareUnicodeCharacter{20AC}{\euro}
\fi

\if@narrowmargins
    \geometry{margin=1in}
\fi


% --------[ PACKAGES: HYPERREF ]------------------------------------------------

% Load last: tex.stackexchange.com/q/1863
% .. and even later: mirrors.ctan.org/macros/latex/contrib/hyperref/doc/hyperref-doc.html#x1-540009
\RequirePackage[pdfusetitle]{hyperref}
\RequirePackage{ellipsis}   % Fixes space after \textellipsis

% Renames subsection labels (etc.) to 'section' for \autoref
\addto\extrasamerican{
    \let\subsectionautorefname\sectionautorefname
    \let\subsubsectionautorefname\sectionautorefname
    \let\paragraphautorefname\sectionautorefname
    \let\subparagraphautorefname\sectionautorefname
}

% Removes boxes around links and sets Creator field
\hypersetup{
    hidelinks,
    pdfcreator={LaTeX with homework.cls}
}

% Removes \, from all text when used for pdf fields (e.g. author)
\pdfstringdefDisableCommands{\def\,{}}

% Customizes space between dots to recreate Libertinus's ellipsis
\renewcommand{\ellipsisgap}{.045em}


% --------[ PATCHES ]-----------------------------------------------------------

% Fixes inconsistencies with libertinust1math (mathtools's conventions are used)
\renewcommand{\vcentcolon}{\!:\!}                                       % Both vertical and horizontal spacing is off
\DeclareMathSymbol{\coloneqq}{\mathrel}{symbols}{"65}                   % :=
\DeclareMathSymbol{\eqqcolon}{\mathrel}{symbols}{"66}                   % =:
\renewcommand{\coloneq}{\vcentcolon\mathrel{\mkern-1.2mu}\mathrel{-}}   % :- (missing in Libertinus)
\DeclareMathSymbol{\eqcolon}{\mathrel}{operators}{"EA}                  % -:

% Without this patch, there is too much vertical spacing above and below the
% proof environment. I've found no other environments that suffer from this,
% yet. This solution (copying & modifying the definition in amsthm.sty) was
% chosen because it requires no additional packages. I think the combination of
% parskip and the reassignment of \topsep in the original \proof is the cause.
% 192722, 339440, 522809 on tex.stackexchange.com/q/
\renewenvironment{proof}[1][\proofname]{%
    \par\pushQED{\qed}\normalfont% Removed: \topsep6\p@\@plus6\p@\relax
    \trivlist\item[\hskip\labelsep\itshape#1\@addpunct{.}]\ignorespaces%
}{%
    \popQED\endtrivlist\@endpefalse%
}


% --------[ CHARACTERS ]--------------------------------------------------------

% Defines * as \cdot (use \ast for asterisk symbol)
\DeclareMathSymbol{*}{\mathbin}{symbols}{"0C}

% Defines symbol for stochastic independence
\newcommand{\indep}{\mathrel{\perp\mkern-8mu\perp}}

% Swaps definition of \epsilon and \varepsilon
\DeclareMathSymbol{\epsilon}{\libus@lcgc}{letters}{"22}
\DeclareMathSymbol{\varepsilon}{\libus@lcgc}{operators}{"0F}

% Imports blackboard 1 from STIX (missing in Libertinus)
\DeclareMathSymbol{\@bbone}{\mathord}{stix2-symbols3}{"31}
\def\bbone{\scalebox{.93}{$\@bbone$}}

\if@altquants
    \DeclareMathSymbol{\forall} {\mathord}{stix2-operators}{"C5}
    \DeclareMathSymbol{\exists} {\mathord}{stix2-operators}{"C7}
    \DeclareMathSymbol{\nexists}{\mathord}{stix2-operators}{"C8}
\fi


% --------[ QUESTIONS ]---------------------------------------------------------

\newaliascnt{question}{section} % So \autoref associates correct name with label
\providecommand{\questionname}{Question}

\let\questionmark\@gobble
\let\toclevel@question\toclevel@section % For PDF bookmarks

% Disables numbering for questions, for both actual headers and in TOC
\def\l@question#1#2{\begingroup\let\numberline\@gobble\l@section{#1}{#2}\endgroup} % tex.stackexchange.com/a/62117
\def\@nonumsquestion{}
\def\@seccntformat#1{% www.texfaq.org/FAQ-seccntfmt
    \ifcsname @nonums#1\endcsname\else%
        \csname the#1\endcsname\quad% Default behavior for other section types, from ltsect.dtx
    \fi%
}

\newcommand{\@questionsection}{% Copied from article.cls and modified
    \@startsection%
        {question}{1}{\z@}%
        {-3.5ex \@plus -1ex \@minus -.2ex}%
        {2.3ex \@plus.2ex}%
        {\normalfont\Large\bfseries}%
}

\newcommand*{\@question}[1][\@nil]{% tex.stackexchange.com/a/217763
    \def\@arg{#1}%
    \begingroup\edef\x{\endgroup% Expands question counter for \nameref: tex.stackexchange.com/a/569405
        \noexpand\@questionsection{%
            \questionname{} % Note: space
            \ifx\@arg\@nnil\the\numexpr\value{question}+1\else#1\fi%
        }%
    }\x%
}

\newcommand{\question}{\@question}

\if@localnums
    \counterwithin{equation}{section} % Resets equation counter for each section/exercise
\fi

\newaliascnt{questionpart}{subsection} % So \autoref associates correct name with label
\providecommand{\questionpartname}{Part}

\let\questionpartmark\@gobble
\let\toclevel@questionpart\toclevel@subsection % For PDF bookmarks

% Disables numbering for questionparts, for both actual headers and in TOC
\def\l@questionpart#1#2{\begingroup\let\numberline\@gobble\l@section{#1}{#2}\endgroup} % tex.stackexchange.com/a/62117
\def\@nonumsquestionpart{}
\def\@seccntformat#1{% www.texfaq.org/FAQ-seccntfmt
    \ifcsname @nonums#1\endcsname\else%
        \csname the#1\endcsname\quad% Default behavior for other section types, from ltsect.dtx
    \fi%
}

% Copied from article.cls and modified
\newcommand{\@questionpartsection}{
    \@startsection
        {questionpart}{2}{\z@}
        {-3.25ex \@plus -1ex \@minus -.2ex}
        {1.5ex \@plus.2ex}
        {\normalfont\normalsize\bfseries}
}

\newcommand*{\@questionpart}[1][\@nil]{% tex.stackexchange.com/a/217763
    \def\@arg{#1}%
    \begingroup\edef\x{\endgroup% Expands questionpart counter for \nameref: tex.stackexchange.com/a/569405
        \noexpand\@questionpartsection{%
            \questionpartname{} % Note: space
            \ifx\@arg\@nnil\the\numexpr\value{questionpart}+1\else#1\fi%
        }%
    }\x%
}

\newcommand{\questionpart}{\@questionpart}


% --------[ THEOREMS ]----------------------------------------------------------

\newtheoremstyle{hw-plain}{}{}{\itshape}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-definition}{}{}{}{}{\bfseries}{ --- }{0pt}{}
\newtheoremstyle{hw-remark}{}{}{}{}{\itshape}{ --- }{0pt}{}

% The string used by \autoref (e.g. 'Lemma') depends on the counter of the
% command. Since all theorem-type commands use the equation counter, you'd get
% the wrong string (i.e. 'Equation'). We fool hyperref by defining an alias
% counter, and we define the right string for it (e.g. \lemmaautorefname).
% tex.stackexchange.com/a/113540
% TODO: add \expandafter to \MakeUppercase?
\newcommand*{\NewTheorem}[1]{
    \expandafter\providecommand\csname#1autorefname\endcsname{\MakeUppercase#1}
    \newaliascnt{#1}{equation}
    \newtheorem{#1}[#1]{\MakeUppercase#1}
    \newtheorem*{#1*}{\MakeUppercase#1}
    \aliascntresetthe{#1} % Section 1.2 of mirrors.ctan.org/macros/latex/contrib/oberdiek/aliascnt.pdf
}

\theoremstyle{hw-plain}
\NewTheorem{theorem}
\NewTheorem{lemma}
\NewTheorem{corollary}
\NewTheorem{proposition}

\theoremstyle{hw-definition}
\NewTheorem{definition}
\NewTheorem{example}

\theoremstyle{hw-remark}
\NewTheorem{remark}
\NewTheorem{note}

\newcommand{\thmlabel}[1]{\label{thm:#1}}
\newcommand{\lemlabel}[1]{\label{lem:#1}}
\newcommand{\corlabel}[1]{\label{cor:#1}}
\newcommand{\prolabel}[1]{\label{pro:#1}}
\newcommand{\deflabel}[1]{\label{def:#1}}
\newcommand{\explabel}[1]{\label{exp:#1}}

\newcommand{\thmref}[1]{Theorem \ref{thm:#1}}
\newcommand{\lemref}[1]{Lemma \ref{lem:#1}}
\newcommand{\corref}[1]{Corollary \ref{cor:#1}}
\newcommand{\proref}[1]{Proposition \ref{pro:#1}}
\newcommand{\defref}[1]{Definition \ref{def:#1}}
\newcommand{\expref}[1]{Example \ref{exp:#1}}


% --------[ MACROS: DELIMITERS ]------------------------------------------------

% Section 3.6 of mirrors.ctan.org/macros/latex/contrib/mathtools/mathtools.pdf
% \mid is of type \mathrel, so \; is used. In (script)script style \, is used.
\newcommand{\@renewmid}{\renewcommand{\mid}{
    \mathclose{}
    \mathchoice{\;}{\;}{\,}{\,}
    \delimsize\vert
    \mathchoice{\;}{\;}{\,}{\,}
    \mathopen{}
}}

% tex.stackexchange.com/a/43009
\DeclarePairedDelimiter{\@abs}{\lvert}{\rvert}
\DeclarePairedDelimiter{\@ceil}{\lceil}{\rceil}
\DeclarePairedDelimiter{\@floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\@angleb}{\langle}{\rangle}
\DeclarePairedDelimiter{\@norm}{\lVert}{\rVert}
\DeclarePairedDelimiterX{\@set}[1]{\{}{\}}{\@renewmid#1}
\DeclarePairedDelimiterX{\@Set}[1]{\{}{\}}{\@renewmid\nonscript\,#1\nonscript\,} % \nonscript suppresses \, in (script)script style

\def\abs{\@ifstar{\@abs}{\@abs*}}
\def\ceil{\@ifstar{\@ceil}{\@ceil*}}
\def\floor{\@ifstar{\@floor}{\@floor*}}
\def\angleb{\@ifstar{\@angleb}{\@angleb*}}
\def\norm{\@ifstar{\@norm}{\@norm*}}
\def\set{\@ifstar{\@set}{\@set*}}
\def\Set{\@ifstar{\@Set}{\@Set*}}


% --------[ MACROS: OTHER ]-----------------------------------------------------

% tex.stackexchange.com/a/42728
\newcommand*{\numberthis}[1]{\stepcounter{equation}\tag{\theequation}\label{#1}}

\newcommand{\N}{\mathbb N}
\newcommand{\Z}{\mathbb Z}
\newcommand{\Q}{\mathbb Q}
\newcommand{\R}{\mathbb R}
\newcommand{\C}{\mathbb C}
