" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



" TODO
" - Support mapmode-nxo (using feedkeys()).
" - Like CapsLock, consistent sticky key.
" -- submode.vim can't map this.
"    because submode.vim does not support
"    mapping with arpeggio.vim

let s:CTRL = 'C'
let s:ALT = 'M'
let s:SHIFT = 'S'
let s:COMMAND = 'D'    " Only Macintosh has this key.

function! stickykey#ctrl() "{{{
    return s:do_sticky(s:CTRL)
endfunction "}}}

function! stickykey#alt() "{{{
    return s:do_sticky(s:ALT)
endfunction "}}}

function! stickykey#shift() "{{{
    return s:do_sticky(s:SHIFT)
endfunction "}}}

function! stickykey#command() "{{{
    return s:do_sticky(s:COMMAND)
endfunction "}}}



function! s:do_sticky(key_id) "{{{
    let opt = g:stickykey_when_no_escaped_key
    if opt !~# '^\%(nop\|thru\|again\|input\|mapping\)$'
        call s:warn(opt . ": invalid g:stickykey_when_no_escaped_key's value")
        return ''
    endif

    while 1
        " TODO When getchar(1) is false.
        let c = s:getchar()
        if getcharmod()    " If key is escaped with meta key.
            if opt ==# 'nop'
                return ''
            elseif opt ==# 'thru'
                return c
            elseif opt ==# 'again'
                continue
            elseif opt ==# 'input'
                return s:meta_key(s:get_charmod_key_id(), c)
            elseif opt ==# 'mapping'
                return s:meta_key(a:key_id, c)
            else
                call s:warn(opt . ": invalid g:stickykey_when_no_escaped_key's value")
                return ''
            endif
        else
            return s:meta_key(a:key_id, c) 
        endif
    endwhile

    call s:warn('sorry, internal error.')
endfunction "}}}



function! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction "}}}

function! s:getchar(...) "{{{
    let c = call('getchar', a:000)
    return type(c) == type("") ? c : nr2char(c)
endfunction "}}}

function! s:getcharmod() "{{{
    let mod = getcharmod()
    return {
    \   'shift': mod / 2 % 2,
    \   'control': mod / 4 % 2,
    \   'alt': mod / 8 % 2,
    \   'meta': mod / 16 % 2,
    \   'mousedouble': mod / 32 % 4 is 1,
    \   'mousetriple': mod / 32 % 4 is 2,
    \   'mousequad': mod / 32 % 4 is 3,
    \   'command': mod / 128 % 2,
    \}
endfunction "}}}

function! s:get_charmod_key_id() "{{{
    if !getcharmod()
        echoerr "s:get_charmod_key_id(): getcharmod() returned 0."
        return s:CTRL
    endif

    let charmod = s:getcharmod()
    let check_order = [
    \   'shift',
    \   'ctrl',
    \   'alt',
    \   'command',
    \]
    let charmod2key_id = {
    \   'shift': s:SHIFT,
    \   'ctrl': s:CTRL,
    \   'alt': s:ALT,
    \   'command': s:COMMAND,
    \}
    for key in check_order
        if charmod[key]
            return charmod2key_id[key]
        endif
    endfor

    echoerr 'never reach here.'
endfunction "}}}

function! s:meta_key(key_id, char) "{{{
    return eval(printf('"\<%s-%s>"', a:key_id, a:char))
endfunction "}}}



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
