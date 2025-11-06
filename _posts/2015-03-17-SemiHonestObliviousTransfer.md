---
layout: post
title: Semi-Honest Oblivious Transfer (OT) Primitives
date: 2015-03-17
tags : [ "mpc", "oblivious transfer" ]
author : Yogesh Swami
---

This page describes a few basic protocols for oblivious transfer
($\textsf{OT}$) schemes and some theoretical results related to them.
The [next post]({% post_url 2015-04-11-ObliviousTransferExtensions %})
will consider $\textsf{OT}$ extensions &mdash; which are needed when
performing a large number of oblivious transfers.

## Semi-Honest Base OT: Syntax and Semantics
---

Semi-honest Alice ($\mathbb{A}$) has two single-bit messages $m_0$ and
$m_1$. Semi-honest Bob ($\mathbb{B}$) has a single choice bit $b$. Alice
wants to send one &mdash; and only one &mdash; of her two messages to
Bob. Bob, depending upon his choice bit $b$, wants to access $m_b$ but
does not want Alice to know which message he picked. This interaction is
summarized in the following diagram:

<figure>
<img id="basic-ot" src="/Diagrams/BasicOT.svg"/>
<figurecaption>Oblivious Transfer Schematic</figurecaption>
</figure>

> ##### Generalization
>
> The scheme described above, where $m_0$ and $m_1$ are bits is called
> bit-$\textsf{OT}$. This definition can be naturally generalized to
> string-$\textsf{OT}$, where $m_0$ and $m_1$ are not bits but _strings
> of the same length_. That is, $m_0, m_1 \in \lbrace  0,1 \rbrace
> ^\kappa$, where $\kappa$ is well known in advance to each party.
> Oblivious transfer of this form is called string-$\textsf{OT}$. Note
> that in addition to having the same length, string-$\textsf{OT}$ is
> only meaningful if $m_0$ and $m_1$ are drawn from computationally
> indistinguishable distributions. Otherwise, a semi-honest Bob can
> trivially break Alice's privacy  by simply observing the distribution
> of $m_0$ or $m_1$. (Usually $m_0$ and $m_1$ are encoded as random
> group elements.)
>
> The definition for $1$-out-of-$2$ oblivious transfer can be extended
> to $k$-out-of-$n$ oblivious transfer in a natural way: Sender has $n$
> messages $\lbrace m_0, \cdots, m_{n-1} \rbrace$ out of which the
> receiver can choose any $k$ of them &mdash; but must remain oblivious
> to the rest of $n-k$ messages. Furthermore, the sender must remain
> oblivious to the messages that the receiver selected.
>
>We use the notation ${2 \choose 1}$ to mean $1$-out-of-$2$ oblivious
>transfer, and ${n \choose k}$ to mean $k$-out-of-$n$ oblivious
>transfer.
>
> **<u>NOTE</u>**: The ordering of $m_0$ and $m_1$ is arbitrary and
> nothing prevents a malicious sender from swapping $m_0$ with $m_1$.
> This, and other potential deviations from the prescribed protocol,
> needs to be handled using a _maliciously secure_ oblivious transfer
> scheme which is **not covered in this post**. This document only
> considers semi-honest adversary, which never deviates from the
> prescribed protocol. (Of course, a semi-honest adversary is not much
> of an adversary, but it's a useful building block for almost all
> maliciously secure $\textsf{OT}$ schemes.)

##### Correctness Requirement

The correctness requirement for an $\textsf{OT}$ protocol is obvious:
If Bob's choice bit is $b$, then $\forall m_0, m_1 \in \lbrace
0,1\rbrace$, with high probability, Bob should receive $m_b$. The
privacy requirements are stated after introducing some notation.

>
> ##### Notation
>
> Let $f(x_1, \cdots, x_n)$ be a function that $n$ parties
> $\mathcal{P}_1, \cdots, \mathcal{P}_n$ wish to compute jointly, where
> each party wants to keep its input $x_i$ secret. Let $\pi_i$ be the
> protocol executed by party $\mathcal{P}_i$ to jointly evaluate $f(x_1,
> \cdots, x_n)$. Abusing notation, we will use $\pi$ to mean the overall
> protocol (an interactive Turing machine) that produces all the
> necessary outputs that are exchanged between parties.
>
> Given the protocol $\pi$, the following notation is used throughout
> this document:
>
> * As always, the inputs to $\pi$ from the same party are listed
>   consecutively and separated by a comma '$,$'. Inputs from different
>   parties are separated by a semicolon '$;$'. In particular,
>   $\textsf{OT}$ as a (co-operatively evaluated) function is
>   represented as:
>
>   $$\textsf{OT}(m_0,m_1;\; b) \to m_b$$
>
>   As a boolean function, $\textsf{OT}$ can be expressed as:
>
>   $$\textsf{OT}(m_0,m_1;\; b) = (m_0\wedge \neg b)\oplus (m_1\wedge b)$$
>
>   Similarly, $\textsf{OT}$ can also be expressed as an arithmetic function over a finite field $\lbrace 0, 1 \rbrace \subseteq \mathbb{F}$ as
>
>   $$\textsf{OT}(m_0,m_1;\; b) = m_0\cdot (1 - b) + m_1 \cdot b$$
>
> * **Alice**'s **view** while interacting with Bob is denoted by
>
>   $$\textsf{View}_{\mathbb{A}}(m_0, m_1, r_{\mathbb{A}};\; b)$$
>
>   where $r_{\mathbb{A}}$ is Alice's private randomness used during
>   that particular execution of the protocol. $$
>   \textsf{View}_{\mathbb{A}}(m_0, m_1, r_{\mathbb{A}};\; b) $$
>   consists of all of Alice's local inputs $(m_0, m_1, r_\mathbb{A})$
>   as well as all the messages she has received from Bob. Note that at
>   any point in time, Alice's view contains all the information to
>   _deterministically generate_ all the messages sent from Alice to
>   Bob.
> * Similarly **Bob**'s **view** is denoted by
>
>   $$\textsf{View}_{\mathbb{B}}(b, r_{\mathbb{B}};\; m_0, m_1)$$
>
>   which includes Bob's local inputs $(b, r_{\mathbb{B}})$ as well as
>   all messages received from Alice.
> * For a given execution of a protocol, all the messages sent between
>   Alice and Bob is called the (communication) **transcript** and is
>   denoted by
>
>   $$\tau(\vec{m}, b) := \langle\mathbb{A}, \mathbb{B}\rangle(m_0,
>   m_1, b)$$
>
>   where $\vec{m} := \lbrace m_0, m_1 \rbrace.$
>
>   Since each execution of the protocol uses fresh randomness, the
>   value of $\tau(\vec{m}, b)$ is a random variable, even for the same
>   value of $(m_0,m_1, b)$. Furthermore, since the protocol is
>   _required_ to terminate after a finite number of steps, the maximum
>   number of random bits used in any execution of the protocol is
>   finite. We use the notation
>
>   $$\mathbb{T}(\vec{m},b) := \lbrace  \tau(\vec{m}, b)
>   \rbrace_{r_{\mathbb{A}},r_{\mathbb{B}}}$$
>
>   to denote the set of all possible transcripts that the protocol can
>   generate by varying the internal randomness $r_\mathbb{A}$ and
>   $r_\mathbb{B}$ of each party for a given value of $\lbrace m_0,
>   m_1\rbrace$ and $b$. Since the set of values for $r_\mathbb{A}$ and
>   $r_\mathbb{B}$ are finite, the size of the set $\mathbb{T}(a,b)$ is
>   finite.
>
> Note that:
>   1. Given the views of Alice and Bob, the transcript can be generated deterministically.
>   2. While the views of Alice and Bob are private, the transcript is public
>      and known to both Alice and Bob.

