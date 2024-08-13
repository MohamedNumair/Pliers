using Pkg
Pkg.add(["CairoMakie", "FFMPEG"])
using CairoMakie
using LinearAlgebra
using Printf
using LaTeXStrings

# Parameters
Nf = 300
t = LinRange(0, 1, Nf)
yt = cos.(2 * π * t)
yt2 = yt .^ 2
yrms = sqrt(mean(yt2)) .+ t .* 0

# Create figure and axes
fig = Figure(resolution = (800, 900), font = "CMU Serif")

ax1 = Axis(fig[1, 1], title = "Root Mean Square",
           xlabel = "t", ylabel = L"y(t)",
           xticksvisible = true, yticksvisible = true)
ax2 = Axis(fig[2, 1], xlabel = L"t", ylabel = L"y^2(t)",
           xticksvisible = true, yticksvisible = true)
ax3 = Axis(fig[3, 1], xlabel = L"t", ylabel = L"\sqrt{ \frac{1}{T} \int_{0}^{T} y^2(t) dt}",
           xticksvisible = true, yticksvisible = true, limits = (nothing, (0, 1.5)))


           
# Plot data
lines!(ax1, t, yt, color = :red, linewidth = 3)
lines!(ax2, t, yt2, color = :blue, linewidth = 3)
lines!(ax3, t, yrms, color = :green, linewidth = 3)

# Display the plot
fig


# # Animation function
# function update_lines!(frame)
#     idx = Int(round(frame))
#     line1[1] = t[1:idx]
#     line1[2] = yt[1:idx]
#     line2[1] = t[1:idx]
#     line2[2] = yt2[1:idx]
#     line3[1] = t[1:idx]
#     line3[2] = yrms[1:idx]
#     return
# end

# # Create animation
# record(fig, "ac_rms.mp4", 1:Nf; framerate = 60) do i
#     update_lines!(i)
# end
