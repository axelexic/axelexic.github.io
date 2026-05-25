---
layout: post
title: Lattices of Cryptography &mdash; Basic Results
date: 2020-06-08
tags: [Lattice, Lattice Based Cryptography, Post-quantum Cryptography]
---

## Introduction

A lattice $\mathcal{L}$ is a _discrete_ additive subgroup of
$\mathbb{R}^n$. This means

1. $\mathcal{L}$ inherits the additive group structure of $\mathbb{R}^n$,
2. $\mathcal{L}$ is equipped with a notion of distance (typically
  $\ell_2$ norm), and
3. there exits a _fixed non-zero radius_ $\epsilon$, such that around
   every point $\vec{x}$ in the lattice, there exists a ball

   $$S_\epsilon(\vec{x}) := \left \lbrace y \in \mathbb{R}^n \; \Big|\; ||x -
   y|| < \epsilon \right \rbrace$$

   inside which no other lattice point can be found, i.e.,

   $$\exists \epsilon > 0,\; \forall \vec{x} \in \mathcal{L}:\quad S_\epsilon(\vec{x}) \cap \mathcal{L} = \{ \vec{x} \}.$$

The above definition is _basis independent_ and ideal for exploring
topological properties of lattices. However, it's not very useful for
computational purposes. For that, we will use the following equivalent
definition:

```Definition {#lattice-definition}

A lattice $\mathcal{L}$ of _rank_ $m$ and _dimension_ $n$ is defined to
be the set of _all possible integer linear combination_ of $m$ linearly independent basis
vectors $\vec{b}_1, \cdots, \vec{b}_m \in \mathbb{R}^n$ represented as columns of the matrix $\mathbf{B} \in \mathbb{R}^{n\times m}$, i.e.,

$$\mathcal{L}(\mathbf{B}) := \left\{ \sum_{i=1}^{m} z_i\vec{b}_i \;{\Bigg|}\; \forall\;z_i \in \mathbb{Z}  \right \}.$$

A lattice whose rank is same as its dimension (i.e., $m = n$) is called a lattice of full-rank.

```

A lattice can be thought of as an embedding of a discrete set in the
vector space $\mathbb{R}^n$. The dimension $n$ of the lattice is the
dimension of _ambient_ vector space $\mathbb{R}^n$. The rank of
$\mathcal{L}$ is the rank of $\mathcal{L}$ as a _free_
$\mathbb{Z}$-module. For the rest of the document, all lattices are
assumed to be of full rank.

We first state and prove that the two definitions above are equivalent.

```Theorem [Classification of Discrete Subgroups of $\mathbb{R}^n$] {#thm-discrete-subgroup-defn-equivalence}

A subset $\mathcal{L} \subseteq \mathbb{R}^n$ is
a _discrete subgroup_ of $\mathbb{R}^n$ if and only if
there exist $m$ linearly independent vectors
$\vec{b}_1, \cdots, \vec{b}_m \in \mathbb{R}^n$ (where $0 < m \leq n$)
such that $\mathcal{L}$ is the set of _all_ integer linear combinations of $\vec{b}_i$s.
```



```Proof  {#proof-discrete-subgroup-defn-equivalence}

We first prove that integer linear combination of linearly independent
vectors $\vec{b}_1, \cdots, \vec{b}_m \in \mathbb{R}^n$ gives rise to
a discrete subgroup of $\mathbb{R}^n$.

######$\mathbb{Z}$-span $\Rightarrow$ Discrete Subgroup:

1.  First note that the integer linear combination of $\vec{b}_i$ is clearly a subgroup of $\mathbb{R}^n$.
2.  We need to show that for every point $\vec{x} = \sum_{i=1}^m z_i\vec{b}_i$ there exists a ball of radius $\epsilon$ such that no other lattice point exists.


Next we prove that given a discrete subgroup $\mathcal{L}$ of $\mathbb{R}^n$, there exists a set of linearly independent basis vectors $\mathbf{B} := \lbrace \vec{b}_1, \cdots, \vec{b}_m  \rbrace \in \mathbb{R}^{n\times m}$ (for some $m < n$) such that $\mathcal{L} = \lbrace \mathbf{B}\cdot \vec{z} \; \Big|\; \forall \vec{z} \in \mathbb{Z}^m  \rbrace$

###### Discrete Subgroup $\Rightarrow$ $\mathbb{Z}$-span

```

```Remark
While lattices in general are defined over reals, for computational
problems only _integral_ lattices are of cryptographic interest, i.e.,
lattices where $\mathbf{B} \in \mathbb{Z}^{n\times m} \subseteq \mathbb{R}^{n\times m}$.
Furthermore, the _number of bits_ needed to represent the basis
vector $\vec{b}_i$ is assumed to be a fixed polynomial
in the dimension $n$. These seemingly artificial restrictions are
necessary for understanding how rank of a lattice
affects computational resources required to solve the problem.
```


