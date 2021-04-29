fun! TogglTracker()
    lua for k in pairs(package.loaded) do if k:match("^toggl%-tracker") then package.loaded[k] = nil end end
    lua require("toggl-tracker").createFloatingWindow()
endfun

let g:toggl_api_key = "6deeefd58c4e5587b0d68a00c4e911e0" 
augroup TogglTracker
    autocmd!
    autocmd VimResized * :lua require("toggl-tracker").onResize()
augroup END
