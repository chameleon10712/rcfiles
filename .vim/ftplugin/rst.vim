setlocal softtabstop=2
setlocal shiftwidth=2

" Add a line under a rst title
nnoremap <buffer> <silent> t0 :call Title("==")<CR>
nnoremap <buffer> <silent> t1 :call Title("=")<CR>
nnoremap <buffer> <silent> t2 :call Title("-")<CR>
nnoremap <buffer> <silent> t3 :call Title("~")<CR>
nnoremap <buffer> <silent> t4 :call Title('"')<CR>
nnoremap <buffer> <silent> t5 :call Title("'")<CR>
nnoremap <buffer> <silent> t6 :call Title("`")<CR>

function! Title(i_title_char) " {{{
    let title_char = a:i_title_char
    let t0 = 0

    if l:title_char ==# "=="
        let t0 = 1
        let l:title_char = "="

    elseif len(l:title_char) != 1
        return

    endif

    let orig_row = line('.')
    let orig_col = col('.')
    let line = getline('.')

    let title_pattern = '^\([^a-zA-Z]\)\1*$'
    if l:line =~# l:title_pattern
        " the cursor is on the title line
        if getline(l:orig_row + 2) =~# l:title_pattern
            " the cursor is on the t0 upper line
            call cursor(l:orig_row + 1, col('.'))

        else
            " the cursor is on the t0 lower line
            call cursor(l:orig_row - 1, col('.'))

        endif

    endif

    if getline(line('.') - 1) =~# l:title_pattern
        " remove the t0 upper line
        normal! kdd
        call cursor(line('.'), l:orig_col)
    endif

    let title_string = repeat(l:title_char, strdisplaywidth(l:line))
    let next_line_content = getline(line('.') + 1)

    if l:next_line_content ==# ''
        call append('.', l:title_string)

    elseif l:next_line_content =~# l:title_pattern
        call setline(line('.')+1, l:title_string)

    else
        call append('.', '')
        call append('.', l:title_string)

    endif

    if l:t0
        call append(line('.') - 1, l:title_string)
    else
        call cursor(l:orig_row, col('.'))
    endif

endfunction " }}}

nnoremap <buffer> <silent> < :call ShiftIndent("LEFT")<CR>
nnoremap <buffer> <silent> > :call ShiftIndent("RIGHT")<CR>
vnoremap <buffer> <silent> < :call ShiftIndent("LEFT")<CR>gv
vnoremap <buffer> <silent> > :call ShiftIndent("RIGHT")<CR>gv

let s:blpattern = '^ *[-*+] \+\([^ ].*\)\?$'
let s:elpattern1 = '^ *\d\+\. \+\([^ ].*\)\?$'
let s:elpattern2 = '^ *#\. \+\([^ ].*\)\?$'

function! ShiftIndent (direction) " {{{
    let cln = line('.')
    let clc = getline(l:cln)
    let tmp = ParseBullet(l:clc)
    let clc_pspace = l:tmp[0]
    let clc_bullet = l:tmp[1]
    let clc_text   = l:tmp[2]
    let remain_space = l:clc_pspace % (&shiftwidth)

    if a:direction ==# "LEFT"
        let pspace_num = strlen(l:clc_pspace) - ((l:remain_space != 0) ? (l:remain_space) : &shiftwidth)
        let l:pspace_num = (l:pspace_num < 0) ? 0 : (l:pspace_num)

    else
        let pspace_num = strlen(l:clc_pspace) + ((l:remain_space != 0) ? (&shiftwidth - l:remain_space) : &shiftwidth)

    endif

    let result_line = repeat(' ', l:pspace_num) . l:clc_text

    if l:clc_bullet != ''
        let llc_pspace = ''
        let llc_bullet = ''
        let i = l:cln - 1
        while l:i > 0
            let tmp = ParseBullet(getline(l:i))
            let llc_pspace = l:tmp[0]
            let llc_bullet = l:tmp[1]
            let llc_text   = l:tmp[2]
            if l:llc_text != '' && l:llc_bullet == ''
                break
            elseif l:llc_bullet != ''
                if strlen(l:llc_pspace) < l:pspace_num
                    let llc_pspace = ''
                    break
                elseif strlen(l:llc_pspace) == l:pspace_num
                    break
                endif
            endif

            let l:i = l:i - 1
        endwhile

        if strlen(l:llc_pspace) != l:pspace_num || l:llc_bullet == ''
            if l:clc_bullet =~# '^[-*+]$'
                let new_bullet = "*-+"[(l:pspace_num / &shiftwidth) % 3]
            else
                let new_bullet = l:clc_bullet
            endif

        elseif l:llc_bullet =~# '^[-*+]$'
            " last line is a bulleted list item
            let new_bullet = "*-+"[(l:pspace_num / &shiftwidth) % 3]

        elseif l:llc_bullet == '#.'
            " last line is a (lazy) enumerate list item
            let new_bullet = '#.'

        elseif l:llc_bullet =~# '^\d\+\.$'
            " last line is a enumerate list item
            let new_bullet = (l:llc_bullet + 1) .'.'

        endif
        let bullet_space = repeat(' ', &softtabstop - ((l:pspace_num + strlen(l:new_bullet)) % (&softtabstop)) )
        let result_line = repeat(' ', l:pspace_num). l:new_bullet . l:bullet_space . l:clc_text

    endif

    call setline('.', l:result_line)
    normal! ^

