local registry = require("mason-registry")
local ensure_installed = {
    'eslint-lsp',
    'gopls',
    'prettierd',
    'stylelint-lsp',
    'typescript-language-server',
    'yamlfmt'
}

local function ensure_installed_packages()
    local packages_to_install = {}
    for _, package in ipairs(ensure_installed) do
        if not registry.is_installed(package) then
            table.insert(packages_to_install, package)
        end
    end

    if #packages_to_install > 0 then
        vim.cmd("MasonInstall " .. table.concat(packages_to_install, " "))
    end
end

if registry.refresh then
    registry.refresh(ensure_installed_packages)
else
    ensure_installed_packages()
end

