---
layout: post
title: You could have invented Weil Pairings
date: 2024-07-06
---

Bilinear pairings over Elliptic Curves has a reputation for beging difficult to understand and implement. As part of Secure Substrates outreach program, we regularily hold week-long workshops on advanced topics in Cryptography, and pairings is one of the most sought after topics in these workshops. An often cited difficulty in understanding pairings is the machinary of Algebraic Geometry (AG) needed to understand just the notation...

Fortunately, one can derive almost everything about Weil pairings from first principles without much AG machinary, if one is willing to sacrifice some generality -- namely limiting Weil pairings to prime-order groups. This blog post is a summary of  workshop presentations on this topic.

## Elliptic Curve Group Structure
