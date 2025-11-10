
local quantity = 50
CPF = 1
CNPJ = 2
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


for i = 1, quantity do
    local choice = math.random(1, 2)
    if choice == CPF then
        print(get_cpf())
    else
        print(get_cnpj())
    end
end
