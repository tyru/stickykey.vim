" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



function! s:run()
    try
        runtime! autoload/stickykey.vim
        Ok 1, "autoload/stickykey.vim does not throw an exception."
    catch
        Ok 0, "autoload/stickykey.vim does not throw an exception."
    endtry
endfunction

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
