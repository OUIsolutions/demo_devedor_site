-- Define your request handler
function main_api_handler(request)
  -- Process the request here

    if request.route == "/api/obtem_devedor_por_cpf" then

        local devedor = request.params["devedor"]
        if not devedor then
            return  serjao.send_json({message="'devedor' não passado nos parâmetros", error=true}, 400)
        end
        local filename = "data/" .. devedor .. ".json"
        -- Verifica se o arquivo existe
        if dtw.isfile(filename) then
            return serjao.send_file(filename, "application/json")
        else
            return serjao.send_json({message="Devedor não encontrado", error=true}, 404)
        end
   end

   if request.route == "/api/obtem_devedor_por_nome" then
        local nome = request.params["nome"]
        if not nome then
            return serjao.send_json({message="'nome' não passado nos parâmetros", error=true}, 400)
        end

        -- Convert search term to lowercase for case-insensitive search
        local nome_busca = string.lower(nome)

        local files = dtw.list_files("data", true)
        for i = 1, #files do
            local current = files[i]
            local content = dtw.load_file(current)
            local parsed = json.load_from_string(content)

            -- Check if any contract has a matching nome_devedor
            if parsed.contratos then
                for j = 1, #parsed.contratos do
                    local contrato = parsed.contratos[j]
                    if contrato.nome_devedor and string.find(string.lower(contrato.nome_devedor), nome_busca, 1, true) then
                        return serjao.send_json(parsed)
                    end
                end
            end
        end

        return serjao.send_json({message="Devedor não encontrado", error=true}, 404)
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
                local encontrou = false
                
                -- Check if any contract has a matching nome_devedor
                if parsed.contratos then
                    for j = 1, #parsed.contratos do
                        local contrato = parsed.contratos[j]
                        if contrato.nome_devedor and string.find(string.lower(contrato.nome_devedor), nome_busca, 1, true) then
                            encontrou = true
                            break
                        end
                    end
                end
                
                if encontrou then
                    table.insert(devedores, parsed)
                end
            else
                table.insert(devedores, parsed)
            end
        end

        return serjao.send_json(devedores)
   end

   return serjao.send_file("index.html", "text/html")

end