The privacy requirements for Alice and Bob can be summarized below:

##### Privacy Requirements

1. **Alice's Privacy**: Let Bob's choice bit be $b$ and let
   $\mathcal{D}$ be a probabilistic polynomial time algorithm (called a
   distinguisher) that a corrupt Bob is trying to use to glean extra
   information about $m_{1-b}$ from his choice bit $b$, the selected
   message $m_b$, and the message transcript

   $$\tau := \langle \mathbb{A}, \mathbb{B}\rangle(m_0, m_1, b)$$

   An $\textsf{OT}$ scheme preserves Alice's privacy if, given $\tau$,
   the probability with which $\mathcal{D}$ can distinguish $m_{1-b}$
   from $1$ (or, for that matter, $0$) with probability significantly
   greater than $\frac{1}{2}$ is negligible, i.e.,

   $$\forall \mathcal{D} \in \text{p.p.t.m}
   :\;\mathbf{Pr}\left[\mathcal{D}(b, m_b, \tau) = 1\right] <
   \frac{1}{2} + \textsf{negl}$$

   where the probability is taken over the private random choices of
   Alice and Bob (i.e., over $\tau$) as well as the internal randomness
   of $\mathcal{D}$.
2. **Bob's Privacy**: Let $\mathcal{D}'$ be a probabilistic polynomial
   time distinguisher that a corrupt Alice is trying to use to find
   information about $b$ from the message transcript

   $$\tau := \langle \mathbb{A}, \mathbb{B}\rangle(m_0, m_1, b)$$

   An $\textsf{OT}$ scheme preserves Bob's privacy if the probability
   that $\mathcal{D}'$ can guess the value of $b$ with probability
   significantly greater than $\frac{1}{2}$ is negligible, i.e.,

   $$\forall \mathcal{D}' \in \text{p.p.t.m}
   :\;\mathbf{Pr}\left[\mathcal{D}'(m_1, m_0, \tau) = b\right] <
   \frac{1}{2} + \textsf{negl}$$

   where the probability is taken over the private random choices of
   Alice and Bob as well as the internal randomness of $\mathcal{D'}$.

## OT Theoretical Results
---

This section lists some well known theoretical results related to
Oblivious Transfer.

> ##### Theorem
> Information theoretically secure oblivious transfer schemes don't exist.
>

We will prove this theorem in two stages: First we will show that given
_any oblivious transfer scheme_

$$\textsf{OT}(m_0, m_1;\; b) \to m_b$$

one can use it as a black box to construct a _two party MPC protocol_ $
\textsf{2pc}_{\wedge} $ that computes the boolean `and` ($\wedge$) of
two bits $a$ and $b$, i.e.,

$$\exists \; \textsf{OT}(m_0, m_1;\; b) \implies \exists \; \textsf{2pc}_{\wedge}(a;\;b) := a\wedge b $$

Second, we will prove that there does not exist _any_ information
theoretically secure $$\textsf{2pc}_{\wedge}(a;\;b)$$ and conclude the
contrapositive that there _does not exist_ any information-theoretically
$\textsf{OT}$ scheme.

> ###### Proof
> [ $ \textsf{OT} \implies 2\textsf{pc}_\wedge $ ]
>
> Suppose $\textsf{Alice}$ has bit $a$ and $\textsf{Bob}$ has bit $b$
> and $\textsf{Alice}$ and $\textsf{Bob}$ want to jointly compute
> $\textsf{2pc}_{\wedge}(a;\;b)$ using $\textsf{OT}(m_0, m_1;\; b)$ as a
> black box.
>
> <figure>
> <img id="ot2pc-and-gate" src="/Diagrams/OT2PCAnd.svg" alt="OT to 2PC And Gate
> reduction"/>
> <figurecaption>Two party <code>and</code> gate from oblivious transfer</figurecaption>
> </figure>
>
> Here's how the two parties proceed (See figure above for pictorial
> representation of these steps):
> 1. $\textsf{Alice}$ acts as the $\textsf{OT}$ sender and
>    $\textsf{Bob}$ acts as the $\textsf{OT}$ receiver.
> 2. As an $\textsf{OT}$ sender, $\textsf{Alice}$ feeds her two inputs
>    as $m_0 := 0$ and $m_1 := a$ to the $\textsf{OT}$ black box.
> 3. As an $\textsf{OT}$ receiver, $\textsf{Bob}$ feeds his choice bit
>    $b := b$ into the $\textsf{OT}$ black box.
> 4. $\textsf{Bob}$ broadcasts the final result of $\textsf{OT}$
>    computation to $\textsf{Alice}$.
>
>
> **<u>Claim</u>**: The output of above oblivious transfer setup
> securely computes $a \wedge b$. Reason:
> 1. Correctness holds because $\textsf{OT}(0, a;\; b) = \left [0\wedge
>    (\neg b) \right ] \oplus \left [a\wedge b \right ] = a\wedge b$.
>
> 2. $\textsf{Alice}$'s privacy holds because of $\textsf{OT}$ sender's
>    privacy guarantee: Namely, if $b = 0$ then the receiver always gets
>    $0$ as its output &mdash; regardless of the value of $a$! Note that
>    when $b = 1$, then any 2-party MPC `and` protocol will reveal the
>    value of $a$, but that's not a privacy breach because even an ideal
>    world implementation of `and` function will leak this information.
>    Furthermore, if $\textsf{OT}$ is maliciously secure or
>    semi-honestly secure, then so is $2\textsf{pc}_\wedge$.
>
> 3. $\textsf{Bob}$'s privacy holds because of $\textsf{OT}$ receiver's
>    privacy guarantees. In particular, $\textsf{OT}$ guarantees that
>    the sender will never learn the value of $b$ with non-negligible
>    probability.


We now prove that its impossible to have an information theoretically
secure two party $\wedge$ gate computation.

> ##### Lemma
> There is no information theoretically secure $2\textsf{pc}_\wedge$ MPC
> scheme with (a) perfect correctness and (b) perfect privacy.
>

Suppose there exists such an information theoretically secure
$2\textsf{pc}_\wedge(a;\;b)$ MPC protocol and suppose one of the parties
$\textsf{Alice}$ (whose input is $a$) is malicious. We will show that if
$\textsf{Alice}$ is computationally unbounded, then just based on the
protocol transcript

$$\tau(a,b) := \langle\mathbb{A}, \mathbb{B} \rangle(0, a, b)$$

she can breach $\textsf{Bob}$'s privacy (whose input is $b$). Note that
breaching $\textsf{Bob}$'s privacy is only meaningful when
$\textsf{Alice}$'s own input $a$ is $0$. This is because when $a = 1$,
the value of $b$ is readily available to $\textsf{Alice}$ (as the final
result of the computation) and there's no expectation of privacy in that
case.

In short, $\textsf{Alice}$'s concrete goal is to find the value of $b$
given that her own input $a = 0$.

>
> ##### Proof
>
> The high level idea of the proof is to build a distinguisher for $b$
> by exploiting the properties of the transcript set $$\mathbb{T}(a,b)
> := \left \lbrace  \tau(a,b) \right \rbrace_{r_\textsf{Alice},
> r_\textsf{Bob}}$$ for different values of $a$ and $b$. In particular,
> it's based on the observation that the transcript set of _any_
> $$2\textsf{pc}_\wedge(a;\;b)$$ MPC protocol with _perfect correctness_
> and _perfect privacy_ must be identical when either $a=0$ or $b=0$,
> i.e.,
>
> $$\mathbb{T}(0,0) = \mathbb{T}(1,0) = \mathbb{T}(0,1)$$
>
> but very distinct when $a=1$ and $b=1$, namely, $$\mathbb{T}(0,1) \cap
> \mathbb{T}(1,1) = \phi$$
>
> A computationally unbounded $\textsf{Alice}$ will use these facts
> (which are proved later in this section), to build a distinguisher to
> decide if the protocol transcript $\tau(0,b)$ is an element of
> $\mathbb{T}(0,0)$ or $\mathbb{T}(0,1)$ and breach $\textsf{Bob}$'s
> privacy.
>
> Here's the concrete strategy $\textsf{Alice}$ can use:
>
> * Since $\textsf{Alice}$ is computationally unbounded, she can
>   enumerate all possible random values (i.e., $r_\textsf{Alice}$ and
>   $r_\textsf{Bob}$) used by the protocol to build a table
>   corresponding to the transcript set
>
>   $$\mathbb{T}(1,0) = \lbrace  \tau(1, 0) \rbrace_{r_\textsf{Alice}, r_\textsf{Bob}}$$
>
>   in her spare time.
> * After this table is built, $\textsf{Alice}$ runs her protocol
>   $2\textsf{pc}_\wedge(a;\;b)$ with input $a = 0$ to obtain the
>   transcript $\tau(0,b)$. Notice that the table $\textsf{Alice}$ has
>   built is for $a = 1$ and $b = 0$, but the actual protocol runs over
>   the values $a=0$ and $b$ unknown.
> * Given the transcript $\tau(0,b)$, $\textsf{Alice}$ searches through
>   the table $\mathbb{T}(1,0)$ to find if $\tau(0,b)$ is present or
>   not, and concludes as follows:
>
>   $$\tau(0,b) \in \mathbb{T}(1,0) \implies \begin{cases}b = 0\;
>   \text{if true}\\ b = 1\; \text{otherwise}\end{cases}$$
>
>
> The reason this strategy succeeds is because as sets $\mathbb{T}(0,0)$
> and $\mathbb{T}(1,0)$ are identical. Concretely that means, if
> $\tau(0,0)$ corresponds to random coin tosses $(r_{\textsf{Alice}},
> r_{\textsf{Bob}})$ during protocol execution, then there must exist
> some other random choices $$(r'_{\textsf{Alice}}, r'_{\textsf{Bob}})$$
> for which $\tau(1,0)$ = $\tau(0,0)$. Furthermore, since
> $\mathbb{T}(1,0) \cap \mathbb{T}(1,1) = \phi$, presence of $\tau(0,b)$
> in $\mathbb{T}(1,0)$, implies absence from $\mathbb{T}(1,1)$.
> Therefore, testing for set membership of $\tau(0,b)$ in
> $\mathbb{T}(1,0)$ is sufficient to conclude if $b = 0$ or $b = 1$.
>
> The only thing left to prove is that $\mathbb{T}(0,0) =
> \mathbb{T}(1,0)$ and $\mathbb{T}(1,0) \cap \mathbb{T}(1,1) = \phi$. We
> prove these as two separate claims:
>
> **<u>Claim</u>**: $\mathbb{T}(0,0) = \mathbb{T}(1,0)$
>
> **<u>Proof</u>**: First note that the output of $2\textsf{pc}_\wedge(a;\;b)$ is
> the same when either $a=0$ or $b = 0$. We will show that if
> $\mathbb{T}(0,0) \neq \mathbb{T}(1,0)$ then it will lead to the breach
> of perfect privacy assumption.
>
> Let's suppose that $\mathbb{T}(0,0) \neq \mathbb{T}(1,0)$. That means,
> there must exist at least one transcript $\gamma$ that is present in
> $\mathbb{T}(0,0)$ but not in $\mathbb{T}(1,0)$ (or vice versa). Let
> $r_\gamma := (r_\textsf{Alice}^\gamma,r_\textsf{Bob}^\gamma)$ be the
> private randomness that was used to generate transcript $\gamma$.
> Since the protocol must terminate in finite number of steps, the
> length of $r_\gamma$ is finite. That means, a computationally
> unbounded adversary can enumerate all possible bit strings of length
> $$ \mid r_\gamma \mid $$ and run the protocol on $(a,b) := (0,0)$ and
> $(a,b) := (1,0)$ and find out whether $\gamma$ corresponds to $(a=0)
> \wedge (b=0)$ or $(a=1) \wedge (b=0).$ In other words, based on
> $\gamma$ alone, the adversary can find out if $a=0$ of $a=1$ with
> non-zero probability. This, however, is a breach of _perfect privacy
> assumption_ which requires that the transcripts are identically
> distributed.
>
> **<u>Claim</u>**: $\mathbb{T}(1,0) \cap \mathbb{T}(1,1) = \phi$
>
> **<u>Proof</u>**: This follows immediately from perfect correctness of
> $$2\textsf{pc}_\wedge(a;\;b)$$. If $\mathbb{T}(1,0) \cap
> \mathbb{T}(1,1) \neq \phi$, that means there exists a transcript
> $\gamma'$ such that  $\gamma' \in \mathbb{T}(1,0)$ and $\gamma' \in
> \mathbb{T}(1,1)$. However the output of $$2\textsf{pc}_\wedge(a;\;b)$$
> is completely determined by $(a,b)$ and the transcript $\gamma'.$
> (Note that the internal coin tosses of the protocol implicitly gives
> rise to different transcripts of the protocol, so one only needs to
> consider the transcript, which acts as a proxy for the internal coin
> tosses of the protocol). But since the output of
> $$2\textsf{pc}_\wedge(1;\;0) = 0$$ but $$2\textsf{pc}_\wedge(1;\;1) =
> 1$$ it would be a breach of perfect privacy if the same $\gamma'$
> could output both $0$ and $1$ based on the internal coin tosses of the
> protocol. Therefore, under perfect correctness assumption
> $\mathbb{T}(1,0) \cap \mathbb{T}(1,1) = \phi$

Together, these results prove that one cannot have information
theoretically secure oblivious transfer scheme, with perfect privacy and
perfect correctness.

## Semi-honest $\textsf{OT}$ Constructions
---

### ${2 \choose 1}$ $\textsf{OT}$ from RSA Hardcore predicate

Let $n = p\cdot q$ be the product of two primes $p$ and $q$. The group
of units in the Ring $\mathbb{Z}/n\mathbb{Z}$ has order $\phi(n) =
(p-1)\cdot(q-1)$. Let $e$ be coprime to $\phi(n)$ and let $d :=
e^{-1}\mod \phi(n)$. Let $x \in \left
(\mathbb{Z}/n\mathbb{Z}\right)^\times$ be a unit, then the **RSA
trapdoor permutation** is defined as $$f_{n,e}(x) = x^e$$ where $d$ is
the trapdoor information, i.e., given $y \in \left
(\mathbb{Z}/n\mathbb{Z}\right)^\times$ such that $y = f_{n,e}(x)$ for
some $x$, then $x = y^d \mod n$.

A result by Alexi, Chor, Goldreich, and Schnorr [^ACGS88] states that
give $n, e$ and $y \in \left (\mathbb{Z}/n\mathbb{Z}\right)^\times$,
where $y = x^e$ for some unknown $x$, then computing the exact value of
$x$ from $y$ is at least as hard as computing the least significant bit
of $x$ (i.e., $\textsf{lsb}(x)$). In other words, the least significant
bit of $x$ is the hard core predicate of the RSA trapdoor permutation.

Assuming semi-honest adversary, the following scheme uses RSA hardcore predicate to build a 1-out-of-2  $\textsf{OT}$ protocol.

**Setup**:
>
> Based on security parameter $\lambda$ (say $\lambda = 2048$), the $\textsf{OT}$ sender Alice ($\mathbb{A}$), generates two random primes $p$ and $p$ of size $\lambda/2$ and computes $n = p\cdot q$, $\phi(n)$, $e$ and $d$ as described before. This one time setup can be reused for different runs of the $\textsf{OT}$ Protocol with potentially different receivers. After computing these values, $\mathbb{A}$ sends $(n,e)$ to the $\textsf{OT}$ receiver Bob ($\mathbb{B}$) and keeps $(n,e,d)$ private.
>

**Protocol Execution**:

> * $\mathbb{B} \longrightarrow \mathbb{A}$: $\left[\right.\mathbb{B}$'s choice bit is $\left. b \in \lbrace 0,1\rbrace\right]$
>   * $\mathbb{B}$ samples two random numbers as follows
>
>     $$\begin{aligned} s &\xleftarrow{\$} \left (\mathbb{Z}/n\mathbb{Z}\right)^\times \\ T &\xleftarrow{\$} \left (\mathbb{Z}/n\mathbb{Z}\right)^\times \end{aligned}$$
>
>     and computes
>
>     $$S := s^e \mod n$$
>
>   * Depending upon the choice bit $b$, $\mathbb{B}$ prepares a message $\Omega$ consisting of two Ring element from $\mathbb{Z}/n\mathbb{Z}$ as follows:
>
>     $$\Omega := \begin{cases}(S,T) & \text{if } b = 0\\(T,S) & \text{if } b = 1  \end{cases}$$
>
>     and sends $\Omega$ to $\mathbb{A}$ in the left to right tuple order (i.e., sends $S$ then $T$ if $b=0$, otherwise, sends $T$ then $S$).
> * $\mathbb{A} \longrightarrow \mathbb{B}$: $\left[\right.\mathbb{A}$'s input messages are $\left. m_0, m_1 \in \lbrace 0,1\rbrace\right]$
>   * Suppose $\mathbb{A}$ receives $\Omega = (X,Y)$. Since $\mathbb{A}$ has access to RSA trapdoor information $d$, it computes
>
>     $$\begin{aligned} x &= X^d \mod n\\ y &= Y^d \mod n\end{aligned}$$
>
>     and extracts the hardcore bits directly as $\textsf{lsb}(x)$ and $\textsf{lsb}(y)$ and prepares the response message $\Delta$ as follows:
>
>     $$\begin{aligned}  c_0 &:= m_0 \oplus \textsf{lsb}(x)\\ c_1 &:= m_1 \oplus \textsf{lsb}(y)\\ \Delta &:= (c_0, c_1) \end{aligned}$$
>
>   * $\mathbb{A}$ then sends $\Delta$ to $\mathbb{B}$.
> * $\mathbb{B}$ Selection: Depending upon the choice bit $b$, $\mathbb{B}$ computes $m_b$ as follows:
>
>     $$m_b = c_b \oplus \textsf{lsb}(s)$$
>

**Perfect Correctness**

> When both $\mathbb{A}$ and $\mathbb{B}$ are honest, the trapdoor information $d$ allows $\mathbb{A}$ to compute the exact value of $s$ from $(X,Y)$. Given $s$, $c_b$ can be thought of one-time pad encryption of message $m_b$, which $\mathbb{B}$ can correctly decrypt.

**Perfect Privacy**

> * **$\mathbb{A}$'s privacy against computationally bounded semi-honest $\mathbb{B}$**: Since $\mathbb{B}$ is semi-honest, it follows the protocol exactly as described. In particular, it only knows the value of $s = S^d \mod n$ and not the value of $t = T^d \mod n$. (By construction, $T$ was selected randomly and $\mathbb{B}$ doesn't know $d$ that it could use to compute $t$ with significant probability). Therefore, it can only decrypt one of $c_0$ or $c_1$ with high probability.
>
>   More formally, assuming that $\textsf{lsb}(\cdot)$ hardcore predicate of the RSA function can be predicted with probability $1/2 + \epsilon$, given $c_{1-b}$ and $T$, $\mathbb{B}$ can predict the value of $m_{1-b}$ with probability $1/2 + \epsilon$.
>
> * **$\mathbb{B}$'s privacy against computationally unbounded malicious $\mathbb{A}$**: Since $S$ and $T$ are identically distributed $\mathbb{A}$ cannot predict with probability greater than $1/2$ which bit $\mathbb{B}$ is interested in. Therefore, $\mathbb{B}$'s privacy is information theoretically guaranteed. (<u>NOTE</u>: it's important that $T$ is sampled uniformly from the group of units of $\mathbb{Z}/n\mathbb{Z}$, otherwise a computationally unbounded $\mathbb{A}$ will be able to breach $\mathbb{B}$'s privacy.)
>

The figure below summarizes the protocol pictorially:

<figure>
<img id="bit-ot-from-rsa" src="/Diagrams/BitOTFromRSA.svg" alt="Bit-OT From RSA Hardcore Predicate Assumption"/>
<figurecaption>${2 \choose 1 }$ bit-$\textsf{OT}$ from RSA Hardcore Predicate</figurecaption>
</figure>

### ${2 \choose 1}\;$ String-$\textsf{OT}$ from DDH Assumption [^NP01]

In a String-$\textsf{OT}$ protocol, the sender has two binary strings $$m_0, m_1 \in \lbrace 0,1\rbrace^\ell$$  (of agreed upon maximum length $\ell$) instead of two bits to send to the receiver. The receiver still has a single bit choice $b \in \lbrace  0, 1\rbrace$. The sender wants to send only one of $m_0$ or $m_1$ to the receiver and the receiver wants to hide its choice bit $b$.

Let $\mathbb{G}$ be a cyclic group of order $\ell$. Let $a,b,c \xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z}$ be three arbitrary random element from the Ring $\mathbb{Z}/\ell\mathbb{Z}$. The group $\mathbb{G}$ is said to satisfy Decisional Diffie Hellman (DDH) assumption, if for all generators $g \in \mathbb{G}$ of the group, a computationally bounded adversary cannot distinguish between the distribution of $(g^a, g^b, g^{ab})$ from $(g^a, g^b, g^{c})$ with non negligible probability. (If the group is of prime order, then any generator $g$ with this property will suffice.)

Assuming semi-honest adversary, the following scheme use DDH assumption to build a $2 \choose 1$ $\textsf{OT}$ scheme where the two message can be arbitrary group elements.

**Setup**:
>
> Based on the security parameter $\lambda$ the $\textsf{OT}$ sender Alice ($\mathbb{A}$) and Bob ($\mathbb{B}$) agree upon:
>    1. An appropriate cyclic group $\mathbb{G}$ of _prime_ order $\ell$ such that DDH assumption holds with $2^{-\lambda}$ distinguishing probability
>    2. A generator $g \in \mathbb{G}$
>    3. A message encoding scheme that encodes bit strings to group elements. From now on, we assume $m_0, m_1 \in \mathbb{G}$
>

**String-$\textsf{OT}$ Protocol**:

> * $\mathbb{B} \longrightarrow \mathbb{A}$: $\left[\right.\mathbb{B}$'s choice bit is $\left. b \in \lbrace 0,1\rbrace\right]$
>   * $\mathbb{B}$ samples three random numbers $(q,r,t)$ and computes $s$ as follows
>
>     $$\begin{aligned} q &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z} \\ r &\xleftarrow{\$}  \mathbb{Z}/\ell\mathbb{Z} \\ s &=  q\times r \\ t &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z} \end{aligned}$$
>
>     and further computes
>
>     $$\begin{aligned} Q &= g^q \\ R &= g^r \\ S &= g^{s} \\ T &= g^t\end{aligned}$$
>
>
>   * Depending upon the choice bit $b$, $\mathbb{B}$ prepares a message $\Omega$ consisting of four group elements as follows:
>
>     $$\Omega := \begin{cases}(Q, R, S, T) & \text{if } b = 0\\(Q, R, T, S) & \text{if } b = 1  \end{cases}$$
>
>     and sends $\Omega$ to $\mathbb{A}$.
>
> * $\mathbb{A} \longrightarrow \mathbb{B}$: $\left[\right.\mathbb{A}$'s input messages are encoded as group elements $\left. m_0, m_1 \in \mathbb{G} \right]$
>    * Suppose $\mathbb{A}$ receives $\Omega = (Q, R, X,Y)$. $\mathbb{A}$ randomly samples
>
>      $$\begin{aligned}u_0 &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z}\\ v_0 &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z}\\ u_1 &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z}\\ v_1 &\xleftarrow{\$} \mathbb{Z}/\ell\mathbb{Z}\end{aligned}$$
>
>    * $\mathbb{A}$ then computes encryption keys $k_0, k_1$ as follows
>
>      $$\begin{aligned} W_0 &= Q^{u_0}g^{v_0} = g^{q\cdot u_0 + v_0}\\ W_1 &= R^{u_1}g^{v_1} = g^{r\cdot u_1 + v_1} \\ k_0 &= X^{u_0}R^{v_0} = \begin{cases} g^{(q\cdot u_0 + v_0)\cdot r} & \text {if } b = 0\\g^{t\cdot u_0 + r \cdot v_0} & \text {if } b = 1\end{cases}\\ k_1 &= X^{u_1}R^{v_1} = \begin{cases} g^{t\cdot u_1 + r \cdot v_1} & \text {if } b = 0\\ g^{(q\cdot u_1 + v_1)\cdot r} & \text {if } b = 1 \end{cases}\end{aligned}$$
>
>      and encrypts it's two messages $m_0, m_1 \in \mathbb{G}$ as
>
>      $$\begin{aligned}C_0 &= m_0\cdot k_0 \\ C_1 &= m_1\cdot k_1\end{aligned}$$
>
>      and formats the response message as four group elements
>
>      $$\Delta := (W_0, C_0, W_1, C_1)$$
>
>
>    * $\mathbb{A}$ then sends $\Delta$ to $\mathbb{B}$.
> * $\mathbb{B}$ Selection: Depending upon the choice bit $b$, $\mathbb{B}$ computes $m_b$ as follows:
>
>   $$m_b = C_b\cdot W_b^{-r} $$
>

