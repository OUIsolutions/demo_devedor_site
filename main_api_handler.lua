
-- Define your request handler
function main_api_handler(request)
  -- Process the request here

    if request.route == "/api/obtem_devedor_por_cpf" then

        local devedor = request.params["devedor"]
        if not devedor then
            return  serjao.send_text("'devedor' não passado nos parâmetros", 400)
        end
        local filename = "data/" .. devedor .. ".json"
        -- Verifica se o arquivo existe
        if dtw.isfile(filename) then
            return serjao.send_file(filename, "application/json")
        else
            return serjao.send_text("Devedor não encontrado", 404)
        end
   end

   if request.route == "/api/obtem_devedor_por_nome" then
        local nome = request.params["nome"]
        if not nome then
            return serjao.send_text("'nome' não passado nos parâmetros", 400)
        end

        -- Convert search term to lowercase for case-insensitive search
        local nome_busca = string.lower(nome)

        local files = dtw.list_files("data", true)
        for i = 1, #files do
            local current = files[i]
            local content = dtw.load_file(current)
            local parsed = json.load_from_string(content)

            -- Check if nome_devedor contains the search term (case-insensitive)
            if parsed.nome_devedor and string.find(string.lower(parsed.nome_devedor), nome_busca, 1, true) then
                return parsed
            end
        end

        return serjao.send_text("Devedor não encontrado", 404)
   end

   if request.route == "/api/listar_devedores" then
        local nome_filtro = request.params["nome"]
        local files = dtw.list_files("data", true)
        local devedores = {}

        for i = 1, #files do
            local current = files[i]
            local content = dtw.load_file(current)
            local parsed = json.load_from_string(content)

            -- If nome_filtro is provided, only include matching debtors
            if nome_filtro then
                local nome_busca = string.lower(nome_filtro)
                if parsed.nome_devedor and string.find(string.lower(parsed.nome_devedor), nome_busca, 1, true) then
                    table.insert(devedores, parsed)
                end
            else
                table.insert(devedores, parsed)
            end
        end

        return devedores
   end

   return serjao.send_file("index.html", "text/html")



end
