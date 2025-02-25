local next_key = 0

local M = {}

M.cache = {}

--- creates a function that caches the output of a callback, indexed by bufnr
---@param cb function
---@return fun(params: NullLsParams): any
M.by_bufnr = function(cb)
    -- assign next available key, since we just want to avoid collisions
    local key = next_key
    M.cache[key] = {}
    next_key = next_key + 1

    return function(params)
        local bufnr = params.bufnr
        if not M.cache[key][bufnr] then
            M.cache[key][bufnr] = cb(params)
        end

        return M.cache[key][bufnr]
    end
end

M._reset = function()
    M.cache = {}
end

return M
