function! ReloadAlpha()
lua << EOF
    for k in pairs(package.loaded) do 
        if k:match("^repl_region") then
            package.loaded[k] = nil
        end
    end
EOF
endfunction

command! TREPLSendRegion lua require("repl_region").send_region()
