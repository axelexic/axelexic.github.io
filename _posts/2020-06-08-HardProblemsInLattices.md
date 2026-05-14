---
layout: post
title: Hard Lattice problems and the labyrinth of their reductions
date: 2020-06-08
tags: [Lattice, Lattice Based Cryptography, Post-quantum Cryptography]
last_modified: 2026-3-11
---

A lattice $\mathcal{L}$ is a _discrete_ additive subgroup of
$\mathbb{R}^n$. Discrete here means that in addition to the algebraic
structure of $\mathbb{R}^n$, $\mathcal{L}$ also has a discrete geometric
structure. That is, for every point $\vec{x} \in \mathcal{L}$ in the
lattice, there exists a ball $ S_\epsilon(\vec{x}) \subseteq \mathbb{R}^n $ of some fixed radius $\epsilon \in \mathbb{R}_{>0} $ such that no other lattice point of $\mathcal{L}$ falls within
$S_\epsilon(\vec{x})$.