**Perfect Correctness**

> When both $\mathbb{A}$ and $\mathbb{B}$ are honest, $\forall b \in \lbrace 0,1\rbrace:\; C_b \cdot W_b^{-r} = (m_b \cdot g^{(q\cdot u_b + v_b)\cdot r})\cdot (g^{(q\cdot u_b + v_b)})^{-r} = m_b$

**Perfect Privacy**

> * **$\mathbb{A}$'s privacy against computationally bounded semi-honest $\mathbb{B}$**: We analyze the $\mathbb{A}$'s privacy for different values of $b$ separately.
>
>    * Case $b = 0$: In this case, the information sent by $\mathbb{A}$ is
>      $$\left (g^{q\cdot u_0 + v_0}, m_0\cdot g^{(q\cdot u_0 + v_0)\cdot r},
>      g^{q\cdot u_1 + v_1}, m_1\cdot g^{(t\cdot u_1 + r \cdot v_1)}\right )$$
>      Since $u_0$ and $v_0$ are sampled independently from $u_1, v_1$, the
>      entries corresponding $W_1, C_1$ is independent from $W_0, C_0$.
>      Furthermore, $$W_1 = g^{q\cdot u_1 + v_1} = (g^{q})^{u_1}\cdot g^{v_1}$$
>      and $$C_1 = m_1\cdot (g^{t})^{u_1}\cdot (g^{r})^{v_1}$$ Assuming
>      semi-honest $\mathbb{B}$, given that $\mathbb{G}$ is a prime order group,
>      $g^q, g^r$, and $g^t$ are also generators of $\mathbb{G}$. Furthermore
>      since  $u_1$ and $v_1$ were randomly selected by $\mathbb{A}$, $W_1$ and
>      $C_1/m_1$ are random elements of the group for a computationally bounded
>      DDH-adversary $\mathbb{B}$. Therefore, the probability with which
>      $\mathbb{B}$ can make inference about $m_1$ is negligible.
>
>     * Case $b = 1$: This case is identical to $b = 0$, except for $u_0$ and
>       $v_0$ playing the role that $u_1$ and $v_1$.
>
> * **$\mathbb{B}$'s privacy against computationally bounded semi-honest $\mathbb{A}$**: Since $\mathbb{A}$ receives tuples either of the form $(g^{\alpha}, g^{\beta}, g^{\alpha\cdot \beta}, g^{\gamma})$ when $b =0$ or of the form $(g^{\alpha}, g^{\beta}, g^{\gamma}, g^{\alpha\cdot \beta})$, when $b=1$, by DDH assumption semi-honest $\mathbb{A}$ cannot distinguish whether it's in $b=0$ or $b=1$ case with non-negligible probability (this can he shown using hybrid argument). This guarantees $\mathbb{B}$'s privacy.
>

