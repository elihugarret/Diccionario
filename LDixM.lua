require "allen"
local insert = table.insert
local sort = table.sort
local concat = table.concat
local create = coroutine.create
local resume = coroutine.resume
local status = coroutine.status
local yield = coroutine.yield
local abrir = io.open
local leer = io.read
local texto = abrir("text.txt")
local out = abrir("out.txt","a+")

local palabras 

local iter = create(
  function ()
    local sus
    for linea in texto:lines() do
      sus = linea:gsub("%¿","")
                 :gsub("%?","")
                 :gsub("%!","")
                 :gsub("%¡","")
                 :gsub("\195","")
                 :gsub("\177","qw")
                 :gsub("\161","aa")
                 :gsub("\169","_e")
                 :gsub("\173","ii")
                 :gsub("\179","oo")
                 :gsub("\186","uu")
                 :gsub("\188","_u")
                 :gsub("%p","")
      --print(sus)
      palabras = words(sus)
      yield()
    end
  end
)

local tab = {}
local busc = function (arg)
    for c,v in ipairs(arg) do
      local u
      local dicc = require "LDix"
      local diccionario = abrir("LDix.lua","a+")
      u = lowerFirst(v)
      if not dix[u] then
        print(u,"\nIngrese: ")
        local ag = leer()
        diccionario:write("\ndix['"..u.."'] "..'='.." '"..ag.."'")
        insert(tab,u.."  "..ag)
      else
        print(repl,dix[u])
        insert(tab,u.."  "..dix[u])
      end
      diccionario:close()
      package.loaded.LDix = nil
    end
  end

function escribir(t)
  local repl 
  for x, y in ipairs(t) do
    repl = y:gsub("aa","á")
                :gsub("_e","é")
                :gsub("ii","í")
                :gsub("qw","ñ")
                :gsub("oo","ó")
                :gsub("uu","ú")
                :gsub("_u","ü")
    out:write("\n"..repl.."\n")
  end
end

while true do
  resume(iter)
  if status(iter) == "dead" then break end
  busc(palabras)
end

sort(tab) -- Comentar para no ordenar las palabras en orden alfabético

escribir(tab)
out:close()
texto:close()
os.exit()
