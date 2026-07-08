---
layout: post
title: Lattices of Cryptography &mdash; Basic Results
date: 2020-06-08
author: Yogesh Swami
published: true
server_side_mathjax: false
tags: [lattices, foundations]
mathjax_macros: |
  \[
    \newcommand{\L}{\mathcal{L}}
    \newcommand{\P}{\mathcal{P}}
    \newcommand{\hatP}{\widehat{\mathcal{P}}}
    \newcommand{\A}{\mathbf{A}}
    \newcommand{\B}{\mathbf{B}}
    \newcommand{\C}{\mathbf{C}}
    \newcommand{\G}{\mathbf{G}}
    \newcommand{\U}{\mathbf{U}}
    \newcommand{\V}{\mathbf{V}}
    \newcommand{\I}{\mathbf{I}}
    \newcommand{\almost}[1]{\stackrel{\sim}{#1}}
    \newcommand{\vol}{\operatorname{covol}}
    \renewcommand{\abs}[1]{\lVert #1 \rVert}
    \newcommand{\svp}{\textsf{SVP}}
    \newcommand{\sivp}{\textsf{SIVP}}
    \newcommand{\musvp}{\mu\textsf{SVP}}
    \newcommand{\allin}[2]{\forall\,{#1} \in \lbrace 1, \cdots, {#2} \rbrace}
    \DeclareMathOperator{\span}{span}
  \]
---

This post is a grab bag of basic definitions and elementary results
related to unstructured lattices. <!-- more --> See [^CaiECCC99] for a
more condensed version of similar topics or [^E272y19] for a more
detailed and advanced algebraic treatment.

## Basis Independent Characterization {#basis-independent-characterization}
---

A lattice $\L$ is a _discrete_ additive subgroup of $\RR^n$, that is,

1. $\L$ inherits the additive group structure of $\RR^n$,
2. $\L$ is equipped with a notion of distance, (or equivalently, a inner product
   $\braket{\cdot, \cdot} : \L\times \L \mapsto \RR$), and
3. there exits a _fixed non-zero radius_ $\epsilon$ (see
   [Fig. 1](#LatticeBasicFigure)), such that the open ball
   $$\mathbb{B}(\vec{x}, \epsilon) := \lrbraces{ y \in \RR^n \; :\; \norm{x - y} < \epsilon }$$
   centered at $\vec{x} \in \L$, contains no _other_ elements of $\L$, i.e.,
   $$
   \begin{equation}
   \exists \epsilon > 0,\; \forall \vec{x} \in \L:\quad \mathbb{B}(\vec{x}, \epsilon) \cap \L = \{ \vec{x} \}.
   \label{basis-free-defn}
   \end{equation}
   $$

```Note
Lattices can be defined more broadly as finitely generated modules over
an integral domain, embedded into a vector space over its fraction
field! But for the purposes of this post, the above limited definition
is sufficient. Full generality, however, brings with itself full
complexity, which does not always aid in understanding.
```

Since $\L$ is an additive subgroup of $\RR^n$, translations of $\L$ by an
arbitrary vector $\vec{v} \in \RR^n$ forms the usual equivalence class of cosets
defined by
$$[\vec{v}] := \vec{v} + \L = \left \lbrace
\vec{v} + \vec{x}\;:\; \vec{x} \in \L \right \rbrace \in \RR^n/\L.$$

By definition, two arbitrary vectors $\vec{x}, \vec{y} \in \RR^n$ belong
to the same coset, if and only if $\vec{x} - \vec{y} \in \L$. Any set
$\hatP \subset \RR^n$ that contains _exactly one_ representative element
$\vec{v}$ from _each_ coset $[\vec{v}] \in \RR^n/\L $ is called a
**strict fundamental domain** of $\L$, and is defined as

$$
\begin{equation} \hatP := \bigcup_{[\vec{v}]
  \;\in\;\RR^n/\L} \vec{v}. \label{eq:strict-fundamental-domain}
\end{equation}
$$

Since the choice of representative $\vec{v} \in [\vec{v}]$ is arbitrary,
$\hatP$ is not uniquely determined. However, $\RR^n/\L$ partitions
$\RR^n$ into its cosets, therefore translations of _any_ given $\hatP$
by the lattice vectors tiles the entire $\RR^n$ _without overlap_, i.e.,

$$
\begin{aligned}\bigcup_{\vec{x} \in \L} \left (\hatP + \vec{x}\right) &= \RR^n \quad \text{and }\\
\forall\, \vec{x}, \vec{y} \in \L,\;\vec{x} \neq \vec{y}:\quad \left (\hatP + \vec{x}\right) \bigcap \left(\hatP + \vec{y}\right) &= \emptyset. \end{aligned}
$$

The **covolume** (sometimes also called **volume**) is the volume of any
of its strict fundamental domains (i.e., a measure of its size). For any
translation invariant measure, like the Lebesgue measure, the covolume
is independent of the choice of representatives used to define $\hatP$.

## Basis Dependent Characterization {#basis-dependent-characterization}
---

The characterization of a lattice so far has been entirely _basis independent_.
This is ideal for exploring algebraic and topological properties of lattices,
however, it's not very useful for computational purposes. For that, the
following _basis dependent_ characterization is more suitable.

```Definition [Lattice with basis] {#lattice-definition}

A lattice $\L$ of _rank_ $m$ and _dimension_ $n$ is the set of _all
possible_ **integer linear combinations** of $m$ _linearly independent_
(over $\RR$) vectors $\vec{b}_1, \cdots, \vec{b}_m \in \RR^n$ (where $m
\leq n$), i.e.,

$$\begin{equation}
\L := \left\{ z_1\vec{b}_1 + \cdots + z_m\vec{b}_m \;:\; z_i \in \ZZ \right \} \subseteq \RR^n.
\label{with-basis-defn}
\end{equation}
$$
```

Since $\lbrace \vec{b}_i \rbrace$s are linearly independent, its
convenient to treat them as _basis vectors_ of $\L$ and represent them
as columns of a matrix $$\B := \begin{pmatrix} \vert & & \vert \\
\vec{a}_1  & \cdots & \vec{a}_m \\ \vert & & \vert\end{pmatrix} \in
\RR^{n\times m}.$$


```Notation {#basis-set-notation}
To emphasize that $\L$ is generated by $\B$, we will use the notation
$\L(\B)$. Furthermore, bold uppercase letters written as
$\C := \braces{\vec{c}_1,\cdots, \vec{c}_m}$ will be treated both as a
_set_ as well as a matrix whose columns have some pre-prescribed
ordering.
```

A few additional definitions are listed below, which should largely be familiar
to most readers:

```Definition {#basic-defn}

Dimension
:   The dimension of $\L \subseteq \RR^n$ is the dimension of the ambient vector space
    $\RR^n$, which is $n$.

Rank
:   Algebraically, a lattice is also a
    [free $\ZZ$-module](https://en.wikipedia.org/wiki/Free_module){:target="_blank"},
    and the rank of $\L$ is the rank of the corresponding $\ZZ$-module.
    Since the rank of a _free_ module is independent of the choice of
    its basis, rank of $\L$ is well defined and
    _independent of the choice of its basis_. When a basis
    $\B \in \RR^{n\times m}$ is explicitly given, the rank of $\L(\B)$
    is the number of linearly independent columns of $\B.$

Full Rank
:   A lattice whose rank is same as its dimension (that is, $m=n$) is
    called a full rank lattice.

Span
:   The span of a lattice $\L(\B)$ is the span of $\B$ as a $\RR$-vector
    space, i.e., $$ \textsf{span}_\RR(\L(\B)) := \textsf{span}_\RR(\B) = \left \lbrace \B\cdot\vec{y} : y \in \RR^m \right \rbrace$$

```

When do two bases $\B_1$ and $\B_2$ generate the same lattice? The
following theorem characterizes this precisely:

```Theorem [Basis Equivalence] {#basis-equivalence}
Let $\B_1, \B_2 \in \RR^{n\times m}$ be two matrices with column rank
$m \leq n$. Then, $\B_1$ and $\B_2$ generate the same lattice $\L$
_if and only if_ there exists an integer matrix $\U \in \ZZ^{m\times m}$
such that $$\B_2 = \B_1\cdot\U\;\text{and}\; \det(\U) = \pm 1.$$
```

```Proof {#proof-basis-equivalence}
We first show that if $\L(\B_2) = \L(\B_1)$ then
$\exists\, \U \in \ZZ^{m\times m}$ such that $\det(\U) = 1$ and
$\B_2 = \B_1\cdot \U$.

###### ($\Rightarrow$): {#basis-equivalence-if-part}
>
>
>  Since $\L(\B_2) = \L(\B_1)$, each column
>  $\lbrace b_1, \cdots, b_m \rbrace$ of $\B_2$ is also an element of $\L(\B_1)$.
>  Therefore, for every $i$-th column of $\B_2$, there exists $\vec{u}_i \in \ZZ^m$, such that
>  $b_i = \B_1\cdot \vec{u}_i$. If we define $\U$ to be the matrix whose
>  columns are $\vec{u}_i$s, then $\U \in \ZZ^{m\times m}$ satisfies the relation:
>  $$\B_2 = \B_1\cdot \U.$$
>
>  By a similar argument, there exists $\V \in \ZZ^{m\times m}$ such that
>  $$\B_1 = \B_2\cdot \V.$$
>
>  Therefore,
>  $$\begin{aligned}
  \B_2 = (\B_2\cdot \V)\cdot \U  & = \B_2\cdot (\V\cdot \U)  \\ \implies   \B_2\cdot(\I_{m} - \V\cdot \U) &= \vec{0},
  \end{aligned}
  $$
>  where $\I_m \in \ZZ^{m\times m}$ is the identity matrix, and
>  $\vec{0} \in \RR^n$ is the all zero vector.
>
>  Since columns of $\B_i$s are assumed to be linearly independent,
>  the linear transformation $\vec{z} \mapsto \B_i\cdot{\vec{z}}$ is injective,
>  i.e., $\B_i\cdot \vec{z} = 0 \highlight{\iff} \vec{z} = \vec{0}$.
>  Therefore,
>  $$\B_2\cdot(\I_{m} - \V\cdot \U) = \vec{0} \highlight{\implies} (\I_{m} - \V\cdot \U) = \vec{0} \highlight{\implies} \V\cdot \U = \I_m.$$
>
>
>  That means, $\U$ and $\V$ are inverses of each other! However, $\U$
>  and $\V$ are both integer matrices, and they can be inverses of
>  each other _if and only if_ $\det(\U) = \det(\V) = \pm 1.$
>
{: .proof-part }

Conversely, if $\U \in \ZZ^{m\times n}$ is such that $\B_2 = \B_1\cdot\U$
  and $\det(\U) = \pm 1$, then we need to show that $\L(\B_2) = \L(\B_1)$.

###### ($\Leftarrow$): {#basis-equivalence-only-if-part}

>
>
>  Given that $\U$ is an integer matrix, $\U\cdot \ZZ^m \highlight{\subseteq} \ZZ^m$.
>  Therefore,
>  $$\L(\B_2) = \B_2 \cdot \ZZ^m = (\B_1\cdot \U) \cdot \ZZ^m = \B_1 \cdot (\U \cdot \ZZ^m) \highlight{\subseteq} \B_1 \cdot \ZZ^m = \L(\B_1).$$
>
>
> Since $\det(\U) =\pm 1$, $\U$ is non-singular and $\U^{-1}$ has
>  _integer entries_ (because $\frac{1}{\det(\U)} = \pm 1$). Therefore,
>  using the relation $\B_1 = \B_2\cdot \U^{-1}$ and arguments similar as
>  before, we get
>  $$\L(\B_1) = \B_1 \cdot \ZZ^m = (\B_2\cdot \U^{-1}) \cdot \ZZ^m = \B_2 \cdot (\U^{-1} \cdot \ZZ^m) \highlight{\subseteq} \B_2 \cdot \ZZ^m = \L(\B_2).$$
>
>
>  Since
>  $\L(\B_2) \subseteq \L(\B_1)$ and $\L(\B_1) \subseteq \L(\B_2) \highlight{\implies} \L(\B_1) = \L(\B_2).$
{: .proof-part }

```

Integer matrices whose _inverse_ also happen to be an integer matrix
have a special name:

```Definition [Unimodular Matrix] {#unimodular-defn}

An integer matrix $\U \in \ZZ^{m\times m}$ is called
 **Unimodular** if $$\det(\U) = \pm 1.$$
```


Since the determinant of $\U$ is $\pm 1$, and the $(i,j)$-th [cofactor
entry](https://en.wikipedia.org/wiki/Minor_(linear_algebra)#Inverse_of_a_matrix){:target="_blank"}
of an integer matrix is always an integer, inverse of $\U$ exists and
has integer entries, that is, $\U^{-1} \in \ZZ^{m\times m}$.
Furthermore, if $\U$ and $\V$ are unimodular and have the same
dimension, then so is $\U\cdot \V$ because $\det(\U\cdot \V) =
\det(\U)\det(\V) = \pm 1.$

To summarize, unimodular matrices _form a group_ under usual matrix
multiplication. This group is called **General Linear Group** over
integers and is denoted by $\mathrm{GL}_m(\ZZ)$. Unimodular matrices
whose determinant is $+1$ forms a subgroup of $\mathrm{GL}_m(\ZZ)$
called the **Special Linear Group** over integers and is denoted by
$\mathrm{SL}_m(\ZZ)$.

```Remark {#integral-lattice-remark}
While lattices, in general, are defined over reals, for computational
problems, only lattices with _integer_ basis vectors (i.e., $\B \in
\ZZ^{n\times m} \subseteq \RR^{n\times m}$) are of cryptographic
interest. Furthermore, the _number of bits_ needed to represent $\B$ is
assumed to be a fixed polynomial in the dimension $n$. This restriction
is important for understanding the role of dimension in solving lattice
problems. In this post, such lattices are called _integral lattices_.

⚠️ The definition of integral lattices in this post is different from
the standard definition ([^E272y19], [Lecture 2](https://people.math.harvard.edu/~elkies/M272.19/sep09.pdf){:target="_blank"}). In the standard literature, integral
lattices are defined more broadly and are not restricted to integer
valued basis vectors. In fact, the only requirement for a lattice to be
integral is that
$$\forall\,\vec{x},\vec{y} \in \L:\; \braket{\vec{x},\vec{y}} \in \ZZ.$$
While the definition used in this post trivially satisfies this
definition, its not complete. This discrepancy, however, is of no
consequence for computational purposes.
```

### Fundamental Parallelepiped {#fundamental-parallelepiped-subsection}

Rank and dimension are crude invariants of a lattice. A more
fine-grained invariant is the covolume of a **fundamental
parallelepiped**, which is defined next.

```Definition [Fundamental Parallelepiped] {#defn-fundamental-parallelepiped}

Given a basis $\B := \braces{\vec{b}_1,\cdots, \vec{b}_m} \in \RR^{n\times m}$,
the **fundamental parallelepiped** $\P(\B)$ is the set of points in
$\RR^n$ that are generated by taking _fractional_ linear combination of
the basis vectors, i.e.,

$$\begin{equation}
  \P(\B) := \lrbraces{ t_1\vec{b}_1 + \cdots + t_m\vec{b}_m \;:\; 0 \le t_i < 1;\;t_i \in \RR}.
  \label{eq:fundamental-parallelepiped-defn}
  \end{equation}
$$

The **covolume** (also called **determinant** or just **volume**) of
$\L(\B)$ is the _volume_ of the fundamental parallelepiped $\P(\B)$,
which can be computed from the
[_Gram matrix_](https://en.wikipedia.org/wiki/Gram_matrix){:target="_blank"}
$\;\B^\top \B$ as:

$$
\begin{equation}
  \vol(\L) = \vol(\P(\B)) = \sqrt{\B^\top \B} > 0. \label{eq:volume-of-lattice}\end{equation}
$$
```

<figure id="LatticeBasicFigure">
<img src="/Diagrams/2020-06-08/final/LatticeBasic.svg"
    style="min-width:300px"/>
<figurecaption>Same lattice with different bases and distinctly shaped
parallelepiped.</figurecaption>
</figure>


In [Fig. 1](#LatticeBasicFigure), the region shaded in green is the
fundamental parallelepiped associated with the basis vectors $\B_1 :=
\lbrace \vec{a}_1, \vec{a}_2\rbrace$. Similarly, the region shaded in
purple is also the fundamental parallelepiped, albeit associated with
$\B_2 := \lbrace \vec{b}_1, \vec{b}_2\rbrace$. So, even though a lattice
is independent of its basis, the shape of a fundamental parallelepiped
is not.

However, in spite of this superficial difference, the fundamental
parallelepiped for any basis $\B$ has two remarkable properties:

1. $\P(\B)$ does not contain any _non-zero_ lattice point, and
2. The covolume of $\L$ is independent of the choice of the basis.

The next two lemmas make these observations precise:

```Lemma {#parallelepiped-basis-lemma}
Let $\L$ be a lattice of rank $m$ and let
$\C := \lbrace \vec{c}_1,\cdots, \vec{c}_m\;:\; \vec{c}_i \in \L \rbrace$
be $m$ linearly independent elements of $\L$. Then, $\C$ forms a basis
of $\L,$ _if and only if_ $$\P(\C) \cap \L = \braces{\vec{0}}.$$
```

```Proof
###### ($\Rightarrow$): If $\C$ is a basis of $\L \highlight{\implies} \P(\B) \cap \L = \lbrace \vec{0}\rbrace.$
>
> By definition, $\P(\C)$ is the $\RR$-span of columns of $\C$ restricted to
>  the half-open set $[0,1)$. The only integer in this half-open set
>  is $0$, therefore,
>  $$\P(\C) \cap \L = \lbrace \C\cdot \vec{0} \rbrace = \lbrace \vec{0} \rbrace.$$
>
{: .proof-part }

###### ($\Leftarrow$): If $\C \subseteq \L$ and $\P(\C) \cap \L = \lbrace \vec{0} \rbrace \highlight{\implies} \C$ is a basis of $\L.$

>
> Since the rank of $\L$ is $m$, and $\vec{c}_1, \dots, \vec{c}_m$ are
>    linearly independent, each lattice vector $\vec{x} \in \L$ can be
>    trivially written as an $\RR$-linear combination of $\vec{c}_i$s,
>    that is:
>    $$\forall\,\vec{x}\in\L,\; \exists\,r_1,\cdots,r_m \in \RR:\quad \vec{x} = r_1\vec{c}_1 + \cdots + r_m\vec{c}_m.$$
>    Given that $r_i$s are real, they can be written as sum of integral and fractional parts as:
>    $$r_i = \floor{r_i} + \fractional{r_i}$$ where $\floor{r_i} \in \ZZ$ and $\fractional{\vec{r}_i} := \vec{r}_i - \floor{\vec{r}_i} \in \highlight{[0, 1)}^n \subseteq \RR^n$.
>   Therefore,
>    $$\vec{x} = \sum_{i=1}^m (\floor{r_i} + \fractional{r_i})\cdot\vec{c}_i = \sum_{i=1}^m \floor{r_i}\cdot\vec{c}_i + \sum_{i=1}^m \fractional{r_i}\cdot\vec{c}_i$$
>    and
>    $$\vec{x} - \left ( \sum_{i=1}^m \floor{r_i}\cdot\vec{c}_i \right) = \left ( \sum_{i=1}^m \fractional{r_i}\cdot\vec{c}_i \right ) \in \P(\C).$$
>
>    By assumption, each $\vec{c}_i$ is an element of $\L$, which means
>    $\left ( \vec{x} - \sum_{i=1}^m \floor{r_i}\cdot\vec{c}_i \right) \in \L$.
>    On the other hand, the right hand side of equation above is an
>    element of $\P(\C)$. But by assumption, $\P(\C) \cap \L = \{ \vec{0} \}$, so the
>    equality can only hold if
>    $$\vec{x} - \sum_{i=1}^m \floor{r_i}\cdot\vec{c}_i = \vec{0}.$$
>
>    Therefore, each $r_i$ must be an integer and every $\vec{x}$ can be
>    written as an integer linear combination of columns of $\C$. In
>    short, $\C$ is a basis of $\L.$
>
{: .proof-part}

```

**<u>Note</u>**: For the previous lemma to hold, it's crucial that
$\vec{c}_i$s are _a priori_ known to be elements of $\L$. If $\C$ is any
arbitrary linearly independent set in $\RR^n$ that satisfies $\P(\C)
\cap \L = \lbrace \vec{0} \rbrace$, then such a $\C$ will not form a
basis of $\L$.

The most remarkable property of a fundamental parallelepiped is that its
covolume is independent of the choice of the basis.

```Lemma [Volume Invariance] {#lattice-volume-invariant}
The covolume of a lattice $\L$ is independent of the choice
of its basis. That is, if $\B_1, \B_2 \in \RR^{n\times m}$ are two
different bases of $\L$, then $$\vol(\P(\B_1)) = \vol(\P(\B_2)).$$
```

```Proof
Since $\B_1$ and $\B_2$ both generate $\L$, by the
[Basis Equivalence Theorem](#basis-equivalence), there exists
$\U \in \ZZ^{m\times m}$ with $\det(U) = 1$ such that $\B_1 = \B_2\U.$
Therefore,
$$\det(\B_1^\top\cdot \B_1) = \det(\U^\top\B_2^\top\cdot \B_2\U)= \det(\U^\top)\det(\B_2^\top\cdot \B_2)\det(\U)) = \det(\B_2^\top\cdot \B_2)$$
and $\vol(\P(\B_1)) = \vol(\P(\B_2)).$
```

Notice that by construction, the fundamental parallelepiped $\P(\B)$ is
also a strict fundamental domain $\hatP$
\eqref{eq:strict-fundamental-domain} whose the coset representatives
form a connected convex set. $\P(\B)$ is connected because the half-open
unit interval $[0,1)$ is connected. It's convex because if $\vec{x}$ and
$\vec{y}$ are elements of $\P(\B)$, then
$$\forall\,\highlight{t}\in [0,1] \subseteq \RR:\; \highlight{t}\cdot \vec{x} + (\highlight{1-t})\cdot \vec{y} \in \P(\B).$$

## Length of Lattice Vectors {#lattice-vector-length}
---
Since lattice points form a repeated pattern in $\RR^n$, each lattice
vector $\vec{x} \in \L$ can be collected into an $n$-dimensional
spherical **shell**, where each shell contains vectors of the same
length. Let $\mathcal{S}_j \subseteq \L$ denote the $j$-th shell and
$\nu_j$ be its radius. Assuming the index $j$ is chosen such that
$\nu_0 = 0$ and $\nu_{j-1} < \nu_j$ then, the following _strict ordering_
of $\nu_j$s is a lattice invariant:

$$\nu_0 \lt \cdots \lt \nu_{j-1} \lt \nu_j \lt \nu_{j+1} \lt \cdots \lt \infty.$$

For all lattices, $\mathcal{S}_0 = \lbrace \vec{0} \rbrace$ and is
called the _trivial_ or _zero shell_ and $\mathcal{S}_j$ for $j>0$ is
called _non-trivial_ or _non-zero shell_.

Given this setup, there are three natural computational questions one can ask.
(See also the [aside](#kissing-number) on bounds of $\mathcal{S}_j$.)

1. Given an index $j$, and a lattice $\L(\B)$ specified by an
   [integral basis](#integral-lattice-remark) $\B \in \ZZ^{n\times m}$, _find_
   an element of $\mathcal{S}_j$. For example, when $j=0$ it's trivial to find
   an element of $\mathcal{S}_0$, since
   $\mathcal{S}_0
     = \lbrace \vec{0}\rbrace$. But what about finding an
   element of $\mathcal{S}_1$ or $\mathcal{S}_{13}$? Does the difficulty depend
   upon the index $j$? Does it depend on the choice of $\B$?
2. Given $j$ and $\L(\B)$ as before, _compute_ the value of $\nu_j$.
   Here, the problem is **not** to explicitly find a lattice vector but
   to only compute the radius $\nu_j$. Indeed, if one can find an
     element $\vec{x} \in \mathcal{S}_j$, then one can trivially compute
     $\nu_j = \abs{\vec{x}}$. However, there might be other "short cuts"
     that directly computes $\nu_j$ without ever explicitly finding an
     element of $\mathcal{S}_j$.
3. Given a lattice vector $\vec{x} \in \L(\B)$ _find_ its position $j$ in the
   partial order, i.e., find $j$ such that $\abs{\vec{x}} =
     \nu_j.$

When the rank of $\L$ is large, solving any of these three problems is
computationally challenging. Cryptographically, however, the most relevant
problem is to find an element of $\mathcal{S}_1$ --- which is also called the
**shortest vector problem**. Surprisingly, it is not only hard to find a
non-zero shortest vector, but also hard to find even an "approximately short"
vector in $\L$.

The next few subsections make these notions precise.

```Remark
In the rest of this post, as is the case in general literature, shortest
vector will always mean shortest **non-zero** vector.
```

```Aside [Bounds on the cardinality of $\mathcal{S}_j$] {#kissing-number}

For a full-rank lattice $\L$, what are the upper and lower bounds on the
_cardinality_ of $\mathcal{S}_1$ (and more generally $\mathcal{S}_j$)?
Let $\tau_n$ denote the cardinality of $\mathcal{S}_1$ and
$\tau_n^{(j)}$ denote the cardinality of $\mathcal{S}_j$.

First notice that the cardinality of any non-zero $\mathcal{S}_j$ is
always even, so a trivial lower bound is $2$. This is because if
$\vec{x} \in \mathcal{S}_j$ then by definition $\vec{x} \neq \vec{0} \in
\mathcal{S}_0$, which means $\vec{x} \neq -\vec{x}$. However, for all
$\vec{x}$, $\abs{\vec{x}} = \abs{-\vec{x}}$, therefore if $\vec{x}$ is
an element of $\mathcal{S}_j$, then so is $-\vec{x}$, and hence the
cardinality of $\mathcal{S}_j$ is even!

Surprisingly, for [integral lattices](#integral-lattice-remark), this
lower bound is also sharp. That is, for every $J^2$ where $J \in \ZZ$,
there exists a $n$-dimensional lattice where each shell $\mathcal{S}_j$ for
$j \in \lbrace 1, \cdots, J \rbrace$ contains only $2$ lattice points!
To see why, let $M \in \ZZ$ be such that $M > J$, and consider the
integral lattice generated by the basis:

$$
\B_M := \left\lbrace \vec{e}_1, \highlight{M}\vec{e}_2, \cdots , \highlight{M}\vec{e}_n \right\rbrace \in \ZZ^{n\times n}
$$

where $\vec{e}_i$s are the [standard $n$-dimensional
basis](https://en.wikipedia.org/wiki/Standard_basis){:target="_blank"}
vectors.

**<u>Claim</u>**: For $\L(\B_M)$, the first $J$ non-zero shell radii
$\nu_j = j$ and
$\mathcal{S}_j = \left \lbrace \pm j\cdot \vec{e}_1 \right \rbrace$.

**<u>Proof</u>**: By definition, every lattice vector
$\vec{x} \in \L(\B_M)$ can be written as
$\vec{x} = z_1\cdot\vec{e}_1 + M\cdot(\sum_{i=2}^n z_i\cdot \vec{e}_i)$,
where $z_i \in \ZZ$. Consider $J$ lattice vectors $\vec{y}_j$s generated
by setting $z_1 = j$ for $ j = 1, \cdots, J$ and $z_2 =\cdots = z_n = 0$,
that is, $\vec{y}_j := j\cdot \vec{e}_1$. Then
$\abs{\vec{y}_j} = \abs{j\cdot \vec{e}_1} = j$.

For an arbitrary vector $\vec{x} \in \L(\B_M)$, it's length can be
written as
$$
\abs{\vec{x}}^2 = z_1^2 + M^2\left(\sum_{i=2}^n z_i^2\right) = z_1^2 + M^2\cdot Z\;\;\text {where } Z := \sum_{i=2}^n z_i^2 \ge 0.
$$

Suppose for each $\vec{y}_j$, there exist other lattice vectors that
have the same length as $\abs{\vec{y}_j}$. Then, there must exist
$z_1, \cdots, z_n \in \ZZ$ such that
$\abs{\vec{y}_j}^2 = j^2 = z_1^2 + M^2\cdot Z$. But $0 < j \leq J < M$,
so the only possible **integer** solutions are $Z = 0$ and $z_1 = \pm j$.
But $Z$ is the sum of positive quantities, therefore, the only
satisfiable value for $z_2,\cdots, z_n$ is $0$. Therefore,
$\nu_j = j$ and $\mathcal{S}_j = \lbrace \pm j\cdot\vec{e}_1 \rbrace$.
<span style="float:right;">&#x25A0;</span>

This lower bound, however, does not capture the asymptotic behavior of
$\tau_n^{(j)}$ as $j \rightarrow \infty$. Better lower bounds (listed
below) are known in Analytic Number Theory literature [^IK04], but
establishing them will require a deep digression into Modular Forms of
weight $n/2$, which is a topic for another post.

  {: #shell-cardinality-lower-bound }
  | Dimension ($n$) | $\lim_{j\rightarrow \infty} \tau_n^{(j)}$|
  |:----------:|:-----------:|
  | $n = 1$    | 2           |
  | $n = 2$    | 4           |
  | $n = 3$    | $\Omega\left(j^{\frac{1}{2} - \epsilon }\right)$ |
  | $n = 4$    | $\Omega\left(j^{1 - \epsilon }\right)$ |
  | $n \ge 5$  | $\Omega\left(j^{\frac{n}{2} - 1 }\right)$ |
Table: Lower bounds on the cardinality of $\mathcal{S}_j$.

What about the _upper bound_ on the cardinality of $\mathcal{S}_1$? Since
every element of $\mathcal{S}_1$ has the same length $\lambda_1 = \nu_1$, one
can pick a random lattice point, say $\vec{0}$ as origin, and draw an
$n$-dimensional $\tau_n$-gon, where corners of the $\tau_n$-gons are at
least $\lambda_1$ apart from each other and the center (See the hexagon
in [Fig. 2](KissingNumber2D)). Computing the maximum possible value of
$\tau_n$ is equivalent to maximizing the number of _solid_ spheres of
radius $\frac{\lambda_1}{2}$ that can be placed on the surface of a
central sphere of radius $\frac{\lambda_1}{2}$. The _number_ of places
where the peripheral spheres touch the central sphere, is known as the
[$n$-dimensional Kissing
Number](https://cohn.mit.edu/kissing-numbers/){:target="_blank"}.
Asymptotically (in $n$), the best known upper and lower bounds for the
value of $\tau_n$ are given below (see [^JJP18] and references there):

$$
  (1+o(1))\sqrt{\frac{3\pi n}{8}}\left (\frac{2}{\sqrt{3}}\right)^{n} \le \highlight{\tau_n} \le (1+o(1))\sqrt{\frac{\pi}{8}}n^{3/2}\cdot 2^{n/2}.
$$


<figure id="KissingNumber2D">
<img src="/Diagrams/2020-06-08/final/KissingNumbers.svg" />
<figurecaption>Kissing spheres in dimension $2$. Corners of the hexagon
represent lattice points.</figurecaption>
</figure>

**<u>Summary</u>**: For an _arbitrary_ integral lattice, the cardinality
of $\mathcal{S}_j$ can range from $2$ to an $\widetilde{O}(2^n)$, where
$\widetilde{O}(\cdot)$ hides polynomial factors. An unfortunate
consequence of the exponentially large size of $\mathcal{S}_j$ is that
even if there were to exist an oracle that could find _some_ elements of
$\mathcal{S}_j$, one cannot use that oracle to find _all_ elements of
$\mathcal{S}_j$ in polynomial time.
```

### Shortest Vector Problem {#svp-section}

The Shortest Vector Problem ($\svp$) is one of the most important
computational problem in lattice based cryptography. It corresponds to
finding an element of $\mathcal{S}_1$, given some arbitrary basis $\B$
of the lattice.

```Problem [<span class="lowercap">Exact-SVP</span>] {#shortest-vector-problem}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : A _non-zero_ $\vec{x} \in \L$ such that $\forall\,\vec{y} \in \L \highlight{\setminus \lbrace \vec{0} \rbrace}:\; \abs{x} \le \abs{y}$.

```

As usual, there's an optimization version and a decisional version of this
problem which are listed below:

```Problem [<span class="lowercap">Opt-SVP</span>] {#shortest-vector-problem-opt}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : The _length_ of the shortest non-zero vector $\nu_1$.

**<u>Note</u>**: If the distance is measured in $\ell_p$ norm, then the
output is allowed to be $\nu_1^p$ instead of $\nu_1$.
```

```Problem [<span class="lowercap">Decisional-SVP</span>] {#shortest-vector-problem-decisional}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : An a distance threshold $r \in \ZZ$.

Output
  : <span class="lowercap">Yes</span> if $\nu_1 < r$ and
    <span class="lowercap">No</span> otherwise
```

Intuitively, it seems that solving $\svp$ should be easy because one of
the basis vectors must be the shortest vector. After all, non-zero
positive or negative _integer_ multiples of each basis vector can only
increase it length, so its _linear combination_ should also just
increase the length. This intuition, however, is incorrect! In fact,
something quite the opposite it true: For _every_ given lattice $\L$,
there exists a basis that's arbitrarily long. The following theorem
makes this precise.

```Theorem [Unbounded Basis Length] {#unbounded-basis-length}
Let $\L(\B) \subseteq \RR^{n\times m}$ be a rank-$m$ lattice, where
$m \ge 2$. Let $\kappa \in \RR$ be an arbitrary positive
constant. Then, there exists a basis $\C := \lbrace \vec{c}_1, \cdots,
\vec{c}_m \rbrace$ such that

$$\L(\C) = \L(\B)\quad\text{and}\quad \forall i\in\lbrace 1,\cdots,
m\rbrace:\;\abs{\vec{c}_i} > \kappa.$$
```

**<u>Note</u>**: This result _fails_ for rank-$1$ lattices. To avoid repetition,
the rank of $\L$ is assumed to be at least two in the proof. Also, $\vec{e}_j$
denotes the $j$-th
[standard basis](https://en.wikipedia.org/wiki/Standard_basis){:target="_blank"}
in the proof. The significance of $\vec{e}_j$ stems from the fact that
it acts as _column selector_ from a matrix. For example, if $\A \in
\RR^{p\times q}$ and $\B \in \RR^{q \times r}$ are two compatible
matrices and $\C = \A\B$ then the $j$-th column of $\C := \lbrace
\vec{c}\_j \rbrace $ can be expressed as

$$\vec{c}_j := \A\B\cdot \vec{e}_j = \A \cdot (\B\cdot \vec{e}_j).$$

```Proof
Recall from the [Basis Equivalence Theorem](#basis-equivalence) that
two bases $\B, \C \in \RR^{n\times m}$ generate the same lattice $\L$ if
and only if there exists a _unimodular matrix_
$\U \in \mathrm{GL}_m(\ZZ) \subseteq \ZZ^{m\times m}$ such that
$\C = \B\cdot \U$ and $\det(\U) = \pm 1$. To prove that every $\L$ has
an arbitrarily large basis
$\C := \lbrace \vec{c}_j \rbrace$ where $\abs{\vec{c}_j} > \kappa$ for
all $j$, we will explicitly construct $\U$ such that $\C = \B\U$ and
$\abs{\vec{c}_j} > \kappa$.

We first analyze how $\B$ affects the length of vectors in $\L$. Let
$\G = \B^\top\B$ be the Gram matrix of $\B$, then

$$\forall\,\vec{x} \neq \vec{0} \in \RR^m:\;\norm{\B\cdot \vec{x}}^2 =
\vec{x}^{\top}\B^{\top}\cdot\B\vec{x} = \vec{x}^\top\G\vec{x} > 0.$$

Therefore $\G$ is _symmetric positive definite_ and all its eigenvalues
are real and positive [^S11]. Let $\lambda_{\min} > 0$ be the smallest
eigenvalue of $\G$ and let
$\sigma := \left |\sqrt{\lambda_{\min}}\right | \neq 0 \in \RR$.
By Rayleigh quotients inequality [^KW09] [^CHR97]

$$ \begin{equation}
\vec{x}^\top\G\vec{x} \highlight{\ge} \lambda_{\min}\norm{\vec{x}}^2 \implies \norm{\B\cdot \vec{x}} \highlight{\ge} \sigma\norm{\vec{x}},
\label{rayleigh-quotients-inequality}
\end{equation}
$$

therefore, to find $\C$ whose columns have norm larger than $\kappa$, it
suffices to find a unimodular matrix $\U \in \mathrm{SL}_m(\ZZ)$ such
that

$$\allin{j}{m}:\quad\norm{\U\cdot \vec{e}_j} \ge \frac{\kappa}{\sigma}$$

because then

$$\norm{\vec{c}_j} = \norm{\C\cdot \vec{e}_j} = \norm{\B\U\cdot\vec{e}_j}
 = \norm{\B\cdot (\U\vec{e}_j)} \highlight{\ge} \sigma\norm{\U\vec{e}_j} \ge \sigma\frac{\kappa}{\sigma} = \kappa$$

where the highlighted inequality follows from \eqref{rayleigh-quotients-inequality}.

To find such a $\U$, consider the following matrix:

$$
\A := \begin{pmatrix}
1 & 1 & 1 & \cdots & 1 \\
1 & 2 & 1 & \cdots & 1 \\
1 & 1 & 2 & \cdots & 1 \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
1 & 1 & 1 & \cdots & 2
\end{pmatrix} \in \ZZ^{m\times m}.
$$

Notice that $\det(\A) = 1$, because subtracting the first row of $\A$
from all the other rows of $\A$ results in $1$ in the diagonal and $0$ every
where else in the _lower triangle_. Therefore, $\A \in \mathrm{SL}_m(\ZZ)$
and for all $t \in \ZZ_{> 0}$, $\A^t \in \mathrm{SL}_m(\ZZ)$. Furthermore,
since each entry of $\A$ is positive and non-zero, each entry of $\A^t$ is
also positive and non-zero.

If $\vec{x} = \lrbraces{x_i : x_i \in \ZZ_{> 0}} \in \ZZ^m$ is a vector with
only _non-zero positive_ entries and $\alpha = \min_{j}\lbrace x_j \rbrace > 0$,
then a lower bound on the $i$-th entry $y_i$ of the vector
$\vec{y} := \A\cdot \vec{x}$ can be established as follows:

$$
\begin{equation}
y_i = \sum_{j=1}^m a_{i,j} x_j \ge \sum_{j=1}^m x_j \ge \sum_{j=1}^m \alpha = m \alpha.
\label{lowerbound-vec-mul}
\end{equation}
$$

Since columns of $\A$ are non-zero and positive, by induction on $t$,
each $(i,j)$-th entry of $\A^t$ must therefore be greater than $m^{t-1}$
($t \ge 1$). (To see this, let $\vec{x}$ denote the $j$-th column of
$\A^{t-1}$ in \eqref{lowerbound-vec-mul}. By induction
hypothesis at step $t-1\;(t > 1)$, every entry of the $j$-th column of
$\A^{t-1}$ is greater than $m^{t-2}$ and $\alpha = m^{t-2}$. Therefore,
every entry of the _vector_ $\A\cdot(\A^{t-1} \cdot \vec{e}_j)$ must be
at least $m\cdot m^{t-2} = m^{t-1}$, again by \eqref{lowerbound-vec-mul}.
But $\A\cdot(\A^{t-1} \cdot \vec{e}_j) = \A^t\cdot\vec{e}_j$, which is the
$j$-th column of $\A^t$. Therefore, every $(i,j)$-th entry of $\A^t$
must be at least $m^{t-1}$.)

To find $\U$, it suffices to find a value of $t{-}1$, say $\tau$, such
that

$$
m^\tau > \left \lceil \frac{\kappa}{\sigma} \right \rceil \implies \tau > \left \lceil \frac{\log(\frac{\kappa}{\sigma} + \frac{1}{2})}{\log(m)} \right \rceil
$$

and defining $\U = \A^{\tau+1}$ ensures that $\C := \B\U$ is a basis of
$\L(\B)$ and $\forall\,i \in \lbrace 1,\cdots, m\rbrace:\;
\abs{\vec{c}_i} > \kappa$.

```

This theorem justifies the earlier [remark](#integral-lattice-remark)
that for computational problems, the input $\B$ to the $\svp$-solver
must have its size (in bits) bounded by $\poly(n)$.

### Shortest _Independent_ Vector Problem {#sivp-section}

The shortest vector only provides "one dimensional" information about
the density or sparsity of a lattice. Computationally, it's equally
interesting to know how dense the lattice is in each dimension. For
example, consider the rank-$2$ lattice generated by the basis matrix

$$
  \B := \begin{pmatrix} 1 & 0 \\ 0 & 2^{100} \end{pmatrix}.
$$

The shortest vector in this lattice is $(1, 0)^\top$ and the next
$2\cdot 2^{100}$ short vectors (i.e., elements of
$\mathcal{S}_2,\cdots, \mathcal{S}_{2^{100} - 1}$) lie on the same line
in the direction of $(1, 0)^\top$. While $\mathcal{S}_1$ provides
crucial information about this lattice, the rest of $\mathcal{S}_j$s up
to $\mathcal{S}_{2^{100}-1}$ are practically of no use.

#### Successive Minima {#successive-minima}

To get information about the density of the lattice in other directions,
its useful to compute the length across _linearly independent_ vectors.
The _successive minima_ of a lattice is an invariant that measures the
length of shortest _linearly independent_ vectors in the lattice. It's
denoted by $\lambda_i$ (where $\lambda_1 = \nu_1$) and defined as
follows:

```Definition [Successive Minima] {#successive-minima}

Let $\L \subseteq \RR^n$ be a lattice of dimension $n$ and rank $m$. Let
$\overline{\mathbb{B}}(\vec{0}, r) := \lrbraces{ \vec{x}\;:\; \abs{x} \le r} \subseteq \RR^n$
denote a *closed* sphere of radius $r \in \RR$ centered at $\vec{0}$.

For $i \in \braces{1,\cdots, m}$, the $i$-th **successive minima** is
defined as
$$\lambda_i(\L) := \inf \lrbraces{ r \; :\; \dim\left(\span_\RR\left (\L \cap \overline{\mathbb{B}}(\vec{0}, r)\right)\right) \ge i }$$

In words: $\lambda_i$ is the _smallest_ radius of a ball that contains
at least $i$ linearly independent _lattice_ vectors.
```

In the previous example,
$\lambda_1 = \nu_1 = 1$ and $\lambda_2 = 2^{100}$.
Notice that $\lambda_2$ is distinct from the shell radius $\nu_2$. It's
not until shell $\mathcal{S}_{2^{100}}$ that one encounters two linearly
independent vectors!

There are interesting _existential_ lower and upper bounds on the length
of successive minima. I'll cover them in some future post.

#### Computational Problems

We are now ready to define the search and optimization versions of
Shortest Independent Vector Problem (SIVP):

```Problem [<span class="lowercap">Exact-SIVP</span>] {#sivp-search}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : _Linearly independent_ vectors $\vec{a}_1,\cdots, \vec{a}_n$ such
    that $\allin{i}{n}:\;\abs{\vec{a}_i} \le \lambda_i$.

Recall, $\vec{0}$ is never part of a linearly independent set and is
automatically ruled out in the output of
<span class="lowercap">Exact-SIVP</span>.
```

```Problem [<span class="lowercap">Opt-SIVP</span>] {#sivp-opt}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : Successive minima $\lambda_1, \cdots, \lambda_n$ of $\L$.

**<u>Note</u>**: If the distance is measured in $\ell_p$ norm, the
output is allowed to be $\lambda_i^p$ instead of $\lambda_i$s.
```

A potential decisional version is not mentioned here because it's primarily
interesting in the approximation algorithm setting.

### Approximately Optimal Solutions and <span class="lowercap">Gap</span> Problems {#gap-lattice-problems-section}

Both [<span class="lowercap">Exact-SVP</span>](#shortest-vector-problem)
and [<span class="lowercap">Exact-SIVP</span>](#sivp-search) are known
to be $\NP$-hard. (<span class="lowercap">Exact-SVP</span> under
randomized reductions [^A98]!) In cryptography, however, _approximate_
solutions to an otherwise computationally hard problem can be just as
effective in breaking the cryptosystem as an exact solution. It's
therefore just as important to consider _approximate solutions_ as it
is to consider exact solutions.

To understand this, consider the familiar example of factoring. There is
no known polynomial time algorithm to factor $N=p\cdot q$. But suppose
there were a polynomial time _heuristic algorithm_ which on input $N$
were to output an integer $r$, which was _approximately_ equal to $p+q$.
That is, the output $r$ came with the guarantee that

$$ r < p + q < \highlight{\alpha} \cdot r;\quad \alpha > 1$$

for a _large fraction_ of integers. Essentially, $\alpha$ measures
how well the heuristic algorithm can approximate $p + q$ when it works.
Can such an algorithm be useful for breaking RSA cryptosystem?

The answer to this, of course, depends upon $\alpha$. If the value of
$\alpha$ is a polynomial in the _bit-length_ of $N$, i.e., $\alpha \in
\poly(\log_2 N)$, then one can _enumerate_ all integers $i$ in the range
$r$ and $\alpha\cdot r$ in _polynomial time_ and check if $\Delta := i^2
- 4N$ is a perfect square. If $\Delta$ turns out to be perfect square,
then $N$ can be trivially factored. Such a heuristic algorithm will be
devastating to RSA like cryptosystems if the heuristics works on a large
fraction of $\log_2(N)$-bit integers!

On the other hand, if $\alpha \not\in \poly(\log_2 N)$ then one cannot possibly
enumerate all values of $i \in \braces{r, \cdots, \highlight{\alpha}r}$ in
polynomial time and _this specific line_ of attack will not be fruitful.
However, RSA people should still sleep with their one eye open, because nothing
rules out the existence of another heuristic algorithm which on input $N$,
approximates the value of some function $f(p,q)$, where the knowledge of
$f(p,q)$ could speed up factoring.

In short, for cryptographic purposes, it's not enough that finding an
exact solution is infeasible, but it's equally important that the
problem be _hard to approximate_ in _polynomial time_! But what does an
approximate solution to $\svp$ and $\sivp$ actually mean? It's defined
(somewhat informally) below:

```Definition [$\gamma$-approximate solutions]

Let $\vec{a} \in \L \subseteq \RR^n$ be a _shortest_ non-zero vector in
$\L$. A $\highlight{\gamma}$-approximate solutions to $\svp$ consist of
those _lattice vectors_ $\vec{x} \in \L$ which are _at most_ $\gamma$
times longer than the optimal $\lambda_1 = \abs{\vec{a}}$, that is

$$
\svp_\gamma := \lrbraces{ \vec{x}\;:\; \vec{x} \in \L\setminus
\braces{\vec{0}}\;\text{and}\; \abs{\vec{x}} \le
\highlight{\gamma(n)}\cdot \lambda_1 }
$$

where $\gamma(n) \ge 1 \in \RR$ is called the _approximation factor_ of
the algorithm. Similarly, a set of linearly independent lattice vectors
$\braces{\vec{x}_1, \cdots, \vec{x}_n} \subseteq \L$ is a
$\gamma$-approximate solution to $\sivp$ if

$$\allin{i}{n}:\; \abs{\vec{x}_i} \le \highlight{\gamma(n)}\cdot
\lambda_{n},$$

where $\lambda_n$ is the [$n$-th successive minima](#successive-minima).
```

$\gamma$ measures how well an approximation algorithm performs compared to the
optimal. Its value is a property of the algorithm itself and is independent of
any lattice instance $\L(\B)$. We will use $\gamma(n)$ to emphasize how well the
approximation algorithm performs as a function of the lattice dimension.

```Remark [Complexity of $\svp_\gamma$]

Depending upon the approximation factor $\gamma(n)$, the difficulty of
solving $\svp_\gamma$ spans across a wide range of complexity classes
--- from $\NP$-hard when $\gamma \in O(1)$, to $\NP \cap \coNP$ when
$\gamma \in \poly(n)$, to  $\ccp$ when $\gamma \in O(2^n)$ (due to
[LLL](https://en.wikipedia.org/wiki/Lenstra%E2%80%93Lenstra%E2%80%93Lov%C3%A1sz_lattice_basis_reduction_algorithm){:target="_blank"}).
All these results will be proved in a series of future post.

```

The next two sections formally state the search, and decisional versions of
these approximation problems.

#### $\gamma$-approximate Shortest Vector Problems

As before, let $\gamma(n) \ge 1$ be an approximation factor and let
$\lambda_1 = \nu_1$ be the length of the shortest non-zero vector. The _search
version_ of the approximation problem is called <span
class="lowercap">SVP$_\gamma$</span> and is defined as follows:

```Problem [<span class="lowercap">Approx-SVP$_\gamma$</span>] {#approx-svp-problem}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : A _non-zero_ $\vec{x} \in \L$ such that $\forall\,\vec{y} \in \L \setminus \lbrace \vec{0} \rbrace:\; \frac{1}{\highlight{\gamma(n)}}\abs{x} \le \abs{y}$, or equivalently, $\vec{x} \in \L \setminus \vec{0} $ such that $\abs{x} \le \highlight{\gamma(n)}\cdot \lambda_1$.
```

The decisional version of <span
class="lowercap">Approx-SVP$_\gamma$</span> is called <span
class="lowercap">GapSVP$_\gamma$</span>. <span
class="lowercap">GapSVP$_\gamma$</span> asks for an algorithm to
_distinguish_ between two types of _lattices_:

- lattices whose shortest vectors are _shorter_ than a threshold $r$, and
- lattices whose shortest vectors are _longer_ than $\highlight{\gamma(n)}\cdot r$

In those cases, where the shortest vector $\lambda_1$ happens to fall
between $r$ and $\gamma \cdot r$, the algorithm is allowed to output
anything --- including different outputs even for the same input, or not
terminate at all! More formally, <span
class="lowercap">GapSVP$_\gamma$</span> if defined as follows:

```Problem [<span class="lowercap">GapSVP$_\gamma$</span>] {#shortest-vector-problem-decisional}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : An threshold value $r \in \ZZ$.

Output
  : <span class="lowercap">Yes</span> if $\lambda_1 \le r$,
  : <span class="lowercap">No</span> if $\lambda_1 > \gamma(n)\cdot r$,
  : Undefined, otherwise.
```

#### $\gamma$-approximate Shortest Independent Vector Problems

The approximate and gap versions of $\sivp$ are defined analogously to $\svp$.
Recall that $\lambda_i$ denotes the
[$i$-th successive minima](#successive-minima) of linearly independent vectors
in $\L$.

```Problem [<span class="lowercap">Approx-SIVP$_\gamma$</span>] {#approx-svp-problem}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.

Output
  : $n$ _linearly independent_ vectors $\braces{\vec{x}_1, \cdots, \vec{x}_1} \subseteq \L$ such that
  $
  \allin{i}{n}:\; \abs{\vec{x}_i} \le \highlight{\gamma(n)}\cdot \lambda_n
  $.

```

The <span class="lowercap">GapSIVP$_\gamma$</span> problem asks to distinguish
between the following two cases:

- lattices whose $n$-th successive minima is smaller than a threshold $r$, and
- lattices whose $n$-th successive minima is longer than
  $\highlight{\gamma(n)}\cdot r$.

More formally,

```Problem [<span class="lowercap">GapSIVP$_\gamma$</span>] {#shortest-vector-problem-decisional}
Input
  : A _non-singular_ basis matrix $\B \in \ZZ^{n\times n}$ representing
    a full-rank [integral lattice](#integral-lattice-remark) $\L$.
  : An threshold value $r \in \ZZ$.

Output
  : <span class="lowercap">Yes</span> if $\lambda_n \le r$,
  : <span class="lowercap">No</span> if $\lambda_n > \highlight{\gamma(n)}\cdot r$,
  : Undefined, otherwise.
```

## Equivalence of definitions {#equivalent-definitions}
---

Finally, the following theorem states and proves that the
[basis-independent](#basis-independent-characterization) and
[basis-dependent](#basis-dependent-characterization) definitions of a lattice
are equivalent:

```Theorem [$\ZZ$-span of $\lbrace b_1, \cdots, b_m \rbrace \highlight{\iff}$ Discrete Subgroup of $\RR^n$ ] {#thm-discrete-subgroup-defn-equivalence}

A subset $\L \subseteq \RR^n$ is a _discrete_ subgroup of $\RR^n$ if
and only if there exist $m$ linearly independent vectors
$\B := \lbrace \vec{b}_1, \cdots, \vec{b}_m \rbrace$
(where $0 < m \leq n$) such that $\L$ is the set of _all_ integer
linear combinations of $\vec{b}_i$s.
```

Recall from \eqref{basis-free-defn} that a set $\L \subseteq \RR^n$ is
_discrete_ if there exists a ball $\mathbb{B}(\vec{x},\epsilon) \in \RR^n$
of radius $\epsilon > 0$, such that
$\forall \vec{x} \in \L:\;
\mathbb{B}(\vec{x},\epsilon) \cap \L = \lbrace \vec{x} \rbrace.$


```Proof {#proof-discrete-subgroup-defn-equivalence}

We first prove that given any arbitrary matrix $\B \in \RR^{n\times m}$ of column-rank $m$, it's $\ZZ$-span is a subgroup of $\RR^n$ that happens to be discrete.

###### ($\Leftarrow$): $\ZZ$-span of $\B$ $\highlight{\implies}$ Discrete Subgroup: {#basis-implies-discrete-subgroup}

>
> The $\ZZ$-span of $\B$ is clearly a subgroup of $\RR^n$ because for
> any $\vec{z}_1, \vec{z}_2 \in \ZZ^m$, $$\B\cdot \vec{z}_1 - \B\cdot
> \vec{z}_2 = \B\cdot (\vec{z}_1  - \vec{z}_2) \in \B\cdot \ZZ^m.$$
>
>
> To show discreteness, given $\B$, we will compute a radius $\epsilon$
> such that for any $\vec{x} \in \B\cdot\ZZ^m$, the ball
> $\mathbb{B}(\vec{x}, \epsilon)$ contains no other element of
> $\B\cdot\ZZ^m$ apart from $\vec{x}$.
>
>
> Let $\vec{x} = \B\cdot\vec{u}$ and $\vec{y} = \B\cdot\vec{v}$ be two
> _distinct_ lattice points in $\RR^n$ for some $\vec{u}, \vec{v} \in \ZZ^m$, and let $\vec{z} := \vec{u} - \vec{v}$. Since $\vec{x}$ and $\vec{y}$ are distinct, $\vec{z} \neq \vec{0}$. The distance between $\vec{x}$ and $\vec{y}$ is $\norm{\vec{x} - \vec{y}} = \norm{\B\cdot(\vec{u} - \vec{v})} = \norm{\B\cdot\vec{z}} > 0$. We will prove that this distance has a lower bound.
>
>
>  Consider the action of the linear transformation $\tau : \vec{a}
>   \mapsto \B\cdot \vec{a}$ restricted to the unit sphere
>    $S^{m-1} := \lbrace \vec{a} \in \RR^m : \norm{\vec{a}} = 1\rbrace$.
>    Let $T :=
>    \B\cdot S^{m-1} \subseteq \RR^n$ and let $\epsilon'$ be the length
>    of the smallest vector in $T$, that is $$ \epsilon' =
>    \min_{\norm{\vec{a} } = 1} \norm{ \B\cdot\vec{a} }. $$
>
>   This minimum is well defined because the unit sphere $S^{m-1}$ is
>   compact, and the map $\vec{a} \mapsto \norm{ \B\cdot \vec{a}}$ is
>   continuous. (NOTE: $\vec{a}$ is an element of $\RR^m$ not $\ZZ^m$.)
>   Furthermore, since columns of $\B$ are linearly independent, $\tau$
>   is injective and maps non-zero elements of $\RR^m$ to non-zero
>   elements of $\RR^n$. Since $\vec{0} \not\in S^{m-1}$, $\vec{0} \not
>   \in T$ and therefore $\epsilon' > 0.$
>
>
>   Back to lattices. In order to prove that for distinct lattice points
>   $\vec{x}$ and $\vec{y}$, $\norm{\vec{x} - \vec{y}} = \norm{\B\cdot
>   \vec{z}} > 0$, notice that $\vec{z} \in \ZZ^m$ is non-zero.
>   Therefore, $\vec{z}$ can be written as a scaling of a unit vector
>   $\vec{u} \in S^{m-1}$ as $$ \vec{z} = \norm{\vec{z}}\vec{u}$$ where
>   $$ \vec{u} = \frac{\vec{z}}{\norm{\vec{z}}} \in \RR^m.$$ Therefore,
>    $$ \norm{\B\cdot\vec{z}} = \norm{\B\cdot(\norm{\vec{z}}\vec{u})} =
>   \norm{\vec{z}}\cdot\norm{ \B\cdot\vec{u}} \ge \norm{\vec{z}}\cdot
>   \epsilon' \ge \epsilon' > 0 $$ where we have used the two
>    inequalities:
>
>   * $\forall \vec{a} \in S^{m-1}: \; \norm{B\cdot \vec{a}} \ge \epsilon'$, and
>   * the minimum norm of a non-zero _integer_ vector $\vec{z} \in \ZZ^m$ is $1$.
>
>   Therefore, a ball of radius $\epsilon = \frac{\epsilon'}{2}$
>   around $\vec{x} \in \B\cdot\ZZ^m$ cannot contain any other lattice
>   point since its smaller than the shorted distance between any two
>   distinct lattice point.
>
{: .proof-part}

Next we prove the converse.

###### ($\Rightarrow$): If $\L$ is Discrete Subgroup of $\RR^n$ $\highlight{\implies}$ A basis $\B$ of $\L$ exists {#discrete-subgroup-implies-basis}

>
> Let $\L \subseteq \RR^n$ be a _discrete subgroup_ of $\RR^n$ and let
> $V := \mathsf{span}_{\RR}(\L)$ be the subspace of $\RR^n$ spanned by
> $\L$. Let $\dim V := m \le n$. We need to show that there exists a set
> of linearly independent vectors $\vec{b}_1,\cdots,\vec{b}_m \in \RR^n$
> such that $$ \L = \vec{b}_1\ZZ + \cdots + \vec{b}_m\ZZ.$$
>
> Choose $m$ arbitrary linearly independent vectors $\C :=
> \braces{\vec{c}_1, \cdots, \vec{c}_m\;:\;\vec{c}_i  \in \L } $ and
> consider the following set
>
> $$L' := \vec{c}_1\ZZ + \cdots + \vec{c}_m\ZZ.$$
>
> Since $L'$ is the set of all integer linear combinations of
> $\vec{c}_i$s, $L'$ is a lattice. Futhermore, $\vec{c}_i$s were chosen
> from $\L$, therefore $L'$ is a subset of $\L$ and therefore a subgroup
> of $\L$ because $\ZZ$ is closed under addition.
>
> Using a standard result in topology [^M98], it can be shown that if
> $H$ is some discrete subgroup of $\RR^n$ and $S \subseteq \RR^n$ is
> some compact set, then $H \cap S$ is finite. (This result only holds
> if $H$ is a discrete subgroup and not just a discrete subset.) Consider
> the fundamental parallelepiped $\P(\C)$ of $L'$. This set is bounded
> (every element of $\P(\C)$ falls within an $n$-dimensional sphere of
> radius $r_{\C} := \sum_{i=0}^m \abs{\vec{c}_i}$, centered at
> $\vec{0}$) and it's closure $\overline{\P(\C)}$ is compact. Therefore
> $\L \cap \overline{\P(\C)}$ is finite, and hence $\L \cap \P(\C)$ is
> finite.
>
> Let $\vec{x} \in \L$ be an arbitrary element, then there exist real
> numbers $r_1,\cdots,r_m \in \RR$ such that
> $ \vec{x} = \sum_i r_i\cdot\vec{c}_i $. Let
> $\vec{r}_i = \floor{r_i} + \fractional{r_i}$, then
> $$
    \begin{aligned}
    \vec{x} &= \sum_i \floor{r_i}\cdot\vec{c}_i + \sum_i \fractional{r_i}\cdot\vec{c}_i \\
    \implies  \vec{x} -  \sum_i \floor{r_i}\cdot\vec{c}_i &= \sum_i \fractional{r_i}\cdot\vec{c}_i.
    \end{aligned}
  $$
> Since $\sum_i \floor{r_i}\cdot\vec{c}_i$ is an element of $L'$, which
> is a subgroup of $\L$ implies
> $\vec{x} - \sum_i \floor{r_i}\cdot\vec{c}_i$ is also and element of $\L$.
> However, by definition $\sum_i \fractional{r_i}\cdot\vec{c}_i$ is
> an element of the fundamental parallelepiped $\P(\C)$. Therefore
> $\vec{x} - \sum_i \floor{r_i}\cdot\vec{c}_i$ is an element of both $\L$
> and $\P(\C)$, that is an element of $\L \cap \P(\C)$. Therefore,
> $$
    \L = \bigcup_{p \in \L \cap \P(\C)}  L' + p
  $$
> and $L'$ has a finite index in $\L$. Since $\L$ is torsion free, by
> the structure theorem of [finitely generated abelian group](https://en.wikipedia.org/wiki/Finitely_generated_abelian_group){:target="_blank"},
> $\L$ is a free finitely generated group, and there must exist elements
> $\vec{b}_1,\cdots, \vec{b}_s \in \RR^n$ such that
> $$
    \L = \ZZ\vec{b}_1 + \cdots + \ZZ\vec{b}_s.
  $$
> But $L'$ has rank $m$, therefore $s \ge m$. On the other hand, the dimension
> of $\span_\RR(\L)$ is $m$, therefore $s \le m \implies s = m$. Therefore
> $\L$ is a lattice of rank $m$.
{: .proof-part }

```

```Remark
For the basis-free definition to be equivalent to the
basis-dependent definition, it's crucial that $\lbrace
b_i\rbrace$s are linearly independent over $\RR$ and not
just $\ZZ$. That is, not every [_free_
$\ZZ$-module](https://en.wikipedia.org/wiki/Free_module){:target="_blank"}
of $\RR$ is a lattice --- the geometry is important.

To see why, consider the set $\lbrace 1, \sqrt{2}\rbrace$. This set is
linearly independent over $\ZZ$ because $$\forall \alpha, \beta \in
\ZZ:\quad \alpha + \beta\cdot\sqrt{2} = 0 \iff \alpha = \beta = 0.$$

On the other hand, _for all_ $\epsilon > 0$, there exists
$\gamma, \delta \in \ZZ$ such that $$ 0 < |(\gamma +
\delta\cdot\sqrt{2}) - (\alpha + \beta\cdot\sqrt{2})| <
\epsilon.$$ (One can prove this claim using [Dirichlet’s
approximation
theorem](https://en.wikipedia.org/wiki/Dirichlet%27s_approximation_theorem){:target="_blank"}.)
 Therefore, even though $\lbrace 1, \sqrt{2}\rbrace$ is
 linearly independent over $\ZZ$, it does not generate a
 lattice in $\RR$.
```

[^CaiECCC99]:
    **J. Y. Cai**, "Some Recent Progress on the Complexity of Lattice Problems,"
    in Electronic Colloquium on Computational Complexity,
    [Report No. 6](https://eccc.weizmann.ac.il/report/1999/006/){:target="_blank"}
    (1999).

[^IK04]:
    **H. Iwaniec** and **E. Kowalski**, "Analytic Number Theory," Colloquium
    Publications of American Mathematical Society, 2004.

[^CZ13]:
    **H. Cohn** and **Y. Zhao**, "Sphere Packing Bounds via Spherical Codes,"
    [Arxiv 1212.5966](https://arxiv.org/pdf/1212.5966){:target="_blank"}, 2013.
    See also, Institute for Advanced Study
    [video lecture](https://www.ias.edu/video/1213/analysis/0122-HenryCohn){:target="_blank"}.

[^JJP18]:
    **M. Jenssen**, **F. Joos**, and **W. Perkins**, "On kissing numbers and
    spherical codes in high dimensions," in Advances in Mathematics, 335,
    (2018),
    [307-321](https://www.sciencedirect.com/science/article/pii/S0001870818302494){:target="_blank"}.

[^E272y19]:
    **N. D. Elkies**, "Rational Lattices and their Theta Functions," Harvard
    Math 272y: Rational Lattices and their Theta Functions,
    [Fall 2019 lecture notes](https://people.math.harvard.edu/~elkies/M272.19/){:target="_blank"}.

[^S11]:
    **G. Strang**, "Positive Definite Matrices and Minima," in MIT OCW Lecture
    Notes on Linear Algebra,
    [Lecture 21](https://ocw.mit.edu/courses/18-06sc-linear-algebra-fall-2011/pages/positive-definite-matrices-and-applications/positive-definite-matrices-and-minima/){:target="_blank"},
    [Fall 2011](https://ocw.mit.edu/courses/18-06sc-linear-algebra-fall-2011/){:target="_blank"}.

[^CHR97]:
    **D. Coppersmith**, **J. Hoffman**, and **U. G. Rothblum**, "Inequalities of
    Rayleigh Quotients and Bounds on the Spectral Radius of Nonnegative
    Symmetric Matrices," in Linear Algebra and its Applications,
    [263:201-220](https://www.sciencedirect.com/science/article/pii/S0024379596005344){:target="_blank"}
    (1997), Elsevier Science Inc.

[^KW09]:
    **J. Kelner** and **A. Wibisono**, "Courant-Fischer and Rayleigh Quotients,"
    in MIT OCW Lecture Notes on Algorithmist's Toolkit,
    [Lecture 03](https://ocw.mit.edu/courses/18-409-topics-in-theoretical-computer-science-an-algorithmists-toolkit-fall-2009/535add3f6457cc13e51d9774f16bf48f_MIT18_409F09_scribe3.pdf){:target="_blank"},
    [Fall 2009](https://ocw.mit.edu/courses/18-409-topics-in-theoretical-computer-science-an-algorithmists-toolkit-fall-2009/){:target="_blank"}.

[^V03]:
    **V. V. Vazirani**, "Approximation Algorithms," Springer 2003. Author's
    [online](https://ics.uci.edu/~vazirani/book.pdf){:target="_blank"} copy.

[^A98]:
    **M. Ajtai**, "The Shortest Vector Problem in $\ell_2$ is $\NP$-hard for
    randomized reductions,"
    ([extended abstract](https://dl.acm.org/doi/10.1145/276698.276705){:target="_blank"}).
    In STOC, pages 10–19. 1998.

[^M98]: **J. Munkres**, "Topology a first course," [Web
    Access](https://math.mit.edu/~hrm/palestine/munkres-topology.pdf){:target="_blank"}.
