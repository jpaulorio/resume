-- Replace the link emoji with a FontAwesome link icon in LaTeX/PDF output.

local function replace_link_emoji_inlines(inlines)
  for i = 1, #inlines do
    local el = inlines[i]
    if el.t == "Str" and el.text:find("🔗") then
      -- Replace each occurrence of the emoji with a LaTeX FA5 command
      local new = pandoc.RawInline("latex", "\\faLink{}")
      -- Split text around emoji to preserve surrounding text
      local parts = {}
      for pre, _ in el.text:gmatch("([^🔗]*)🔗") do
        table.insert(parts, pre)
      end
      local tail = el.text:match(".*🔗(.*)") or el.text
      -- Build new inline sequence: interleave text parts + icon, plus tail
      local seq = {}
      local emoji_count = select(2, el.text:gsub("🔗", ""))
      for idx, pre in ipairs(parts) do
        if pre ~= "" then table.insert(seq, pandoc.Str(pre)) end
        if idx <= emoji_count then table.insert(seq, new) end
      end
      if tail ~= "" then table.insert(seq, pandoc.Str(tail)) end
      -- Splice into the inline list
      inlines:remove(i)
      for j = #seq, 1, -1 do
        inlines:insert(i, seq[j])
      end
    end
  end
  return inlines
end

function Header(h)
  if FORMAT:match("latex") then
    h.content = replace_link_emoji_inlines(h.content)
  end
  return h
end

function Para(p)
  if FORMAT:match("latex") then
    p.content = replace_link_emoji_inlines(p.content)
  end
  return p
end

function Plain(p)
  if FORMAT:match("latex") then
    p.content = replace_link_emoji_inlines(p.content)
  end
  return p
end
