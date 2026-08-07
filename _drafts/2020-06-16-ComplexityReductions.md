---
layout: post
title: Classical complexity reductions among hard lattice problems
date: 2020-06-16
author: Yogesh Swami
published: true
server_side_mathjax: false
tags: [svp, cvp, lattices, foundations]
mathjax_macros: |
  \[
    \newcommand{\A}{\mathbf{A}}
    \newcommand{\B}{\mathbf{B}}
    \newcommand{\C}{\mathbf{C}}
    \newcommand{\U}{\mathbf{U}}
    \newcommand{\V}{\mathbf{V}}
    \newcommand{\L}{\mathcal{L}}
    \newcommand{\P}{\mathcal{P}}
    \newcommand{\svp}{\mathsf{SVP}}
    \newcommand{\cvp}{\mathsf{CVP}}
    \newcommand{\abs}[1]{\lVert {#1} \rVert}
  \]
---

The difficulty of solving a hard lattice problem depends significantly
on the choice of its parameters. One cannot meaningfully discuss
cryptographic constructions --- especially FHE schemes --- without first
understanding the complexity landscape of lattice problems. This post
describes several classical (i.e., non-quantum) reductions among
different lattice problems. If you only care about the results, here's a
visual representation of the complexity of solving these problems as a
function of approximation ratio $\gamma$:

<figure id="SVP-CVP-Complexity-Landscape">

<img style="width:100vw;max-width:700px;min-width:400px;padding-top:10px;padding-bottom:10px" src="/Diagrams/2020-06-16/final/ComplexityLandscape.svg" alt="Hardness of approximating SVP and CVP as function of approximation parameter gamma"/>

<figurecaption>Hardness of approximating <span
class="lowercap">GapSVP</span> and <span class="lowercap">GapCVP</span> in
$\ell_2$ norm as a function of approximation ratio $\gamma(n)$.
<br/>(<span class="normal"><span class="lowercap">SVP</span>$^*$ under
randomized, quasi-polynomial reduction!</span>) </figurecaption>

</figure>

This chart is taken from [^AR05] with the following change: Khot's
seminal `GapSVP`{: .lowercap }$_{\gamma}$ inapproximability result from
[^K05], where $\gamma(n) \le 2^{(\log n)^{1/2 - \epsilon}}$ was proved
to be inapproximable, has been updated with Haviv-Regev's
inapproximability result from [^HR11] where
$\gamma(n) \le n^{c/\log \log n}$. These reductions are not covered in
this post as they deserve a standalone post with a discussion about
augmented tensor codes.

## `SVP`{: .mathsf } and `CVP`{: .mathsf } Problem Instances {#section--svp-cvp-instances}
---

Recall that an `NP Optimization (NPO)`{: .mathsf } problem is a
minimization or maximization problem where the goal is to find an
optimal solution from a set of possible solutions. An _approximation
algorithm_ for an `NPO`{: .mathsf } problem always returns a _valid
solution_, but with the caveat that it may not be optimal. However, even
in the worst case, these algorithms do provide the guarantee that the
output will be no worse than $\gamma > 1$ times the optimal solution.
$\gamma$ is called the _approximation ratio_ and its value depends on
the algorithm not the problem instance.

```Note [Approximation algorithms vs. Heuristics]
An approximation algorithm differs from a _heuristic algorithm_ in the
types of guarantees they provides. An approximation algorithm guarantees
that even for worst case problem instances:

1. The algorithm will terminate in polynomial time, and
2. The output will be no worse than $\gamma$ times the optimal.

A heuristic, on the other hand, provides no such guarantee. In spite of
this, for cryptanalysis, heuristic algorithms are just as important as
exact- or approximation algorithms.
```

Both `SVP`{: .mathsf} and `CVP`{: .mathsf} are `NP Optimization (NPO)`{:
.mathsf } problems. Recall, that an $\svp_\gamma$ [problem instance]({%
post_url 2020-06-08-LatticesBasicDefinitions
%}#jxkmath563xkj-approximate-shortest-vector-problems) consists of a
lattice $\L$ specified by a basis $\B \in \ZZ^{n\times n} \subseteq
\RR^{n\times n}$ and an approximation ratio $\gamma$. The goal is to
find a short (non-zero) lattice vector $\vec{x}\in \L$ such that
$\vec{x}$ is _at most_ $\gamma$ times longer that the _shortest_
(non-zero) vector in $\L$. In case of $\cvp_\gamma$, in addition to $\B$
and $\gamma$, we are also given a target vector $\vec{t} \in \RR^n$, and
the goal is to find some lattice vector $\vec{y} \in \L$ that is _at
most_ $\gamma$ times longer than the _shortest_ possible distance
between $\vec{t}$ and any point in $\L$.

The three different flavors of exact SVP ---  [Search-SVP]({% post_url
2020-06-08-LatticesBasicDefinitions
%}#problem--shortest-vector-problem){: .lowercap}, [Opt-SVP]({% post_url
2020-06-08-LatticesBasicDefinitions
%}#problem--shortest-vector-problem-opt){: .lowercap}, and
[Decisional-SVP]({% post_url 2020-06-08-LatticesBasicDefinitions
%}#problem--shortest-vector-problem-decisional){: .lowercap} --- as well
their approximate versions ---  [Approx-SVP$_\gamma$]({% post_url
2020-06-08-LatticesBasicDefinitions %}#approx-svp-problem){: .lowercap}
and [GapSVP$_\gamma$]({% post_url 2020-06-08-LatticesBasicDefinitions
%}#gap-svp-problem){: .lowercap} --- were described in detail in the
[previous post]({% post_url 2020-06-08-LatticesBasicDefinitions %}). The
next subsection formally defines the exact and approximate versions of
Closest Vector Problem (`CVP`{: .mathsf }). Readers already familiar
with `CVP`{: .mathsf } can safely skip the next subsection.

### The Closest Vector Problem {#subsection--cvp}

The distance between any _lattice vector_ $\vec{x} \in \L$ and a point
$\vec{t} \in \RR^n$ in space is defined as the usual euclidean distance
(or any $\ell_p$ norm) between two points in space: $\Delta(\vec{t},
\vec{x}) := \abs{\vec{t} -\vec{x}}$. However, a lattice is an infinite
collection of points, so defining the distance between a point and the
_entire lattice_ requires a new definition:

```Definition [Distance from a Lattice, Closest Vector] {#defn--lattice-point-distance}
Let $\L$ be a full-rank lattice specified by a basis
$\B \in \RR^{n\times n}$, and let $\vec{t} \in \RR^n$ be an arbitrary
point in space. Then, the distance between $\vec{t}$ and $\L$ is
defined as the _minimum distance_ between $\vec{t}$ and any point
$\vec{y}$ in the lattice, i.e.,
$$ \Delta(\vec{t}, \L) := \min_{\vec{y} \in \L} \lrbraces{ \norm{\vec{t} - \vec{y}} }.$$

A lattice vector $\vec{x} \in \L$ is a **closest vector** to $\vec{t}$ if
$\Delta(\vec{t}, \L) = \Delta(\vec{t}, \vec{x})$.
```

#### Exact Closest Vector Problem (<span class="mathsf">CVP</span>) {#subsubsection--cvp}

The _exact_ search, optimization, and decision problem related to
`CVP`{: .mathsf } are listed below:

```Problem [<span class="lowercap">Search-CVP</span>] {#problem--search-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : A point $\vec{t} \in \ZZ^n$.

Output
  : A vector $\vec{x} \in \L$ such that $\forall\,\vec{y} \in \L:\; \abs{\vec{t} - \vec{x}} \le \abs{\vec{t} - \vec{y}}$.

```

```Problem [<span class="lowercap">Opt-CVP</span>] {#problem--opt-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : A point $\vec{t} \in \ZZ^n$.

Output
  : The _length_ between $\vec{t}$ and the lattice $\L$, i.e.,
    $\Delta(\vec{t}, \L)$.

`Note`{: .bul }: In $\ell_p$ norm, the algorithm is allowed to return
$\Delta(\L, \vec{t})^p$ instead of $\Delta(\L, \vec{t})$.
```

```Problem [<span class="lowercap">Decisional-CVP</span>] {#problem--decisional-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : A point $\vec{t} \in \ZZ^n$.
  : A distance threshold $r \in \QQ$.

Output
  : `Yes`{: .lowercap } if $\Delta(\vec{t}, \L) \leq r$
  : `No`{: .lowercap } otherwise.

`Note`{: .bul }: The distance threshold $r$ is allowed to be
a rational number. However, it's assumed that the numerator and
the denominator of $r$ can be represented using polynomial (in
dimension) number of bits.
```

#### Approximate <span class="mathsf">CVP</span> {#subsubsection--approx-cvp}

Let $\gamma \in \RR$ be an approximation factor, which may depend upon
the dimension $n$ of the lattice $\L \subseteq \RR^n$. The approximate
search and decision (`Gap`{:.lowercap}) problems related to
`CVP`{:.mathsf} are listed below:

```Problem [<span class="lowercap">Approx-CVP$_\gamma$</span>] {#problem--approx-cvp-search}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \ZZ^n$.

Output
  : A lattice vector $\vec{x} \in \L$ such that $\forall\,\vec{y} \in \L:\; \abs{x} \le \gamma(n)\cdot \abs{y}$.
```


```Problem [<span class="lowercap">GapCVP$_\gamma$</span>] {#problem--GapCVP}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : An threshold value $r \in \QQ$.

Output
  : `Yes`{: .lowercap } if $\Delta(\vec{t}, \L) \le r$,
  : `No`{: .lowercap } if $\Delta(\vec{t}, \L) > \gamma(n)\cdot r$,
  : `Undefined`{: .lowercap }, otherwise.
```

```Remark [<span class="lowercap">Gap</span> Reductions] {#remark--gap-reductions}
If a problem $\mathcal{X}$ reduces to `GapCVP`{: .lowercap }, it's
important that the input to `GapCVP`{: .lowercap } oracle either
 correspond to the `Yes`{: .lowercap } instance or the `No`{:
 .lowercap } instance of the problem, but never to the
 `Undefined`{: .lowercap} instance.
```

## Reductions among exact problems {#section--exact-reductions}
---
This section lists a series of reductions related to `SVP`{: .mathsf}
and `CVP`{: .mathsf}.

### [<span class="lowercap">Search-CVP</span>](#problem--search-cvp) reduces to [<span class="lowercap">Decisional-CVP</span>](#problem--decisional-cvp) {#subsection-search-cvp-to-decisional-cvp-reduction}

We are given an oracle that can _somehow_ solve [<span class="lowercap">
Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp) for
any arbitrary lattice basis $\C \in \ZZ^{n\times n}$, target vector
$\vec{s} \in \ZZ^n$, and a distance threshold $r \in \RR$. Given another
basis $\B \in \ZZ^{n \times n}$ and a target vector $\vec{t} \in \ZZ^n$,
the goal of the reduction is to use the `Decisional-CVP`{: .lowercap}
oracle to find $\vec{x} \in \L(\B)$ such that $\abs{\vec{t} - \vec{x}} =
\Delta(\vec{t}, \L)$. Notice, that both sides of the previous equation,
namely $\vec{x}$ and $\Delta(\vec{t}, \L)$, are unknown.

Indeed, like most `Search`{: .lowercap} to `Decision`{: .lowercap}
reductions for `NP`{: .mathsf} optimization problems, the first
challenge is to compute the optimal measure, i.e., $\Delta(\vec{t}, \L)$
using the decisional oracle. In this particular case, that means coming
up with a reduction from [Opt-CVP](#problem--opt-cvp){: .lowercap} to
`Decisional-CVP`{: .lowercase}. Fortunately, the distance between
$\vec{t}$ and $\L$ is _polynomially bounded_ from above and below, and a
simple binary search is sufficient to compute $\Delta(\vec{t}, \L)$.
Once $\Delta(\vec{t}, \L)$ is known, we will use Babai's nearest plane
algorithm to solve `Search-CVP`{: .lowercap} using `Opt-CVP`{:
.lowercase} as an oracle.

These two reductions are described independently as follows:

```Reduction [<span class="lowercap">Opt-CVP</span> $\le$ <span class="lowercap">Decisional-CVP</span> ]
Input
  : Basis Vector $\B \in \ZZ^{n\times n}$
  : Target Vector $\vec{t} \in \ZZ$

Output
  : Distance between $\vec{t}$ and $\L$, i.e., $\Delta(\vec{t}, \L(\B))$.

Oracle
  : [<span class="lowercap">Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp), where $\C \in \ZZ^{n\times n}$, $\vec{s} \in \ZZ^n$, and $r \in \RR$.

Algorithm
  : We first establish a lower and upper bound on $\Delta(\vec{t}, \L)$.

    >
    > Claim-1
    >   : $\Delta(\vec{t}, \L) \ge 0$.
    >
    > Proof
    >   : The minimum distance between $\vec{t}$ and $\L$ cannot be less
          than zero, therefore $\Delta(\vec{t}, \L) \ge 0$. This minimum
          distance is realized if and only if $\vec{t} \in \L$.
          <div class="proof-end"/>
    >
    > Claim-2
    >   : Let $\vec{b}_i$ denote the $i$-th column of $\B$ and let
          $D(\B) := \ceil{\sum_{i=1}^n \abs{\vec{b}_i}} \in \ZZ$, then
    >     $$\Delta(\vec{t}, \L) \le D(\B).$$
    >
    > Proof
    >    : Recall that the lattice-translates of the parallelepiped
           tiles the entire space, that is,
           $$\RR^n = \bigcup_{\vec{y} \in \L} \vec{y} + \P(\L).$$
           Therefore, given the target vector $\vec{t} \in \RR^n$, it must
           fall in some lattice-translate of $\P(\B)$. Let
           $\vec{t} = \vec{y}^* + \vec{v}^*$ for some $\vec{y}^* \in \L(\B)$
           and $\vec{v}^* \in \P(\B)$. By definition,
           $\Delta(\vec{t}, \L)$ is the smallest distance between
           $\vec{t}$ and _any_ lattice point $\vec{y} \in \L$, therefore
           $$
           \Delta(\vec{t}, \L) \le \abs{\vec{t} - \vec{y}^*} = \abs{\vec{v}^*}.
           $$
    >
    >      Since $\vec{v}^* \in \P(\B)$, it can be written as the
           _fractional linear combination_ of columns of $\B$, namely,
           $\vec{v}^* = \sum_{i} u_i^*\cdot \vec{b}_i$ for uniquely determined
           $u_i^* \in [0,1) \subseteq \RR^n$. Hence,
           $$
           \Delta(\vec{t}, \L) \le \abs{\vec{v}^*} = \norm{\sum_i u_i^*\cdot \vec{b}_i} \le \sum_i \abs{u_i^*\cdot \vec{b}_i} \le \sum_i \abs{\vec{b}_i} \le D(\B).
          $$
          <div class="proof-end"/>
    >
    {: .details }

    Based on the upper and lower bounds on $\Delta(\vec{t}, \L)$, the
    `Opt-CVP`{: .lowercap}$(\B, \vec{t})$ solver can use _binary search_
    in the range $[0, D(\B)]$ to compute $\Delta(\vec{t}, \L)$ as follows:

    >
    > ###### <span class="lowercap">Opt-CVP</span> Solver
    > ---
    >
    > 1. The solver maintains a search range
       $(\alpha, \beta) \in \QQ^2$, where $\alpha$ and $\beta$ are initialized to
       $\alpha \leftarrow 0$ and $\beta \leftarrow D(\B).$
    >
    > 2. `Repeat until`{: .bul } $\beta - \alpha < \frac{1}{2^{O(n^c)}}$:
    >
    >    a. Set $\highlight{\gamma} = \frac{\alpha + \beta}{2}$.
    >
    >    b. `Invoke`{: .bul }
    >       `Decisional-CVP`{: .lowercap}$(\B, \vec{t}, \highlight{\gamma})$
    >       oracle to determine if $\Delta(\vec{t}, \L) < \highlight{\gamma}$?
    >
    >    c. If $\Delta(\vec{t}, \L) < \highlight{\gamma}\;$ `then`{: .bul} set
    >        $\beta \leftarrow \highlight{\gamma}$, `else`{: .bul}
    >        set $\alpha \leftarrow \highlight{\gamma}$.
    >
    >    d. `Continue`{: .bul} to step $2$.
    >
    > 3. `Return`{: .bul } $\beta$ (which is also equal to
    >    $\alpha$ within precision threshold).
    >
    {: .details }

  `Note`{: .bul}: The precision threshold $\frac{1}{2^{O(n^c)}}$
  determines the running time of this algorithm.
```


## Approximate Reductions

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
