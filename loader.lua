-- ============================================
-- LOADER UNIFICADO PARA SISTEMA DE VALIDACIÓN
-- ============================================

local key = "ZEN-PERM-7K4M-Q9TX"  -- 👈 CAMBIA ESTO POR TU KEY

-- ============================================
-- DETECCIÓN DE HTTP FUNCTIONS
-- ============================================

local http_request = nil

-- Synapse X / Synapse Z
if syn and syn.request then
    http_request = function(url, method)
        local response = syn.request({
            Url = url,
            Method = method or "GET"
        })
        return response.Body
    end
end

-- Krnl
if not http_request and request then
    http_request = function(url, method)
        local response = request({
            Url = url,
            Method = method or "GET"
        })
        return response.Body
    end
end

-- ScriptWare / Vega X
if not http_request and http and http.request then
    http_request = function(url, method)
        local response = http.request({
            Url = url,
            Method = method or "GET"
        })
        return response.Body
    end
end

-- Electron
if not http_request and http_request then
    http_request = function(url, method)
        local response = http_request({
            Url = url,
            Method = method or "GET"
        })
        return response.Body
    end
end

-- Fallback: game:HttpGet (Roblox)
if not http_request then
    http_request = function(url, method)
        return game:HttpGet(url)
    end
end

-- ============================================
-- DECODIFICAR JSON
-- ============================================

local function decode_json(text)
    if game and game:GetService("HttpService") then
        return game:GetService("HttpService"):JSONDecode(text)
    end
    return nil
end

-- ============================================
-- FUNCIÓN PRINCIPAL
-- ============================================

local function load_script()
    print("🚀 Cargando script protegido...")
    
    -- 1. Validar key
    local validate_url = "https://zen-key-api.ea0066777.workers.dev/validate?key=" .. key
    local response_body = http_request(validate_url, "GET")
    local data = decode_json(response_body)
    
    if not data or not data.valid then
        error("❌ Key inválida: " .. (data and data.error or "error desconocido"))
    end
    
    local access_token = data.access_token
    print("✅ Key validada")

    -- 2. Obtener script
    local script_url = "https://zen-key-api.ea0066777.workers.dev/script?token=" .. access_token
    local script_content = http_request(script_url, "GET")
    
    if script_content:sub(1, 10) == '{"error":' then
        error("❌ Error del servidor: " .. script_content)
    end
    
    print("✅ Script descargado (" .. string.len(script_content) .. " caracteres)")

    -- 3. Ejecutar script
    print("🚀 Ejecutando script...")
    local func, err = loadstring(script_content)
    if func then
        func()
        print("✅ Script ejecutado correctamente")
    else
        error("❌ Error al compilar: " .. tostring(err))
    end
end

-- Ejecutar
pcall(load_script)