The figure below summarizes the protocol pictorially:

<figure>
<img id="string-ot-from-ddh" src="/Diagrams/StringOTFromDDH.svg" style="margin-left:auto; margin-right:auto" alt="String-OT From DDH Assumption"/>
<figurecaption>${2 \choose 1}\;$ String-$\textsf{OT}$ from DDH Assumption</figurecaption>
</figure>

### ${n \choose 1}$ String-$\textsf{OT}$ from ${2 \choose 1}$ String-$\textsf{OT}$ [^NP99]

In an ${n \choose 1}\; \textsf{OT}$ scheme, semi-honest sender Alice ($\mathbb{A}$) has $n$ messages $\lbrace  x_0, \cdots, x_{n-1} \rbrace$, where each $x_i$ is of length $m$ bits. Semi-honest receiver Bob ($\mathbb{B}$) has a choice index $i$ with $0 \leq i < n$. Similar to ${2 \choose 1}\;\textsf{OT}$ scheme, $\mathbb{A}$ wants to send one &mdash; and only one &mdash; of $x_j$'s to $\mathbb{B}$ but doesn't want to reveal any additional additional information about  other messages. $\mathbb{B}$, on the other hand, doesn't want $\mathbb{A}$ to learn about his choice index $i$.

The scheme by Naor and Pinkas achieves ${n \choose 1}\;\textsf{OT}$ by making $\log n$ blackbox invocations to ${2 \choose 1}\; \textsf{OT}$. The scheme also requires a PRF/PRP

