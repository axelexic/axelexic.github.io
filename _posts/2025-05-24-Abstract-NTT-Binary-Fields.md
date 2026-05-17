---
layout: post
title: Abstract NTT and its application to Binary Fields
date: 2025-05-24
---

## Introduction
---

If you need to evaluate a univariate polynomial $f(x) \in \mathbb{F}_q[x]$
on a large set of values $\Omega \subseteq \mathbb{F}_q$,
then Number Theoretic Transform (NTT)[^N82] is _the tool_ of
choice --- provided the set $\Omega$ has an appropriate algebraic
structure. The set $\Omega$ is usually chosen to be a _smooth_
multiplicative subgroup of $\mathbb{F}_q^\times$, where the order of
$\Omega$ is a usually a power of $2$. When such a multiplicative
subgroup exists, "textbook NTT" can work wonders[^LN16].

However, when the underlying field $\mathbb{F}_q$ does not possess a
smooth multiplicative subgroup structure, textbook NTT doesn’t work!
After all, the structure of the multiplicative subgroups of
$\mathbb{F}_q^\times$ is dictated by the prime factorization of $q-1$.
For example, in case of binary fields (i.e., fields of the form
$\mathbb{F}_{2^\kappa}$), multiplicative subgroups whose order is a
power of $2$, say $2^r$, do not exist because $\not\exists\; r >0$ such
that $2^r \not\mid 2^\kappa - 1$.

In these cases, several seemingly disparate techniques have been
developed that impose and exploit different algebraic structure of
$\Omega$ to achieve similar time and space complexity as textbook NTT.
For example, in case of binary fields, one exploits the additive
group[^LCH14] structure of $\mathbb{F}_\kappa$, which goes by the name
"Additive FFT" or "Frobenious FFT." In other cases, e.g.
EC-FFT[^BCKL21], one exploits rational maps between Elliptic Curves
(isogenies) to optimize for other parameters.

The goal of this exposition is to abstract away the details of these
different constructions and present and unified description of NTT that
works with arbitrary structured sets $\Omega$.

## Textbook Number Theoretic Transform (NTT)
---



[^N82]: H. J. Nussbaumer. "[Number Theoretic Transforms](https://doi.org/10.1007/978-3-642-81897-4_8)." In: Fast Fourier Transform and Convolution Algorithms. Springer Series in Information Sciences, vol 2., 1982, Springer, Berlin, Heidelberg.

[^LN16]: Patrick Longa and Michael Naehrig. "[Speeding up the Number Theoretic Transform for Faster Ideal Lattice-Based Cryptography](https://dl.acm.org/doi/10.1007/978-3-319-48965-0_8)." In: Cryptology and Network Security: 15th International Conference, CANS 2016, Milan, Italy, November 14-16, 2016. ePrint: [2016/504](https://eprint.iacr.org/2016/504)

[^LCH14]: Sian-Jheng Lin, Wei-Ho Chung, and Yunghsiang S. Han. "[Novel Polynomial Basis and Its Application to Reed–Solomon Erasure Codes](https://i4ai.org/hanyunghsiang/manuscript_focs_paper49.pdf)." In: IEEE 55th Annual Symposium on Foundations of Computer Science. 2014, pp. 316–325.

[^BCKL21]: Eli Ben-Sasson, Dan Carmon, Swastik Kopparty, and David
    Levit. "[Elliptic Curve Fast Fourier Transform (ECFFT) Part I: Fast Polynomial Algorithms over all Finite Fields](https://epubs.siam.org/doi/10.1137/1.9781611977554.ch30)." In: Proceedings of the 2023 Annual ACM-SIAM Symposium on Discrete Algorithms (SODA). arXiv: [2107.08473](https://arxiv.org/abs/2107.08473)
