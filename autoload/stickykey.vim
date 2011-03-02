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

let s:CTRL    = 'C'
let s:ALT     = 'M'
let s:SHIFT   = 'S'
let s:COMMAND = 'D'    " Only *Macintosh PC* has this key.

function! stickykey#ctrl(...) "{{{
    return s:do_sticky(s:CTRL, (a:0 ? a:1 : g:stickykey_when_no_escaped_key))
endfunction "}}}
function! stickykey#ctrl_nop() "{{{
    return stickykey#ctrl("nop")
endfunction "}}}
function! stickykey#ctrl_thru() "{{{
    return stickykey#ctrl("thru")
endfunction "}}}
function! stickykey#ctrl_again() "{{{
    return stickykey#ctrl("again")
endfunction "}}}

function! stickykey#alt(...) "{{{
    return s:do_sticky(s:ALT, (a:0 ? a:1 : g:stickykey_when_no_escaped_key))
endfunction "}}}
function! stickykey#alt_nop() "{{{
    return stickykey#alt("nop")
endfunction "}}}
function! stickykey#alt_thru() "{{{
    return stickykey#alt("thru")
endfunction "}}}
function! stickykey#alt_again() "{{{
    return stickykey#alt("again")
endfunction "}}}

function! stickykey#shift(...) "{{{
    return s:do_sticky(s:SHIFT, (a:0 ? a:1 : g:stickykey_when_no_escaped_key))
endfunction "}}}
function! stickykey#shift_nop() "{{{
    return stickykey#shift("nop")
endfunction "}}}
function! stickykey#shift_thru() "{{{
    return stickykey#shift("thru")
endfunction "}}}
function! stickykey#shift_again() "{{{
    return stickykey#shift("again")
endfunction "}}}

function! stickykey#command(...) "{{{
    return s:do_sticky(s:COMMAND, (a:0 ? a:1 : g:stickykey_when_no_escaped_key))
endfunction "}}}
function! stickykey#command_nop() "{{{
    return stickykey#command("nop")
endfunction "}}}
function! stickykey#command_thru() "{{{
    return stickykey#command("thru")
endfunction "}}}
function! stickykey#command_again() "{{{
    return stickykey#command("again")
endfunction "}}}



function! s:do_sticky(key_id, opt) "{{{
    if a:opt !~# '^\%(nop\|thru\|again\|input\|mapping\)$'
        call s:warn(a:opt . ": invalid g:stickykey_when_no_escaped_key's value")
        return ''
    endif

    while 1
        " TODO When getchar(1) is false.
        let c = s:getchar()
        if getcharmod()    " If key is escaped with meta key.
            if a:opt ==# 'nop'
                return ''
            elseif a:opt ==# 'thru'
                return c
            elseif a:opt ==# 'again'
                continue
            elseif a:opt ==# 'input'
                return s:meta_key(s:get_charmod_key_id(), c)
            elseif a:opt ==# 'mapping'
                return s:meta_key(a:key_id, c)
            else
                call s:warn(a:opt . ": invalid g:stickykey_when_no_escaped_key's value")
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
    let charmod = getcharmod()
    let r = {
    \   'shift': 0,
    \   'ctrl': 0,
    \   'alt': 0,
    \   'mousedouble': 0,
    \   'mousetriple': 0,
    \   'mousequad': 0,
    \   'command': 0,
    \}
    if !charmod    " no flags are set.
        return r
    endif
    let key_table = [
    \   'shift',
    \   'ctrl',
    \   'alt',
    \   'mousedouble',
    \   'mousetriple',
    \   'mousequad',
    \   'command',
    \]
    let i = len(r) - 1
    while 1
        let j = float2nr(pow(2, i + 1))
        if charmod >= j
            let r[key_table[i]] = 1
            let charmod -= j
            if charmod < 0
                echoerr 'wtf'
            endif
        endif
        if i ==# 0
            return r
        endif
        let i -= 1
    endwhile
    echoerr 'never reach here.'
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
