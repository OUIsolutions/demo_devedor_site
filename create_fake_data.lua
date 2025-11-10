
local quantity = 1
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


function construct_element(dest,model)
    llm = newLLM({})
    local result = {}
    llm.add_system_prompt("use the function set_fake_data to return the json with fake data")
    llm.add_system_prompt("construct a json with fake data based on the following model: " .. model)
-- Define the callback function to handle color change
    local set_fake_data = function(args)
        local fake_data = args.fake_data
        print("Fake Data: " .. fake_data)
        local parsed = json.load_from_string(args["fake_data"])
    end

    local parameters = {
    {
        name = "fake_data",
        description = "The json string with fake data based on the model",
        type = "json string",
        required = true
    }
}
    llm.add_function("set_fake_data", "se the fake data", parameters, set_fake_data)

    response = llm.generate()
    print("Response: " .. response)
    
end

function construct_cpf()
    local cpf = get_cpf()
    construct_element(cpf, cpf_model)
end
function construct_cnpj()
    local cnpj = get_cnpj()
    construct_element(cnpj, cnpj_model)
end



for i = 1, quantity do
    local choice = math.random(1, 2)
    if choice == CPF then
        construct_cpf()
    else
        construct_cnpj()
    end
end
