---
layout: post
title: Classical complexity reductions among hard lattice problems
date: 2020-06-16
author: Yogesh Swami
last_modified: 2024-02-03
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
    \newcommand{\uvec}[1]{\overset{\mathbf{\scriptsize \hookrightarrow}}{#1}}
    \newcommand{\dotprod}[1]{\langle {#1} \rangle}
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
seminal `GapSVP`{: .lowercap }$_{\gamma}$ inapproximability result
[^K05], where $\gamma(n) \le 2^{(\log n)^{1/2 - \epsilon}}$ was proved
to be inapproximable, has been updated with Haviv-Regev's
inapproximability result from [^HR11] where
$\gamma(n) \le n^{c/\log \log n}$.

## <span class="mathsf">SVP</span> and <span class="mathsf">CVP</span> Problem Instances {#section--svp-cvp-instances}
---

Recall that an `NP Optimization (NPO)`{: .mathsf } problem is a
minimization or maximization problem where the goal is to find an
_optimal solution_ from a set of possible solutions. An _approximation
algorithm_ for an `NPO`{: .mathsf } problem always returns a _valid
solution_, but with the caveat that it may not be optimal. However, even
in the worst case, these algorithms do provide the guarantee that the
output will be no worse than $ \gamma \in \RR \;(\gamma \ge 1) $ times the
optimal. $\gamma$ is called the _approximation ratio_ and its
value depends on the algorithm, not the problem instance.

Both `SVP`{: .mathsf} and `CVP`{: .mathsf} are `NP Optimization (NPO)`{:
.mathsf } problems. Recall that an `SVP`{: .mathsf}$_\gamma$[problem instance]({%
post_url 2020-06-08-LatticesBasicDefinitions
%}#jxkmath563xkj-approximate-shortest-vector-problems)  consists of a
lattice $\L$ specified by a basis $\B \in \RR^{n\times n}$ and an
approximation ratio $\gamma$. The goal is to find a short (non-zero)
lattice vector $\vec{x}\in \L(\B)$ such that $\vec{x}$ is _at most_
$\gamma$ times longer than the _shortest_ (non-zero) vector in $\L(\B)$.
In case of `CVP`{: .mathsf}$_\gamma$, in addition to $\B$ and $\gamma$, we are also
given a target vector $\vec{t} \in \RR^n$, and the goal is to find some
lattice vector $\vec{y} \in \L$ that is _at most_ $\gamma$ times longer
than the _shortest_ possible distance between $\vec{t}$ and any point in
$\L$.

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
$\vec{t} \in \RR^n$ in space is defined as the usual Euclidean distance
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

```Problem [Bounded distance Decoding, $\alpha$<span class="lowercap">-BDD</span>] {#problem--bdd}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$ whose shortest non-zero vector has length
    $\lambda_1$. ($\lambda_1$ is not an explicit input to the algorithm.)
  : A target vector $\vec{t} \in \QQ^n$ with the guarantee that
    $0 \le \Delta(\vec{t}, \L(\B)) < \highlight{\alpha}\cdot\lambda_1$.

Output
  : A _unique_ vector $\vec{x} \in \L(\B)$ such that
    $\forall\,\vec{y} \in \L(\B) :\; \abs{\vec{t} - \vec{x}} \le \abs{\vec{t} - \vec{y}}$.

`Note`{: .bul}: $\alpha$ is a measure of the effectiveness of the
algorithm. It must satisfy the constraint
$0 < \highlight{\alpha} \le \frac{1}{2}$ to ensure that there's a
_unique lattice vector_ $\vec{x} \in \L(\B)$ that's closest to $\vec{t}$.
Consequently, $\vec{t}$ can be written as $\vec{t} = \vec{x} + \vec{e}$
where $\vec{x} \in \L(\B)$ and $\vec{e} \in \P(\B)$ are uniquely determined.
```

Complexity results related to `BDD`{: .mathsf} are not discussed further
in this post. See [^LLM06] (and a very recent work by Bennett and Peikert
[^BP20], which I haven't fully read) for a deeper dive.

#### Approximate Closest Vector Problem (<span class="mathsf">$\gamma$-CVP</span>) {#subsubsection--approx-cvp}

Let $\gamma \in \RR\;(\gamma \ge 1)$  be an approximation factor. $\gamma$
will often be written as $\gamma(n)$ to emphasize its dependence on
the dimension of $\L \subseteq \RR^n$. Indeed, the entire game of
inapproximability is to understand the dependence of $\gamma$ on $n$.

The approximate search and decision (`Gap`{:.lowercap}) problems related
to `CVP`{:.mathsf} are listed below:

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

### [<span class="lowercap">Decisional-CVP</span>](#problem--decisional-cvp) is $\NP$-Complete

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
 to `Decisional-CVP`{: .lowercap} suffice (reduction below is adapted
 from Chapter 03 of [^MG02]). But first, the `Subset-Sum`{: .lowercap}
 problem (`SSP`{: .mathsf}) is defined precisely.

```Problem [<span class="lowercap">Subset-Sum</span>]{#problem--subset-sum}
Input
  : A set $A := \braces{a_1,\cdots, a_n} \subseteq \ZZ$ of $n$ integers
    (distinct by definition of a set).
  : A target sum $U \in \ZZ$.

Output
  : `Yes`{: .lowercap } if there exists a subset $A' \subseteq A$ such
    that $U = \sum_{a' \in A'} a'$
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
          \end{pmatrix} \in \ZZ^{(n+1)\times n}
          &
          \vec{t} &:= \begin{pmatrix}
                      \highlight{n}\cdot U \\
                      1 \\
                      \vdots \\
                      1
                      \end{pmatrix} \in \QQ^{n+1}
          \quad\text{and} &
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

### [<span class="lowercap">Decisional-SVP$|_{\ell_\infty}$</span>]({% post_url 2020-06-08-LatticesBasicDefinitions %}#problem--shortest-vector-problem-decisional) is $\NP$-Complete

Recall that a [Decisional-SVP$_\infty(\B, r)$]({% post_url
2020-06-08-LatticesBasicDefinitions
%}#problem--shortest-vector-problem-decisional){: .lowercap} problem
instance consists of an integral lattice basis $\B \in \ZZ^{n\times n}$
and a distance threshold $r \in \QQ$. The goal is to decide if
$\lambda_1^\infty(\B) \highlight{\lessgtr} r$? Also recall that in
$\ell_\infty$ norm, if $\vec{x} := \braces{x_1,\cdots,x_n} \in \ZZ^n$
then $$\norm{\vec{x}}_\infty = \max_{1\le i \le n}\lrbraces{ |x_i| }$$

This proof is an adaptation of the original 1981 proof by van Emde Boas
[^vEB81]. The proof follows the following chain of reductions:

$2$`-Partition`{: .lowercap }
$\highlight{\preceq}$ `Bounded Homogeneous Linear Equation`{:.lowercap }
$\highlight{\preceq}$ `Decisional-SVP`{: .lowercap }
{: .centered-text .larger-font .bolder-font }

These individual problems and the corresponding reductions are described
next.

#### <span class="lowercap">Subset-Sum</span> $\preceq$  <span class="lowercap">$2$-Partition</span>  {#subsubsection--2-partition-np-complete}

Given a set $A := \braces{a_1,\cdots, a_n}$ of integers, the
$2$`-Partition`{:.lowercap} problem asks: Does $A$ have a subset $B
\subseteq A$ such that the sum of all elements in $B$ equals the sum of
all elements in $A\setminus B$. Or equivalently, does there exist
$x_i \in \highlight{\lrbraces{+1, -1}}$ such that
$$\sum_{i=1}^n x_i\cdot a_i = 0?$$

Formally $2$`-Partition`{:.lowercap} is defined as follows:

```Problem [<span class="lowercap">$2$-Partition</span>]{#problem--2-partition}
Input
  : A set $A = \braces{a_1, \cdots, a_n} \subseteq \ZZ$.

Output
  : `Yes`{: .lowercap } if $\exists\,B \subseteq A$ such that
    $$ \sum_{b \,\in\, B} b = \sum_{c \,\in\, A \setminus B } c.$$
  : `No`{: .lowercap } otherwise.
```

The following reduction from
[Subset-Sum$(S,U)$](#problem--subset-sum){: .lowercap } to $2$`-Partition`{: .lowercap}
establishes `NP`{: .mathsf}-completeness of $2$`-Partition`{:
.lowercap}.

```Reduction [<span class="lowercap">Subset-Sum $\preceq$ $2$-Partition</span>]{#reduction--subset-sum-to-partition}

Input
  : A `Subset-Sum`{: .lowercap} instance $S \subseteq \ZZ$, and
  : A `Subset-Sum`{: .lowercap} target $U \in \ZZ$.

Output
  : `Yes`{: .lowercap} if $\exists\, S' \subset S:\; \sum_{s' \in S} s' \highlight{=} U$
  : `No`{: .lowercap} otherwise

Algorithm
  : This is a very [well known reduction](https://www.youtube.com/watch?v=_mpVTPBepjY){: target="_blank"}, details of which are left as an exercise to the
  reader 😊. (See page $60$ and Appendix A$3.2$ of [^GJ79] for a detailed
  analysis.)
```

#### <span class="lowercap">$2$-Partition</span> $\preceq$ $\ell_\infty$-Bounded Homogeneous Linear Equation (<span class="mathsf">BHLE</span>) {#subsubsection--bhle-np-complete}

Given a set $A := \braces{a_1,\cdots, a_n}$ of integers and a positive
threshold $\kappa \in \ZZ_{>0}$, the problem of **Bounded Homogeneous
Linear Equation** (`BHLE`{: .mathsf .bul}) in $\ell_\infty$-norm is
defined as follows:

```Problem [$\ell_\infty$-Bounded Homogeneous Linear Equation]{#problem--bhle}
Input
  : A set $A$ represented as $\uvec{a} := \braces{a_1, \cdots, a_n} \in \ZZ^n$,
  : A positive solution threshold $\kappa \in \ZZ_{> 0}$.

Output
  : `Yes`{: .lowercap } if
    $\exists\, \vec{x} := \braces{x_1,\cdots, x_n} \in \ZZ^n$
    such that
    $$ \dotprod{\vec{x}, \uvec{a}} = 0\quad\text{and }\quad 0 < \abs{\vec{x}}_{\ell_\infty} \leq \kappa.$$
    (Or equivalently, $\vec{x} \in  \ZZ^n\highlight{\setminus \vec{0}}$,
    $\dotprod{\vec{x}, \uvec{a}} = 0$, and $|x_i| \le \kappa$ for all
    $i \in \braces{1,\cdots, n}$.)
  : `No`{: .lowercap } otherwise.

`Note`{:.bul}: One can define `BHLE`{:.mathsf} for any arbitrary
$\ell_p$ norm, and restrict the solution space $\vec{x} \in \ZZ^n$
to non-zero points inside a $n$-dimensional sphere
$0 < \abs{\vec{x}}_{\ell_p} \leq \kappa$. However, for the rest of this
section only $\ell_\infty$ norm is considered.
```

```Notation {#notation--uvec-bracket-kappa}
* `In`{:#notation--set-as-a-vector} this section, a set $A := \braces{a_1,\cdots,a_n} \subseteq
  \ZZ$ is often represented as a _vector of **unique** values_, i.e.,
  $\forall i,j \in \braces{1,\cdots, n}:\; a_i = a_j \highlight{\iff} i = j$.
  The following notation is used to represent sets as vectors:

  $$
    \uvec{a} := \braces{a_1,\cdots, a_n}
  $$

  The index $i$ of $a_i$ is chosen arbitrarily, but once fixed,
  remains fixed forever. (`Note`{:.bul}: With this notation, equality
  relations like $\uvec{a} = \uvec{b}$ are ill defined and should be
  avoided.)

* `Let`{:#notation--square-bracket} $\kappa \in \ZZ_{>0}$ be a positive integer. Then the set of integers
  with _absolute value_ less than or equal to $\kappa$ is denoted by $[\kappa]$,
  i.e.,
  $$[\kappa] := \lrbraces{ i : |i| \le \kappa} \subseteq \ZZ$$

* `Vector`{:#notation--zero-one-vectors}
  $\vec{0} := \braces{0,\cdots, 0}$ denotes all zeros vector
  and $\vec{1} := \braces{1,\cdots, 1}$ denotes all ones vector of
  _appropriate dimension_ (which should be inferred from the context).
```

When $\kappa = 1$, `BHLE`{: .mathsf} almost appears to be an instance of
$2$`-Partition`{: .lowercap}. However, these two problems are
fundamentally different. To see why, notice that a solution to a
$2$`-Partition`{: .lowercap} instance is a statement about the entire
set $A$. However, in case of `BHLE`{: .mathsf}, since
$x_{i}$s are allowed to be zero, _any two disjoint subsets_ of $A$ that
sum to the same value suffice as a solution (by setting $x_i = 0$ for other
elements). Conversely, if $A$ corresponds to an `Yes`{: .lowercap}
instance of `BHLE`{: .mathsf}, then _every superset_ of $A$ also
corresponds to an `Yes`{: .lowercap} instance of `BHLE`{: .mathsf}.
This is not the case with $2$`-Partition`{: .lowercap}.
(In theory, one could consider an `NPO`{:.mathsf} version of `BHLE`{:
.mathsf}, say `Min-`{:.lowercap}`BHLE`{: .mathsf}, with the goal to
minimize the _count of_ $x_i = 0$ coordinate in $\vec{x}$. However, even
`Min-`{:.lowercap}`BHLE`{: .mathsf} is different from
$2$`-Partition`{: .lowercap}.)

To prove that $2$`-Partition`{: .lowercap} (Karp) reduces to
`BHLE`{:.mathsf} in polynomial-time, we need to define a polynomial time
map $\xi : \ZZ^n \mapsto \ZZ^{\poly(n)}$ from inputs to the
$2$`-Partition`{: .lowercap} instance, to inputs to the `BHLE`{:.mathsf}
instance. Let $\uvec{a} := \braces{a_1,\cdots, a_n} \in \ZZ^n$ be an
input to $2$`-Partition`{: .lowercap} problem instance, and let
$\mu > \kappa\sum_i |a_i|$ be a sufficiently large integer.
Furthermore, let $d \in \ZZ_{>0}$ be a positive integer, whose value
will be derived at the end to satisfy the constraints of the reduction.

Let
<div class="multi-columns" id="bhle-tuvw-definitions">
<div style="max-width:350px;margin-bottom:0rem;" id="bhle-t-definition">
$$
\mathbf{T} = \begin{pmatrix}
              \kappa  & \kappa  & 0       & \kappa  & 0\\
              0       & \kappa  & 0       & 0       & \kappa\\
              \kappa  & 0       & \kappa  & 0       & 0\\
              0       & 0       & \kappa  & \kappa  & \kappa\\
              0       & 0       & 0       & \highlight{1} & 0
              \end{pmatrix}
$$
</div>
<div style="max-width:350px;margin-bottom:0rem;" id="bhle-u-definition">
$$
\vec{u} = \begin{pmatrix}
              1 \\ \kappa d \\ (\kappa d)^2 \\ (\kappa d)^3 \\ (\kappa d)^4
          \end{pmatrix}
$$
</div>
<div style="max-width:350px;margin-bottom:0rem;" id="bhle-v-definition">
$$
\vec{v} = \begin{pmatrix}
            (\kappa d)^{4n-4} \\ (\kappa d)^{4n-3} \\ (\kappa d)^{4n - 2} \\ (\kappa d)^{4n - 1} \\ \highlight{1}
          \end{pmatrix}
$$
</div>
<div style="max-width:250px;margin-bottom:0rem;" id="bhle-w-definition">
$$
\vec{w} = \begin{pmatrix}
            1 \\ 0 \\ 0 \\ 1 \\ 0
          \end{pmatrix}
$$
</div>
</div>
and let $\vec{\beta} : \braces{1,\cdots, n} \times \ZZ \mapsto \ZZ^5$
be the following affine transform that maps each
$a_i \in \uvec{a}$ to a **vector** of $5$ elements:
$$
  \begin{equation}
  {\vec{\beta}}(i, a_i) :=  \begin{cases}
    a_i\cdot\vec{w} \;+\; \mu \cdot  (\kappa \cdot d)^{4i-4} \cdot \mathbf{T}\vec{u}
         & \quad\text{for } 1 \le i \le \highlight{n-1} \\
                          & \\
    a_n\cdot\vec{w} \;+\; \mu\cdot \mathbf{T}\vec{v}
    \end{cases}
    \label{bhle-encoding-equations}
  \end{equation}
$$

Define the _polynomial time_ input encoding map
${\xi} : \ZZ^n \mapsto \ZZ^{5n}$ as the
_concatenation_ of $5$-tuples
${\vec{\beta}}(i, a_i)$ for all $i \in \braces{1,\cdots,n}$,
i.e.,
$$
\begin{equation}
{\xi}(\uvec{a}) := \begin{pmatrix}
  {\vec{\beta}}(1, a_1) \\
  \vdots \\
  {\vec{\beta}}(n, a_n)
\end{pmatrix} \in \ZZ^{5n}
\label{two-partition-to-bhle-encoding-xi}
\end{equation}
$$
(Recall that all vectors are column vectors!)

In the next few lemmas we will prove that if $\uvec{a}$ is a
$2$`-Partition Yes`{:.lowercap} instance, then
${\xi}(\uvec{a})$ is a `BHLE`{:.mathsf} `Yes`{:.lowercap}
instance. Conversely, given an arbitrary set $\uvec{a}$ such that
${\xi}(\uvec{a})$ is a `BHLE`{:.mathsf} `Yes`{:.lowercap}
instance, then we will prove that $\uvec{a}$ is a $2$`-Partition
Yes`{:.lowercap} instance.

Let $\vec{x} := \braces{x_1,\cdots, x_n} \in \braces{-1,+1}^n$ denote
the indeterminates of $2$`-Partition`{:.lowercap} linear Diophantine
equation
$$\dotprod{\vec{x}, \uvec{a}} = 0.$$

Corresponding to each $x_i$, let $\vec{\chi}_i$ denote the $5$-tuple of
indeterminates for `BHLE`{:.mathsf} linear Diophantine equations, i.e.,
$$
\begin{equation}
\vec{\chi}_i := \lrbraces{y_{(i,1)}, y_{(i,2)}, y_{(i,3)}, y_{(i,4)}, y_{(i,5)}}
\label{bhle-chi-definition}
\end{equation}
$$
and let
$$
  \begin{equation}
  \vec{\Upsilon} := \begin{pmatrix} \vec{\chi}_1 \\ \vdots \\ \vec{\chi}_n \end{pmatrix}.
  \label{bhle-upsilon-definition}
  \end{equation}
$$
Then, the following linear Diophantine equation corresponds to an
`BHLE`{:.mathsf} `Yes`{:.lowercap} instance if there exists
$\vec{\Upsilon} \in \ZZ^{5n}$ such that
$$\dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} = 0\quad{\huge \wedge }\quad 0 < \abs{\vec{\Upsilon}}_{\ell_\infty} \le \kappa,$$
or equivalently $\exists\,\vec{\chi}_i \in [\kappa]^5$ (with **not all**
$\vec{\chi}_i = \vec{0}$) such that
$$
  \begin{equation}
  \begin{array}{rcl}
  \dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} &=& \sum_{i=1}^n \dotprod{\vec{\chi}_i,\;{\vec{\beta}}(i, a_i)} \\
    &=& \mu\left(\dotprod{\vec{\chi}_n,\;\mathbf{T}\vec{v}} + \sum_{i=1}^{n-1} (\kappa d)^{4i-4}\braket{\vec{\chi}_i,\;\mathbf{T}\vec{u}}\right) + \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)}) \\
    &=& 0
  \end{array}
  \label{expanded-bhle-sum}
  \end{equation}
$$
where $\mathbf{T}, \vec{u}, \vec{v}$, and
$\vec{w}$ are defined as in \eqref{bhle-encoding-equations}.

In the [following](#lemma--two-partition-implies-bhle) Lemma, we first
state and prove that if $\uvec{a} \in \ZZ^n$ is a
$2$`-Partition Yes`{:.lowercap} instance, then
${\xi}(\uvec{a}) \in \ZZ^{5n}$ correctly maps
$\uvec{a}$ into a `BHLE`{:.mathsf} `Yes`{:.lowercap} instance.

```Lemma [$\uvec{a} \in$ <span class="lowercap">$2$-Partition</span> $\implies {\xi}(\uvec{a}) \in$ <span class="mathsf">BHLE</span> ] {#lemma--two-partition-implies-bhle}

Let $\uvec{a} \in \ZZ^n$ be an `Yes`{:.lowercap} instance of
$2$`-Partition`{:.lowercap}, i.e., $\exists\, \vec{x} \in \braces{-1, +1}^n$ such
that $\dotprod{\vec{x}, \uvec{a}} = 0$, then there exists
$\vec{\Upsilon} \in [\kappa]^{5n}\setminus \vec{0}$ such that
$$\dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} = 0.$$
```

```Proof {#proof--two-partition-implies-bhle}
Since $\uvec{a} := \braces{a_1,\cdots, a_n}$ is a
$2$`-Partition`{:.lowercap} `Yes`{:.lowercap} instance,
$\exists\,\vec{x} = \braces{x_1,\cdots,x_n} \in \braces{-1, +1}^n$ such
that $$\sum_{i=1}^n x_i\cdot a_i = 0.$$

Consider the following assignment to $\chi_i$ based on the value of
$x_i$:

* If $x_i = +1$, then define
  $$
    \begin{equation}
    \chi_i^{+1} := \begin{pmatrix}
              1 \\ -1 \\ 0 \\ 0 \\ \highlight{-\kappa}
              \end{pmatrix} \in [\kappa]^5\setminus \vec{0}
    \label{chi-plus-one}
    \end{equation}
  $$

* If $x_i = -1$, then define
  $$
    \begin{equation}
    \chi_i^{-1} :=\begin{pmatrix}
              0 \\ 0 \\ 1 \\ -1 \\ \highlight{\kappa}
              \end{pmatrix} \in [\kappa]^5\setminus \vec{0}
    \label{chi-minus-one}
    \end{equation}
  $$

`Note`{:.bul}: $\chi_i^{-1}$ is just notation, and should not be
interpreted as inverse of anything!

First observe that
$$
  \begin{aligned}
  \dotprod{ \chi_i^{+1},\; \mathbf{T}\vec{u}} &\highlight{=} \dotprod{ \chi_i^{-1},\; \mathbf{T}\vec{u}} \highlight{=} \kappa\cdot \left (1 - (\kappa d)^4 \right) & \text{ for } 1 \le i \le n-1, \quad \text{ and} \\
  \dotprod{ \chi_n^{+1},\; \mathbf{T}\vec{v}} &\highlight{=} \dotprod{ \chi_n^{-1},\; \mathbf{T}\vec{v}} \highlight{=} \kappa\cdot \left( (\kappa d)^{4n - 4} - 1\right)
  \end{aligned}
$$
and construct $\vec{\Upsilon} \in [\kappa]^{5n}\setminus \vec{0}$ as the
vector with entries $\chi_i^{+1}$ or $\chi_i^{-1}$, depending upon whether
$x_i = +1$  or $x_i = -1$ in the solution to $2$`-Partition`{:.lowercap}
instance. Then by \eqref{expanded-bhle-sum}
$$
\begin{aligned}
\dotprod{\vec{\Upsilon},\; {\xi}(\uvec{a})} &= \mu\cdot \kappa \left (\highlight{(\kappa d)^{4n - 4} - 1} +
\sum_{i=1}^{n-1} (\kappa d)^{4i-4}(1-(\kappa d)^4)\right) + \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)}) \\
&= \mu\cdot\kappa \left (\highlight{(\kappa d)^{4n - 4} - 1} + \underbrace{(1- (\kappa d)^4 + (\kappa d)^4 - (\kappa d)^8 + \cdots + (\kappa d)^{4n-8} - (\kappa d)^{4n - 4})}_{1 - (\kappa d)^{4n-4}}\right)  \\ & \quad\quad\quad + \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)}) \\
&= \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)})
\end{aligned}
$$

Notice that if $x_i = 1$, then by \eqref{chi-plus-one},
$y_{(i,1)} = 1$ and $y_{(i,4)} = 0$, therefore
$$a_i\cdot (y_{(i,1)} + y_{(i,4)}) = a_i = x_i\cdot a_i$$
Similarly, when $x_i = -1$ by \eqref{chi-minus-one}:
$$a_i\cdot (y_{(i,1)} + y_{(i,4)}) = -a_i = x_i\cdot a_i$$
Therefore
$$
  \dotprod{\vec{\Upsilon},\; {\xi}(\uvec{a})} = \sum_{i} a_i\cdot (y_{(i,1)} + y_{(1,4)}) = \sum_{i} x_i a_i = 0
$$

and ${\xi}(\uvec{a}) \in$ `BHLE`{:.mathsf}.
```

To prove the other direction of Karp reduction, we need the following
elementary lemma:

```Lemma [Unique Bit Decomposition] {#lemma--unique-bit-decomposition}
Let $\uvec{a} := \braces{a_1, \cdots, a_n}$,
$\uvec{b} := \braces{b_1, \cdots, b_n}  \in \ZZ^n$ (where $n > 1$) be
two sets and, as before, let
$$
\begin{equation}
\mu > \kappa\sum_i |a_i|,
\label{bounded-lemma-assumption}
\end{equation}
$$
where $\kappa \in \ZZ_{>0}$ is a positive integer. Then the following linear
Diophantine equation in $\vec{x} = \braces{x_1,\cdots, x_n} \in \ZZ^n$
$$
\dotprod{\vec{x},\;\;\uvec{a} + \highlight{\mu}\cdot\uvec{b}} = 0
$$
has a solution in the hypercube
$[\kappa]^n := \lrbraces{ x_i \highlight{:}\; |x_i| < \kappa } \subseteq \ZZ^n$
_if and only if_ the following two linear Diophantine equations are
satisfied simultaneously:
$$
\dotprod{\vec{x}, \uvec{a}} = 0\;\;\text{and}\;\;\dotprod{\vec{x}, \uvec{b}} = 0
$$
```

```Proof
$\highlight{(\Rightarrow)}$:

>   If $\vec{x} \in [\kappa]^n$ simultaneously satisfies
      $\dotprod{\vec{x}, \uvec{a}} = 0$ and
      $\dotprod{\vec{x}, \uvec{b}} = 0$, then by bilinearity,
      $$
        \dotprod{\vec{x}, \uvec{a}} + \mu\cdot \dotprod{\vec{x}, \uvec{b}} = \dotprod{\vec{x}, \uvec{a} + \mu\cdot \uvec{b}} = 0.
      $$
      Therefore, $\vec{x}$ is a solution to $\uvec{a} + \mu\cdot \uvec{b}$.
>
{:.details style="margin-top:0px;padding-top:0px;"}

$\highlight{(\Leftarrow)}$:

> Conversely, suppose $\vec{x} \in [\kappa]^n$ is a solution to
    $\dotprod{\vec{x}, \uvec{a} + \mu\cdot \uvec{b}} = 0$. We need to show
    that $\dotprod{\vec{x}, \uvec{a}} = 0$ and
    $\dotprod{\vec{x},\uvec{b}} = 0$.
>
>First note that by assumption, $n>1$ and $\uvec{a}$ is a vector of
  _distinct elements_, hence $\uvec{a}$ must contain at least one
  non-zero element. Therefore $\sum_i |a_i| > 0$ $\implies$ $\mu \neq 0$.
>
>   Since $\mu > \kappa \sum_{i=1}^n | a_i |$,
    $$
      \norm{ \sum_{i=1}^n x_i \cdot a_i } \highlight{\le}  \sum_{i=1}^n \abs{ x_i \cdot a_i } \highlight{\le} \kappa \sum_{i=1}^n | a_i | \highlight{<} \mu,
    $$
    and by assumption,
    $$
    \dotprod{\vec{x}, \uvec{a} + \mu\cdot \uvec{b}} = 0 \highlight{\implies}  \sum_{i=1}^n x_i \cdot a_i  = - \mu \sum_{i=1}^n x_i \cdot b_i.
    $$
    Therefore,
    $$ \mu\norm{\sum_{i=1}^n x_i \cdot b_i } \highlight{=} \norm{ \sum_{i=1}^n x_i \cdot a_i } \highlight{<} \mu \highlight{\implies} \norm{\sum_{i=1}^n x_i \cdot b_i } \highlight{<} 1\quad (\text{since } \mu \neq 0).
    $$
    But $x_i$s and $b_i$s are _integers_, therefore $\sum_{i=1}^n x_i \cdot b_i$ is
    an integer. But the only _integer_ with norm strictly less than $1$ is $0$. Therefore,
    $$
    \norm{\sum_{i=1}^n x_i \cdot b_i } = 0 \highlight{\implies} \begin{cases} \sum_{i=1}^n x_i \cdot b_i = 0 &\text{and} \\ & \\ \sum_{i=1}^n x_i \cdot a_i = 0 & \end{cases}
    $$
>
{:.details style="margin-top:0px;padding-top:0px;" }

```

Finally, we are ready to state and prove the other direction of the
reduction.

```Lemma [${\xi}(\uvec{a}) \in $ <span class="mathsf">BHLE</span> $\implies \uvec{a} \in$ <span class="lowercap">$2$-Partition</span>] {#lemma--bhle-implies-two-partition}

Let $\uvec{a} := \braces{a_1,\cdots, a_n} \in \ZZ^n$ be an arbitrary set
and let ${\xi}(\uvec{a}) \in \ZZ^{5n}$ be an encoding of
$\uvec{a}$ as defined in \eqref{two-partition-to-bhle-encoding-xi}.
If there exists $\href{#mjx-eqn:bhle-upsilon-definition}{\vec{\Upsilon}} := \href{#mjx-eqn:bhle-chi-definition}{\braces{\chi_1,\cdots, \chi_n}} \in [\kappa]^{5n}\setminus \vec{0}$ such that
$\dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} = 0$,
then there exists
$\vec{x} := \braces{x_1,\cdots,x_n} \in \braces{-1,+1}^n$ such that
$$
\dotprod{\vec{x}, \uvec{a}} = 0.
$$
```

```Proof {#proof--bhle-implies-two-partition}
Given that there exists
$\vec{\Upsilon} \in [\kappa]^{5n}\setminus \vec{0}$ such that
$\dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} = 0$, by
\eqref{expanded-bhle-sum}
$$
  \dotprod{\vec{\Upsilon}, {\xi}(\uvec{a})} \highlight{=} \mu\left(\dotprod{\vec{\chi}_n,\;\mathbf{T}\vec{v}} + \sum_{i=1}^{n-1} (\kappa d)^{4i-4}\braket{\vec{\chi}_i,\;\mathbf{T}\vec{u}}\right) + \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)}) \highlight{=} 0
$$

Since $\mu > \kappa \sum_i |a_i|$, by the previous [unique bit decomposition](#lemma--unique-bit-decomposition)
lemma, the above equation is equivalent to the following two linear
Diophantine equations that must be satisfied simultaneously:

$$
\begin{align}
\sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)})  &= 0 \label{partition-to-bhle-good-part}\\
\left(\sum_{i=1}^{n-1} (\kappa d)^{4i-4}\braket{\vec{\chi}_i,\;\mathbf{T}\vec{u}}\right) + \dotprod{\vec{\chi}_n,\;\mathbf{T}\vec{v}} &= 0 \label{partition-to-bhle-messy-part} \\
\end{align}
$$

Expanding \eqref{partition-to-bhle-messy-part}, we get
$$
\begin{array}{llclr}
  \braket{\vec{\chi}_i,\;\mathbf{T}\href{#bhle-u-definition}{\vec{u}}}_{1\le i \le n-1} ={}& \kappa\cdot(y_{(i,1)} + y_{(i,3)}) & \cdot & 1 & {+} \\
  & \kappa\cdot(y_{(i,1)} + y_{(i,2)}) & \cdot & \kappa d & {+} \\
  & \kappa\cdot(y_{(i,3)} + y_{(i,4)}) & \cdot & (\kappa d)^2 & {+} \\
  & \left(\kappa\cdot\highlight{(y_{(i,1)} + y_{(i,4)})} + y_{(i,5)}\right) &\cdot & (\kappa d)^3 & {+} \\
  & \kappa\cdot(y_{(i,2)} + y_{(i,4)}) &\cdot & (\kappa d)^4 &
  \end{array}
$$
and
$$
\begin{array}{llllr}
  \braket{\vec{\chi}_n,\;\mathbf{T}\href{#bhle-v-definition}{\vec{v}}} ={}&
  \kappa\cdot(y_{(n,1)} + y_{(n,3)}) & \cdot & (\kappa d)^{4n-4} & {+} \\
  & \kappa\cdot(y_{(n,1)} + y_{(n,2)}) & \cdot & (\kappa d)^{4n-3} & {+} \\
  & \kappa\cdot(y_{(n,3)} + y_{(n,4)}) & \cdot & (\kappa d)^{4n-2} & {+} \\
  & \left(\kappa\cdot\highlight{(y_{(n,1)} + y_{(n,4)})} + y_{(n,5)}\right) &\cdot & (\kappa d)^{4n-1} & {+} \\
  & \kappa\cdot(y_{(n,2)} + y_{(n,4)}) &\cdot & \highlight{1} &
  \end{array}
$$
and collecting powers of $\kappa \cdot d$ in \eqref{partition-to-bhle-messy-part},
we get
$$
\begin{array}{rlllr}
\left(\sum_{i=1}^{n-1} (\kappa d)^{4i-4}\braket{\vec{\chi}_i,\;\mathbf{T}\vec{u}}\right) + \dotprod{\vec{\chi}_n,\;\mathbf{T}\vec{v}} ={}& \kappa\cdot(y_{(1,1)} + y_{(1,3)} + y_{(n,2)} + y_{(n,4)}) & & & {+} \\
& \sum_{\highlight{i=2}}^{n} \kappa\cdot(y_{(i,1)} + y_{(i,3)} + y_{(\highlight{i-1},2)} + y_{(\highlight{i-1},4)}) & \cdot & (\kappa d)^{4i-4} & {+} \\
& \sum_{i=1}^{n} \kappa\cdot(y_{(i,1)} + y_{(i,2)}) & \cdot & (\kappa d)^{4i-3} & {+} \\
& \sum_{i=1}^{n} \kappa\cdot(y_{(i,3)} + y_{(i,4)}) & \cdot & (\kappa d)^{4i-2} & {+} \\
& \sum_{i=1}^{n} \left(\kappa\cdot\highlight{(y_{(i,1)} + y_{(i,4)})} + y_{(i,5)}\right) & \cdot & (\kappa d)^{4i-1} & \\
={}&0 & & &
\end{array}
$$

Since $|y_{(i,j)}| \le \kappa$, the maximum value of any coefficient of
$(\kappa d)^i$ can be _no greater than_ $4\kappa^2$. (The value
$4\kappa^2$ is attained either for the coefficient of $(\kappa d)^0$:
$\kappa (y_{(1,1)} + y_{(1,3)} + y_{(n,2)} + y_{(n,4)})$
or for the coefficient of $(\kappa d)^{4i-4}|_{i\ge 2}$:
$\kappa(y_{(i,1)} + y_{(i,3)} + y_{(i-1,2)} + y_{(i-1,4)})$. For all other powers
of $(\kappa d)$, including $(\kappa d)^{4i-1}$, the maximum value of
the coefficients cannot exceed $4\kappa^2$.)

Therefore, if $d > 4$, one can apply the [unique bit decomposition
](#lemma--unique-bit-decomposition) lemma repeatedly over powers of $\kappa d$
to obtain the following system of linear Diophantine equations, that
along with \eqref{partition-to-bhle-good-part}, must be satisfied
simultaneously:

$$
\begin{equation}
\begin{array}{rclrrl}
  y_{(1,1)} + y_{(1,3)} + y_{(n,2)} + y_{(n,4)} &=& 0 & & \quad & \cssId{bhle-eqn-a1}{(A1)}\\
  y_{(i,1)} + y_{(i,3)} + y_{(i-1,2)} + y_{(i-1,4)} &=& 0 & 2\le i \le n & \quad & \cssId{bhle-eqn-a}{(A)} \\
  y_{(i,1)} + y_{(i,2)} &=&0& 1\le i \le n & \quad &\cssId{bhle-eqn-b}{(B)}\\
  y_{(i,3)} + y_{(i,4)} &=&0& 1\le i \le n & \quad &\cssId{bhle-eqn-c}{(C)}\\
  \kappa\cdot(y_{(i,1)} + y_{(i,4)}) + y_{(i,5)} &=&0& 1\le i \le n & \quad & \cssId{bhle-eqn-d}{(D)}\\
  \sum_{i=1}^na_i\cdot(y_{(i,1)} + y_{(i,4)}) &=&0& \text{from } \eqref{partition-to-bhle-good-part} & & \\
\end{array}
\label{bhle-system-of-equations}
\end{equation}
$$

> `Claim`{: .bul .highlighted-text #bhle-reverse-claim }: If the system of linear Diophantine equations in
   [$(A1)$](#bhle-eqn-a1), [$(A)$](#bhle-eqn-a), [$(B)$](#bhle-eqn-b), [$(C)$](#bhle-eqn-c), and [$(D)$](#bhle-eqn-d) have a non-trivial solution, i.e.,
   $y_{(i,j)}\in [\kappa]$
   with **not all** $y_{(i,j)} = 0$, then
   $$\forall i \in \braces{1,\cdots, n}:\; y_{(i,1)} + y_{(i,4)} \in \braces{-1, +1}$$
   thereby proving that $\uvec{a} \in \textsc{2-Partition}$.
>
{:.details}

>
> `Proof`{: .bul .highlighted-text #bhle-reverse-claim-proof}:
  By [$(A)$](#bhle-eqn-a) and [$(A1)$](#bhle-eqn-a1)
  $$ \begin{array}{rclr}
  y_{(i,1)} + y_{(i,3)} &=& -y_{(i-1,2)} - y_{(i-1,4)}, & \text{for } 2 \le i \le n\; \text{and}\\
  y_{(1,1)} + y_{(1,3)} &=& -y_{(n,2)} - y_{(n,4)} &
  \end{array}
  $$
  By [$(B)$](#bhle-eqn-b) and [$(C)$](#bhle-eqn-c) $y_{(i,1)} = -y_{(i,2)}$
  and $y_{(i,3)} = -y_{(i,4)}$ for all $i$. Substituting these values in
  the equation above we obtain
  $$ \begin{array}{rclr}
    y_{(i,1)} + y_{(i,3)} &=& y_{(i-1,1)} + y_{(i-1,3)}, & \text{for } 2 \le i \le n\; \text{and}\\
    y_{(1,1)} + y_{(1,3)} &=& y_{(n,1)} + y_{(n,3)}, & \\
  \end{array}
  $$
  which, by induction on $i$, implies $y_{(i,1)} + y_{(i,3)}$ does not
  depend on $i$. Let
  $$
    \omega := y_{(i,1)} + y_{(i,3)} = y_{(1,1)} + y_{(1,3)} \quad \forall i \in \braces{1,\cdots, n}
  $$
> where $\omega$ is called the weight of the invariant. A priori,
   $\omega$ can take any integer value between
   $-\kappa$ and $\kappa$. However, since multiplying [$(A1)$](#bhle-eqn-aa) and
   [$(A)$](#bhle-eqn-a) by $-1$ does not affect the solutions,
   $\omega$ can be arranged to be positive, therefore without loss of
   generality, $0\le \omega \le \kappa$.
>
> While the system of equations in
  \eqref{bhle-system-of-equations} gives rise to _a solution_ to
  `BHLE`{:.mathsf} instance, not all _non-trivial solutions_ result in
  a _non-trivial solution_ to the $2$`-Partition`{:.lowercap} constraint in
  \eqref{partition-to-bhle-good-part}. In particular, if
  $$\chi_{i}^\star := \begin{pmatrix}1 \\ -1 \\ 1 \\ -1 \\ 0 \end{pmatrix}\quad \text{for } 1 \le i \le n,$$
  then [$(A1)$](#bhle-eqn-a1), [$(A)$](#bhle-eqn-a),
  [$(B)$](#bhle-eqn-b), [$(C)$](#bhle-eqn-c),
  [$(D)$](#bhle-eqn-d) and \eqref{partition-to-bhle-good-part},
  are all satisfied, but $\forall\,i: y_{i,1} + y_{i,4} = 0$, which
  corresponds to a trivial solution to the $2$`-Partition`{:.lowercap}
  constraint in \eqref{partition-to-bhle-good-part}.
  Notice, however, there are $5n$ indeterminates but only $4n+1$
  equations! Therefore, it's desirable to impose an extra constraint
  such that every solution to \eqref{bhle-system-of-equations}
  corresponds to a _non-trivial solution_ to both:
>
> 1. The `BHLE`{:.mathsf #bhle-condition-1} instance
      ${\xi}(\uvec{a})$, and
> 2. The $2$`-Partition`{:.lowercap #bhle-condition-2} instance in
      $\eqref{partition-to-bhle-good-part}$.
>
> Both these conditions can be enforced simultaneously by ensuring that
  $y_{(i,1)} + y_{(i,4)} \neq 0$ for _at least one_ $i$, say $i=1$, by
  setting $y_{(1,4)} = 0$. Since
  $y_{(1,4)} = -y_{(1,3)} = 0 \implies \omega = y_{(1,1)} \in [\kappa]$.
>
> Furthermore,
  by [$(D)$](#bhle-eqn-d)
  $$
    \begin{equation}
    \kappa|y_{(i,1)} + y_{(i,4)}| = |y_{(i,5)}| \le \kappa \highlight{\implies} |y_{(i,1)} | \le 1\quad\text{for } 1 \le i \le n.
    \label{yonefive-bound}
    \end{equation}
  $$
> Since $\omega = y_{(1,1)}$ and positive, by equation above
  $\omega \in \braces{0, 1}$. Furthermore, by [$(C)$](#bhle-eqn-c):
  $\;y_{(i,3)} = -y_{(i,4)}$ and by
  [$(D)$](#bhle-eqn-d): $\;y_{(i,5)}$ $=$ $-\kappa(y_{(i,4)}+y_{(i,1)})$ $=$ $\kappa(y_{(i,3)} - y_{(i,1)})$. However,
    $y_{(i,1)} + y_{(i,3)} = \omega$, therefore $\forall i \in \braces{1,\cdots,n}$:
    $$
      \begin{equation}
      \begin{array}{rcl}
      \kappa(y_{(i,3)} - y_{(i,1)}) &=& y_{(i,5)} \\
      y_{(i,3)} + y_{(i,1)} &=& \omega
      \end{array}
      \highlight{\implies}
      \begin{array}{rcl}
      \highlight{2\cdot\kappa}\cdot y_{(i,3)} &= \kappa\cdot\omega + y_{(i,5)}\\
      \highlight{2\cdot\kappa}\cdot y_{(i,1)} &= \kappa\cdot\omega - y_{(1,5)}
      \end{array}
      \label{bhle-condition-on-yi5}
      \end{equation}
    $$
> We separately analyze the range of values that $y_{(i,1)} + y_{(i,4)}$
  can take when $\omega = 0$ and when $\omega = 1$.
>
> $\omega = 0$
>   : Since $\omega =0$, by \eqref{bhle-condition-on-yi5}
      $\;2\cdot\kappa\cdot y_{(i,3)} =  y_{(i,5)}$. However, as a linear Diophantine
      equation, both $y_{(i,3)}$ and $y_{(i,5)}$ must take _integer_ values in
      $\braces{-\kappa,\cdots,\kappa}$. The only integer value that satisfies
      this requirement is
      $$y_{(i,3)} = y_{(i,5)} = 0\quad \forall i \in \braces{1,\cdots, n}.$$
      However, this forces every $y_{(i,j)} = 0$ _for all_ $(i,j)$,
      which, by assumption, is not a valid solution. Therefore, $\omega=0$
      is a pathological case that is _disallowed by the definition_
      of `BHLE`{:.mathsf} instance.
>
> $\omega = 1$
>   : Arguing as before, when $\omega = 1$, $y_{(i,5)}$ cannot be $0$,
      otherwise $y_{(i,1)}$ and $y_{(i,3)}$ won't be integers in \eqref{bhle-condition-on-yi5}. Furthermore, since
      $y_{(i,5)} = -\kappa(y_{(i,4)} + y_{(i,1)})$ and
      $|y_{(i,5)}|\le\kappa$, the only possible solution
      to $y_{(i,4)}$, $y_{(i,1)}$, and $y_{(i,5)}$ that are _all integers_
      is obtained when $y_{(i,5)} \in \braces{-\kappa, \kappa}$, in which case
      $$y_{(i,4)} + y_{(i,1)} \in \braces{+1, -1} \quad \forall i \in \braces{1,\cdots, n},$$ proving the claim.
>
{:.details}
```

```Remark
This reduction has "Rabbit out of Hat" feel to it. How
[Peter van Emde Boas](https://en.wikipedia.org/wiki/Peter_van_Emde_Boas){:target="_blank"} came up with the Diophantine equations remains a
mystery to me. The presentation above in terms of matrix $\mathbf{T}$
and vectors $\vec{u}$, $\vec{v}$ and $\vec{w}$ was an attempt to unravel
this mystery, but without much success.

`Update`{:.bul} (3 Feb 2024): Kreuzer and Nipkow have formally verified
this reduction in Isabelle HOL. See [^KN23] for more details.
```

Based on the lemmas above, we conclude that $2$`-Partition`{:.lowercap}
reduces to `BHLE`{:mathsf}. Since $2$`-Partition`{:.lowercap} is
$\NP$-Complete, that implies `BHLE`{:mathsf} is $\NP$-Complete **for all**
$\kappa \ge 1$.


#### <span class="mathsf">BHLE</span> $\preceq$ <span class="lowercap">Decisional-SVP$|_{\ell_\infty}$</span> {#subsubsection--svp-ell-infty-np-complete}

To prove that [Decisional-SVP]({% post_url
2020-06-08-LatticesBasicDefinitions
%}#problem--shortest-vector-problem-decisional){:.lowercap} is
$\NP$-Complete in ${\ell_\infty}$ norm, this section describes a
polynomial time (Karp) reduction from [BHLE](#problem--bhle){:.mathsf}
to `Decisional-SVP`{:.lowercap}. Recall that input to a
`Decisional-SVP`{:.lowercap} instance is a full rank integral
lattice basis $\mathbf{B} \in \ZZ^{m\times m}$ and a distance threshold
$r \in \QQ_{>0}$, and the goal of the solver is to decide if
$$\href{ {% post_url 2020-06-08-LatticesBasicDefinitions %}#defn--successive-minima }{\lambda_{1}^{\ell_\infty}}(\L(\B)) < r?$$
Also, recall from the [previous
section](#subsubsection--bhle-np-complete), that input to a
`BHLE`{:.mathsf} instance is a set of integers $\vec{a} :=
\braces{a_1,\cdots, a_n} \in \ZZ^n$ and a positive integer threshold
$\kappa \in \ZZ_{>0}$, and the goal of the `BHLE`{:.mathsf} solver is to
decide if $$ \exists\, \vec{x} \in \ZZ^n\setminus \vec{0}:\; \dotprod{\vec{x}, \vec{a}} =
0\quad {\huge \wedge}\quad 0 < \abs{\vec{x}}_{\ell_\infty} \le \kappa?$$

A Karp reduction from `BHLE`{:.mathsf} to `Decisional-SVP`{:.lowercap}
requires a polynomial time encoding map
$\highlight{\zeta} : \ZZ^n\times \ZZ_{>0} \highlight{\longrightarrow} \ZZ^{\poly(n)\times \poly(n)}\times \QQ_{>0}$ that maps a `BHLE`{:.mathsf} instance
$(\vec{a},\kappa) \in \ZZ^n \times \ZZ$ into a `Decisional-SVP`{:.lowercap} instance $(\mathbf{B}, r) \in \ZZ^{\poly(n)\times\poly(n)}\times\QQ_{>0}$,
such that:

1. `If`{:#bhle-to-svp-reduction-condition-1} $(\vec{a},\kappa)$ is a `BHLE`{:.mathsf} `Yes`{:.lowercap}
   instance, then the encoded value
   $(\mathbf{B}, r) := \zeta(\vec{a}, \kappa)$ corresponds to a
   `Decisional-SVP Yes`{:.lowercap} instance, and
2. `Given`{:#bhle-to-svp-reduction-condition-1} an
   _arbitrary pair_ $(\vec{a}, \kappa)$ such that
   its encoded value $(\mathbf{B}, r) := \zeta(\vec{a}, \kappa)$
   corresponds to a `Decisional-SVP Yes`{:.lowercap} instance,
   then $(\vec{a}, \kappa)$ corresponds to a `BHLE`{:.mathsf}
   `Yes`{:.lowercap} instance.

As before, let $\mu = \sum_{i} |a_i|$, and define a basis
matrix $\mathbf{B}$ as
$$
\mathbf{B} :=
  \begin{pmatrix}
    \mathbf{I}_{n}            &   0\\
    (\kappa + 1)\cdot\vec{a}^\top  & (\kappa+1)\cdot (\kappa \mu + 1)
  \end{pmatrix} \in \ZZ^{(n+1)\times(n+1)}
$$
where $\vec{a}^\top$ is the transpose of $\vec{a}$ and $\mathbf{I}_n$ is
the $n\times n$ identity matrix. Notice that $\mathbf{B}$ is full-rank
because $\det(\mathbf{B})$ $=$ $\det(\mathbf{B}^\top)$ $=$
$(\kappa + 1)\cdot(\kappa\mu + 1) > 0$, therefore the lattice generated
by $\B$ is full rank. Define the encoding map $\zeta$ as follows:
$$
  \begin{equation}
  \begin{array}{rll}
  \zeta &:& \ZZ^n\times \ZZ_{>0} \longrightarrow \ZZ^{(n+1)\times(n+1)}\times \QQ_{>0}\\
  \zeta(\vec{b}, \kappa) &:=& (\mathbf{B}, \kappa + 1).
  \end{array}
  \label{bhle-to-svp-zeta-map}
  \end{equation}
$$

The next two lemmas prove that $\zeta$ satisfies both condition
 [(1)](#bhle-to-svp-reduction-condition-1) and
 [(2)](#bhle-to-svp-reduction-condition-2) listed before.


```Lemma [$(\vec{a},\kappa) \in \mathsf{BHLE} \implies \zeta(\vec{a},\kappa) \in \textsc{Decisional-SVP}$]{#lemma--bhle-to-svp-forward}

Suppose $(\vec{a}, \kappa) \in \ZZ^{n}\times \ZZ_{>0}$ is a
`BHLE`{:.mathsf} `Yes`{:.lowercap} instance, then
$\zeta(\vec{a}, \kappa)$ corresponds to a
`Decisional-SVP Yes`{:.lowercap} instance.
```

```Proof {#proof--bhle-to-svp-forward}

Since $\vec{a} \in $ `BHLE`{:.mathsf}
$\implies \exists\,\vec{x} \in \ZZ^{n}\setminus \vec{0}$, such that $\dotprod{\vec{x}, \vec{a}} = 0$ and $0 < \abs{\vec{x}} \le \kappa$. Let
$$
\vec{z} := \begin{pmatrix} \vec{x} \\ 0 \end{pmatrix} \in \ZZ^{(n+1)}
$$
then, $\vec{z} \neq \href{#notation--zero-one-vectors}{\vec{0}}$ since
$\vec{x} \neq \vec{0}$ by the definition of `BHLE`{:.mathsf}. Furthermore,
$\mathbf{B}$ is full-rank and hence injective, therefore
$\mathbf{B}\cdot \vec{z} \neq \vec{0}$. By construction
$$
  \mathbf{B}\cdot \vec{z} = \begin{pmatrix} \vec{x} \\ (\kappa+1)\underbrace{\dotprod{\vec{a}, \vec{x}}}_{0} + (\kappa+1)(\kappa\mu + 1)\cdot 0 \end{pmatrix} = \begin{pmatrix} \vec{x} \\ 0 \end{pmatrix}
$$
therefore $\abs{\mathbf{B}\cdot \vec{z}}$ $=$ $\abs{\vec{x}} \le \kappa$ $< \kappa + 1$ $\implies$ $\zeta(\vec{a}, \kappa) \in$ `Decisional-SVP`{:.lowercap}.

```

`Note`{:.bul}: The lemma [above](#lemma--bhle-to-svp-forward) and its
proof holds for any arbitrary $\ell_p$ norm, not just $\ell_\infty$.

```Lemma [$\exists(\vec{a},\kappa): \zeta(\vec{a},\kappa) \in \textsc{Decisional-SVP} \implies (\vec{a},\kappa) \in \mathsf{BHLE}$]{#lemma--bhle-to-svp-reverse}

Let $\vec{a} \in \ZZ^n$ be an arbitrary integer vector and let
$\kappa \in \ZZ_{>0}$ be a positive constant. If
$(\mathbf{B}, \kappa + 1) := \zeta(\vec{a}, \kappa)$
defined in \eqref{bhle-to-svp-zeta-map} corresponds to a
`Decisional-SVP Yes`{:.lowercap} instance, then $(\vec{a}, \kappa)$
corresponds to a `BHLE`{:.mathsf} `Yes`{:.lowercap} instance.
```

```Proof {#proof--bhle-to-svp-reverse}

Given that $(\mathbf{B}, \kappa + 1) := \zeta(\vec{a}, \kappa)$
corresponds to `Decisional-SVP Yes`{:.lowercap} instance, there exists
a _non-zero integer_ vector
$$
\vec{z}^\star := \begin{pmatrix} \vec{z} \\ z_{n+1} \end{pmatrix} \in \ZZ^{(n+1)}\setminus \href{#notation--zero-one-vectors}{\vec{0}}, \quad\text{where }\vec{z} := \braces{z_1,\cdots, z_n}
$$
such that
$0 < \abs{\mathbf{B}\cdot \vec{z}^\star}_{\ell_\infty} < \kappa + 1$. We
need to prove that

1. $0 < \abs{\vec{z}}_{\ell_\infty} \le \kappa$, and
2. $\dotprod{\vec{z}, \vec{a}} = 0$.

By construction
$$
\mathbf{B}\cdot \vec{z}^\star = \begin{pmatrix} \vec{z} \\ 0\end{pmatrix} +
(\kappa + 1)\begin{pmatrix} \vec{0}\\ \dotprod{\vec{z}, \vec{a}} + (\kappa\mu + 1)\cdot z_{n+1}\end{pmatrix},
$$
and since $\vec{z}^\star$ corresponds to a `Decisional-SVP Yes`{:.lowercap} instance,

$$
\begin{equation}
\abs{\mathbf{B}\cdot \vec{z}^\star}_{\ell_\infty} < k + 1 \highlight{\implies} \begin{cases} \abs{z_i} < \kappa + 1 & \text{for}\, 1\le i \le n,\;\text{and}\\
&\\
\abs{\dotprod{\vec{z}, \vec{a}} + (\kappa\mu + 1)\cdot z_{n+1}} < 1. &
\end{cases}
\label{bhle-to-svp-reverse-cases}
\end{equation}
$$

Given that $\vec{z}_i$s are integers: $\abs{z_i} < \kappa + 1$ $\highlight{\iff}$ $\abs{z_i} \le \kappa$,
therefore, $\abs{\vec{z}}_{\ell_\infty} \le \kappa$, and
$$
\begin{equation}
 \abs{\dotprod{\vec{z},\vec{a}}} \highlight{\le} \sum_{i=1}^n \abs{z_i\cdot a_i} \highlight{\le} \kappa\cdot\sum_{i=1}^n \abs{a_i} \highlight{=} \kappa\cdot\mu.
\label{bhle-to-svp-reverse-inner-relation}
\end{equation}
$$

We need to show that $\abs{\vec{z}}_{\ell_\infty} \neq 0$ and $\dotprod{\vec{z}, \vec{a}} = 0$.

Since $\dotprod{\vec{z}, \vec{a}} + (\kappa\mu + 1)\cdot z_{n+1}$  is
an integer with absolute value _strictly_ less than $1$,
$\dotprod{\vec{z}, \vec{a}} + (\kappa\mu + 1)\cdot z_{n+1} = 0$
is the only possible solution to the second case in
\eqref{bhle-to-svp-reverse-cases}, hence
$$\abs{\dotprod{\vec{z}, \vec{a}}} \highlight{=} (\kappa\mu + 1)\abs{z_{n+1}}.$$

Suppose
$z_{n+1} \neq 0 \highlight{\implies} (\kappa\mu + 1)\abs{z_{n+1}} \ge (\kappa\mu + 1)$,
therefore, by \eqref{bhle-to-svp-reverse-inner-relation},
$$
\kappa\mu \highlight{\ge} \abs{\dotprod{\vec{z}, \vec{a}}} \highlight{=} (\kappa\mu + 1)\abs{z_{n+1}} \highlight{\ge} (\kappa\mu + 1)
$$
which is impossible! Hence, the assumption that $z_{n+1} \neq 0$ is wrong and
$$
\dotprod{\vec{z}, \vec{a}} \highlight{=} -(\kappa\mu + 1)\cdot z_{n+1} \highlight{=} 0.
$$

Finally, by assumption $\vec{z}^\star \neq \vec{0}$, but
since $z_{n+1} = 0 \highlight{\implies} \vec{z} \neq \vec{0}$.
```

<!-- ### [<span class="lowercap">Search-SVP$|_{\ell_p}$</span>]({% post_url 2020-06-08-LatticesBasicDefinitions %}/#problem--shortest-vector-problem) is $\NP$-Hard -->

### [<span class="lowercap">Search-CVP</span>](#problem--search-cvp) reduces to [<span class="lowercap">Decisional-CVP</span>](#problem--decisional-cvp) {#subsection-search-cvp-to-decisional-cvp-reduction}

```Remark
This section is written with $\ell_2$ norm in mind. However,
`Search-CVP`{:.lowercap} to `Decisional-CVP`{: .lowercap} holds in all
$\ell_p$ norms, including $\ell_\infty$ norm in dimension preserving
way. See [^K87] and [^NSD16] for a more nuanced treatment.
```

We are given an oracle that can _somehow_ solve [<span class="lowercap">
Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp) for
any lattice basis $\C \in \ZZ^{n\times n}$, target vector
$\vec{s} \in \QQ^n$, and a distance threshold $r \in \QQ$. Given a basis
$\B \in \ZZ^{n \times n}$ and a target vector $\vec{t} \in \QQ^n$, the
goal of the reduction is to use the `Decisional-CVP`{: .lowercap} oracle
to find a $\vec{x} \in \L(\B)$ such that $\abs{\vec{t} - \vec{x}} =
\Delta(\vec{t}, \L)$. Notice that both sides of this equation, namely
$\vec{x}$ and $\Delta(\vec{t}, \L)$, are unknown.

Indeed, like most `Search`{: .lowercap} to `Decision`{: .lowercap}
reductions for `NPO`{: .mathsf} problems, the first
challenge is to compute the optimal distance (metric) using the
decisional oracle. In case of `CVP`{: .mathsf} that means coming up
with a reduction from [Opt-CVP](#problem--opt-cvp){: .lowercap} to
[Decisional-CVP](#problem--decisional-cvp){: .lowercap}. Since the
distance between $\vec{t}$ and $\L$ is _polynomially bounded_ from above
and below, standard binary search using the decisional oracle is
sufficient to compute $d^\dagger := \Delta(\vec{t}, \L).$

Once $d^\dagger$ is known, the `Search-CVP`{: .lowercap} solver works as
follows: It iteratively creates _sublattices_
$\L(\B^*) \leftarrow \L(\B)$ and new targets
$\vec{t}^* \leftarrow \vec{t}$ such that the shortest vector length
$\lambda_1(\B^*)$ of the dilated sublattice keeps doubling, while the
distance between $\L(\B^*)$ and $\vec{t}^*$ remains fixed, i.e.,

$$
\begin{equation}
d^\dagger = \Delta(\vec{t}, \L(\B)) = \Delta(\vec{t}^*, \L(\B^*)).
\label{search-to-decision-invariant}
\end{equation}
$$

Since $d^\dagger$ remains fixed while $\lambda_1(\B^*)$ keeps doubling,
after an appropriate (polynomial) number of iterations, the
[Search-CVP](#problem--search-cvp){: .lowercap} instance transforms
into an [$\alpha$-BDD](#problem--bdd){:.lowercap} instance with
$\alpha < \frac{1}{1+2^{n/2}}$. For such small values of $\alpha$,
Babai's Nearest Plane _approximation algorithm_ solves
$\alpha{-}$`BDD`{:.lowercap} instance exactly, leading to a polynomial
time reduction. (`Note`{: .bul}: There are other ways [^K87] of getting
this reduction, but this is most elegant, in my opinion.)

These reductions are described in detail as follows:

```Reduction [<span class="lowercap">Opt-CVP</span> $\preceq$ <span class="lowercap">Decisional-CVP</span> ]
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n \times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L(\B)$.
  : Target Vector $\vec{t} \in \QQ^n$

Output
  : Distance $\highlight{d^\dagger} \in \QQ$ that's arbitrarily close to
    $\Delta(\vec{t}, \L(\B))$. In other words, $d^\dagger$ is such
    that
    $$\abs{d^\dagger - \Delta(\vec{t}, \L(\B)) } <\frac{1}{2^{O(n^c)}}$$
    for arbitrary user selected constant $c > 1 \in \ZZ$.

Oracle
  : [<span class="lowercap">Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp), where $\C \in \ZZ^{n\times n}$, $\vec{s} \in \QQ^n$, and $r \in \QQ$.

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
    {: .details }

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
    >      Since $\vec{v}^* \in \P(\B)$, it can be written uniquely as the
           _fractional linear combination_ of columns of $\B$, namely,
           $\vec{v}^* = \sum_{i} u_i^*\cdot \vec{b}_i$ for uniquely
           determined $u_i^* \in [0,1) \subseteq \RR^n$. Hence,
           $$
           \Delta(\vec{t}, \L) \le \abs{\vec{v}^*} = \norm{\sum_i u_i^*\cdot \vec{b}_i} \le \sum_i \abs{u_i^*\cdot \vec{b}_i} \le \sum_i \abs{\vec{b}_i} \le D(\B).
          $$
          <div class="proof-end"/>
    >
    {: .details }

    Based on the upper and lower bounds on $\Delta(\vec{t}, \L)$, the
    `Opt-CVP`{: .lowercap}$(\B, \vec{t})$ solver uses _binary search_
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
    >    a. Set $\highlight{\psi} = \frac{\alpha + \beta}{2} \in \QQ$.
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
    > 3. Set $\highlight{d^\dagger} \leftarrow \frac{\alpha + \beta}{2}$
         and `return`{: .bul } $\highlight{d^\dagger}$.
    >
    {: .details }

  `Note`{: .bul}: The precision threshold $\frac{1}{2^{O(n^c)}}$
  determines the running time of this algorithm.
```

Given $d^\dagger$, any $\vec{x} \in \L(\B)$ that lies in the
$n$-dimensional sphere of radius $d^\dagger$ centered around $\vec{t}$
is a valid solution to `Search-CVP`{: .lowercap}. How many lattice
vectors are exactly $d^\dagger$ distance away from $\vec{t}$? There are
$2^n$ corners of the parallelepiped, so in the worst case, each one of
the $2^n$ corners could be a potential candidate. This leads to the
following trivial exhaustive search algorithm with a worst case running
time of $O(2^n)$.

```Algorithm [CVP Exhaustive Search] {#algo--cvp-exhaustive-search}

Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n \times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L(\B)$.
  : A target vector $\vec{t} \in \QQ^n$
  : Distance $d^\dagger = \Delta(\vec{t}, \L(\B))$ and a precision threshold $O(1/2^c)$

Output
  : $\vec{x} \in \L(\B)$ such that $\abs{\vec{t} - \vec{x}} = d^\dagger$

The algorithm works as follows:

> 1. Since $\vec{t} \in \QQ^n$ and $\B \in \ZZ^{n\times n} \subseteq \QQ^{n\times n}$ is
     non-singular, it can be uniquely written as an element of
     $\textsf{span}_\QQ(\B)$, i.e.,
     $$
        \forall i \in 1\cdots n,\;\exists! q_i\in\QQ:\; \vec{t} = q_1\vec{b}_1 + \cdots + q_n\vec{b}_n.
     $$
>
> 2. `Let`{: #algo--cvp-exhaustive-search-step-2} $\fractional{q_i} := q_i - \floor{q_i} \in [0,1) \subseteq \QQ$ denote the
     fractional part of $q_i$. Compute the target vector within the parallelepiped
     $$ \vec{t}^* = \fractional{q_1}\vec{b}_1 + \cdots + \fractional{q_n}\vec{b}_n \in \P(\B)
     $$
>
>
> 3. `for`{: .bul #algo--cvp-exhaustive-search-step-3} $ i \leftarrow 0 \cdots (2^n - 1)$ `do`{: .bul}
>
>      * Bit decompose $i$ as $\braces{i_1,\cdots, i_n} \in \{0,1\}^n $ (that is
>          $i = \sum_{j=1}^{n} i_j2^{j-1}$).
>
>      * Let $ \vec{x}_i^* := i_1\vec{b}_1 + i_2\vec{b}_2 + \cdots + i_n\vec{b}_n \in \L(\B)$
>         and compute $\mu_i = \abs{\vec{t}^* - \vec{x}_i^*}$
>
>      * `If`{: .bul} $|\mu_i - d^\dagger| < \frac{1}{2^c}$ `break`{: .bul}.
>
> 4. Compute the final closest vector as
>    $$ \vec{x} = \vec{x}_i^* + \sum_{j=1}^n \floor{q_j}\vec{b}_j$$
>    and `return`{: .bul} $\vec{x}$.
{: .details }

The loop in [step-3](#algo--cvp-exhaustive-search-step-3) enumerates all
lattice vectors on the corners the parallelepiped. Since $d^\dagger$ is
guaranteed to be within $O(1/2^c)$ of $\Delta(\vec{t}, \L(\B))$, the loop
terminates on the first corner $\vec{x}_i^*$ that's roughly $d^\dagger$
away from $\vec{t}^*$. The final closest lattice vector is then obtained
by adding the lattice-translate of the parallelepiped in which $\vec{t}$
resides.
```

The exhaustive search algorithm above _does not_ lead to a polynomial
time reduction. As alluded before, a better strategy to get a polynomial
time reduction is to transform `Search-CVP`{: .lowercap} into an
$\alpha$`-BDD`{: .lowercap} instance, and then use Babai's nearest plane
algorithm to exactly solve $\alpha$`-BDD`{: .lowercap}. These two steps
are described in next two subsections:

#### `Search-CVP`{: .lowercap} reduces to $\alpha$`-BDD`{: .lowercap}

Given the explicit knowledge of $d^\dagger = \Delta(\vec{t}, \L(\B))$
and access to `Decisional-CVP`{: .lowercap} oracle, the reduction from
`Search-CVP`{: .lowercap} to $\alpha$`-BDD`{: .lowercap} works as
follows (adapted from Chapter 03 of [^MG02] and [Regev's Lecture
Notes](https://cims.nyu.edu/~regev/teaching/lattices_fall_2004/ln/complexity.pdf){:
target="_blank"}):

```Reduction [<span class="lowercap">Search-CVP<sup style="vertical-align: super;padding-left:0.25em"><span class="lowercap">[Decisional-CVP]</span></sup></span> $\preceq \alpha$<span class="lowercap">-BDD</span>]{#reduction--search-cvp-to-alpha-bdd}

Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n \times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L(\B)$.
  : Target Vector $\vec{t} \in \QQ^n$
  : Distance $d^\dagger = \Delta(\vec{t}, \L(\B)) \in \QQ$

Output
  : A vector $\vec{x} \in \L(\B)$ such that $\forall\,\vec{y} \in \L(\B):\; \abs{\vec{t} - \vec{x}} \le \abs{\vec{t} - \vec{y}}$.

Oracle
  : [Decisional-CVP$(\C, \vec{s}, r)$](#problem--decisional-cvp){: .lowercap} that outputs
    $1$ if $\Delta(\vec{s}, \L(\C)) \le r$ and $0$ otherwise, where
    $\C \in \ZZ^{n\times n}$, $\vec{s} \in \QQ^n$, and $r \in \QQ$.
  : [$\alpha$-BDD$(\C, \vec{s})$](#problem--decisional-cvp){: .lowercap} that
    outputs unique $\vec{x} \in \L(\C)$ closest to $\vec{s} \in \QQ^n$, provided
    $\frac{\Delta(\vec{s}, \L(\C))}{\lambda_1(\C)} < \alpha$,
    where $\lambda_1(\C)$ is the length of shortest non-zero vector in $\L(\C)$,
    $\C \in \ZZ^{n\times n}$ and $0 \le \alpha < \frac{1}{2}$.

Algorithm
  : We first describe the high level ideas of the reduction:

    * Given the lattice basis $\B := \braces{b_1,\cdots, b_n}$, the
      `Search-CVP`{: .lowercap } solver creates sublattices $\L(\B^*)$ of
      $\L(\B)$ using a "dilated" basis

      $$
        \B^* := [\highlight{2\vec{b}_1}, \vec{b}_2,\cdots, \vec{b}_n ].
      $$

      Since $\L(\B^*)$ is a subgroup of $\L(\B)$, by construction, its
      quotient group is
      $$ \begin{aligned}
      & \quad \L(\B)/\L(\B^*) = \braces{\L(\B^*), \L(\B^*) + \vec{b}_1 } \\
      \Longrightarrow & \quad \L(\B) = \L(\B^*) \bigsqcup \left (\L(\B^*) + \vec{b}_1 \right) \\
      \Longrightarrow & \quad \P(\B^*) = \P(\B) \bigsqcup \left (\P(\B) + \vec{b}_1 \right ).
      \end{aligned}
      $$

      Given that $\P(\B^*)$ is the disjoint union of $\P(\B)$ and
      $\P(\B) + \vec{b}_1$, either $\vec{t}$ or $\vec{t} + \vec{b}_1$ must
      be $d^\dagger$ apart from $\L(\B^*)$. (See [Fig.
      2](#figcaption--CVPSearch-to-Decision-Reduction) for an
      illustration.) Therefore, the solver can easily maintain the
      invariant in \eqref{search-to-decision-invariant} provided it can
      decide whether:
      $$\begin{equation}
        \Delta(\vec{t}, \L(\B^*)) = d^\dagger\quad\highlight{\text{or}}\quad
      \Delta(\vec{t} + \vec{b}_1, \L(\B^*)) = d^\dagger?
        \label{translation-decision}
        \end{equation}
      $$

    * To decide between the above two cases in \eqref{translation-decision},
      the solver invokes $\highlight{\xi_1} \longleftarrow$
      `Decisional-CVP`{: .lowercap}$(\B^*, \vec{t}, \highlight{d^\dagger}) \in \braces{0,1}$ to
      determine if $\vec{t}$ is still $d^\dagger$ apart from $\L(\B^*)$?
      If $\xi_1 = 1$ then $\Delta(\vec{t}, \L(\B^*)) = d^\dagger$, otherwise
      $\Delta(\vec{t} + \highlight{\vec{b}_1}, \L(\B^*)) = d^\dagger$.
      By updating the target vector to
      $$\vec{t}^* \leftarrow \vec{t} + \highlight{(1-\xi_1)}\cdot\vec{b}_1,$$
      the solver can maintain the invariant
      $$
      \Delta(\vec{t}^*, \L(\B^*)) = \Delta(\vec{t}, \L(\B)) = d^\dagger.
      $$

      Furthermore, suppose the `Search-CVP`{: .lowercap } solver could
      somehow find the closest vector $\vec{x}^* \in \L(\B^*)$ to
      $\vec{t}^*$, then finding the closest vector  $\vec{x} \in \L(\B)$
      to $\vec{t}$ is easy:
      $$
        \vec{x} = \vec{x}^* - \highlight{(1 - \xi_1)}\cdot\vec{b}_1.
      $$

    * The solver repeats the above procedure for all the $n$ basis
      vectors, $\vec{b}_1, \cdots, \vec{b}_n$, updating the target vector
      $\vec{t}$ to $\vec{t}^{*\cdots *}$ using help from
      `Decisional-CVP`{: .lowercap} oracle. At the end of one complete round
      covering all columns of $\B$, the `Search-CVP`{: .lowercap }
      solver would be left with:

        * A sublattice $\L(2\B) \subseteq \L(\B)$ with basis
          $
            2\B = [2\vec{b}_1, 2\vec{b}_2, \cdots, 2\vec{b}_n]
          $

        * A displacement vector
          $$\vec{h} := \sum_{i=1}^n (1- \xi_i)\cdot \vec{b}_i \in \L(\B)$$
          where each $\xi_i \in \braces{0,1}$ is the output of
          invocations to `Decisional-CVP`{: .lowercap} oracle, and

        * The updated target vector
          $$\vec{t}^{*\cdots *} \leftarrow \vec{t} + \vec{h}$$
          that maintains the invariant
          $$\Delta(\vec{t}^{*\cdots *}, 2\B) = \Delta(\vec{t}, \B) = d^\dagger.$$

        * As before, if the `Search-CVP`{: .lowercap} solver could somehow
          find the closest lattice vector $\vec{x}^{*\cdots *} \in \L(2\B)$
          to $\vec{t}^{*\cdots *}$, then the solver can find the closest
          lattice vector $\vec{x} \in \L(\B)$ to $\vec{t}$ as
          $$
            \vec{x} = \vec{x}^{*\cdots *} - \vec{h} \in \L(\B).
          $$


    * Let $\lambda_1(\B)$ be the length of the shortest non-zero vector in
      $\L(\B)$ and let
      $$\widehat{\alpha}(\vec{t}, \B) := \frac{\Delta(\vec{t}, \L(\B))}{\lambda_1(\B)}.$$

      Before the solver can invoke $\alpha$`-BDD`{: .lowercap} oracle, it
      must ensure that $\widehat{\alpha}(\vec{t}^{*\cdots *}, \B^{*\cdots *}) < \alpha$
      for $\alpha$`-BDD`{: .lowercap} to find the unique solution.
      Since $\lambda_1(2\B) = 2\cdot\lambda_1(\B)$ while
      $\Delta(\vec{t}, \L(\B)) = \Delta(\vec{t}^{*\cdots *}, \L(2\B))$
      $\highlight{\implies}$
      $\alpha(\vec{t}^{*\cdots *}, 2\B) = \frac{1}{2}\alpha(\vec{t}, \B)$. Therefore,
      repeating the above procedure $k$-times results in the updated
      target vector $\vec{t}^{\overbrace{*\cdots *}^{\text{k times}}}$
      with a sublattice basis
      $2^k\B = [2^k\vec{b}_1,\cdots, 2^k\vec{b}_n]$ and
      $$\alpha(\vec{t}^{\overbrace{*\cdots *}^{\text{k times}}}, 2^k\B) = \frac{1}{2^k}\alpha(\vec{t}, \B).$$

      Unfortunately, the solver doesn't know $\lambda_1(\B)$! To address
      that, let $L = \min_{1 \le i \le n}\{ \abs{\vec{b}_i } \}$
      be the length of the shortest basis vector of $\B$. By definition,
      $\lambda_1(\B) \le L$, therefore
      $$
        \frac{\Delta(\vec{t}, \L(\B))}{L} \le \frac{\Delta(\vec{t}, \L(\B))}{\lambda_1(\B)} \highlight{\implies} \frac{d^\dagger}{2^k\cdot L} = \frac{\Delta(\vec{t}^{\overbrace{*\cdots *}^{\text{k times}}}, \L(\B^{\overbrace{*\cdots *}^{\text{k times}}}))}{2^k\cdot L} \le \frac{\Delta(\vec{t}^{\overbrace{*\cdots *}^{\text{k times}}}, \L(\B^{\overbrace{*\cdots *}^{\text{k times}}}))}{2^k\cdot \lambda_1(\B)}.
      $$

      Therefore, to ensure $\widehat{\alpha}(\vec{t}^{\overbrace{*\cdots *}^{\text{k times}}}, 2^k\cdot \B) < \alpha$ it's sufficient to iterate the above steps
      $k$-times, where
      $$
        \begin{equation}
        k \ge \ceil{ \log_2 \left( \frac{d^\dagger}{\alpha \cdot L} \right ) }
        \label{cvp-to-bdd-iteration-count}
        \end{equation}
      $$

      As proved in the [next subsection](#section--polynomial-time-algorithm),
      Babai's nearest plane _approximation algorithm_ acts as an
      $\alpha$`-BDD`{: .lowercap} solver for $\alpha = \frac{1}{1 + 2^{n/2}}$.
      Substituting this value of $\alpha$ in
      \eqref{cvp-to-bdd-iteration-count} leads to
      $$
        k \ge \ceil{ \log_2(1 + 2^{n/2}) + \log_2(d^\dagger / L) } \in O(n).
      $$

<figure id="fig--cvpsearch-to-decision-reduction">
  <div class="multi-columns">
    <div style="max-width:350px" id="CVPSearch-to-Decision-Itr-0">
      <img src="/Diagrams/2020-06-16/final/CVPSearch2Decision-1.svg"/>
            <figurecaption>Lattice with basis $\B := [\vec{b}_1, \vec{b}_2],$
            target vector $\vec{t}$, and computed minimum distance
            $d^\dagger = \Delta(\L(\B), \vec{t})$.</figurecaption>
    </div>
    <div style="max-width:350px;" id="CVPSearch-to-Decision-Itr-1">
      <img src="/Diagrams/2020-06-16/final/CVPSearch2Decision-2.svg" />
      <figurecaption><span class="bul">Iteration-1</span>: Sublattice
      with basis $\B^* := [2\vec{b}_1, \vec{b}_2]$ has
      $\Delta(\L(\B^*), \vec{t}) > d^\dagger$ and
      <em>requires</em> updating the target vector to
      $\vec{t}^* \leftarrow \vec{t} + \vec{b}_1$ to maintain the invariant
      $\Delta(\L(\B^*), \vec{t}^*) = d^\dagger$. </figurecaption>
    </div>
    <div style="max-width:350px" id="CVPSearch-to-Decision-Itr-2">
      <img src="/Diagrams/2020-06-16/final/CVPSearch2Decision-3.svg"/>
        <figurecaption><span class="bul">Iteration-2</span>: Sublattice
      with basis $\B^{**} := [2\vec{b}_1, 2\vec{b}_2]$ implicitly
      preserves the invariant $\Delta(\L(\B^{**}), \vec{t}^*) = d^\dagger$
      and <em>does not</em> require update to target vector $\vec{t}^*$,
      therefore $\vec{t}^{**} \leftarrow \vec{t}^*$.</figurecaption>
    </div>
  </div>
  <figurecaption id="figcaption--CVPSearch-to-Decision-Reduction">Two iterations of <span class="lowercap">Search-CVP</span>
  to <span class="lowercap">Decisional-CVP</span> reduction.</figurecaption>
</figure>


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
optimal solution to `Search-CVP`{: .lowercap}$(\B, \vec{t})$ is
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

<!-- ## Hardness of approximating <span class="mathsf">SVP</span>$_\gamma$ and <span class="mathsf">CVP</span>$_\gamma$ -->

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
    target="_blank"} [<span class="pdf-icon"/>](/assets/posts/{{ page.date | date: "%Y-%m-%d" }}/van_emde_boas_1981.pdf){: target="_blank"}

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
