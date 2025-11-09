
-- Define your request handler
local function api_handler(request)
  -- Process the request here

  if request.route == "/api/obtem_devedor" then

    local devedor = request.params["devedor"]
    if not devedor then 
        return  serjao.send_text("'devedor' não passado nos parâmetros", 400)
    end
    local filename = "data/" .. devedor .. ".json"
    return serjao.send_file(filename, "application/json")
  end 


  if request.route == "/" then
    return serjao.send_file("static/paginas/principal.html", "text/html")
  end

  local page = "static/paginas/".. request.route ..".html"
  if not dtw.isfile(page) then 
    return serjao.send_text("Página não encontrada", 404)
  end
  return serjao.send_file(page, "text/html")



 


end

-- Start server with port range (will try ports 3000-5000 until one works)
serjao.server(3000, 5000, api_handler)
