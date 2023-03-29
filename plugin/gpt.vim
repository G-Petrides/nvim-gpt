" in plugin/gpt.vim
if exists('g:loaded_gpt') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" command to run our plugin
command! -nargs=? Gpt lua require'gpt'.printMessage(vim.fn.expand('<args>'))

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_gpt = 1
