# Pliers.jl


<img src="Pliers-logo.png" align="left" width="200" alt="PowerModelsDistribution logo"> 


Pliers.jl is a collection of tools that I usually need (like pliers for an electrician) for analyzing power distribution systems. It is designed to be used in conjunction with the [PowerModelsDistribution.jl](https://github.com/lanl-ansi/PowerModelsDistribution.jl) or [PowerModelsDistributionStateEstimation.jl](https://github.com/Electa-Git/PowerModelsDistributionStateEstimation.jl) packages for simplified reporting, analysis and visualization.

Other relevant Power System Distribution tools and packages can be also supports, e.g., converting different formats into each other. 

The package is still in very early development, so please report any issues you encounter.


# Pliers Products

## Pliers Explorer
Explore: This part is designed to read, manipulate and add to the data structures (mostly dictionaries) of the network models and results.
Visualize: it can be used to tabularize and visualize the network models and results in a more user-friendly way.
Analyze: It can be used to analyze the network models and results in a more user-friendly way.

## Pliers Scenario Builder
This part it designed to streamline the scenarios and case studies creation process. It can be used to create different scenarios by changing the network models and results as a funciton of a number of variable. This is ultimately useful for sensitivity analysis and optimization. Additionally, this can be a basis for reproducible research.

## Pliers Data Pipleline
Format Converter: This part is designed to streamline the data pipeline process. It can be used to convert different formats into each other. This is ultimately useful for data integration and data analysis.
API reader: Additionally it should be able to communicate with different Open Data API, to retrieve data from different sources needed for different studies and convert it to suitable format.
Database reader: It should be able to read data from different databases and convert it to suitable format.


