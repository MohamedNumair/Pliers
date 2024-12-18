# Printing Styles


function header(text::String)
    print(BOLD(UNDERLINE(BLUE_FG("$text\n"))))
end

function sub_header(text::String)
    print(BOLD(ITALICS(BLUE_FG("$text\n"))))
end

sub_sub_header(text::String) = print(BOLD(MAGENTA_FG("$text\n")))


function warning_text(message::String)
    print(ITALICS(YELLOW_FG("Warning: $message\n")))
end

function error_text(message::String)
    print(ITALICS(RED_FG("Error: $message\n")))
end
    

# PrettyTables Highlighting

highlight_row_label = Highlighter(
    f=(data, i, j) -> j == 1,
    crayon=Crayon(bold=true)
)

highlight_diagonal = Highlighter(
    f=(data, i, j) -> i == j-1,
    crayon=Crayon(foreground = :cyan, bold=true)
)

highlight_off_diagonal = Highlighter(
    f=(data, i, j) -> i != j-1,
    crayon=Crayon(foreground = :white, bold=true)
)

# for the results table in PMD
_highlight_results_status = Highlighter(
    f=(data, i, j) -> i==1 && string(data[i,j]) == "PF_CONVERGED",
    crayon=Crayon(foreground = :green, bold=true)
)