$$F : \lbrace  0,1\rbrace^\lambda \times \lbrace  0,1\rbrace^m \mapsto \lbrace  0,1\rbrace^m$$

where $\lambda$ is the length of the PRF-key (also assumed to be the security parameter) and $m \ge \log n$.

Define $[n] := \lbrace  0, \cdots, n-1\rbrace$ and let $\ell = \lceil \log n \rceil$ be the number of bits needed to encode $n \in \mathbb{Z}$ as a binary string. The main idea of the paper is to generate $\ell$-pairs of $\lambda$-bit PRF keys

$$ S := \lbrace  (s_0^0, s_0^1),  \cdots, (s_k^0, s_k^1), \cdots, (s_{\ell-1}^0, s_{\ell-1}^1) \rbrace$$

and associate each pair $(s_k^0, s_k^1)$ with a bit position $k$ in the binary representation of $n$.

Given the list of key pairs $S$, for each index $j \in [n]$, the sender derives a new one-time-pad (OTP) encryption key based on the $\ell$-bit binary representation of $j$ as follows:
* Let the binary representation of $j$ be denoted by $\vec{j} := \lbrace   J_0, J_1, \cdots, J_{\ell-1}\rbrace_2$, where each $J_k \in \lbrace 0,1\rbrace$ (without loss of generality, this document uses least significant bit first for binary representation). The encryption key $S_j$ for index $j$ consists of $\ell$-tuples

  $$S_j := (s_0^{J_0}, s_1^{J_1},\cdots,s_{\ell-1}^{J_{\ell-1}}) \in \left(\lbrace 0,1\rbrace^\lambda\right)^\ell$$


