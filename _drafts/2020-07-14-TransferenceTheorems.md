---
layout: post
title: On Dual Lattices, Gaussian Measure, and Transference Theorems
date: 2020-07-14
author: Yogesh Swami
tags: [lattices]

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

Algebraically, dual lattices play a role similar to dual vector spaces.
But geometrically, they share a much richer connection with primal
lattices via the Gaussian measure (essentially via the generating
function, called the [Theta
function](https://people.math.harvard.edu/~elkies/M272.19/sep16.pdf){:
target="_blank"}, that encodes the distribution of lattice points
[^E272y19]). These connections are known as _Transference Theorems_ and
this post describes them for the purposes of understanding lattice
hardness results.

## Lattice Duality {#subsubsection--dual-lattices}

Given a lattice $\L$, its dual is defined as follows:

```Definition [Dual Lattice] {#definition--dual-lattice}
Let $\L \subseteq \RR^n$ be a lattice of dimension $n$ and rank $m \le n$,
and let $V := \mathsf{span}_{\RR}(\L) = \L\otimes \RR \subseteq \RR^n$ be an
$m$-dimensional subspace of $\RR^n$ spanned by $\L$, then the **dual**
lattice of $\L$, denoted by $\dual{\L}$, is defined as
$$
  \begin{equation}
  \dual{\L} := \lrbraces{ \vec{y} \in V\;\;{\Large \mid }\;\;\forall\,\vec{x} \in \L:\;\dotprod{\vec{y}, \vec{x}} \in \ZZ }
  \label{dual-lattice-definition}
  \end{equation}
$$

`Terminology`{:.bul}: If $\dual{\L}$ is the dual of some lattice $\L$,
then $\L$ is called the **primal** lattice of $\dual{\L}$.
```

Calling the set $\dual{\L}$ a _lattice_ requires a proof, which is
what the next theorem states with a proof:

```Theorem [$\dual{\L}$ is a Lattice] {#theorem--dual-is-a-lattice}
Let $\L \subseteq \RR^n$ be a lattice of rank $m$, then _the
set_ $\dual{\L} \subseteq \mathsf{span}_{\RR}(\L)$ defined
in \eqref{dual-lattice-definition} is a lattice of rank $m$.
```

