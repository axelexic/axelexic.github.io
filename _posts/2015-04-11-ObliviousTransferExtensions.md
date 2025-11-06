---
layout: post
title: OT Extensions &mdash; Theory and Practice
date: 2015-04-11
tags : [ "mpc", "oblivious transfer" ]
author : Yogesh Swami
---

The [previous post]({% post_url 2015-03-17-SemiHonestObliviousTransfer
%}){:target="_blank"} covered basic oblivious transfer primitives for
${2 \choose 1}$ bit-$\textsf{OT}$ and String-$\textsf{OT}$. Both of
these protocols require some form of public-key operation. Frequently,
in real world MPC use cases, one needs to perform a large number of
oblivious transfers. In these scenarios, the computational cost of
$\textsf{OT}$ due to public-key operations can be so prohibitive that it
could completely undermine the practicality of the scheme.

This begs the question, can one construct $\textsf{OT}$ schemes that are
 _entirely_ based on secret-key operations? The short (and under
qualified) answer to this question is no, but one can achieve the next
best thing: **$\textsf{OT}$ Extensions** [^B96] [^IKNP03]. $\textsf{OT}$
Extensions use a small number of public-key operations to bootstrap a
symmetric-key based $\textsf{OT}$ scheme, which can be used to compute a
large number of $\textsf{OT}$s.

