function diff_vectors(vec1::Vector{Float64}, vec2::Vector{Float64})
    green = Crayon(foreground = :green)
    red = Crayon(foreground = :red)
    display(vec1)
    display(vec2)
    println("diff :")
    for (num1, num2) in zip(vec1, vec2)
        str1 = string(num1)
        str2 = string(num2)
    
        # Ensure the strings have the same length for comparison
        len = max(length(str1), length(str2))
        str1 = rpad(str1, len)
        str2 = rpad(str2, len)
    
        for (d1, d2) in zip(str1, str2)
            if d1 == d2
                print(green(string(d1)))
            else
                print(red(string(d2)))
            end
        end
        println()  # Newline after each comparison    
    end
end
