-- Replace the link emoji with a FontAwesome link icon in LaTeX/PDF
local function swap_emoji(inlines)
  for i = 1, #inlines do
    local el = inlines[i]
    if el.t == "Str" and el.text:find("🔗") and FORMAT:match("latex") then
      local text = el.text
      local seq = {}
      local pos = 1
      while true do
        local s, e = text:find("🔗", pos, true)
        if not s then
          local tail = text:sub(pos)
          if #tail > 0 then table.insert(seq, pandoc.Str(tail)) end
          break
        end
        local pre = text:sub(pos, s - 1)
        if #pre > 0 then table.insert(seq, pandoc.Str(pre)) end
        table.insert(seq, pandoc.RawInline("latex", "\\faIcon{link}"))
        pos = e + 1
      end
      inlines:remove(i)
      for j = #seq, 1, -1 do inlines:insert(i, seq[j]) end
    end
  end
  return inlines
end

function Header(h) h.content = swap_emoji(h.content); return h end
function Para(p)   p.content = swap_emoji(p.content); return p end
function Plain(p)  p.content = swap_emoji(p.content); return p end
