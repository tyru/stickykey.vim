" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


let g:__stickeykey_test_called_do_sticky = 0
function! s:hook_do_sticky() "{{{
    redir => output
    silent scriptnames
    redir END

    let sid = ''
    for l in split(output, '\n')
        let m = matchlist(l, '^\s*\(\d\+\):')
        if !empty(m)
            let sid = m[1]
            break
        endif
    endfor
    if sid == ''
        return 0
    endif

    try
        execute join([
        \   'function! <SNR>' . sid . '_do_sticky()',
        \       'let g:__stickeykey_test_called_do_sticky = 1',
        \   'endfunction',
        \], "\n")
    catch
        return 0
    endtry

    return 1
endfunction "}}}

function! s:do_normal(key) "{{{
    let g:__stickeykey_test_called_do_sticky = 0
    execute 'normal' a:key
    Ok g:__stickeykey_test_called_do_sticky
endfunction "}}}

function! s:run() "{{{
    if !s:hook_do_sticky()
        Skip "error: could not hook s:do_sticky()"
        \  . " in autoload/stickykey.vim"
    endif

    for mod in ['-ctrl', '-alt', '-shift']
    \           + (has('mac') ? ['-command'] : [])
        for opt in ['', '-nop', '-thru', '-again']
            for remap in ['', '-remap']
                let key =
                \   printf("(stickeykey%s%s%s)",
                \           mod,
                \           opt,
                \           remap)
                Diag '<Plug>' . key
                call s:do_normal("\<Plug>" . key)
            endfor
        endfor
    endfor
endfunction "}}}

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
