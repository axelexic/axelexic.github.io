---
layout: post
title: Classical complexity reductions among hard lattice problems
date: 2020-06-16
author: Yogesh Swami
published: true
server_side_mathjax: false
tags: [svp, cvp, lattices, foundations]
add_toc: "Yes"

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
_optimal solution_ from a set of possible solutions. An _approximation
algorithm_ for an `NPO`{: .mathsf } problem always returns a _valid
solution_, but with the caveat that it may not be optimal. However, even
in the worst case, these algorithms do provide the guarantee that the
output will be no worse than $\gamma > 1$ times the optimal solution.
$\gamma$ is called the _approximation ratio_ and its value depends on
the algorithm not the problem instance.

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

A specific subclass of `CVP`{: .mathsf }, similar in spirit to _unique
decoding_ of error correcting codes, is known as the Bounded Distance
Decoding (`BDD`{: .mathsf}) Problem [^LLM06]. The `BDD`{: .mathsf}
problem is formally defined as follows:

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
This section lists a series of reductions related to exact version of
`CVP`{: .mathsf} and `SVP`{: .mathsf}.

### [Decisional-CVP](#problem--decisional-cvp){: .lowercap} is $\NP$-Complete

We are given a lattice basis $\B \in \ZZ^{n \times n}$, a target vector
$\vec{t} \in \QQ^n$, and a distance threshold $r \in \QQ$. To prove
`Decisional-CVP`{: .lowercap} is in $\NP$, we need to provide a witness
and an efficient verification procedure that can validate the claim:
$$\Delta(\vec{t}, \L(\B)) \highlight{\stackrel{?}{\le}} r.$$

If $\Delta(\vec{t}, \L(\B)) \le r$, then there exists
$\vec{x} \in \L(\B)$ such that $\abs{\vec{t} - \vec{x}} \le r$. Any
such $\vec{x}$ can act as an $\NP$ witness with the following
verification procedure:

1. Verifier computes $r' := \abs{\vec{x} - \vec{t}}$ and checks
   $r' \highlight{\stackrel{?}{\le}} r$.
2. Verifier checks whether $\vec{x} \highlight{\stackrel{?}{\in}} \L(\B)$
   by treating $\B$ as an element of $\QQ^{n \times n}$ and $\vec{x}$
   as an element of $\QQ^n$ and solving the following linear equation in
   $\vec{z} \in \QQ$:
   $$\B\cdot\vec{z} = \vec{x}. $$
   If all elements of $\vec{z}$ turn out to be integers (i.e.,
   has denominator $1$) then $\vec{x} \in \L(\B)$ otherwise not.

To prove $\NP$-Completeness, a reduction from `Subset-Sum`{: .lowercap}
 to `Decisional-CVP`{: .lowercap} suffice (reduction below is
 adapted from Chapter 03 of [^MG02]). But first, the
 `Subset-Sum`{: .lowercap} problem (`SSP`{: .mathsf}) is defined
 precisely.

```Problem [<span class="lowercap">Subset-Sum</span>]{#problem--subset-sum}
Input
  : A set $A := \braces{a_1,\cdots, a_n} \subseteq \ZZ$ of $n$ integers
    (distinct by definition of a set).
  : A target sum $U \in \ZZ$.

Output
  : `Yes`{: .lowercap } if there exists a subset $A' \subseteq A$ such that $U = \sum_{a' \in A'} a'$
  : `No`{: .lowercap} otherwise

Subset sum is a well known
[$\NP$-complete problem](https://www.iitg.ac.in/deepkesh/CS301/assignment-2/subsetsum.pdf){: target="_blank"}, with various applications in cryptography and
cryptanalysis.
```

