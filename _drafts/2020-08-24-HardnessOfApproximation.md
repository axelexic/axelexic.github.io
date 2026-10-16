---
layout: post
title: Inapproximability of hard lattice problems
date: 2020-08-24
author: Yogesh Swami
tags: [svp, cvp, lattices, foundations]

mathjax_macros: |
  \[
    \newcommand{\A}{\mathbf{A}}
    \newcommand{\B}{\mathbf{B}}
    \newcommand{\C}{\mathbf{C}}
    \newcommand{\G}{\mathbf{G}}
    \newcommand{\U}{\mathbf{U}}
    \newcommand{\V}{\mathbf{V}}
    \newcommand{\L}{\mathcal{L}}
    \newcommand{\P}{\mathcal{P}}
    \newcommand{\dist}{\mathfrak{D}}
    \newcommand{\svp}{\mathsf{SVP}}
    \newcommand{\cvp}{\mathsf{CVP}}
    \newcommand{\abs}[1]{\lVert {#1} \rVert}
    \newcommand{\uvec}[1]{\overset{\mathbf{\scriptsize \hookrightarrow}}{#1}}
    \newcommand{\dotprod}[1]{\langle {#1} \rangle}
    \newcommand{\dual}[1]{{#1}^{\star}}
  \]
---

This post is a continuation of the [previous post]({% post_url
2020-06-16-ComplexityReductions %}) on the complexity of hard lattice
problems. While the previous post discussed the hardness of _exact_
lattice problems, this post covers the hardness of approximating  <span
class="mathsf">SVP</span>$_\gamma$ and <span
class="mathsf">CVP</span>$_\gamma$ as a function of $\gamma(n)$.
<!-- more -->

Recall from the previous complexity [landscape diagram]({% post_url
2020-06-16-ComplexityReductions %}#SVP-CVP-Complexity-Landscape) that
the hardness of solving <span class="mathsf">SVP</span>$_\gamma$ and
<span class="mathsf">CVP</span>$_\gamma$ depends greatly on the
approximation factor $\gamma(n)$. Goal of this post is prove the results
shown in this diagram.

<figure id="SVP-CVP-Complexity-Landscape">

<img style="width:100vw;max-width:700px;min-width:400px;padding-top:10px;padding-bottom:10px" src="/Diagrams/2020-06-16/final/ComplexityLandscape.svg" alt="Hardness of approximating SVP and CVP as function of approximation parameter gamma"/>

<figurecaption>Hardness of approximating <span
class="lowercap">GapSVP</span> and <span class="lowercap">GapCVP</span> in
$\ell_2$ norm as a function of approximation ratio $\gamma(n)$.
<br/>(<span class="normal"><span class="lowercap">SVP</span>$^*$ under
randomized, quasi-polynomial reduction!</span>) </figurecaption>

</figure>

## Hardness of approximating <span class="mathsf">SVP</span>$_\gamma$ and <span class="mathsf">CVP</span>$_\gamma$ {#section--hardness-of-approximation}

Recall that a `Gap`{:.lowercap} decision problem consists of an
$\NP$-Optimization (`NPO`{:.mathsf}) problem along a threshold $r$, and
the goal is to decide if the _optimal solution_ is less than $r$ or
greater than $\gamma(n) r$. If the optimal solution fall between $r$ and
$\gamma(n) r$, the algorithm is free to output either `Yes`{:.lowercap} or
`No`{:.lowercap} (or both `Yes`{:.lowercap} and `No`{:.lowercap} on
different invocations of the same problem, in case of Turing reduction).

The meta template for proving _inapproximability_ of an `NPO`{:.mathsf}
problem is to Karp reduce an _exact_ $\NP$-Complete problem to a
`Gap`{:.lowercap} `NPO`{:.mathsf} instance. Concretely, that means
coming up with an encoding function
$$\Xi : \braces{0,1}^n \mapsto \braces{0,1}^{\poly(n)}$$
that maps `Yes`{: .lowercap} and `No`{:.lowercap} instances of the
$\NP$-Complete problem to the corresponding `Yes`{: .lowercap} and
`No`{:.lowercap} instances of the `Gap`{:.lowercap} problem.
Conversely, if for some $x \in \braces{0,1}^{n}$, $\Xi(x)$ corresponds
to a `Yes`{: .lowercap} or `No`{:.lowercap} instance of the
`Gap`{:.lowercap} problem, then $x$ should correspond to a
`Yes`{:.lowercap} or `No`{:.lowercap} instance (respectively) of the
$\NP$-Complete problem.

As discussed before, `SVP`{: .mathsf} and `CVP`{: .mathsf} are not only
hard to solve _exactly_, but also hard to approximate within polynomial
factors. This section describes a series of reductions to establish the
`NP`{:mathsf}-hardness of approximating
[GapSVP$_\gamma$]({% post_url 2020-06-08-LatticesBasicDefinitions
%}#gap-svp-problem){: .lowercap} and
[GapCVP$_\gamma$](#problem--GapCVP){:.lowercap} as
a function of $\gamma(n)$. The primary purpose of these reductions is
to establish a _sharp asymptotic upper bound_ on $\gamma(n)$ up to which
these problems remain $\NP$-hard. But before describing these
reductions, we first prove a "_negative_" result about the $\NP$-hardness
of these problems: There exists a sufficiently large constant
$c > 0\in \RR$, such that $$\textsc{GapCVP}_{c\sqrt{n}} \in \NP\cap \coNP$$
Unless $\NP = \coNP$ (which is highly unlikely), this rules out the
possibility that `GapCVP`{:.lowercap}$_\gamma$ is `NP`{:.mathsf}-hard beyond
$\gamma \ge c\sqrt{n}$ approximation factor. Furthermore, there's a well known
_dimension and gap preserving_ reduction from `GapSVP`{:.lowercap}$_\gamma$ to
`GapCVP`{:.lowercap}$_\gamma$ which leads to a similar conclusion about
`GapSVP`{:.lowercap}$_\gamma$. These results are described next.

### <span class="lowercap">GapCVP</span>$_{O(\sqrt{n})} \in$ <span class="mathsf">NP</span> $\cap$ <span class="mathsf">coNP</span> {#subsection--GapCVP-in-NP-intersect-coNP}

This result is an adaptation of the result from [^AR05]. To keep the
proof self contained, the notion of dual lattices, transference theorem,
and Gaussian measure is developed first. Readers already familiar these
topics can skip to next subsection.

[^AR05]: **D. Aharonov** and **O. Regev**, "Lattice problems in $\NP
    \cap \coNP$," in Journal of the ACM (JACM), Volume 52, Issue 5.,
    [Pages 749 -
    765](https://dl.acm.org/doi/epdf/10.1145/1089023.1089025){:target="_blank"}.

[^HR11]: **I. Haviv** and **O. Regev**, "Tensor-based Hardness of the
    Shortest Vector Problem to within Almost Polynomial Factors," in
    Theory of Computing Journal, Volume 8 (2012), [Pages 513 -
    531](https://theoryofcomputing.org/articles/v008a023/v008a023.pdf){:target="_blank"}.

[^K05]: **S. Khot**, "Hardness of approximating the shortest vector
    problem in lattices," in Journal of the ACM (JACM), Volume 52, Issue 5., [Pages 789 - 808](https://dl.acm.org/doi/epdf/10.1145/1089023.1089027){:target="_blank"}

[^LLM06]: **Y. Liu**, **V. Lyubashevsky** and **D. Micciancio**, "On
    Bounded Distance Decoding for General Lattices," in 9th
    International Workshop on Approximation Algorithms for Combinatorial
    Optimization Problems, APPROX 2006 and 10th International Workshop
    on Randomization and Computation, RANDOM 2006, Barcelona, Spain,
    August 28-30, 2006. [Pages 450 -
    461](https://link.springer.com/chapter/10.1007/11830924_41){:target="_blank"}

[^BP20]: **H. Bennett** and **C. Peikert**, "Hardness of Bounded
    Distance Decoding on Lattices in $\ell_p$ Norms," in 35th
    Computational Complexity Conference (CCC 2020). [Available
    Online](https://d-nb.info/1366619331/34){:target="_blank"}

[^MG02]: **D. Micciancio** and **S. Goldwasser**, "Complexity of Lattice
    Problems: A Cryptographic Perspective," Springer, New York,
    NY., 2002, DOI:
    [https://doi.org/10.1007/978-1-4615-0897-7](https://doi.org/10.1007/978-1-4615-0897-7){:
    target="_blank"}

[^K87]: **R. Kannan**, "Minkowski’s convex body theorem and integer
    programming," Mathematics of Operations Research, 12(3), 1987.
    [Pages 415–440](http://www.jstor.org/stable/3689974){:
    target="_blank"}

[^vEB81]: **P. v. E. Boas**, "Another $\NP$-complete partition problem
    and the complexity of computing short vectors in a lattice,"
    Technical Report, 1981. [Available
    Online](https://staff.fnwi.uva.nl/p.vanemdeboas/vectors/mi8104c.html){:
    target="_blank"}. Unofficial copy: [<span class="pdf-icon"/>](/assets/posts/{{ page.date | date: "%Y-%m-%d" }}/van_emde_boas_1981.pdf){: target="_blank"}

[^GJ79]: **M. R. Garey** and **D. S. Johnson**, "Computers and
    Intractability: A Guide to the Theory of
    `NP`{: .mathsf}-Completeness," W. H. Freeman, 1979.

[^NSD16]: **N. Stephens-Davidowitz**, "Search-to-Decision Reductions for
    Lattice Problems with Approximation Factors (Slightly) Greater Than
    One," in Approximation, Randomization, and Combinatorial
    Optimization, Algorithms and Techniques (APPROX/RANDOM 2016),
    Article No. 19; [Pages
    19:1–19:18](https://drops.dagstuhl.de/storage/00lipics/lipics-vol060-approx-random2016/LIPIcs.APPROX-RANDOM.2016.19/LIPIcs.APPROX-RANDOM.2016.19.pdf){:
    target="_blank"}

[^KN23]: **K. Kreuzer** and **T. Nipkow**, "Verification of NP-hardness
    Reduction Functions for Exact Lattice Problems" in the Proceedings
    of CADE 29: 29th International Conference on Automated Deduction,
    Rome, Italy, July 1–4, 2023. [Available
    Online](https://arxiv.org/pdf/2306.08375){:target="_blank"}

[^JYC98]: **J.-Y. Cai** "A new transference theorem and applications to
    Ajtai's connection factor," in Electronic Colloquium on
    Computational Complexity, Report No. 5 (1998).
    [Available Online.](https://pages.cs.wisc.edu/~jyc/papers/transference.pdf){: target="_blank"}

[^WB93]: **W. Banaszczyk**, "New bounds in some transference theorems in
    the geometry of numbers," in Mathematische Annalen, Volume 296,
    [pages
    625–635](https://link.springer.com/article/10.1007/BF01445125){:
    target="_blank"} (1993). Unofficial copy: [<span class="pdf-icon"/>](/assets/posts/{{
    page.date | date: "%Y-%m-%d" }}/BanaszczykTransferenceTheorem.pdf){:
    target="_blank"}

[^NSD17]: **N. Stephens-Davidowitz**, "On the Gaussian Measure Over
    Lattices," Ph.D. Thesis, Department of Computer Science, New York
    University, September 2017. [Available
    Online.](https://cs.nyu.edu/media/publications/stephens-davidowitz_noah.pdf){:target="_blank"}

[^BO07]: **B. Osgood**, "The Fourier Transform and its Applications",
    Lecture notes for EE 261, Stanford University. [Available
    Online.](https://see.stanford.edu/materials/lsoftaee261/book-fall-07.pdf){:
    target="_blank"}