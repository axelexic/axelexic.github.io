---
layout: post
title: Lattices of Cryptography -- Basic Results
date: 2020-06-08
tags: [Lattice, Lattice Based Cryptography, Post-quantum Cryptography]
---

A lattice $\mathcal{L}$ is a _discrete_ additive subgroup of $\mathbb{R}^n$. That means

* $\mathcal{L}$ inherits the additive group structure of $\mathbb{R}^n$,
* $\mathcal{L}$ is equipped with a notion of distance (typically $\ell_2$ norm), and
* for every point $\vec{x}$ in the lattice, there exists a ball

  $$S_\epsilon(\vec{x}) := \left \lbrace y \in \mathbb{R}^n \; \Big|\; ||x -
   y|| < \epsilon \right \rbrace \subseteq \mathbb{R}^n$$

  of _fixed radius_ $\epsilon$ such that no other point of $\mathcal{L}$ falls
   within that ball, i.e.,

   $$\exists \epsilon\; \forall \vec{x}:\; S_\epsilon(\vec{x}) \cap \mathcal{L} = \{ \vec{x} \}.$$

Alternatively, a lattice of _rank_ $m$ and _dimension_ $n$ is defined as
the _integer linear combination_ of $m$ linearly independent basis
vectors $ \vec{b}_1, \cdots, \vec{b}_m \in \mathbb{R}^n$
of dimension $n$ represented as columns of the matrix $\mathbf{B}$, i.e.,

$$\mathcal{L}(\mathbf{B}) := \left\{ \sum_{i=1}^{m} z_i\vec{b}_i \;{\Bigg|}\; \forall\;z_i \in \mathbb{Z}  \right \}.$$

A lattice where rank is same as its dimension is called lattice of full
rank. For the rest of the document, all lattices are assumed to be of
full rank.

While lattices in general are defined over reals, for algorithmic
problems we will limit the discussion to _integral_ lattices, i.e.,
$\mathbf{B} \in \mathbb{Z}_{\leq \textsf{poly(n)}}^{n\times m} \subseteq
\mathbb{R}^{n\times m}$. Furthermore, the size of each integer needed
to represent the basis vector $\vec{b}_i$ is assumed to be a fixed
polynomial in the dimension $n$. These seemingly artificial restrictions
are necessary for understanding how the rank/dimension of the lattice
asymptotically affects computational resources required to solve the
problem.




