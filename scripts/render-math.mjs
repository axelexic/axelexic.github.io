import MathJax from "mathjax";

const input = await readStdin();
const request = JSON.parse(input);

await MathJax.init({
  loader: {
    load: ["input/tex", "output/chtml", "[tex]/html", "[tex]/color"],
  },
  startup: {
    typeset: false,
  },
  tex: {
    inlineMath: { "[+]": [["$", "$"]] },
    displayMath: [
      ["$$", "$$"],
      ["\\[", "\\]"],
    ],
    packages: { "[+]": ["html", "color"] },
    processEscapes: true,
    processEnvironments: true,
    processRefs: true,
    tags: "ams",
    macros: {
      ZZ: "{\\mathbb{Z}}",
      NN: "{\\mathbb{N}}",
      QQ: "{\\mathbb{Q}}",
      RR: "{\\mathbb{R}}",
      CC: "{\\mathbb{C}}",
      Fp: ["\\mathbb{F}_{p^{#1}}", 1, ""],
      Fq: ["\\mathbb{F}_{q^{#1}}", 1, ""],
      ZQ: ["\\ZZ_{#1}", 1],
      Zmod: ["\\ZZ/{#1}\\ZZ", 1],
      ccp: "{\\mathsf{P}}",
      NP: "{\\mathsf{NP}}",
      coNP: "{\\mathsf{coNP}}",
      pspace: "{\\mathsf{PSPACE}}",
      np: "{\\mathsf{NP}}",
      PRIMES: "{\\mathsf{PRIMES}}",
      poly: ["\\mathsf{poly}"],
      norm: ["{\\left \\lVert {#1} \\right \\rVert }", 1],
      round: ["{\\left \\lfloor {#1} \\right \\rceil }", 1],
      floor: ["{\\left \\lfloor {#1} \\right \\rfloor }", 1],
      ceil: ["{\\left \\lceil {#1} \\right \\rceil }", 1],
      fractional: ["{\u27E6 {#1} \u27E7 }", 1],
      braket: ["{\\left \\langle {#1} \\right \\rangle }", 1],
      bra: ["{\\left \\langle {#1} \\right |}", 1],
      ket: ["{\\left | {#1} \\right \\rangle }", 1],
      braces: ["{\\lbrace {#1} \\rbrace }", 1],
      lrbraces: ["{\\left \\lbrace {#1} \\right \\rbrace }", 1],
      highlight: ["\\class{math-accent}{#1}", 1],
    },
  },
  output: {
    mtextInheritFont: true,
    merrorInheritFont: true,
    linebreaks: {
      inline: false,
    },
  },
  chtml: {
    fontURL:
      "https://cdn.jsdelivr.net/npm/@mathjax/mathjax-newcm-font@4.1.3/chtml/woff2",
  },
});

const output = Array.isArray(request)
  ? await renderExpressions(request)
  : await renderDocument(request);

process.stdout.write(JSON.stringify(output));

async function renderExpressions(items) {
  const document = await typesetDocument(
    items
      .map((item) => {
        const tag = item.display ? "div" : "span";
        const [open, close] = item.display ? ["\\[", "\\]"] : ["\\(", "\\)"];
        return `<${tag} id="${wrapperId(item.id)}">${open}${escapeHTML(item.tex)}${close}</${tag}>`;
      })
      .join(""),
    items[0]?.preamble,
  );
  const adaptor = MathJax.startup.adaptor;

  return items.map((item) => {
    const wrapper = adaptor.getElement(`#${wrapperId(item.id)}`, document.document);
    if (!wrapper) {
      throw new Error(`MathJax output wrapper is missing for expression ${item.id}`);
    }

    return {
      id: item.id,
      html: adaptor.innerHTML(wrapper),
    };
  });
}