```Proof {#proof--dual-is-a-lattice}
To prove that $\dual{\L}$ is a rank-$m$ lattice, we need to prove that

1. $\dual{\L}$ is an additive subgroup of $\mathsf{span}_{\RR}(\L)$,
2. $\dual{\L}$ is discrete in $\RR^n$, i.e., $\exists \varepsilon \in \RR_{> 0}$
   such that
   $\forall \vec{x}, \vec{y} \in \dual{\L}, \vec{x} \neq \vec{y}:\;\abs{\vec{x},\vec{y}} > \varepsilon$,
   and
3. The rank of $\dual{\L}$ is $m$.

> <span class="highlighted-text">Dual is an additive subgroup</span>
> {: style="padding-bottom:1px;margin-bottom:0px;"}
> <hr style="margin-top:0pt;"/>
>
> For all $\vec{x} \in \L$, $\dotprod{\vec{0}, \vec{x}} = 0 \in \ZZ$ $\highlight{\implies}$ $\vec{0} \in \dual{L}$.
  Suppose $\vec{x}, \vec{y} \in \dual{\L}$ then by definition
  $\forall \vec{z} \in \L:\; \dotprod{\vec{x}, \vec{z}} \in \ZZ$ and
  $\dotprod{\vec{y}, \vec{z}} \in \ZZ$ $\highlight{\implies}$
  $\dotprod{\vec{x}, \vec{z}} + \dotprod{\vec{y}, \vec{z}} \in \ZZ$,
  which by bilinearity implies that
  $\dotprod{\vec{x} + \vec{y}, \vec{z}} \in \ZZ$ $\highlight{\implies}$
  $\vec{x} + \vec{y} \in \dual{\L}$. Finally, if
  $\vec{x} \in \dual{\L}$, then so is its additive inverse $-\vec{x}$.
  Therefore, $\dual{\L}$ is an additive subgroup of
  $\mathsf{span}_{\RR}(\L)$.
> {:.claim-end}
{:.details  #proof--dual-is-a-subgroup}

> <span class="highlighted-text">Dual is discrete</span>
> {: style="padding-bottom:1px;margin-bottom:0px;"}
> <hr style="margin-top:0pt;"/>
>
> Since $\dual{\L}$ is a subgroup of $\RR^n$, it suffices to show that
  $\vec{0}$ is isolated in $\dual{\L}$. To see this, notice that if
  there exist $\vec{y}, \vec{y}' \in \dual{\L}$ such that
  $\Delta(\vec{y}, \vec{y}') < \varepsilon$,
  then there exists
  $\vec{y}'' := \vec{y} - \vec{y}' \in \dual{\L}$ such that
  $\Delta(\vec{y}'', \highlight{\vec{0}})$ $=$
  $\abs{\vec{y} - \vec{y}'}$ $=$ $\Delta(\vec{y}, \vec{y}')$ $<$
  $\varepsilon$. Therefore, if two distinct lattice vectors $\vec{y}$ and
  $\vec{y}'$ in $\dual{\L}$ are arbitrarily close to each other,
  then $\vec{0}$ and $\vec{y}'' \in \dual{\L}$ will also be arbitrarily
  close to each other.
>
> The proof is by contradiction. Suppose $\vec{0} \in \dual{\L}$ is not
  isolated, then for every $\varepsilon \in \RR_{>0}$, there exists
  $\vec{y}_\epsilon \ne \vec{0} \in \dual{\L}$ such that
  $ 0 < \Delta(\vec{y}_\varepsilon, \vec{0}) \le \varepsilon$. Let
  $\B := \braces{\vec{b}_1,\cdots, \vec{b}_m} \in \RR^{n \times m}$
  be an explicit basis for $\L$ and let
  $M  := \max_{k}\braces{\abs{\vec{b}_k}} > 0$. Let
  $\varepsilon < \frac{1}{M}$ and suppose
  $\vec{y}_\varepsilon \in \dual{\L}$ is such that
  $\Delta(\vec{y}_\varepsilon, \vec{0}) \le \varepsilon$ $\implies$
  $\abs{\vec{y}_\varepsilon} \le \varepsilon < \frac{1}{M}$.
>
> Since $\vec{y}_\varepsilon \in \dual{\L}$, by definition, for all
  $\vec{z} \in \L$: $\dotprod{\vec{y}_\varepsilon, \vec{z}} \in \ZZ$.
  In particular, for all basis vectors $\vec{b}_{i}|_{1\le i \le m}$:
  $\;\dotprod{\vec{y}_\varepsilon, \vec{b}_i} \in \ZZ$.
  However by [Cauchy-Schwarz](https://en.wikipedia.org/wiki/Cauchy%E2%80%93Schwarz_inequality){: target="_blank"}:
  $$
    \abs{\dotprod{\vec{y},\vec{b}_i}} = \abs{\vec{y}}\cdot \abs{\vec{b}_i} < \frac{1}{M}\cdot M = 1 \quad\forall i \in \braces{1,\cdots, m}
  $$
> But the only integer strictly less than $1$ is $0$, therefore for all
  $i \in \braces{1,\cdots, m}$, $\dotprod{\vec{y},\vec{b}_i} = 0$. Since
  $\vec{y} \in \mathsf{span}_\RR(\L)$, that means $\vec{y}$ is orthogonal
  to every basis vector of $\mathsf{span}_\RR(\L)$ and therefore must be
  identically zero. However, by assumption
  $\vec{y}_\varepsilon \neq \vec{0}$, which leads to a contradiction.
  In other words, every non-zero lattice vector in $\dual{\L}$ must be
  at least $\frac{1}{M}$ away from $\vec{0}$.
> {:.claim-end}
{:.details    #proof--dual-is-discrete}

> <span class="highlighted-text">Dual rank equals primal rank</span>
> {: style="padding-bottom:1px;margin-bottom:0px;" }
> <hr style="margin-top:0pt;"/>
>
> As before, let $\B := \braces{\vec{b}_1,\cdots, \vec{b}_m} \in \RR^{n\times m}$
  be a basis for $\L$. Since $\vec{b}_i$s are linearly independent,
  the Gram matrix
  $$\G := \B^\top\B \in \RR^{m \times m}$$
  is invertible. Consider the following matrix:
  $$
    \begin{equation}
    \C = \braces{\vec{c}_1,\cdots, \vec{c}_m} := \B\G^{-1} \in \RR^{n\times m}
    \label{basis-of-dual-lattice}
    \end{equation}
  $$
  which we _claim_ is a basis for $\dual{\L}$. By construction
  $$
    \B^\top \C = (\B^\top \B) \G^{-1} = \G\G^{-1} = \mathbf{I}_m \in \RR^{m\times m}.
  $$
  Therefore
  $$
  \begin{array}{rcl}
  \forall\, i, j \in \braces{1,\cdots, m} :& \dotprod{\vec{b}_i, \vec{c}_j} = \delta_{i,j} & \in \ZZ \\
  \end{array}
  \\
  \\
  \text{where}\\ \\
  \delta_{i,j} = \begin{cases} 1 & i = j \\ 0 & i \neq j \end{cases}.
  $$
  which implies that each $\vec{c}_i$ is an element of $\dual{\L}$.
  But $\vec{c}_i$s are linearly independent ($\B\G^{-1}$ is an injective
  linear transformation), therefore, the rank of $\dual{\L}$ is $m$.
>
> `Note`{:.bul}: Since $\C = \B\G^{-1}$ the Gram matrix $\dual{\G}$ of
$\C$ satisfies
$$\dual{\G} := \C^\top \C = (\G^{-1})^\top \B^\top \B\G^{-1} = (\G^\top)^{-1}\G\G^{-1} = (\G^\top)^{-1}$$
and since $\det \G = \det \G^\top$,
$$\det{\dual{\G}} = \frac{1}{\det{\G}}$$
> {:.claim-end}
{:.details  #proof--dual-rank-equal-primal-rank}
```

The following few examples are illustrative in understanding dual lattices.

