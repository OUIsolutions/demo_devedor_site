
local quantity = 50
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

function validate_cpf_data(data)
    local required_fields = {
        notificacao_valida = "boolean",
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
        quantidade_parcelas = "number",
        parcela_inicial = "number",
        parcela_final = "number",
        descricao_bem = "string",
        renavam = "string",
        placa = "string",
        total_em_atraso_contrato = "string",
        total_em_atraso_extenso = "string",
        total_a_pagar = "string",
        valor_causa = "string",
        valor_causa_extenso = "string",
        data_atual = "number",
        total_em_atraso = "string"
    }
    validate_data(data, required_fields)
end

function validate_cnpj_data(data)
    local required_fields = {
        notificacao_valida = "boolean",
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
        quantidade_parcelas = "number",
        parcela_inicial = "number",
        parcela_final = "number",
        descricao_bem = "string",
        renavam = "string",
        placa = "string",
        total_em_atraso_contrato = "string",
        total_em_atraso_extenso = "string",
        total_a_pagar = "string",
        valor_causa = "string",
        valor_causa_extenso = "string",
        data_atual = "number",
        total_em_atraso = "string"
    }
    validate_data(data, required_fields)
end

function construct_element(name,model,validator)
    llm = newLLM({})
    local result = {}
    llm.add_system_prompt("use the function set_fake_data to return the json with fake data")
    llm.add_system_prompt("the json must have the same schema of the model, but not the same values,create the values randomly")
    llm.add_system_prompt("the key descricao_bem , must be only about vehicles") 
    llm.add_user_prompt("construct a json with fake data based on the following model:( " .. model..")")
    
    -- Define the callback function to handle color change
    local set_fake_data = function(args)
        local fake_data = args.fake_data
        local parsed = json.load_from_string(fake_data)
        validator(parsed)
        parsed["cpf_cnpj_devedor"]= name
        dtw.write_file("data/"..name..".json",json.dumps_to_string(parsed,true))
    end

    local parameters = {
    {
        name = "fake_data",
        description = "The json string with fake data based on the model",
        type = "string",
        required = true
    }
}
    llm.add_function("set_fake_data", "se the fake data", parameters, set_fake_data)

    response = llm.generate()
    
end

function construct_cpf()
    local cpf = get_cpf()
    construct_element(cpf, cpf_model, validate_cpf_data)
end
function construct_cnpj()
    local cnpj = get_cnpj()
    construct_element(cnpj, cnpj_model, validate_cnpj_data)
end



for i = 1, quantity do
    local choice = math.random(1, 2)
    if choice == CPF then
        construct_cpf()
    else
        construct_cnpj()
    end
end
