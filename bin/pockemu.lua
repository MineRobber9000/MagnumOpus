term.clear()
term.setCursorPos(1,1)
name = "Pockemu V1.1"
args = { ... }
program = table.concat(args, " ")
if program == "" then
  error("Usage: pockemu <program name>")
end
local function inAlphabet(k)
  local alphabet = "abcdefghijklmnopqrstuvwxyz"
  for i=1,#alphabet do
    if k==keys[alphabet:sub(i,i)] then return true end
  end
  return false
end
local function anykey(msg)
  print(msg and msg or "Press any key to continue...")
  local tEvent = { os.pullEvent("key") }
  if inAlphabet(tEvent[2]) then os.pullEvent("char") end
end
pakpromptcalled = false
local function run(cmd)
  oldTerm = term.redirect(term.native())
  shell.run("pockemu "..cmd)
  term.redirect(oldTerm)
  term.setCursorPos(1,1)
  term.clear()
end
x, y = term.getSize()
term.clear()
windowWidth = 26
windowHeight = y
windowBox = window.create(term.current(), 1, 1, windowWidth, windowHeight, true)
_G.pocket = {}
_G.pockemu = {}
_G.pockemu.anykey = anykey
_G.pockemu.run = run
term.setBackgroundColour(colours.white)
for x1 = windowWidth + 1, x do
  for y1 = 1, y do
    term.setCursorPos(x1, y1)
    write(" ")
  end
end
term.setTextColour(colours.black)
term.setCursorPos(x/2 + (windowWidth + 1) / 2 - #name / 2, y/2)
print(name)
term.setBackgroundColour(colours.black)
term.setTextColour(colours.white)
oldTerm = term.redirect(windowBox)
shell.run(program)
term.redirect(oldTerm)
term.clear()
term.setCursorPos(1,1)
windowBox = nil
_G.pocket = nil
_G.pockemu = nil