* Define a new PRF $\widetilde{F} : \left(\lbrace 0,1\rbrace^\lambda\right)^\ell \times \lbrace 0,1\rbrace^m \to \lbrace 0,1\rbrace^m$ whose key is the $\ell$-tuple $S_j$ as:

  $$\widetilde{F}(S_j, x) := \oplus_{s \in S_j} F(s, x)$$

* Given index $j \in [n]$ and message $x_j$, where $j$ is public information, the OTP encryption of any message $x \in \lbrace 0,1\rbrace^m$ is defined as:

  $$\textsf{enc}_j(x) := x \oplus \widetilde{F}(S_j, j)$$

Based on the above encryption scheme, a semi-honest sender $\mathbb{A}$ first enumerates all possible $2^\ell$ tuple of keys $S_j$ and then, for each $j \in [n] \subset [2^\ell]$, encrypts $x_j$ using $\textsf{enc}_j(x_j)$ to obtain $n$ ciphertexts:

$$C_j := x_j\oplus \widetilde{F}(S_j,j) = x_j\oplus_{s \in S_j} {F}(s,j)$$

Since $S_j \neq S_k$ whenever $j \neq k$, invocations of the PRF $\widetilde{F}$ for distinct indices $j$ and $k$ differ by at least one key $s_{\alpha}^\beta$ for some $\alpha, \beta$. In other words, a semi-honest sender will never encrypt two messages $x_j$ an $x_k$ with the same key unless $j = k$.

