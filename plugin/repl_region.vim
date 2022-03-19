function! ReloadAlpha()
lua << EOF
    for k in pairs(package.loaded) do 
        if k:match("^repl_region") then
            package.loaded[k] = nil
        end
    end
EOF
endfunction

command! TREPLSendLineStatement lua require("repl_region").send_repl_statement("line")
command! TREPLSendContextStatement lua require("repl_region").send_repl_statement("global")
command! TREPLReload call ReloadAlpha()
