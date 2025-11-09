
-- Define your request handler
local function api_handler(request)
  -- Process the request here

    if request.route == "/api/obtem_devedor_por_cpf" then

        local devedor = request.params["devedor"]
        if not devedor then 
            return  serjao.send_text("'devedor' não passado nos parâmetros", 400)
        end
        local filename = "data/" .. devedor .. ".json"
        return serjao.send_file(filename, "application/json")
   end 
   if request.route == "/api/listar_devedores" then
        local files = dtw.list_files("data",true)
        local devedores = {}
        for i = 1,#files do
            local current = files[i] 
            local content = dtw.load_file(current)
            local parsed = json.load_from_string(content)
            table.insert(devedores, parsed)
        end 
        return devedores
   end

   return serjao.send_file("index.html", "text/html")






end

-- Start server with port range (will try ports 3000-5000 until one works)
serjao.server(3000, 5000, api_handler)