async function renderDocument({ html, preamble }) {
  const document = await typesetDocument(html, preamble);
  const adaptor = MathJax.startup.adaptor;
  const macros = adaptor.getElement("#mathjax-server-preamble", document.document);
  if (macros) {
    adaptor.remove(macros);
  }

  const stylesheet = adaptor.getElement(
    "#MJX-CHTML-styles",
    adaptor.head(document.document),
  );
  const styles = stylesheet ? adaptor.outerHTML(stylesheet) : "";
  const body = adaptor.innerHTML(adaptor.body(document.document));

  return {
    html: styles ? `${styles}\n${body}` : body,
  };
}

async function typesetDocument(body, preamble) {
  const document = MathJax.startup.getDocument(buildDocument(body, preamble));
  await document.renderPromise();
  normalizeInheritedText(document);
  replaceStandaloneEquationReferences(document);
  return document;
}

function normalizeInheritedText(document) {
  const adaptor = MathJax.startup.adaptor;
  const body = adaptor.body(document.document);

  for (const kind of ["mjx-mtext", "mjx-merror"]) {
    for (const text of adaptor.tags(body, kind)) {
      removeInlineStyle(adaptor, text, "font-family");

      for (const content of adaptor.tags(text, "mjx-utext")) {
        removeInlineStyle(adaptor, content, "width");
      }
    }
  }

  for (const row of adaptor.tags(body, "mjx-mlabeledtr")) {
    const height = adaptor.getStyle(row, "height");
    if (height && !Number.isFinite(Number.parseFloat(height))) {
      removeInlineStyle(adaptor, row, "height");
    }
  }
}

function removeInlineStyle(adaptor, node, property) {
  adaptor.setStyle(node, property, "");
  if (!(adaptor.getAttribute(node, "style") || "").trim()) {
    adaptor.removeAttribute(node, "style");
  }
}

function replaceStandaloneEquationReferences(document) {
  const adaptor = MathJax.startup.adaptor;
  const body = adaptor.body(document.document);

  for (const reference of adaptor.elementsByClass(body, "MathJax_ref")) {
    const container = closestElement(adaptor, reference, "mjx-container");
    const referenceLink = adaptor.parent(reference);
    const math = referenceLink ? adaptor.parent(referenceLink) : null;
    const isMathRoot =
      math &&
      (adaptor.kind(math) === "mjx-math" ||
        adaptor.getAttribute(math, "data-mml-node") === "math");
    if (
      !container ||
      !referenceLink ||
      adaptor.kind(referenceLink) !== "a" ||
      !isMathRoot
    ) {
      continue;
    }

    const mathChildren = adaptor.childNodes(math);
    if (mathChildren.length !== 1 || mathChildren[0] !== referenceLink) {
      continue;
    }

    const href = adaptor.getAttribute(referenceLink, "href");
    const label = adaptor.textContent(reference).trim();
    if (!href || !label) {
      continue;
    }

    const link = adaptor.node("a", {
      class: "mathjax-eqref",
      href,
    });
    adaptor.append(link, adaptor.text(label));
    adaptor.replace(link, container);
  }
}

function closestElement(adaptor, node, kind) {
  for (let current = node; current; current = adaptor.parent(current)) {
    if (adaptor.kind(current) === kind) {
      return current;
    }
  }
  return null;
}

function buildDocument(body, preamble) {
  const cleanPreamble = cleanMathPreamble(preamble);
  const macros = cleanPreamble
    ? `<div id="mathjax-server-preamble" style="display:none">\\[${escapeHTML(cleanPreamble)}\\]</div>`
    : "";

  return `<!doctype html><html><head></head><body>${macros}${body}</body></html>`;
}

function wrapperId(id) {
  return `mathjax-server-expression-${id}`;
}

function cleanMathPreamble(preamble) {
  return String(preamble || "")
    .replace(/^\s*\\\[/, "")
    .replace(/\\\]\s*$/, "")
    .trim();
}

function escapeHTML(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
}

function readStdin() {
  return new Promise((resolve, reject) => {
    let data = "";
    process.stdin.setEncoding("utf8");
    process.stdin.on("data", (chunk) => {
      data += chunk;
    });
    process.stdin.on("end", () => resolve(data));
    process.stdin.on("error", reject);
  });
}
