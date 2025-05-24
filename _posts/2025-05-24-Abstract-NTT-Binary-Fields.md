---
layout: post
title: Abstract NTT and its application in Binary Fields
date: 2025-05-24
---

# Introduction

If you need to evaluate a univariate polynomial $f(x) \in \mathbb{F}_q[x]$ on a large set of values $\Omega \subset \mathbb{F}_q$, then NTT is _the tool_ of choice — provided the set $\Omega$ has an appropriate algebraic structure. The set $\Omega$ is usually chosen to be a _smooth_ multiplicative subgroup of $\mathbb{F}_q^\times$, where the order of $\Omega$ is a usually a power of 2. When such a multiplicative subgroup exists, “textbook NTT” can work wonders.

However, when the underlying field $\mathbb{F}_q $ does not possess this subgroup structure (after all, the subgroup structure of $\mathbb{F}_q^\times$ is dictated by the prime factorization of $q-1$), textbook NTT doesn’t work. For example, in binary fields (i.e., fields of the form $\mathbb{F}_{2^\kappa}$), multiplicative subgroups of order $2^r$ do not exists since $2^r \not\mid 2^\kappa - 1$. In these cases, several seemingly disparate techniques have been developed that impose and exploit different algebraic structure over $\Omega$ to achieve similar time and space complexity as  textbook NTT. For example, in case of binary fields, one exploits the [additive  group][1] structure of $\mathbb{F}_\kappa$, which goes by the name “Additive FFT” or “Frobenious FFT”. In other cases (non-binary fields), e.g., EC-FFT, one exploits rational maps between Elliptic Curves (isogenies) to optimize for other parameters. 

The goal of this exposition is to abstract away the details of these different constructions and present and unified description of NTT that works with arbitrary structured sets $\Omega$. 

## Getting inspiration from multiplicative NTT



^[1]: Sian-Jheng Lin, Wei-Ho Chung, and Yunghsiang S. Han. “Novel Polynomial Basis and Its Application to Reed–Solomon Erasure Codes.” In: IEEE 55th Annual Symposium on Foundations of Computer Science. 2014, pp. 316–325.
