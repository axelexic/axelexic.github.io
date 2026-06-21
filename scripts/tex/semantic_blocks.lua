local theorem_environments = {
  algorithm = true,
  aside = true,
  assumption = true,
  claim = true,
  corollary = true,
  definition = true,
  example = true,
  examples = true,
  exercise = true,
  lemma = true,
  note = true,
  notation = true,
  problem = true,
  proof = true,
  reduction = true,
  remark = true,
  theorem = true,
}

local function theorem_class(classes)
  for _, class in ipairs(classes) do
    if theorem_environments[class] then
      return class
    end
  end
  return nil
end

local function has_class(classes, expected)
  for _, class in ipairs(classes) do
    if class == expected then
      return true
    end
  end
  return false
end

local function caption_latex(blocks)
  if #blocks == 0 then
    return nil
  end

  local caption = pandoc.write(pandoc.Pandoc(blocks), "latex")
  caption = caption:gsub("^%s+", ""):gsub("%s+$", "")
  caption = caption:gsub("\n\n+", " ")
  caption = caption:gsub("\n", " ")

  if caption == "" then
    return nil
  end

  return caption
end

local function detokenize(value)
  value = value:gsub("}", "\\}")
  return "\\detokenize{" .. value .. "}"
end

local function figure_div(div)
  local src = div.attributes["src"] or ""
  local width = div.attributes["width"] or "0.8\\linewidth"
  local original_src = div.attributes["original-src"] or src
  local missing = div.attributes["missing"] == "true" or src == ""
  local caption = caption_latex(div.content)
  local latex = {
    "\\begin{figure}[htbp]",
    "\\centering",
  }

  if missing then
    table.insert(latex, "\\fbox{\\parbox{0.85\\linewidth}{\\centering Missing figure: \\texttt{" .. detokenize(original_src) .. "}}}")
  else
    table.insert(latex, "\\includegraphics[width=" .. width .. "]{" .. src .. "}")
  end

  if caption then
    table.insert(latex, "\\caption{" .. caption .. "}")
  end

  if div.identifier and div.identifier ~= "" then
    table.insert(latex, "\\label{" .. div.identifier .. "}")
  end

  table.insert(latex, "\\end{figure}")
  return { pandoc.RawBlock("latex", table.concat(latex, "\n")) }
end

function Div(div)
  if has_class(div.classes, "tex-figure") then
    return figure_div(div)
  end

  local environment = theorem_class(div.classes)
  if not environment then
    return div.content
  end

  local title = div.attributes["title"]
  local begin_environment = "\\begin{" .. environment .. "}"

  if title and title ~= "" then
    begin_environment = begin_environment .. "[" .. title .. "]"
  end

  if div.identifier and div.identifier ~= "" then
    begin_environment = begin_environment .. "\\label{" .. div.identifier .. "}"
  end

  local blocks = { pandoc.RawBlock("latex", begin_environment) }
  for _, block in ipairs(div.content) do
    table.insert(blocks, block)
  end
  table.insert(blocks, pandoc.RawBlock("latex", "\\end{" .. environment .. "}"))

  return blocks
end

function Span(span)
  return span.content
end

function RawBlock(raw)
  if raw.format:match("html") and raw.text:match("^%s*</?div") then
    return {}
  end
  return raw
end

function RawInline(raw)
  if raw.format:match("html") and raw.text:match("^%s*</?span") then
    return {}
  end
  return raw
end
