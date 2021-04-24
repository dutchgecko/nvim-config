local mt = {
    __index = function(t, k)
        local result = rawget(t, k:lower())
        if result == nil then
            return k
        else
            return result
        end
    end,
}

local M = {
    func = "",
    ['function'] = "",
    functions = "",
    var = "",
    variable = "",
    variables = "",
    const = "",
    constant = "",
    constructor = "",
    method = "",
    package = "",
    packages = "",
    enum = "",
    enummember = "",
    enumerator = "",
    module = "",
    modules = "",
    type = "",
    typedef = "",
    types = "",
    field = "",
    fields = "",
    macro = "",
    macros = "",
    map = "פּ",
    class = "",
    augroup = "פּ",
    struct = "",
    union = "謹",
    member = "",
    target = "",
    property = "襁",
    interface = "",
    namespace = "",
    subroutine = "",
    implementation = "",
    typeParameter = "",
    default = "",
    file = '',
    array = '',
    key = '',
    null = '',
}
setmetatable(M, mt)

return M