But why can't oblivious transfer be realized purely from symmetric-key
operations? [Section &sect;1](#textsfot-from-one-way-function-owf)
provides theoretical arguments to justify this claim. (**<u>NOTE</u>**:
these are just relativized arguments, not impossibility results.)
[Section &sect;2](#textsfot-extension-protocols) provides a detailed
description of how to construct efficient $\textsf{OT}$ Extensions.
Readers not interested in theory can safely skip to [Section
&sect;2](#textsfot-extension-protocols) without loss of context or
continuity.

## $\textsf{OT}$ from One-Way-Function (OWF)?
<hr/>

Recall that Impagliazzo, Levin, and Luby [^ILL89] proved that
One-Way-Functions are _necessary and sufficient_ for building
symmetric-key cryptographic primitive, especially Pseudo Random
Generators (PRGs). In this section, we examine if $\textsf{OT}$ can be
realized from black box OWFs, without making any additional hardness
assumption?

Kilian [^K88] famously proved that $\mathsf{OT}$ is complete for cryptography!
That is, given any $\textsf{OT}$ protocol as a _black box_, Alice and Bob can
jointly evaluate _any_ function $f(x,y)$ while keeping their respective inputs
$x$ and $y$ private. What's novel about Kilian's protocol is that apart from the
existence of oblivious transfer as a black box, it makes no other cryptographic
hardness assumptions. That is, the rest of the protocol is information
theoretically secure.

> ##### Yao vs. Kilian
>
> You may wonder how is this different from Yao’s Garbled Circuits (GC)
> [^Y86]? After all, GC too requires $\textsf{OT}$ and achieves the same
> functionality. However GC &mdash; in addition to the existence of
> oblivious transfer &mdash; also assumes the existence of symmetric-key
> primitives. Kilian’s protocol, on the other hand, only assumes the
> existence of  oblivious transfer and nothing else.
>
> Another distinction: Unlike GC, Kilian’s protocol is secure even if
> one of the two parties is malicious. To achieve this, he constructs a
> bit-commitment and a (non-interactive) zero-knowledge proof _from
> oblivious transfer alone_ and uses it to force malicious parties from
> misbehaving. (See Theorem 1 and 2 of [^K88] for further details.)

Since $\textsf{OT}$ is complete, that means one can construct a
key-exchange protocol using $\textsf{OT}$ alone. However, a result by
Impagliazzo and Rudich [^IR89] provides strong evidence that one cannot
realize a key-exchange protocol using black box access to a
One-Way-Permutation (OWP) alone. So if $\textsf{OT}$ could be
constructed from black box OWP alone, then that would imply that
key-exchange could also be constructed from black box OWP, by simply
using $\textsf{OT}$ as an intermediate subroutine. This would contradict
Impagliazzo and Rudich theorem that key-exchange cannot be realized from
black-box OWP alone.

The rest of this section describes in detail the three ingredients of
the above argument, that is:
1. $\textsf{OT}$ is complete,
2. $\textsf{OT} \implies $ key-exchange, and
3. Impagliazzo and Rudich theorem

### $\textsf{OT}$ is complete for cryptography

An algorithm $\mathcal{P}$ is complete for cryptography if it can be
used to emulate any cryptographic primitive or protocol &mdash;
public-key encryption, key-exchange, etc., &mdash; without relying upon
any additional computational hardness assumption. Since a _maliciously_
secure MPC protocol can evaluate any function $f(x_1,\cdots, x_n)$
between $n$ mutually distrusting parties, any construction of such an
MPC protocol &mdash; _purely from oracle access to $\mathcal{P}$_
&mdash; is sufficient to prove that $\mathcal{P}$ is complete.

Kilian described a way to instantiate a two-party _maliciously secure_
MPC protocol from oracle access to oblivious transfer. His protocol
consists of two distinct components:
1. An information theoretically secure two-party protocol for
   semi-honest _oblivious circuit evaluation_, and
2. A bit-commitment and non-interactive Zero-Knowledge protocol using
   $\textsf{OT}$ as an oracle

Since any semi-honest MPC protocol can be compiled to a maliciously
secure MPC protocol using zero-knowledge proof, the combined protocol
can simulate any maliciously secure cryptographic primitive.

Instead of developing Kilian's protocol in detail, we present a more
modern and practical instantiation of the same result based on the work
of Ishai, Prabhakaran and Sahai [^IPS08].

### Key-exchange from black box $\textsf{OT}$

Intuitively, $\textsf{OT} \implies $ key-exchange, is almost immediate! To see this, notice that the $\textsf{OT}$ transcript that the

### Key-exchange and black box OWP

## $\textsf{OT}$ Extension Protocols
<hr/>


[^K88]: J. Kilian, "[Founding Cryptography on Oblivious
    Transfer](https://dl.acm.org/doi/pdf/10.1145/62212.62215){:target="_blank"},"
    in STOC 1988.

[^IPS08]: Y. Ishai, M. Prabhakaran and A. Sahai, "[Founding Cryptography
    on Oblivious Transfer –
    Efficiently](https://link.springer.com/chapter/10.1007/978-3-540-85174-5_32){:target="_blank"},"
    in Crypto 2008.

[^GKMRV]: Y. Gertner, S. Kannan, T. Malkin, O. Reingold and  M.
    Viswanathan, "[The relationship between public key encryption and
    oblivious
    transfer](https://omereingold.wordpress.com/wp-content/uploads/2014/10/gkmrv.pdf){:target="_blank"},"
    in FOCS 2000.

[^Y86]: A. C. Yao, "[How to generate and exchange
    secrets](https://ieeexplore.ieee.org/document/4568207){:target="_blank"},"
    in SFCS 1986.

[^IR89]: R. Impagliazzo and S. Rudich, "[Limits on the provable
    consequences of one-way
    permutations](https://dl.acm.org/doi/pdf/10.1145/73007.73012){:target="_blank"},"
    in STOC 1989.

[^ILL89]: R. Impagliazzo, L. Levin, and M. Luby, "[Pseudo-random
    generation from one-way
    functions](https://dl.acm.org/doi/pdf/10.1145/73007.73009){:target="_blank"},"
    in STOC 1989.

[^IKNP03]: Y. Ishai, J. Kilian, K. Nissim, and E. Petrank, "[Extending
    Oblivious Transfers
    Efficiently,"](https://www.iacr.org/archive/crypto2003/27290145/27290145.pdf){:target="_blank"}
    in Crypto 2003.

[^B96]: D. Beaver, "[Correlated Pseudorandomness and the Complexity of
    Private
    Computations](https://dl.acm.org/doi/pdf/10.1145/237814.237996){:target="_blank"},"
    in STOC 1996.