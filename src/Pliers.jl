module Pliers


# data structure
using DataFrames
using CSV
using FileIO

# pretty terminal packages
using Crayons
using Crayons.Box
using PrettyTables

# plotting packages
using Makie
using CairoMakie
using WGLMakie
using GLMakie
using GraphMakie

# data analysis packages
import Statistics
using LinearAlgebra
using Graphs
using MetaGraphs
# using Dates
# using StatsPlots
# using StatsBase
# using Distributions
# using Random  

# Power Distribution Tools
import PowerModelsDistribution
# import PowerModelsDistributionStateEstimation


# pkg const
const pkg_name = "Pliers"
const BASE_DIR = dirname(@__DIR__)


# data structure
const _DF = DataFrames
const _CSV = CSV

# pretty terminal packages
const _CRN = Crayons
const _PT = PrettyTables

# plotting packages
const _MK = Makie
const _CMK = CairoMakie
const _WGLMK = WGLMakie
const _GLMK = GLMakie

# data analysis packages
const _STAT = Statistics

# Power Distribution Tools
# const _PMD = PowerModelsDistribution
# const _PMDSE = PowerModelsDistributionStateEstimation

author() = println("This package was developped by Mohamed Numair")


# included functionalities


# helper functions
include("core/styles.jl")
include("core/utils.jl")
include("core/PMD/results_explorer.jl")
include("core/PMD/eng_explorer.jl")
include("core/PMD/network_plotting.jl")
include("core/export.jl")

include("io/load-networks.jl")


end # module Pliers