```Reduction [<span class="lowercap">Subset-Sum</span> $\preceq$ <span class="lowercap">Decisional-CVP</span>] {#reduction--subset-sum-to-decisional-cvp}
Input
  : A set $A = \braces{a_1,\cdots, a_n} \subseteq \ZZ$,
  : A target sum $U \in \ZZ$.

Output
  : `Yes`{: .lowercap } if $\exists A' \subseteq A:\; \sum_{a' \in A'} a' = U$
  : `No`{: .lowercap} otherwise.

Oracle
  : [<span class="lowercap">Decisional-CVP</span>$(\B, \vec{t}, r)$](#problem--decisional-cvp)
    where $\B \in \ZZ^{(n+1) \times n}$, $\vec{t} \in \QQ^{n+1}$ and
    $r \in \QQ$. (`Note`{: .bul}: Given a fixed target $\vec{t}$,
    there are standard techniques to transform low-rank
    `CVP`{: .mathsf} instances into a full rank
    `CVP`{: mathsf} instance.)

Algorithm
  : Let $\abs{\cdot}_p$ denote the usual $\ell_p$ norm. Recall
    that $\ell_p$ norm of a vector $\vec{x} = \braces{x_i}$ is defined as
    $$
    \norm{\vec{x}}_p = \begin{cases}
                        \sqrt[p]{\sum_i \norm{x_i}_p^p} & \text{if } p < \infty\\
                        & \\
                        \max_i\lrbraces{ \left|x_i \right| } & \text{if } p = \infty
                       \end{cases}
    $$

    While this post is mainly geared towards $\ell_2$ norm, this
    reduction works for arbitrary $\ell_p$ norm without much
    technicality, therefore the proof is given in full generality.

    Given $A = \braces{a_i}$, the reduction needs to convert the
    `Subset-Sum`{:.lowercap} instance into a
    `Decisional-CVP`{:.lowercap} instance. Consider the following
    `Decisional-CVP`{:.lowercap} instance
    $$
    \begin{equation}
    \begin{aligned}
    \B &:= \begin{pmatrix}
          \highlight{n}\cdot a_1 & \highlight{n}\cdot a_2  & \cdots & \highlight{n}\cdot a_n  \\
          2   & 0    & \cdots & 0    \\
          0   & 2    & \cdots & 0    \\
          \vdots & \vdots & \ddots & \vdots \\
          0   & 0    & \cdots & 2   \\
          \end{pmatrix} \in \ZZ^{(n+1)\times n}, \\
          & \\
          \vec{t} &:= \begin{pmatrix}
                      \highlight{n}\cdot U \\
                      1 \\
                      1 \\
                      \vdots \\
                      1 \\
                      1
                      \end{pmatrix} \in \ZZ^{n+1} \subseteq \QQ^{n+1}
          \quad\text{and}, \\ &\\
          r &:= \begin{cases}
                                      \highlight{\sqrt[p]{n}} & \text{for } p < \infty\\
                                      & \\
                                      \highlight{1} & \text{for } \ell_\infty\; \text{norm}
                                    \end{cases}
        \end{aligned}
          \label{subset-sum-to-cvp-instance}
    \end{equation}
    $$

    If $\vec{z} := \braces{z_1,\cdots,z_n} \in \ZZ^n$ then the
    difference between a lattice vector $\B\cdot \vec{z}$ and
    $\vec{t}$ is:
    $$
      \begin{equation}
      \B\cdot\vec{z} - \vec{t} = \begin{pmatrix}
                      \highlight{n}\sum_{i=1}^n z_i\cdot a_i - \highlight{n} U \\
                      2z_1-1 \\
                      \vdots \\
                      2z_n - 1
                      \end{pmatrix} \in \QQ^{n+1}
      \label{subset-sum-lattice-vec}
      \end{equation}
    $$

    We will prove that `Subset-Sum`{:.lowercap}$(A, U)$ is
    `True`{: .lowercap} _if and only if_
    $\Delta_{\highlight{p}}(\vec{t}, \L(\B)) \le r$, where
    $\Delta_\highlight{p}(\cdot, \cdot)$ denotes the distance of $\vec{t}$ from
    $\L(\B)$ in $\ell_p$ norm.

    >
    > $(\Rightarrow)$
    >   : Suppose `Subset-Sum`{:.lowercap}$(A, U)$ is `True`{:.lowercap}.
          Then there exists an index set
          $J := \braces{j_1,\cdots,j_k} \subseteq \braces{1,2,\cdots, n}$
          such that $\sum_{1 \le i \le k} a_{j_i} = U$. Consider
          $$\vec{z} := \braces{z_1, \cdots, z_n} \in \ZZ^{n},\quad (z_i \in \braces{0,1})$$
          where $z_i = 1$ if $i \in J$ and zero otherwise. Then by
          \eqref{subset-sum-lattice-vec}
          $$\B\cdot\vec{z} - \vec{t}=\begin{pmatrix}
                      0 \\
                      2z_1-1 \\
                      \vdots \\
                      2z_n - 1
                      \end{pmatrix}
          $$
    >     Since $z_i \in \braces{0,1}$ $\highlight{\implies}$
          $2z_i - 1 \in \braces{-1,1}$ $\highlight{\implies}$
          $\norm{\B\cdot \vec{z} - \vec{t}}_p = \begin{cases}\sqrt[p]{n}& \text{if } p < \infty \\ 1 & \text{if } p = \infty\end{cases}$
          $\highlight{\implies}$ $\Delta_p(\vec{t}, \B) \le r$ and
          `Decisional-CVP`{:.lowercap}$(\B, \vec{t}, r)$
    >      correspond to an `Yes`{:.lowercap} instance.
    >      <div class="proof-end"/>
    >
    {: .details}

    >
    > $(\Leftarrow)$
    >   : Conversely, suppose $\Delta_p(\vec{t}, \L(\B)) \le r$.
          We need to show that
          $\exists\;\vec{z} := \braces{z_1,\cdots,z_n} \in \highlight{\braces{0,1}^n}$,
    >     such that $\sum_{z_i \in \vec{z}} z_i\cdot a_i = U$. By
          \eqref{subset-sum-lattice-vec}
          $$
            \norm{\B\cdot\vec{z} - \vec{t}}_p^p = \begin{cases}
              n^p\cdot\norm{\sum_{i=1}^{n}z_i\cdot a_i - U}_p^p + \sum_{j=1}^{n} \norm{2z_j - 1}_p^p & \text{if } p < \infty\\
              & \\
              \max_{1 \le i \le n}\lrbraces{ \left|2z_i-1\right|, \;\;n\cdot\left|\sum_{i=j}^{n}z_j\cdot a_j - U\right| } & \text{if } p = \infty
              \end{cases}
          $$
    >
    >     We consider $\ell_{p|_{p < \infty}}$ and $\ell_\infty$ norms separately:
    >
    >     $\ell_{p|_{p < \infty}}$ norm
    >       : Since each $z_i$ is an integer, $\norm{2z_i - 1}_p \ge 1$.
                Therefore $$\sum_{j=1}^{n} \norm{2z_j - 1}_p^p \ge n$$
                which implies $\norm{\B\cdot\vec{z} - \vec{t}}_p^p \ge n$.
                However, by assumption,
                $\norm{\B\cdot\vec{z} - \vec{t}}_p^p \le n$ therefore the only feasible solution is
                $$\begin{aligned}
                  & \norm{\B\cdot\vec{z} - \vec{t}}_p^p = n \\
                  \highlight{\implies} & \norm{n^p\left(\sum_{i=1}^{n}z_i\cdot a_i - U\right)}_p^p = 0 \;\;\text{and}\;\; \forall i: \abs{2z_i - 1}_p = 1 \\
                  \highlight{\implies} & \sum_{i=1}^{n}z_i\cdot a_i =  U\;\;\text{and}\;\; \braces{z_1,\cdots, z_n} \in \braces{0,1}.
                  \end{aligned}
                $$
    >
    >     $\ell_\infty$ norm
    >       : As before, $\forall z_i \in \ZZ: |2z_i - 1| \ge 1.$ If $|\sum_{i=1}^{n}z_i\cdot a_i - U| \ne 0$ then
    >         $$\max_{1\le i \le n}\lrbraces{\;|2z_i - 1|,\;\;n\cdot \left|\sum_{j=1}^{n}z_j\cdot a_j - U\right|} \ge n.$$
    >         By assumption, $\Delta_\infty(\B, \vec{t}) \le 1$.
    >         Therefore, the only feasible solution is
              $$\begin{aligned}
                  & \norm{\B\cdot\vec{z} - \vec{t}}_\infty = 1 \;\;\text{and}\;\; \left|\sum_{j=1}^{n}z_j\cdot a_j - U\right| = 0\\
                  \highlight{\implies} & \forall i: |2z_i - 1| = 1\\
                  \highlight{\implies} & \sum_{i=1}^{n}z_i\cdot a_i =  U\;\;\text{and}\;\; \braces{z_1,\cdots, z_n} \in \braces{0,1}.
                  \end{aligned}
                $$
    > <div class="proof-end"/>
    >
    {: .details}

  Based on the result above, a `Subset-Sum`{: .lowercap} problem instance
  can be encoded as a `Decisional-CVP`{: .lowercap} instance using
  \eqref{subset-sum-to-cvp-instance}. Since `Subset-Sum`{: .lowercap} is
  $\NP$-complete, `Decisional-CVP`{: .lowercap} is also $\NP$-complete.
```

