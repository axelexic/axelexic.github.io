---
layout: post
title: OT Extensions &mdash; Theory and Practice
date: 2015-04-11
tags : [ "mpc", "oblivious transfer" ]
author : Yogesh Swami
---

The [previous post]({% post_url 2015-03-17-SemiHonestObliviousTransfer
%}){:target="_blank"} covered basic oblivious transfer primitives for ${2
\choose 1}$ bit-$\textsf{OT}$ and String-$\textsf{OT}$. Both of these protocols
require some form of public-key operation. In real world use cases &mdash; where
one needs to perform a large number of oblivious transfers &mdash; the
computational cost of public-key operations could be so prohibitive that it can
undermine the feasibility of the scheme.

This begs the question: Can one construct $\textsf{OT}$ schemes that are based
_entirely_ on secret-key operations? The short answer is no, but one can achieve
the next best thing &mdash; **$\textsf{OT}$ Extensions**. $\textsf{OT}$
Extensions use a small number of public-key operations to bootstrap a
symmetric-key based $\textsf{OT}$ scheme, which can then be used to cheaply
perform a large number of oblivious transfers. (This should remind the reader of
[KEM-DEM](https://link.springer.com/chapter/10.1007/978-3-540-40974-8_12){:target="_blank"}
framework for hybrid encryption.)

But before describing the mechanism of $\textsf{OT}$ Extensions, [Section
&sect;1](#textsfot-from-one-way-function-owf) provides theoretical arguments for
why $\textsf{OT}$ is _unlikely_ to be realized from symmetric-key operations
alone. Readers not interested in theory of cryptography can safely skip to
[Section &sect;2](#textsfot-extension-protocols).

## $\textsf{OT}$ from One-Way-Function (OWF)?

Recall that Impagliazzo, Levin, and Luby [^ILL89] proved that One-Way-Functions
are _necessary and sufficient_ for building any symmetric-key cryptographic
primitive. In this section, we examine if $\textsf{OT}$ can be realized from
black box OWF?

Kilian [^K88] famously proved that $\mathsf{OT}$ is complete for cryptography!
That is, given any $\textsf{OT}$ protocol as a _black box_, Alice and Bob can
jointly evaluate _any_ function $f(x,y)$ while keeping their respective inputs
$x$ and $y$ private. What's novel about Kilian's protocol is that apart from the
existence of oblivious transfer as a black box, it makes no other cryptographic
hardness assumptions. That is, the rest of the protocol is information
theoretically secure.

> ##### Yao vs. Kilian
>
> You may wonder how is this different from Yao’s [^Y86] Garbled Circuits (GC)?
> After all, GC too requires $\textsf{OT}$ and achieves the same functionality.
> However GC &mdash; in addition to the existence of oblivious transfer &mdash;
> also assumes the existence of symmetric key primitives. Kilian’s protocol, on
> the other hand, only assumes the existence of  oblivious transfer and nothing
> else.
>
> Another distinction: Unlike GC, Kilian’s protocol is secure even if one of the
> two parties is malicious. To achieve this, he constructs a bit-commitment and
> a (non-interactive) zero-knowledge proof _from oblivious transfer alone_ and
> uses it to force malicious parties from misbehaving.

Since $\textsf{OT}$ is complete,  that means one can construct a key-exchange
protocol using $\textsf{OT}$ alone. However, a result by Impagliazzo and Rudich
[^IR89] provides strong evidence that one cannot realize a key-exchange protocol
using black box access to a one-way permutation alone.

In summary, one can realize a key-exchange protocol using $\mathsf{OT}$ as a
back box [^GKMRV], but since its unlikely that any key-exchange protocol can be
realized using purely black box access to OWF alone, it's safe to conclude that
$\mathsf{OT}$ is unlikely to be realized from OWF.

The rest of this section describes a modern instantiation of Kilian’s protocol
due to Ishai, Prabhakaran, and Sahai [^IPS08]. This model of MPC, called
$\textsf{OT}$-hybrid model, is the predominant design methodology for efficient
MPC protocols in the real world. Sub-section XXX builds a key-exchange protocol
in the $\textsf{OT}$-hybrid model and Sub-section YYY states and proves
Impagliazzo and Rudich’s result. Readers not interested in theory can safely
skip to [Section &sect;2](#textsfot-extension-protocols).

## $\textsf{OT}$ Extension Protocols

[^GV87]: O. Goldreich and R. Vainish, "[How to solve any protocol problem &mdash; An Efficiency Improvement](https://www.wisdom.weizmann.ac.il/~oded/PSX/gv.pdf){:target="_blank"}," in Crypto 1987.

[^K88]: J. Kilian, "[Founding Cryptography on Oblivious Transfer](https://dl.acm.org/doi/pdf/10.1145/62212.62215){:target="_blank"}," in STOC 1988.

[^IPS08]: Y. Ishai, M. Prabhakaran and A. Sahai, "[Founding Cryptography on Oblivious Transfer – Efficiently](https://link.springer.com/chapter/10.1007/978-3-540-85174-5_32){:target="_blank"}," in Crypto 2008.

[^GKMRV]: Y. Gertner, S. Kannan, T. Malkin, O. Reingold and  M. Viswanathan, "[The relationship between public key encryption and oblivious transfer](https://omereingold.wordpress.com/wp-content/uploads/2014/10/gkmrv.pdf){:target="_blank"}," in FOCS 2000.

[^Y86]: A. C. Yao, "[How to generate and exchange secrets](https://ieeexplore.ieee.org/document/4568207){:target="_blank"}," in SFCS 1986.

[^IR89]: R. Impagliazzo and S. Rudich, "[Limits on the provable consequences of one-way permutations](https://dl.acm.org/doi/pdf/10.1145/73007.73012){:target="_blank"}" in STOC 1989.

[^ILL89]: R. Impagliazzo, L. Levin, and M. Luby, "[Pseudo-random generation from one-way functions](https://dl.acm.org/doi/pdf/10.1145/73007.73009){:target="_blank"}," in STOC 1989.

[^Dent03]: A. W. Dent, "[A Designer’s Guide to KEMs](https://link.springer.com/chapter/10.1007/978-3-540-40974-8_12){:target="_blank"}," in Cryptography and Coding, 2003.