**<u>NOTE</u>**: When evaluating $F(\cdot, j)$, the value of $j$ as an argument to $F$ should be encoded as $m$-bit binary string.

Let $i \in [n]$ be receiver's choice index. Let the bit decomposition of $i$ be denoted by $$\vec{i} := \lbrace I_0, I_1,  \cdots, I_{\ell -1}\rbrace_2$$. In order to decrypt $C_i$, the receiver needs access to the $\ell$-tuple of keys $S_i := (s_{0}^{I_{0}}, s_1^{I_1},  \cdots, s_{\ell-1}^{I_{\ell - 1}})$, which $\mathbb{B}$ can get by performing $\ell$ parallel executions of ${2 \choose 1}$ string-$\textsf{OT}$ by invoking

$$\begin{aligned} s_{0}^{I_{0}} &\leftarrow \textsf{OT}(s_0^0, s_0^1;\; I_{0}) \\ s_{1}^{I_{1}} &\leftarrow \textsf{OT}(s_1^0, s_1^1;\; I_{1}) \\ & \quad \vdots \\ s_{\ell-1}^{I_{\ell-1}} &\leftarrow \textsf{OT}(s_{\ell-1}^0, s_{\ell-1}^1;\; I_{\ell-1}) \end{aligned}$$

Once $\mathbb{B}$ has access to $S_i$, it can decrypt $x_i$ as follows:

$$x_i = C_i \oplus \widetilde{F}(S_i, i) = C_i\oplus_{k=0}^{\ell - 1} F(s_k^{I_k}, i)$$


