---
layout: post
title: Classical complexity reductions among hard lattice problems
date: 2020-06-16
author: Yogesh Swami
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
output will be no worse than $\gamma \in \RR \;(\gamma \ge 1)$ times the
optimal solution. $\gamma$ is called the _approximation ratio_ and its
value depends on the algorithm, not the problem instance.

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
.mathsf } problems. Recall that an $\svp_\gamma$ [problem instance]({%
post_url 2020-06-08-LatticesBasicDefinitions
%}#jxkmath563xkj-approximate-shortest-vector-problems) consists of a
lattice $\L$ specified by a basis $\B \in \RR^{n\times n}$ and an
approximation ratio $\gamma$. The goal is to find a short (non-zero)
lattice vector $\vec{x}\in \L(\B)$ such that $\vec{x}$ is _at most_
$\gamma$ times longer that the _shortest_ (non-zero) vector in $\L(\B)$.
In case of $\cvp_\gamma$, in addition to $\B$ and $\gamma$, we are also
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
$\vec{t} \in \RR^n$ in space is defined as the usual euclidean distance
(or more generally any $\ell_p$ norm) between two points in space:
$\Delta(\vec{t}, \vec{x}) := \abs{\vec{t} -\vec{x}}$. However, a lattice
is an infinite collection of vectors (also called points), so defining
the distance between a target vector and the _entire lattice_ requires a
new definition:

```Definition [Distance from a Lattice, Closest Vector] {#defn--lattice-point-distance}
Let $\L$ be a lattice specified by a basis $\B \in \RR^{n\times m}$, and
let $\vec{t} \in \RR^n$ be an arbitrary point in space. Then, the
distance between $\vec{t}$ and $\L(\B)$ is defined as the
_minimum distance_ between $\vec{t}$ and any point $\vec{y}$ in the
lattice, i.e.,
$$ \Delta(\vec{t}, \L(\B)) := \min_{\vec{y} \in \L(\B)} \lrbraces{ \norm{\vec{t} - \vec{y}} } =
\min_{\vec{z} \in \ZZ^m} \lrbraces{ \norm{\vec{t} - \B\cdot\vec{z}}}.$$

A lattice vector $\vec{x} \in \L(\B)$ is a **closest vector** to $\vec{t}$ if
$\Delta(\vec{t}, \L(\B)) = \Delta(\vec{t}, \vec{x})$.
```

```Remark
Since bit representation of real numbers is challenging, it's customary
to limit the study of `CVP`{: .mathsf} to lattices with [integral
basis]({% post_url 2020-06-08-LatticesBasicDefinitions
%}#integral-lattice-remark) where $\B \in \ZZ^{n\times m} \subseteq
\RR^{n\times m}$. In addition, the target vector is assumed to be a
vector over rationals, i.e., $\vec{t} \in \QQ^n \subseteq \RR^n$,
with a fixed $\poly(n)$ size bit representation. In addition, to avoid
precision issues with $\ell_p$ norm, its often acceptable to consider
$\abs{\cdot}^p \in \QQ$ as the distance metric instead of the exact
$\ell_p$ norm. (The rest of this post only considers euclidean norm.)

In principal, one could multiply both the lattice basis $\B$ and the
target vector $\vec{t}$ by an appropriate integer such that $\vec{t} \in
\ZZ^n$, however, this post follows the standard convention of specifying
$\vec{t}$ over the rationals instead of integers.

```

#### Exact Closest Vector Problem (<span class="mathsf">CVP</span>) {#subsubsection--cvp}

The _exact_ search, optimization, and decision problems related to
`CVP`{: .mathsf } are listed below:

```Problem [<span class="lowercap">Search-CVP</span>] {#problem--search-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \QQ^n$.

Output
  : A vector $\vec{x} \in \L(\B)$ such that $\forall\,\vec{y} \in \L(\B):\; \abs{\vec{t} - \vec{x}} \le \abs{\vec{t} - \vec{y}}$.

```

```Problem [<span class="lowercap">Opt-CVP</span>] {#problem--opt-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \QQ^n$.

Output
  : The _length_ between $\vec{t}$ and the lattice $\L(\B)$, i.e.,
    $\Delta(\vec{t}, \L)$.

`Note`{: .bul }: In $\ell_p$ norm, the algorithm is allowed to return
$\Delta(\L, \vec{t})^p$ instead of $\Delta(\L, \vec{t})$.
```

```Problem [<span class="lowercap">Decisional-CVP</span>] {#problem--decisional-cvp}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \QQ^n$.
  : A distance threshold $r \in \QQ$.

Output
  : `Yes`{: .lowercap } if $\Delta(\vec{t}, \L) \leq r$
  : `No`{: .lowercap } otherwise.
```

#### Approximate <span class="mathsf">CVP</span> {#subsubsection--approx-cvp}

Let $\gamma \in \RR\;(\gamma > 1)$  be an approximation factor. $\gamma$
will often be written as $\gamma(n)$ to emphasize that it may depend on
the dimension of the lattice $\L \subseteq \RR^n$. Indeed, the entire of
game of inapproximability is to understand the dependence of $\gamma$ on
$n$.

The approximate search and decision (`Gap`{:.lowercap}) problems related
to `CVP`{:.mathsf} are listed below:

```Problem [<span class="lowercap">Approx-CVP$_\gamma$</span>] {#problem--approx-cvp-search}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \QQ^n$.

Output
  : A lattice vector $\vec{x} \in \L$ such that $\forall\,\vec{y} \in \L:\; \abs{x} \le \gamma(n)\cdot \abs{y}$.
```


```Problem [<span class="lowercap">GapCVP$_\gamma$</span>] {#problem--GapCVP}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice]({% post_url 2020-06-08-LatticesBasicDefinitions %}#integral-lattice-remark) $\L$.
  : A target vector $\vec{t} \in \QQ^n$.
  : A distance threshold $r \in \QQ$.

Output
  : `Yes`{: .lowercap } if $\Delta(\vec{t}, \L) \le r$,
  : `No`{: .lowercap } if $\Delta(\vec{t}, \L) > \gamma(n)\cdot r$,
  : `Undefined`{: .lowercap } if $r < \Delta(\vec{t}, \L) \le \gamma(n)\cdot r$.

`Note`{: .bul }: When the distance threshold $r$ falls within the
 `Undefined`{: .lowercap} region, the algorithm is allowed to output
 `Yes`{: .lowercap }, `No`{: .lowercap }, or _both_ for different
 invocations of the same problem instance, depending upon internal
 randomness of the algorithm.
```

## Reductions among exact problems {#section--exact-reductions}
---
This section lists a series of reductions related to `SVP`{: .mathsf}
and `CVP`{: .mathsf}.

### [<span class="lowercap">Search-CVP</span>](#problem--search-cvp) reduces to [<span class="lowercap">Decisional-CVP</span>](#problem--decisional-cvp) {#subsection-search-cvp-to-decisional-cvp-reduction}

We are given an oracle that can _somehow_ solve [<span class="lowercap">
Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp) for
lattice basis $\C \in \ZZ^{n\times n}$, target vector
$\vec{s} \in \ZZ^n$, and a distance threshold $r \in \QQ$. Given a basis
$\B \in \ZZ^{n \times n}$ and a target vector $\vec{t} \in \ZZ^n$, the
goal of the reduction is to use the `Decisional-CVP`{: .lowercap} oracle
to find $\vec{x} \in \L(\B)$ such that $\abs{\vec{t} - \vec{x}} =
\Delta(\vec{t}, \L)$. Notice, that both sides of this equation, namely
$\vec{x}$ and $\Delta(\vec{t}, \L)$, are unknown.

Indeed, like most `Search`{: .lowercap} to `Decision`{: .lowercap}
reductions for `NP`{: .mathsf} optimization problems, the first
challenge is to compute the optimal measure using the decisional oracle.
In this particular case that means coming up with a reduction from
[Opt-CVP](#problem--opt-cvp){: .lowercap} to
[Decisional-CVP](#problem--decisional-cvp){: .lowercap}. Since the
distance between $\vec{t}$ and $\L$ is _polynomially bounded_ from above
and below, standard binary search using the decisional oracle is
sufficient to compute $d^\dagger := \Delta(\vec{t}, \L).$

Once $d^\dagger$ is known, the `Search-CVP`{: .lowercap} solver works as
follows: It iteratively creates _sublattices_
$\L(\B^*) \leftarrow \L(\B)$ and new targets
$\vec{t}^* \leftarrow \vec{t}$ such that in each iteration the following
invariant is maintained
$$ d^\dagger = \Delta(\L(\B), \vec{t}) = \Delta(\L(\B^*), \vec{t}^*).$$
A consequence of maintaining the distance while dilating the lattice is
that the target vector gradually gets "cornered" towards a specific
lattice vector (see [Fig. 2](#fig--CVPSearch-to-Decision-Reduction)),
which allows one to efficiently compute $\vec{t}^{*\cdots*}$ and finally
$\vec{t}$ from $\vec{t}^{*\cdots*}$.

These two reductions are described in detail as follows:

```Reduction [<span class="lowercap">Opt-CVP</span> $\le$ <span class="lowercap">Decisional-CVP</span> ]
Input
  : Basis Vector $\B \in \ZZ^{n\times n}$
  : Target Vector $\vec{t} \in \ZZ^n$

Output
  : Distance $\highlight{d^\dagger} \in \QQ$ that's arbitrarily close to
    $\Delta(\vec{t}, \L(\B))$. In other words, $d^\dagger$ is such
    that
    $$\abs{d^\dagger - \Delta(\vec{t}, \L(\B)) } <\frac{1}{2^{O(n^c)}}$$
    for arbitrary user selected constant $c > 1 \in \ZZ$.

Oracle
  : [<span class="lowercap">Decisional-CVP</span>$(\C, \vec{s}, r)$](#problem--decisional-cvp), where $\C \in \ZZ^{n\times n}$, $\vec{s} \in \ZZ^n$, and $r \in \QQ$.

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
    >    a. Set $\highlight{\gamma} = \frac{\alpha + \beta}{2} \in \QQ$.
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
    > 3. `Return`{: .bul } Set
          $\highlight{d^\dagger} \leftarrow \frac{\alpha + \beta}{2}$ and return
          $\highlight{d^\dagger}$.
    >
    {: .details }


  `Note`{: .bul}: The precision threshold $\frac{1}{2^{O(n^c)}}$
  determines the running time of this algorithm.
```

<figure id="fig--CVPSearch-to-Decision-Reduction">
  <div class="multi-images">
    <div style="max-width:400px" id="CVPSearch-to-Decision-Itr-0">
      <img src="/Diagrams/2020-06-16/final/CVPSearch2Decision-1.svg"/>
            <figurecaption>Lattice with basis $\B := [\vec{b}_1, \vec{b}_2],$
            target vector $\vec{t}$, and computed minimum distance
            $d^\dagger = \Delta(\L(\B), \vec{t})$.</figurecaption>
    </div>
    <div style="max-width:400px;" id="CVPSearch-to-Decision-Itr-1">
      <img src="/Diagrams/2020-06-16/final/CVPSearch2Decision-2.svg" />
      <figurecaption><span class="bul">Iteration-1</span>: Sublattice
      with basis $\B^* := [2\vec{b}_1, \vec{b}_2]$ has
      $\Delta(\L(\B^*), \vec{t}) > d^\dagger$ and
      <em>requires</em> updating the target vector to
      $\vec{t}^* \leftarrow \vec{t} + \vec{b}_1$ to maintain the invariant
      $\Delta(\L(\B^*), \vec{t}^*) = d^\dagger$. </figurecaption>
    </div>
    <div style="max-width:400px" id="CVPSearch-to-Decision-Itr-2">
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
