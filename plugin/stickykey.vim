" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_stickykey') && g:loaded_stickykey
    finish
endif
let g:loaded_stickykey = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Global Variables {{{
if !exists('stickykey_when_no_escaped_key')
    let stickykey_when_no_escaped_key = 'nop'
endif
" }}}

" Mappings {{{
function! s:map(modes, remap_p, lhs, rhs_func) "{{{
    for mode in split(a:modes, '\zs')
        execute
        \   printf('%s%smap', mode, (a:remap_p ? '' : 'nore'))
        \   '<silent><expr>'
        \   a:lhs
        \   printf('%s()', a:rhs_func)
    endfor
endfunction "}}}

call s:map('icsl', 0, '<Plug>(stickykey-ctrl)', 'stickykey#ctrl')
call s:map('icsl', 0, '<Plug>(stickykey-alt)', 'stickykey#alt')
call s:map('icsl', 0, '<Plug>(stickykey-shift)', 'stickykey#shift')
call s:map('icsl', 0, '<Plug>(stickykey-command)', 'stickykey#command')

call s:map('icsl', 1, '<Plug>(stickykey-ctrl-remap)', 'stickykey#ctrl')
call s:map('icsl', 1, '<Plug>(stickykey-alt-remap)', 'stickykey#alt')
call s:map('icsl', 1, '<Plug>(stickykey-shift-remap)', 'stickykey#shift')
call s:map('icsl', 1, '<Plug>(stickykey-command-remap)', 'stickykey#command')
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
