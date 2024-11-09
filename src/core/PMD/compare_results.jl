"""
    diff_vectors(vec1::Vector{Float64}, vec2::Vector{Float64})

Prints the difference between two vectors element-wise.

# Arguments
- `vec1::Vector{Float64}`: The first vector.
- `vec2::Vector{Float64}`: The second vector.

# Example

diff_vectors([1.0, 2.0, 3.0], [1.0, 2.0, 4.0])


"""
function diff_vectors(vec1::Vector{Float64}, vec2::Vector{Float64})
    green = _CRN.Crayon(foreground = :green)
    red = _CRN.Crayon(foreground = :red)
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

# Exporting
export diff_vectors