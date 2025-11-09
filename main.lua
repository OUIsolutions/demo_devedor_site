
-- Define your request handler
local function server_api_handler(request)
  -- Process the request here
  os.execute("git pull")
  relative_load("main_api_handler.lua")
    return main_api_handler(request)

end

-- Start server with port range (will try ports 3000-5000 until one works)
serjao.server(3000, 5000, server_api_handler)