Notice that the ${2 \choose 1}$ string-$\textsf{OT}$ hides each and every bit $\lbrace  I_k \rbrace_{k \in [\ell]}$ of $i$ from a semi-honest sender $\mathbb{A}$. Therefore, the index $i$ is itself hidden from $\mathbb{A}$ after $\ell$ parallel executions. Furthermore, for every key $s_k^{I_k}$ the ${2 \choose 1}$ string-$\textsf{OT}$ hides information about $s_k^{(1 - I_k)}$ (here, $(1 - I_k)$ should be treated as superscript computation), and the only message that the receiver can decrypt correctly is at index $i$. Therefore, all other messages apart from $x_i$ remain hidden from semi-honest $\mathbb{B}.$

For the security proof to work, it's important that $\mathbb{B}$ performs $\ell$ parallel ${2 \choose 1}\;\textsf{OT}$ invocations _before_ the sender sends $\lbrace  C_k \rbrace_{k \in [n]}$. A formal (and very enlightening) proof of security can be found in the original paper.

>
> ##### Example
>
> Let $n=4$ and $\ell = 2$. Let the list of key-pairs be
>
> $$ S := \lbrace (s_0^0,s_0^1), (s_1^0,s_1^1)\rbrace$$
>
> In this notation, the number in subscript
> indicates the bit position and number in superscript indicates the binary value
> present at that bit position.
>
> Based on this notation, for any index $j \in \lbrace 0,1,2,3\rbrace$, the key to be used
> when bit-0 of $j$ has value $0$ is $s_0^0$; and $s_0^1$ when its value is $1$.
> Similarly, the key to be used when bit-1 has value $0$ is $s_1^0$; and $s_1^1$
> when its value is $1$.
>
> Therefore, the tuple of keys for different indices are
>
> $$\begin{aligned}S_0
> &= (s_0^0, s_1^0) \\ S_1 &= (s_0^1,s_1^0) \\ S_2 &= (s_0^0,s_1^1) \\ S_3 &=
> (s_0^1,s_1^1) \end{aligned}$$
>
>
> Notice that for any two indexes $i,j$ where $i \neq j$, the keys $S_i$ and $S_j$ are distinct and differ in at least one key.
>
> If the semi-honest sender $\mathbb{A}$ has messages $\lbrace  x_0, x_1, x_2, x_3 \rbrace$ to send, it should compute ciphertexts as
>
> $$\begin{aligned}C_0 &= x_0 \oplus F(s_0^0, 0) \oplus F(s_1^0, 0) \\ C_1 &= x_1 \oplus F(s_0^1, 1) \oplus F(s_1^0, 1)  \\ C_2 &= x_2 \oplus F(s_0^0, 2) \oplus F(s_1^1, 2) \\ C_3 &= x_3 \oplus F(s_0^1, 3) \oplus F(s_1^1, 3) \end{aligned}$$
>
>
> Suppose the receiver $\mathbb{B}$ is interested in index $i=2$. The bit decomposition of $i$ is $\vec{2} = (0, 1)_2$ (this is LSB-first bit decomposition). The receiver should then do two oblivious transfers: One for bit position zero, with sender messages  $(s_0^0, s_1^0)$ and another one for bit position one, with sender messages  $(s_0^1, s_1^1)$. The receiver's choice bits for the first $\textsf{OT}$ is $0$ (since bit zero of $2$ has value $0$) and the receiver choice bits for the second $\textsf{OT}$ is $1$ (bit one of $2$ has value $1$). At the end of $\textsf{OT}$ invocations, receiver $\mathbb{B}$ will have access to $s_0^0$ and $s_1^1$, based on which it can compute:
>
> $$x_2 = C_2\oplus F(s_0^0, 2)\oplus F(s_1^1, 2)$$
>
>
> Privacy guarantees:
>   * The sender's privacy guarantees afforded by ${2\choose 1} \textsf{OT}$ ensures that the transfer of $s_0^0$ from messages $(s_0^0, s_0^1)$ completely hides information about $s_0^1$. Similarly the transfer of $s_1^1$ from messages $(s_1^0, s_1^1)$ completely hides information about $s_0^1$. Furthermore, for all $j \neq k$, $S_k \setminus S_j \neq \phi$, therefore $$\mathbf{Pr}\left[\widetilde{F}(S_k,\cdot) = \widetilde{F}(S_j,\cdot)\; \mid \; j \neq k \right] < \frac{1}{2^{m-1}} \leq \frac{1}{2^\lambda}$$ which ensures that the receiver cannot decrypt any message index other than $i$. This guarantees sender's privacy.
>   * The receiver's privacy guarantees afforded by ${2\choose 1} \textsf{OT}$ ensures that the bits of $i$ (i.e., $\lbrace I_k\rbrace_{k \in [ell]}$) remain hidden from the sender during individual $\textsf{OT}$ invocations. This guarantees receiver's privacy.
>

The figure below summarizes the protocol pictorially:

<figure>
<img id="n-choose-one-ot" src="/Diagrams/NChoose1OT.svg" style="margin-left:auto; margin-right:auto" alt="N choose 1 OT"/>
<figurecaption>Efficient ${n \choose 1}\; \textsf{OT}$ from oracle access to ${2 \choose 1}\; \textsf{OT}$</figurecaption>
</figure>

[^ACGS88]: W. Alexi, B. Chor, O. Goldreich, and C. P. Schnorr, "[RSA and
    Rabin Functions: Certain Parts are as Hard as the
    Whole](https://mit6875.github.io/FA23HANDOUTS/rsa-hardcore-bit.pdf){:target="_blank"}," in SIAM Journal of Computing, Vol 17, No. 2, 1988.

[^NP01]: M. Naor and B. Pinkas, "[Efficient oblivious transfer protocols](https://dl.acm.org/doi/10.5555/365411.365502){:target="_blank"}," in SODA 2001.

[^NP99]: M. Naor and B. Pinkas, "[Oblivious transfer and polynomial evaluation](https://dl.acm.org/doi/pdf/10.1145/301250.301312){:target="_blank"}," in STOC 1999.