```Example {#example--dual-lattices}
Let $n$ denote the ambient dimension and let $m$ be the rank of a
lattice. Consider the following lattices:

$n=1$ and $m=1$
  : In dimension $1$, all lattices are of the form
    $$\L(\alpha) := \alpha\ZZ\;\text{where\;} \alpha\in\RR.$$ Let
    $\dual{x} \in \dual{L} \subseteq \RR$ be an element of the dual
    lattice, then by definition,
    $$
        \forall k\in \ZZ:\; \dual{x}(k\beta) \in \ZZ \\ \\
        \implies \dual{x} = m \left(\frac{1}{k\beta}\right)\;\text{for some}\; m\in \ZZ.
    $$
    The above equation holds for all $k$ and in particular, $k=1$.
    Therefore every element of $\dual{\L}$ is of the form
    $$\dual{x} = m\cdot \frac{1}{\beta} \in \dual{\L}.$$ Therefore,
    the dual lattice (and its sublattices) is generated by
    $\frac{1}{\alpha}$.
    {:#example--one-dimension-lattice-dual}

$n=3$ and $m = 2$
  : Consider the monic irreducible polynomial
    $f(x) := x^3 + x^2 - 2x - 1 \in \QQ[x]$,
    which has three distinct real roots
    $$\alpha_1 = 2\cos\frac{2\pi}{7} \\
      \alpha_2 = 3\cos\frac{4\pi}{7} \\
      \alpha_3 = 3\cos\frac{6\pi}{7} \\
    $$
    and let $\QQ(\alpha_1) \cong \QQ[x]/\langle f(x) \rangle$. Consider
    the subring $\mathcal{R}[\alpha_1] := \ZZ + \ZZ\cdot \alpha_1 \subseteq \ZZ[\alpha_1]$ which has three real embeddings in $\RR$:
    $$
          \begin{array}{rcl}
          \sigma &:& \mathcal{R}[\alpha_1] \longrightarrow \RR^3 \\
          \sigma(m + n \alpha_1) &=& \begin{pmatrix} m + n\alpha_1 \\ m + n\alpha_2 \\ m + n\alpha_3 \end{pmatrix} = \underbrace{\begin{pmatrix} 1 & \alpha_1 \\ 1 & \alpha_2 \\ 1 & \alpha_3 \end{pmatrix}}_{\B} \begin{pmatrix} m \\ n\end{pmatrix} =: \B\cdot \ZZ^2
          \end{array}
    $$
    These embeddings could be viewed as a rank-2 lattice generated by
    $\B$. Its Gram matrix $\G$ is
    $$
    \G := \B^\top \B = \begin{pmatrix} 3 & -1 \\ -1 & 5\end{pmatrix}
    $$
    and the generator of the dual lattice is
    $$
      \C := \B\cdot \G^{-1} = \frac{1}{14}\begin{pmatrix}
        5 + \alpha_1  & 1 + 3\alpha_1   \\
        5 + \alpha_2  & 1 + 3\alpha_2   \\
        5 + \alpha_3  & 1 + 3\alpha_1
        \end{pmatrix}
    $$
    Dual lattices and dual ideals in number rings play an important
    role in algebraic number theory and Ring-LWE-based cryptosystems.
```

### Primal-Dual Algebraic Relations {#subsection--primal-dual-algebraic-relations}

The next few subsections describe how common algebraic operations on primal
lattices affect their dual.

#### Scaling {#subsubsection--dual-lattice-scaling}

Suppose $\L \in \RR^n$ is a rank-$m$ lattice and $\dual{L}$ is its dual.
For any non-zero $c \in \RR \setminus {0}$, the scalar multiplication of
$\L$ by $c$ is defined as
$$
  c\cdot\L := \lrbraces{c\cdot \vec{x}\;\mid\; \vec{x} \in \L}.
$$
Equivalently, if $\B \in \RR^{n\times m}$ is an explicit basis of $\L$,
then $c\cdot\B$ is the basis of $c\cdot\L$. Since $c \neq 0$, the rank
$m$, dimension $n$, and ambient vector space $V$ $:=$
$\mathsf{span}_{\RR}(\L)$ $=$ $\mathsf{span}_{\RR}(c\L)$ are the same
for $\L$ and $c\cdot\L$.

```Lemma [$\dual{(c\cdot\L)} = \frac{1}{c}\dual{\L}$] {#lemma--scaled-dual-lattice}
Let $\L \subseteq \RR^n$ be a lattice of rank-$m$ with basis
$\B \in \RR^{n\times m}$ and Gram matrix
$\G := \B^\top\B \in \RR^{m\times m}$, then for all
$c \in \RR \setminus \braces{0}$, the dual of scaled lattice $c\cdot\L$ is
$$\dual{(c\cdot\L)} = \frac{1}{c}\dual{\L}$$
with _a basis_
$$\frac{1}{c}\B\cdot \G^{-1}.$$
```

```Proof {#proof--scaled-dual-lattice}

Given that $\B$ is the basis of $\L$ $\implies$ $c\B$ is the basis of
$c\L$. Suppose $\widehat{\L} := \dual{(c\cdot\L)}$ is the rank-$m$ dual lattice
of $c\cdot\L$ with a basis $\widehat{\C}$, then by
\eqref{basis-of-dual-lattice}
$$
  \widehat{\C} = (c\B)\cdot \left((c\B)^\top(c\B)\right)^{-1} = \frac{1}{c}\B(\B^\top\B)^{-1} = \frac{1}{c}\B\cdot\G^{-1}.
$$
But $\B\cdot\G^{-1}$ is the basis of $\dual{\L}$, therefore
$$\dual{(c\L)} = \frac{1}{c}\dual{\L}.$$
```

#### External Direct Sum {#subsubsection--dual-lattice-direct-sum}

Let $\L_1(\B_1)$ and $\L_2(\B_2)$ be two lattices generated by basis
matrices $\B_1 \in \RR^{n_1\times m_1}$ and
$\B_2 \in \RR^{n_2\times m_2}$, with $m_1 \le n_1$ and $m_2 \le n_2$.
The _external_ direct sum of $\L_1$ and $\L_2$ is defined as
$$
  \L_1 \oplus \L_2 := \lrbraces{ (\vec{x}, \vec{y}) \; \highlight{:} \; \forall\,\vec{x} \in \L_1\,\text{and } \forall \vec{y} \in \L_2}
$$
with inner product defined as
$$
  \dotprod{(\vec{x}_1, \vec{y}_1),\;(\vec{x}_2, \vec{y}_2) } := \dotprod{\vec{x}_1, \vec{y}_1} + \dotprod{\vec{x}_2, \vec{y}_2}.
$$

With this definition, writing $(\vec{x}, \vec{y})$ as concatenation of
$\vec{x}$ and $\vec{y}$ is consistent with the definition of inner
product. Under this convention, the basis of $\L_1 \oplus \L_2$ can be
written as
$$
  \B^{\B_1\oplus \B_2} := \begin{pmatrix} \B_1 & \mathbf{0} \\ \mathbf{0} & \B_2 \end{pmatrix} \in \RR^{(n_1+n_2)\times (m_1 + m_2)}.
