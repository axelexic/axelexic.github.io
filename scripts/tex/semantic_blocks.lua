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
  proof = true,
  proposition = true,
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

function Div(div)
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
