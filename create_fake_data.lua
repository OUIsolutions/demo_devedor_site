
local quantity = 550
CPF = 1
CNPJ = 2

local cpf_model = dtw.load_file("models/cpf.json")
local cnpj_model = dtw.load_file("models/cnpj.json")

function generate_randon_value(size)
    local text = ""
    for i = 1, size do
        text = text .. math.random(0, 9)
    end
    return text
end
function get_cpf()
    return generate_randon_value(11)
end
function get_cnpj()
    return generate_randon_value(14)
end

function validate_bem(b)
    local required_fields = {
        descricao_bem = "string",
        renavam = "string",
        placa = "string"
    }

    validate_data(b, required_fields)
end


function validate_contrato(c)
    local required_fields = {
        nome_devedor = "string",
        cpf_cnpj_devedor = "string",
        endereco_devedor = "string",
        comarca = "string",
        uf = "string",
        cep = "string",
        email_devedor = "string",
        numero_contrato = "string",
        data_emissao = "number",
        valor_contrato = "string",
        total_em_atraso_contrato = "string",
        quantidade_parcelas = "number",
        parcela_inicial = "number",
        parcela_final = "number",
        bens = "table"
    }

    validate_data(c, required_fields)

    if #c.bens < 1 then
        error("bens deve ter pelo menos 1 item")
    end

    for _, bem in ipairs(c.bens) do
        validate_bem(bem)
    end
end


function validate_notificacao(data)

    local required_root = {
        notificacao_valida = "boolean",
        total_em_atraso_extenso = "string",
        total_a_pagar = "string",
        total_a_pagar_extenso = "string",
        valor_causa = "string",
        valor_causa_extenso = "string",
        data_atual = "number",
        data_calculo = "number",
        total_em_atraso = "string",
        contratos = "table"
    }

    validate_data(data, required_root)

    if #data.contratos < 1 then
        error("contratos deve ter pelo menos 1 contrato")
    end


    for _, contrato in ipairs(data.contratos) do
        validate_contrato(contrato)
    end
end


function validate_data(data, required_fields)
    local missing_fields = {}
    local type_errors = {}
    
    for field_name, expected_type in pairs(required_fields) do
        if data[field_name] == nil then
            table.insert(missing_fields, field_name)
        else
            local actual_type = type(data[field_name])
            if actual_type ~= expected_type then
                table.insert(type_errors, field_name .. " (expected " .. expected_type .. ", got " .. actual_type .. ")")
            end
        end
    end
    
    if #missing_fields > 0 then
        error("Missing required fields: " .. table.concat(missing_fields, ", "))
    end
    
    if #type_errors > 0 then
        error("Type validation errors: " .. table.concat(type_errors, ", "))
    end
end

function construct_element(name, model)
    llm = newLLM({})
    
    llm.add_system_prompt("use the function set_fake_data to return the json with fake data")
    llm.add_system_prompt("the json must have the same schema of the model, but not the same values, create the values randomly")
    llm.add_system_prompt("the json MUST contain between 1 and 3 contracts inside the key 'contratos'")
    llm.add_system_prompt("each contract MUST contain between 1 and 3 items in the key 'bens'")
    llm.add_system_prompt("each 'descricao_bem' MUST describe a vehicle")
    llm.add_user_prompt("construct a json with fake data based on the following model: (" .. model .. ")")
    
    local set_fake_data = function(args)
        local ok, result = pcall(function()
            local fake_data = args.fake_data
            local parsed = json.load_from_string(fake_data)

            validate_notificacao(parsed)

            parsed.contratos[1].cpf_cnpj_devedor = name

            local output = json.dumps_to_string(parsed, true)
            dtw.write_file("data/" .. name .. ".json", output)

        end)

        if not ok then
            print("ERROR IN set_fake_data:", result)
        end
    end

    llm.add_function("set_fake_data", "set the fake data", {
        {
            name = "fake_data",
            description = "The json string with fake data based on the model",
            type = "string",
            required = true
        }
    }, set_fake_data)

    llm.generate()
end

function construct_cpf()
    construct_element(get_cpf(), cpf_model)
end

function construct_cnpj()
    construct_element(get_cnpj(), cnpj_model)
end


for i = 1, quantity do
    local choice = math.random(1, 2)
    if choice == CPF then
        construct_cpf()
    else
        construct_cnpj()
    end
end