### [Decisional-SVP]({% post_url 2020-06-08-LatticesBasicDefinitions %}#problem--shortest-vector-problem-decisional){: .lowercap} is $\NP$-Complete in $\ell_\infty$ norm

This result is adapted from [^vEB81].

### [Search-SVP]({% post_url 2020-06-08-LatticesBasicDefinitions %}/#problem--shortest-vector-problem-decisional){: .lowercap} is $\NP$-Hard in $\ell_2$ norm

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

Since $d^\dagger$ remains fixed while $\lambda_1(\B^*)$ keeps doubling,
after an appropriate (polynomial) number of iterations, the
[Search-CVP](#problem--search-cvp){: .lowercap} instance transforms
into an [$\alpha$-BDD](#problem--bdd){:.lowercap} instance with
$\alpha < \frac{1}{1+2^{n/2}}$. For such small values of $\alpha$,
Babai's Nearest Plane _approximation algorithm_ solves
$\alpha{-}$`BDD`{:.lowercap} instance exactly, leading to a polynomial
time reduction. (`Note`{: .bul}: There are other ways of getting this
reduction [^K87], but this is most elegant, in my opinion.)

These reductions are described in detail as follows:

```Reduction [<span class="lowercap">Opt-CVP</span> $\preceq$ <span class="lowercap">Decisional-CVP</span> ]
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
           $$\RR^n = \bigcup_{\vec{y} \in \L} \vec{y} + \P(\B).$$
           Therefore, given the target vector $\vec{t} \in \RR^n$, it must
           fall in some lattice-translate of $\P(\B)$. Let
           $\vec{t} = \vec{y}^* + \vec{v}^*$ for some $\vec{y}^* \in \L(\B)$
           and $\vec{v}^* \in \P(\B)$. By definition,
           $\Delta(\vec{t}, \L)$ is the smallest distance between
           $\vec{t}$ and _any_ lattice vector $\vec{y} \in \L$, therefore
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
    >       `Decisional-CVP`{: .lowercap}$(\B, \vec{t}, \highlight{\psi})$
    >       oracle to determine if $\Delta(\vec{t}, \L) < \highlight{\psi}$?
    >
    >    c. If $\Delta(\vec{t}, \L) < \highlight{\psi}\;$ `then`{: .bul} set
    >        $\beta \leftarrow \highlight{\psi}$, `else`{: .bul}
    >        set $\alpha \leftarrow \highlight{\psi}$.
    >
    >    d. `Continue`{: .bul} to step $2$.
    >
    > 3. `Return`{: .bul } $\beta$ (which is also equal to
    >    $\alpha$ within precision threshold).
    >
    {: .details }

  `Note`{: .bul}: The precision threshold $\frac{1}{2^{O(n^c)}}$
  determines the running a of this algorithm.$.
```



  The exact steps of the reduction are described below:

  > ###### <span class="lowercap">Search-CVP</span> solver via $\frac{1}{1 + 2^{n/2}}$<span class="lowercap">-BDD</span>
  > <hr/>
  >
  > 1. Compute $L = \min_{1 \le i \le n}\{ \abs{\vec{b}_i } \}$
  > 2. `set`{: .bul} iteration count $k = \ceil{ \log_2(1 + 2^{n/2}) + \log_2(d^\dagger / L) }$
  > 3. `set`{: .bul} displacement vector $\vec{h} = \vec{0} \in \L(\B)$
  > 4. `for`{:.bul} $i \leftarrow 1\cdots k$ `do`{: .bul}
  >
  >    * `for`{: .bul} $j = 1\cdots n$ `do`{: .bul}
  >
  >       * Let the basis so far be $\B = [\vec{b}_1, \cdots, \vec{b}_n]$,
            `update`{: .bul} basis:
            $$\B \leftarrow \left[\vec{b}_1,\cdots, \vec{b}_{j-1},\;\highlight{2\cdot\vec{b}_j},\;\vec{b}_{j+1}, \cdots, \vec{b}_n \right]$$
  >
  >       * `invoke`{: .bul} $\;\;\xi \leftarrow$ `Decisional-CVP`{: .lowercap}$(\B, \vec{t}, d^\dagger)$ and `update`{: .bul} $$\begin{aligned} \vec{t} &\leftarrow \vec{t} + (1 - \xi)\cdot \vec{b}_j\\ \vec{h} &\leftarrow \vec{h} + (1-\xi)\cdot \vec{b}_j \end{aligned} $$
  >
  > 5. `compute`{: .bul} `LLL`{: .mathsf} reduced basis $\widetilde{\B} \leftarrow \textsf{LLL}(\B)$.
  >
  > 6. `invoke`{: .bul} $\;\;\vec{x} \leftarrow \alpha$`-BDD`{:.lowercap}$(\widetilde{\B}, \vec{t})$.
  >
  > 6. `return`{: .bul} $\vec{x} - \vec{h}$.
  {: .details }

`Note`{: .bul}: Even though the `BDD`{: .mathsf} oracle is invoked on
`LLL`{: .mathsf} reduced basis, the closeness of $\vec{x}$ to $\vec{t}$
is independent of the choice of basis.
```

The next subsection describes Babai's nearest plane algorithm and proves
that it solves $\alpha$`-BDD`{: .lowercap} exactly for
$\alpha < \frac{1}{1+2^{n/2}}$.

#### Polynomial time algorithm for $\frac{1}{1+2^{n/2}}$`-BDD`{: .lowercap} instance {#section--polynomial-time-algorithm}

Babai's nearest plane algorithm is a polynomial time _approximation
algorithm_ for `CVP`{: .mathsf}. Details of this algorithm for an arbitrary
lattice basis $\B$ is described below.

```Algorithm [Babai's Nearest Plane Algorithm]{#algo--babai-nearest-plane}
Input
  : A non-singular lattice basis $\B = \braces{b_i} \in \ZZ^{n\times n}$
  : A target vector $\vec{t} \in \QQ^n$

Output
  : $\vec{x} \in \L(\B)$
  : $\vec{e} \in \P(\B^\perp)$ such that $\vec{t} = \vec{x} + \vec{e}$
    where $\P(\B^\perp)$ is fundamental domain of Gram-Schmidt
    orthogonal basis.

The algorithm works by computing the Gram-Schmidt orthogonal basis
$\B^\perp := [\vec{b}_1^\perp,\cdots, \vec{b}_n^\perp]$
and progressively projecting the target vector to $\vec{b}_i^\perp$ and uses rounding to
find a lattice vector "close" to $\vec{t}$.

In more detail:

> 1. Compute Gram-Schmidt orthogonal basis
     $\B^\perp := [\vec{b}_1^\perp,\cdots, \vec{b}_n^\perp] \leftarrow \textsf{gso}(\B) \in \QQ^{n\times n}$
>
> 2. `Initialize`{: .bul} error term $\vec{e} \leftarrow \vec{t} \in \QQ^n$
>
> 3. `Initialize`{: .bul} "close" lattice $\vec{x} \leftarrow \vec{0} \in \ZZ^{n}$
>
> 4. `for`{: .bul #algo--bababi-nearest-plane-step-4} $i \leftarrow n\cdots 1$ `do`{: .bul}
>
>    * Compute $k := \round{ \frac{\left \langle \vec{e},\;\vec{b}_i^\perp \right \rangle}{\norm{\vec{b}_i^\perp}^2} } \in \ZZ$
>
>    * $\vec{e} \leftarrow \vec{e} - k\cdot \vec{b}_i$
>
>    * $\vec{x} \leftarrow \vec{x} + k\cdot \vec{b}_i$
> 5. `Return`{: .bul} $(\vec{x}, \vec{e})$.
>
{: .details }
```

For an arbitrary (bad) basis $\B$, this algorithm does not guarantee
that its output will be a known bounded approximation to
[Search-CVP](#problem--search-cvp){: .lowercap}. If $\B$ is an
[LLL](https://ocw.mit.edu/courses/18-409-topics-in-theoretical-computer-science-an-algorithmists-toolkit-fall-2009/eaa6bc3cd49d94630490cfe3227fa5dc_MIT18_409F09_scribe20.pdf#page=2){: target="_blank" .mathsf}
reduced basis, then one can show that $\vec{x}$ is guaranteed to be at a
distance that's _at most_ $2^{n/2}$ times the optimal. That is, if the
optional solution to `Search-CVP`{: .lowercap}$(\B, \vec{t})$ is
$\highlight{\vec{x}^\dagger}$ then
$$
  \abs{\vec{x} - \vec{t}} \le  2^{n/2} \cdot \Delta(\vec{t}, \L(\B)) = 2^{n/2} \cdot \abs{\highlight{\vec{x}^\dagger} - \vec{t}}.
$$

More generally, suppose Babai's nearest plane algorithm returns
$\vec{x} \in \L(\B)$ that's a $\gamma(n)$ approximation to
`Search-CVP`{: .lowercap}, i.e.,
$\abs{\vec{x} - \vec{t}} \le  \gamma(n) \cdot \Delta(\vec{t}, \L(\B))$.
For an [$\alpha$-BDD](#problem--bdd){:.lowercap} problem instance, we
wish to derive the range of values of $\alpha \in [0, \frac{1}{2})$ for
which Babai's nearest plane algorithm can solve `Search-CVP`{:
.lowercap} _exactly_ in polynomial time.

By triangle inequality
$$
\begin{equation}
\abs{\vec{x} - \vec{x}^\dagger} = \abs{\vec{x} - \vec{t} + \highlight{\vec{t} - \vec{x}^\dagger}} \le \abs{\vec{x} - \vec{t}} + \highlight{\abs{\vec{x}^\dagger - \vec{t}}}
\label{bdd-triangle-inequality}
\end{equation}
$$

By assumption, for an $\alpha$`-BDD`{: .lowercap} instance,
$\abs{\vec{x}^\dagger - \vec{t}} < \alpha\cdot\lambda_1$. Furthermore,
the nearest plane algorithm guarantees that
$\abs{\vec{x} - \vec{t}} < \gamma(n)\cdot \Delta(\vec{t}, \L(\B))$, which
again by $\alpha$`-BDD`{: .lowercap} promise implies
$\abs{\vec{x} - \vec{t}} < \gamma(n)\cdot\alpha\cdot \lambda_1$.
Therefore by \eqref{bdd-triangle-inequality}:
$$
\abs{\vec{x} - \vec{x}^\dagger} \highlight{\le} \gamma(n)\cdot\Delta(\vec{t}, \L(\B)) + \alpha\cdot\lambda_1 \highlight{\le} \gamma(n)\cdot\alpha\cdot \lambda_1
 + \alpha\cdot\lambda_1 \highlight{=} (1 + \gamma(n))\cdot \alpha \cdot \lambda_1.$$

On the other hand, if $\vec{x}$ and $\vec{x}^\dagger$ are distinct, then
$\lambda_1 \le \abs{\vec{x} - \vec{x}^\dagger}$, and hence
$$
  \lambda_1 \highlight{\le} (1 + \gamma(n))\cdot \alpha \cdot \lambda_1 \highlight{\implies}  \alpha \ge \frac{1}{1 + \gamma(n)}.
$$

In other words, if $\alpha \ge \frac{1}{1 + \gamma(n)}$ then Babai's
nearest plane algorithm is likely to output a lattice vector that's
not necessarily the optimal $\vec{x}^\dagger$. Conversely,
if $\alpha < \frac{1}{1 + \gamma(n)}$ then $\vec{x}$ and
$\vec{x}^\dagger$ cannot be distinct and Babai's nearest plane algorithm
_will output_ the optimal solution to `Search-CVP`{: .lowercap}!
For example, if $\B$ is an `LLL`{: .mathsf} reduced
basis, then for $\alpha <  \frac{1}{1 + 2^{n/2}}$, the nearest plane
algorithm will output _the optimal_ solution to `Search-CVP`{: .lowercap}.

`Sanity Check`{: .bul}: If $\gamma(n) = 1$ then the result above
 requires $\alpha < \frac{1}{2}$ for a unique solution, which matches
 with the uniqueness requirement for $\alpha$`-BDD`{: .lowercap}.

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
    and the complexity of computing short vectors in a lattice.
    Technical Report, 1981. [Available
    Online](https://staff.fnwi.uva.nl/p.vanemdeboas/vectors/mi8104c.html){:
    target="_blank"}
