fun! TogglTracker()
    lua for k in pairs(package.loaded) do if k:match("^toggl%-tracker") then package.loaded[k] = nil end end
    lua require("toggl-tracker").createFloatingWindow()
endfun

let g:toggl_api_key = "fe804de4d159f7d1af977d0183879319" 
augroup TogglTracker
    autocmd!
    autocmd VimResized * :lua require("toggl-tracker").onResize()
augroup END
