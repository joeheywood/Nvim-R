
function ROpenPDF2(fullpath)
    call system("env NVIMR_PORT=" . g:rplugin_myport .
                \ " qpdfview --unique '" . a:fullpath . "' 2>/dev/null >/dev/null &")
    if g:R_synctex && a:fullpath =~ " "
        call RWarningMsg("Qpdfview does support file names with spaces: SyncTeX backward will not work.")
    endif
endfunction

function SyncTeX_forward2(tpath, ppath, texln, tryagain)
    let texname = substitute(a:tpath, ' ', '\\ ', 'g')
    let pdfname = substitute(a:ppath, ' ', '\\ ', 'g')
    call system("NVIMR_PORT=" . g:rplugin_myport . " qpdfview --unique " .
                \ pdfname . "#src:" . texname . ":" . a:texln . ":1 2> /dev/null >/dev/null &")
    if g:rplugin_has_wmctrl
        call system("wmctrl -a '" . substitute(substitute(a:ppath, ".*/", "", ""), ".pdf$", "", "") . "'")
    endif
endfunction

if g:R_synctex && g:rplugin_nvimcom_bin_dir != "" && IsJobRunning("ClientServer") == 0 && $DISPLAY != ""
    if $PATH !~ g:rplugin_nvimcom_bin_dir
        let $PATH = g:rplugin_nvimcom_bin_dir . ':' . $PATH
    endif
    let g:rplugin_jobs["ClientServer"] = StartJob("nclientserver", g:rplugin_job_handlers)
endif
