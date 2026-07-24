import MathJax from "mathjax";

const PT_SERIF_STACK = '"PT Serif", Georgia, "Times New Roman", Times, serif';
const input = await readStdin();
const request = JSON.parse(input);

await MathJax.init({
  loader: {
    load: ["input/tex", "output/svg", "[tex]/html", "[tex]/color"],
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
      textsf: ["\\mathsf{#1}", 1],
    },
  },
  output: {
    mtextInheritFont: false,
    mtextFont: PT_SERIF_STACK,
    merrorInheritFont: false,
    merrorFont: PT_SERIF_STACK,
    linebreaks: {
      inline: false,
    },
  },
  svg: {
    fontCache: "local",
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
    "#MJX-SVG-styles",
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
  deduplicateTextFontStyles(document);
  return document;
}

function deduplicateTextFontStyles(document) {
  const adaptor = MathJax.startup.adaptor;
  const textFontStyle = `font-family: ${PT_SERIF_STACK};`;

  for (const group of adaptor.tags(adaptor.body(document.document), "g")) {
    const nodeType = adaptor.getAttribute(group, "data-mml-node");
    if (nodeType !== "mtext" && nodeType !== "merror") {
      continue;
    }

    const style = adaptor.getAttribute(group, "style") || "";
    const remainingStyle = style.replace(textFontStyle, "").trim();
    if (remainingStyle) {
      adaptor.setAttribute(group, "style", remainingStyle);
    } else {
      adaptor.removeAttribute(group, "style");
    }
  }
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