endfunction " }}}

function! ParseBullet (line) " {{{
    let pspace = matchstr(a:line, '^ *')
    let bullet = ''
    if a:line =~# s:blpattern
        let bullet = matchstr(a:line, '\(^ *\)\@<=[-*+]\( \+\([^ ].*\)\?$\)\@=')
        let text = matchstr(a:line, '\(^ *[-*+] \+\)\@<=\([^ ].*\)\?$')

    elseif a:line =~# s:elpattern1
        let bullet = matchstr(a:line, '\(^ *\)\@<=\d\+\.\( \+\([^ ].*\)\?$\)\@=')
        let text = matchstr(a:line, '\(^ *\d\+\. \+\)\@<=\([^ ].*\)\?$')

    elseif a:line =~# s:elpattern2
        let bullet = matchstr(a:line, '\(^ *\)\@<=#\.\( \+\([^ ].*\)\?$\)\@=')
        let text = matchstr(a:line, '\(^ *#\. \+\)\@<=\([^ ].*\)\?$')

    else
        let bullet = ''
        let text = matchstr(a:line, '\(^ *\)\@<=[^ ].*$')

    endif

    "echom '['. l:pspace .']['. l:bullet .']['. l:text .']'
    return [l:pspace, l:bullet, l:text]
endfunction " }}}

inoremap <buffer> <silent> <leader>b <ESC>:call CreateBullet()<CR>a
function! CreateBullet () " {{{
    let cln = line('.')
    let clc = getline(l:cln)
    let tmp = ParseBullet(l:clc)
    let clc_pspace = l:tmp[0]
    let clc_bullet = l:tmp[1]
    let clc_text   = l:tmp[2]
    let pspace_num = strlen(l:clc_pspace)

    let i = l:cln - 1
    while l:i > 0
        let tmp = ParseBullet(getline(l:i))
        let llc_pspace = l:tmp[0]
        let llc_bullet = l:tmp[1]
        let llc_text   = l:tmp[2]
        if l:llc_text != '' && l:llc_bullet == ''
            let llc_pspace = ''
            break
        elseif l:llc_bullet != ''
            break
        endif

        let l:i = l:i - 1
    endwhile

    let pspace_num = strlen(l:llc_pspace)

    if l:llc_bullet == ''
        let new_bullet = "*-+"[(l:pspace_num / &shiftwidth) % 3]

    elseif l:llc_bullet =~# '^[-*+]$'
        " last line is a bulleted list item
        let new_bullet = "*-+"[(l:pspace_num / &shiftwidth) % 3]

    elseif l:llc_bullet == '#.'
        " last line is a (lazy) enumerate list item
        let new_bullet = '#.'

    elseif l:llc_bullet =~# '^\d\+\.$'
        " last line is a enumerate list item
        let new_bullet = (l:llc_bullet + 1) .'.'

    endif

    let bullet_space = repeat(' ', &softtabstop - ((l:pspace_num + strlen(l:new_bullet)) % (&softtabstop)) )
    let result_line = repeat(' ', l:pspace_num). l:new_bullet . l:bullet_space . l:clc_text
    call setline(l:cln, l:result_line)
    call cursor(l:cln, strlen(l:result_line))

endfunction " }}}