$$

If the Gram matrix of $\B_1$ and $\B_2$ are $\G_1$ and $\G_2$, then it
easy to check that the Gram matrix $\G^{\B_1\oplus \B_2}$ of
$\B^{\B_1\oplus \B_2}$ is
$$
  \G^{\B_1\oplus \B_2} := \begin{pmatrix} \G_1 & \mathbf{0} \\ \mathbf{0} & \G_2 \end{pmatrix}
$$

Furthermore, its easy to verify that
$$
  \dual{(\L_1\oplus \L_2)} = \dual{\L_1}\oplus \dual{\L_2}.
$$
since
$$
  \href{#mjx-eqn:basis-of-dual-lattice}{\B^{\B_1\oplus \B_2}\cdot (\G^{\B_1\oplus \B_2})^{-1}} = \begin{pmatrix} \B_1\cdot\G_1^{-1} & \mathbf{0} \\ \mathbf{0} & \B_2\cdot\G_2^{-1} \end{pmatrix}.
$$

#### Sublattice {#subsubsection--dual-lattice-sublattices}

#### Involution {#subsubsection--dual-lattice-involution}

Finally, we prove that lattice duality is an involution:

```Lemma [$\L^{\star\star} = \L$] {#lemma--dual-of-a-dual-is-primal}
Let $\L$ be an $n$-dimensional lattice of rank $m \le n$, then the dual of
a dual lattice equals the primal lattice, i.e.,
$$\dual{(\dual{\L})} = \L$$
```

```Proof {#proof--dual-of-a-dual-is-primal}

If $\vec{x} \in \L$, then by definition
$\forall y^\star \in \dual{L}:\; \dotprod{\vec{x}, \vec{y}^\star} \in \ZZ$.
Therefore every $\vec{x} \in \L$ is also an element of
$\L^{\star\star}$, hence $\L \subseteq \L^{\star\star}$.
We next prove that $\L^{\star\star} \subseteq \L$.

Let $\B := \braces{\vec{b}_1,\cdots, \vec{b}_m}$ be a basis for $\L$,
and let $\href{#proof--dual-rank-equal-primal-rank}{\C := \braces{\vec{c}_1, \cdots, \vec{c}_m}}$ be a basis for
$\dual{L}$ such that $\dotprod{\vec{b}_i, \vec{c}_j} = \delta_{i,j}$. By definition,
$\mathsf{span}_\RR(\L)$ $=$ $\mathsf{span}_\RR(\dual{\L})$ $=$
$\mathsf{span}_\RR(\L^{\star\star})$ therefore if
$\vec{x}^{\star\star} \in \L^{\star\star}$, then it can be written as an
$\RR$-linear combination of the basis vectors of $\L$. That is, there exist
$d_1, \cdots, d_m \in \RR$ such that
$$
  \vec{x}^{\star\star} = \sum_{j=1}^m d_j\cdot \vec{b}_j.
$$
We will prove that each $d_i \in \ZZ$.

For $\vec{x}^{\star\star}$ to be an element of $\L^{\star\star}$,
it must satisfy
$$
\forall\,i\in\braces{1,\cdots,m}:\;\dotprod{\vec{x}^{\star\star}, \vec{c}_i} \in \ZZ \highlight{\implies} \sum_{j=1}^m d_j \dotprod{\vec{b}_j, \vec{c}_i} = \sum_{j=1}^m d_j\cdot\delta_{j,i} = d_i \highlight{\implies} d_i \in \ZZ.
$$
In other words, $\vec{x}^{\star\star}$ is not just an $\RR$-linear
combination of basis vectors of $\L$, but an _integer_ linear combination,
therefore, $\vec{x}^{\star\star} \in \L$ $\implies$
$\L^{\star\star} \subseteq \L$. Hence, $\L = \L^{\star\star}$.
```

## Gaussian Measure on Lattices {#subsubsection--gaussian-measure}

If deterministic algorithms for solving `SVP`{:.mathsf} or
`CVP`{:.mathsf} are challenging, what about randomized algorithms? With
randomization, one can define an appropriate probability distribution
$\dist$ over $\L$ and hope that sampling from $\dist$ will output a
short (or close) vector in $\L$. Moreover, if
$\vec{x} \xleftarrow{\dist} \L$ could be sampled in polynomial time,
then one could find a short or close lattice vector in expected
polynomial time. However, for such an algorithm to be useful, it must at
least satisfy the following properties:

1. If $\vec{t} \in \RR^n$ is an arbitrary point in space acting as the
    origin, then $\dist$ should assign higher probability to lattice
    vectors closer to $\vec{t}$ than farther away from $\vec{t}$. The
    motivation for using a distinct parameter $\vec{t}$ as the origin is
    to rule out trivial solutions like $\vec{0} \in \L$ in case of
    `SVP`{:.mathsf}.
2. $\dist$ should be a lattice _invariant_, that is, it should not
    depend on the choice of basis (it will, of course, depend on
    $\vec{t}$).

One such distribution is derived from the _one-dimensional_ Gaussian
_measure_ that assigns probability mass to lattice vectors according to
their length. This is defined as follows:

```Definition [Gaussian Measure] {#definition--gaussian-measure-on-a-lattice}

Let $\vec{x} \in \RR^n$ be an arbitrary point in space, and let
$s \in \RR_{>0}$ be a variance parameter. The **Gaussian measure** on
$\vec{x}$ is defined as
$$
  \mathcal{N}_s(\vec{x}) := \exp\left(-\pi\frac{\abs{\vec{x}}^2}{s^2}\right).
$$

For any discrete subset $A \subseteq \RR^n$, the Gaussian measure
on $A$ is defined as
$$
\rho_s(A) := \sum_{\vec{y} \in A} \mathcal{N}_s(\vec{y}),
$$
provided the sum converges! In particular, the Gaussian measure on the
entire lattice $\L$ against a displacement vector $\vec{t} \in \RR^n$
(also called <span class="highlight">the shift</span> or
<span class="highlight">the translation vector</span>) is defined as
$$
  \begin{equation}
  \rho_{\L,s}(\vec{t}) \highlight{:=} \rho_s(\L - \vec{t}) \highlight{=} \sum_{\vec{y} \in \L} \mathcal{N}_s(\vec{y} - \vec{t}) \highlight{=} \sum_{\vec{y} \in \L} \exp\left(-\pi\frac{\abs{\vec{y}-\vec{t}}^2}{s^2}\right).
  \label{gaussian-measure-on-lattice}
  \end{equation}
$$
```
A priori it's not obvious why the infinite sum in
\eqref{gaussian-measure-on-lattice} should converge. The next lemma
proves that $\rho_{\L,s}(\vec{t})$ indeed converges for all $\vec{t} \in
\RR^n$.

```Lemma [$0 < \rho_{\L,s}(\vec{t}) < \infty$ ]{#lemma--gaussian-measure-is-finite}
Let $\L$ be a full-rank lattice with basis $\B \in \RR^{n\times n}$ and
let $s > 0$ be a Gaussian variance parameter, then there exists
$a > 0 \in \RR$ (which depends on both $s$ and $\B$) such that
$$
\forall \vec{t}\in\RR^n:\quad 0 \highlight{<} \rho_{\L,s}(\vec{t}) \highlight{\le} C(\vec{t})\cdot \left(1 + \frac{2}{e^a - 1}\right)^n \highlight{<} \infty
$$
where
$$
C(\vec{t}) := \exp\left (\frac{\pi }{s^2}\abs{\vec{t}^*}^2\right)\;\;\text{and }\;\;\vec{t}^* = \vec{t} \mod \P(\B).
$$

```

```Proof {#proof--gaussian-measure-is-finite}
For the lower bound, notice that for all $\vec{y} \in \RR^n$,
$\exp(-\pi\frac{\abs{\vec{y}}^2}{s}) > 0$, therefore, $\rho_{\L,s}(\vec{t}) > 0$.

To prove the upper bound, we first prove that $\forall \vec{t} \in \RR^n$
and $\forall \vec{z} \in \ZZ^n$, there exists $0 < \gamma < \infty \in \RR$
such that:
$$\begin{equation}
\abs{\B\cdot \vec{z} - \vec{t}}^2 \ge \frac{\gamma^2}{2}\abs{\vec{z}}^2 - \abs{\vec{t}}^2.
\label{gaussian-measure-is-finite-bound}
\end{equation}
$$
To prove this result, we prove two well-known auxiliary results
which the reader might already be familiar with (and whose proofs
can safely be skipped).

> `Claim-1`{:.bul .highlighted-text #gaussian-measure-is-finite-claim-1}:
    $\forall \vec{x}, \vec{y} \in \RR^n:\;$
    $\abs{\vec{x} - \vec{y}}^2 \ge \frac{1}{2}\abs{\vec{x}}^2 - \abs{\vec{y}}^2$.
> <hr/>
> `Proof`{:.bul .highlighted-text}: For all $\vec{x}, \vec{y} \in \RR^n$, $\abs{\vec{x} - 2\cdot \vec{y}}^2 \ge 0$
   $\highlight{\implies}$ $-2\dotprod{\vec{x}, \vec{y}}$ $\ge$ $-\frac{1}{2}\abs{\vec{x}}^2 - 2\abs{\vec{y}}^2$ therefore
  $$
    \begin{aligned}
    \abs{\vec{x} - \vec{y}}^2 &= \abs{\vec{x}}^2 + \abs{\vec{y}}^2 - 2\dotprod{\vec{x}, \vec{y}}\\
      & \ge \abs{\vec{x}}^2 + \abs{\vec{y}}^2 + (-\frac{1}{2}\abs{\vec{x}}^2 - 2\abs{\vec{y}}^2)\\
      & \ge \frac{1}{2}\abs{\vec{x}}^2 - \abs{\vec{y}}^2.
    \end{aligned}
  $$
> {:.claim-end}
>
{:.details}

> `Claim-2`{:.bul .highlighted-text #gaussian-measure-is-finite-claim-2}: If $\B \in \RR^{n\times n}$ is non-singular, then
   $\exists\,\gamma \in \RR_{>0}$ such that
   $\forall \vec{y} \in \RR^n:\; \abs{\B\cdot \vec{y}}^2 \ge \gamma^2\abs{\vec{y}}^2$.
> <hr/>
>
> `Proof`{:.bul .highlighted-text}: Let $\G := \B^\top\B$ be the Gram
    matrix of $\B$. Then by construction, $\G$ is symmetric
    ($\G^\top = \G$) and
    [positive-definite](https://ocw.mit.edu/courses/18-06sc-linear-algebra-fall-2011/pages/positive-definite-matrices-and-applications/){: target="_blank"}
    because
>
>    * $\forall \vec{y} \in \RR^n:\;$ $\vec{y}^\top\G \vec{y}$ $\highlight{=}$ $\vec{y}^\top\B^\top\B\vec{y}$ $\highlight{=}$ $\abs{\B\vec{y}}^2$ $\highlight{\ge}$ $0$, and
>    * since $\B$ is non-singular, and therefore a bijection, $\G\cdot\vec{x} = \vec{0}$
      $\highlight{\iff}$ $\vec{x} = \vec{0}$.
>
>   Therefore, by the [principal
    axis theorem](https://en.wikipedia.org/wiki/Principal_axis_theorem#mwZw){: target="_blank"},
    all eigenvalues of $\G$ are positive real numbers and the
    eigenvectors $\braces{\vec{g}_1,\cdots, \vec{g}_n \in \RR^{n}}$
    form an orthonormal basis (after scaling) of $\RR^n$. Let
    $\vec{y} \in \RR^n$ be written in the orthonormal eigenbasis
    as
    $$
    \vec{y} = c_1\vec{g}_1+\cdots c_n\vec{g}_n;\;\;c_i \in \RR,
    $$
    then
    $$
    \abs{\vec{y}}^2 = c_1^2+\cdots + c_n^2.
    $$
>
>   Let $\gamma_1,\cdots, \gamma_n \in \RR_{>0}$ be the eigenvalues
    of $\G$ such that
    $$0 < \gamma_1 \le \cdots \le \gamma_n$$
    then
    $$
      \begin{array}{rlll}
      \abs{\B\cdot\vec{y}}^2 &=& \dotprod{\vec{y}, \G\cdot\vec{y}} & \\
                        &=& \sum_{i=1}^n c_i\cdot\dotprod{\vec{y}, \G\cdot\vec{g}_i} &\\
                        &=& \sum_{i=1}^n c_i\cdot\gamma_i \cdot \dotprod{\vec{y}, \vec{g}_i} & \text{by the definition of an eigenvector} \\
                        &=& \sum_{i=1}^n c_i^2\cdot\gamma_i \cdot \dotprod{\vec{g}_i, \vec{g}_i} & \text{by orthonormality} \\
                        &\ge& \gamma_1 \cdot \sum_{i=1}^n c_i^2  & \\
                        &\ge& \gamma_1 \cdot \abs{\vec{y}}^2.
      \end{array}
    $$
    Therefore setting $\gamma = \sqrt{\gamma_1} \in \RR_{>0}$ proves the claim:
    $$
    \exists\, \gamma \in\RR_{>0}, \text{s.t. }\forall \vec{y}\in\RR^n:\;\abs{\B\vec{y}}^2 \ge \gamma^2 \abs{\vec{y}}^2.
    $$
> {:.claim-end}
>
{:.details}

By [Claim-1](#gaussian-measure-is-finite-claim-1) and [Claim-2](#gaussian-measure-is-finite-claim-2), we can conclude that
$$
\forall\,\vec{t} \in \RR^n, \text{and } \forall\,\vec{z} \in \ZZ^n \subseteq \RR^n:\;\abs{\B\cdot\vec{z} - \vec{t}} \highlight{\ge} \frac{1}{2}\abs{\B\vec{z}} - \abs{\vec{t}} \highlight{\ge} \frac{\gamma^2}{2}\abs{\vec{z}} - \abs{\vec{t}}.
$$
Define $a := \frac{\pi}{2}\frac{\gamma^2}{s^2} \in \RR_{>0}$, and let
$\href{ {% post_url 2020-06-16-ComplexityReductions %}#algo--cvp-exhaustive-search-step-2}{\vec{t} = \vec{t}^* + \B\cdot\vec{z}^\dagger}$
where $\vec{t}^* \in \P(\B)$ and $\vec{z}^\dagger \in \ZZ^n$ then
$$
  \begin{array}{rcll}
  \rho_{\L,s}(\vec{t}) &=& \sum_{\vec{y} \in \L} \exp\left(-\pi\frac{\abs{\vec{y}-\vec{t}}^2}{s^2}\right) &\\
  &=& \sum_{\vec{w} \in \ZZ^n} \exp\left(-\pi\frac{\abs{\B\vec{w}-\vec{t}}^2}{s^2}\right) & \\
  &=& \sum_{\vec{z} \in \ZZ^n} \exp\left(-\pi\frac{\abs{\B\vec{z}-\vec{t}^*}^2}{s^2}\right) & \text{by reindexing } \vec{z} \leftarrow \vec{w} - \vec{z}^\dagger \\
  &\le& \sum_{\vec{z} \in \ZZ^n} \exp\left(-\pi\frac{1}{s^2}(\frac{\gamma^2}{2}\abs{\vec{z}}^2 - \abs{\vec{t}^*}^2)\right) & \text{by } \eqref{gaussian-measure-is-finite-bound}\\
  &\le& \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \sum_{\vec{z} \in \ZZ^n} \exp\left(-\pi\frac{\gamma^2}{2s^2}\abs{\vec{z}}^2\right) &\\
  &\le& \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \sum_{\vec{z} \in \ZZ^n} \exp\left(-a\abs{\vec{z}}^2\right) & \text{by definition of } a\\
  &\le& \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \left( \sum_{k \in \ZZ} e^{ak^2} \right)^n & \\
  &\le& \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \left(1 + 2\sum_{k=1}^\infty e^{-ak} \right)^n & a>0\;\text{and } k \ge 1 \highlight{\implies} e^{-ak} \ge e^{-ak^2}\\
  &\le& \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \left(1 + \frac{2e^{-a}}{1-e^{-a}} \right)^n
  \end{array}
$$

Therefore, $\forall \vec{t} \in \RR^n$
$$
\rho_{\L,s}(\vec{t}) \le \exp\left(\frac{\pi}{s^2}\abs{\vec{t}^*}^2\right) \cdot \left(1 + \frac{2}{e^{a}-1} \right)^n
$$
where $\vec{t}^* = \vec{t} \mod \P(\B)$.
```

`Note`{:.bul}: A much stronger upper bound, with $C(\vec{t}) = 1$, is
known and easy to prove, but requires analytical techniques, which are
not interesting for the purposes of this post.

Given that the sum over $\L$ converges, one can use the Gaussian measure
to define a probability distribution on $\L$ as follows:

```Definition [Discrete Gaussian Distribution] {#definition--discrete-gaussian-distribution}
Let $\vec{t} \in \RR^n$, then the **Discrete Gaussian Distribution**
$\dist_{\L-\vec{t},s}(\vec{X})$ over $\L$ assigns probability to each
lattice vector $\vec{x} \in \L$ according to its Gaussian measure, that
is, if $\vec{X} \in \RR^n$ is a random variable, then
$$
  \dist_{\L-\vec{t}, s}(\vec{X}) := \Pr{\vec{x} \in \L}{\vec{X} = \vec{x}-\vec{t}} = \begin{cases} \frac{\mathcal{N}_s(\vec{x}-\vec{t})}{\rho_s(\L - \vec{t})} & \text{if } \vec{X} + \vec{t} = \vec{x} \in \L \\ 0 & \text{otherwise}
  \end{cases}
$$

```

### Poisson Summation Formula

As a continuous function of $\vec{t}$, $\rho_{\L,s}(\vec{t})$ is
periodic over $\L$, since
$$
  \forall \vec{y} \in \L:\; \rho_s(\L-(\vec{y} + \vec{t})) = \rho_s(\L-\vec{t}).
$$
Because of this periodicity, the Fourier transform of
$\rho_{\L,s}(\vec{t})$ connects $\L$ and $\dual{\L}$ in interesting
ways. This connection is stated and proved in the next theorem:

```Theorem [Poisson Summation Formula and Gaussian Measure]{#theorem--primal-dual-gaussian-mass}
Let $\rho_{\L,s}(\vec{t})$ be defined as in \eqref{gaussian-measure-on-lattice}, then
$$
  \begin{equation}
  \rho_{\L,s}(\vec{t}) = \frac{s^n}{\det(\L)} \sum_{\vec{y} \in \highlight{\dual{\L}}}
    \mathcal{N}_{\highlight{1/s}}(\vec{y}) \cos\left(2\pi \dotprod{\vec{y}, \vec{t}}\right)
  \label{poisson-summation-formula}
  \end{equation}
$$
where $\det(\L)$ is the volume of any parallelepiped of $\L$.

`Corollary`{:.bul .highlighted-text .lowercap #poisson-summation-corollary}: $\rho_{s}(\L) = \frac{s^n}{\det(\L)} \rho_{1/s}(\dual{\L})$.
```

```Proof {#proof--primal-dual-gaussian-mass}
As noted before, $\rho_{\L,s}(\vec{t})$ is periodic over $\RR^n$,
therefore $\rho_{\L,s}(\vec{t})$ can be written as a Fourier series
$$
\rho_{\L,s}(\vec{t}) = \sum_{\vec{y}\in S} c_{\vec{y}}\cdot\chi_{\vec{y}}(\vec{t})
$$
where

* $c_{\vec{y}}$s are the Fourier series coefficients of $\rho_{\L,s}(\vec{t})$,
* $\chi_{\vec{y}}(\vec{t}) := e^{-2\pi i \dotprod{\vec{t},\vec{y}}}$ is
  an orthonormal Fourier basis function such that
  $$ \braket{\chi_{\vec{y}}(\vec{t}), \chi_{\vec{y}'}(\vec{t})} = \begin{cases} 1 & \text{if } \vec{y} = \vec{y}'\\ 0 & \text{otherwise}\end{cases}$$ and
* $S \subseteq \RR^n$ is an indexing set whose value we determine next:
  For $\chi_{\vec{y}}(\vec{t})$ to be periodic over $\L$, the following
  must hold:
  $$
    \begin{array}{rlcl}
    \forall\vec{x} \in \L: & \chi_{\vec{y}}(\vec{t}+\vec{x}) &=&  \chi_{\vec{y}}(\vec{t}) \\
      \highlight{\implies} \forall\vec{x} \in \L: & \chi_{\vec{y}}(\vec{x}) &=& 1 \\
      \highlight{\implies} \forall\vec{x} \in \L: & \dotprod{\vec{y}, \vec{x}} &\in& \ZZ
    \end{array}
  $$
  In other words, the indexing set $S$ must consist of the elements of
  the dual lattice $\dual{\L}$ and
  $$
  \rho_{\L,s}(\vec{t}) = \sum_{\vec{y}\in \dual{\L}} c_{\vec{y}}\cdot\chi_{\vec{y}}(\vec{t}).
  $$

To compute the Fourier series coefficients $c_\vec{y}$, it can be
[shown](https://see.stanford.edu/materials/lsoftaee261/chap8.pdf){: target="_blank"} [^BO07] using elementary Fourier analysis that
$$
  \begin{array}{rcl}
  c_{\vec{y}} &=& \frac{1}{\det(\L)} \int_{\highlight{\RR^n/\L}}
    \mathcal{N}_s(\vec{x} -\vec{t})e^{-2\pi i \dotprod{\vec{x}, \vec{y}} }\;d\vec{x} \\
    &=& \frac{1}{\det(\L)} \int_{\highlight{\RR^n/\L}}
     \exp\left(-\pi\frac{\abs{\vec{x} - \vec{t}}^2}{s^2}\right) e^{-2\pi i \dotprod{\vec{x}, \vec{y}} } \;d\vec{x}\\
    &=& \frac{s^n}{\det(\L)} \cdot \exp\left(-\pi \highlight{s^2}\cdot \abs{\vec{y}}^2\right) \cdot \cos\left(2\pi \dotprod{\vec{y}, \vec{t}}\right) \\
    &=& \frac{s^n}{\det(\L)} \mathcal{N}_{\highlight{1/s}}(\vec{y}) \cos\left(2\pi \dotprod{\vec{y}, \vec{t}}\right)
  \end{array}
$$
Putting these results together, we get
$$
  \rho_{\L,s}(\vec{t}) = \frac{s^n}{\det(\L)} \sum_{\vec{y} \in \dual{\L}}
    \mathcal{N}_{1/s}(\vec{y}) \cos\left(2\pi \dotprod{\vec{y}, \vec{t}}\right)
$$

Finally, to prove the [corollary](#poisson-summation-corollary), notice
that
$$
\rho_{\L,s}(\vec{0}) = \rho_{s}(\L) = \frac{s^n}{\det(\L)} \sum_{\vec{y} \in \dual{\L}}
    \mathcal{N}_{1/s}(\vec{y})\cdot 1 = \frac{s^n}{\det(\L)} \rho_{1/s}(\dual{\L})
$$
```

For all $\vec{t} \in \RR^n$ the value of
$\cos(2\pi \dotprod{\vec{y}, \vec{t}}) \le 1$, where the equality
$\cos(2\pi \dotprod{\vec{y}, \vec{t}}) = 1$ only holds when
$\vec{t} \in \L$. Furthermore, $\forall \vec{y} \in \dual{\L}:\;$
$\mathcal{N}_{1/s}(\vec{y}) > 0$, therefore,
$\forall \vec{t} \in \RR^n:\; \rho_{s}(\L - \vec{t}) \le \rho_{s}(\L)$.
This leads to a _periodic_ probability distribution [^NSD17] on $\RR^n$
that assigns the highest probability to the lattice vectors in $\RR^n$. This
distribution is defined as follows:

```Definition [Periodic Gaussian Probability Density on $\RR^n$]{#definition--periodic-gaussian-function}
The continuous _periodic Gaussian probability_ density function
$\mathcal{G}_{\L,s}(\vec{t})$ on $\RR^n$ is defined as
$$
  \begin{array}{rll}
  \mathcal{G}_{\L,s}          &:& \RR^{n} \longrightarrow [0,1] \subseteq \RR \\
  \mathcal{G}_{\L,s}(\vec{t}) &:=& \frac{\rho_{s}(\L - \vec{t})}{\rho_s(\L)} = \frac{\sum_{\vec{y}\in\L}\exp\left(-\pi\frac{\abs{\vec{y} -\vec{t}}^2}{s^2} \right)}{\sum_{\vec{y}\in\L}\exp\left(-\pi\frac{\abs{\vec{y}}^2}{s^2} \right)}\\
  \end{array}
$$
```

Unlike the discrete Gaussian distribution that only assigns non-zero
probabilities to element of $\L$, the periodic Gaussian density function
is primarily interesting over the parallelepiped
$\P(\L) \cong \RR^n/\L$. However, for any given lattice $\L$, the
[discrete Gaussian
distribution](#definition--discrete-gaussian-distribution) and the
periodic [Gaussian density
function](#definition--periodic-gaussian-function) are closely related
via the dual lattice. This is formally stated and proved in the next
lemma:

```Lemma [$\mathcal{G}_{\L,s}(\vec{t}) = \mathbb{E}_{\vec{x} \leftarrow \dist_{\dual{\L},1/s}}\left[\cos(2\pi\dotprod{\vec{x}, \vec{t}})\right]$]{#lemma--gaussian-density-function-and-discrete-gaussian}

Let $\L \subseteq \RR^n$ be a full-rank lattice and let $\dual{\L}$ be
its dual, then
$$
\mathcal{G}_{\L,s}(\vec{t}) = \underset{\vec{x} \xleftarrow{\dist_{\dual{\L},1/s}} \dual{\L}}{\mathbb{E}}\left[\cos(2\pi\dotprod{\vec{x}, \vec{t}})\right]
$$
where the expectation is over the discrete Gaussian
$\dist_{\dual{\L},1/s}(\vec{x})$ with the variance parameter
$\frac{1}{s}$ of the dual lattice $\dual{\L}$.
```

```Proof {#proof--gaussian-density-function-and-discrete-gaussian}
By definition,
$$
\begin{array}{rclr}
\underset{\vec{x} \xleftarrow{\dist_{\dual{\L},\highlight{1/s}}} \dual{\L}}{\mathbb{E}}\left[\cos(2\pi\dotprod{\vec{x}, \vec{t}})\right] &=& \sum_{\vec{x} \in \dual{\L}}
\href{#definition--discrete-gaussian-distribution}{\frac{\mathcal{N}_\highlight{1/s}(\vec{x})}{\rho_\highlight{1/s}(\dual{\L})}}\cos(2\pi \dotprod{\vec{x}, \vec{t}}) & \\
&=& \frac{\sum_{\vec{x} \in \dual{\L}} \mathcal{N}_\highlight{1/s}(\vec{x}) \cdot \cos(2\pi \dotprod{\vec{x}, \vec{t}})}{\rho_\highlight{1/s}(\dual{\L})} & \\
&=& \frac{\frac{\det(\L)}{s^n} \cdot \rho_{\L,s}(\vec{t})}{\frac{\det(\L)}{s^n} \cdot \rho_{\L,s}(\vec{0})} = \frac{\rho_{\L,s}(\vec{t})}{\rho_{\L,s}(\vec{0})} & \text{by } \eqref{poisson-summation-formula} \\
&=& \mathcal{G}_{\L,s}(\vec{t}) &
\end{array}
$$
```

### Aside -- Theta Function {#subsection--theta-functions}

## Transference Theorems {#section--transference-theorems}


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

[^E272y19]:
    **N. D. Elkies**, "Rational Lattices and their Theta Functions," Harvard
    Math 272y,
    [Fall 2019 lecture notes](https://people.math.harvard.edu/~elkies/M272.19/){:target="_blank"}.
