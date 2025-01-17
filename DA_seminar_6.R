install.packages("decisionSupport")
library(decisionSupport)
install.packages("DiagrammeR")
library (DiagrammeR)

mermaid("graph TD
        Y(Yield)-->I(Income); linkStyle 0 stroke:green, stroke-width:2px
        M(Market price)-->I; linkStyle 1 stroke: green, stroke-width:2px
        I-->F(Final result); linkStyle 2 stroke: green, stroke-width:2px
        OC(Overall costs)-->F; linkStyle 3 stroke: red, stroke-width:2px
        CL(Labor cost)-->OC; linkStyle 4 stroke: red, stroke-width:2px
        MC(Management cost)-->OC; linkStyle 5 stroke: red, stroke-width: 2px")

make_variables <- function(est,n=1)
{ x<-random(rho=est, n=n)
for(i in colnames(x)) assign(i,
                             as.numeric(x[1,i]),envir=.GlobalEnv)
}
make_variables(as.estimate(input_estimates))

Market_price

make_variables(as.estimate(input_estimates))
Labor_cost + Management_cost

input_estimates <- data.frame(variable = c("Yield", "Market_price", "Labor_cost",
                                           "Management_cost"),
                              lower = c(6000, 3, 500, 100),
                              median = NA,
                              upper = c(14000, 8, 1000, 2000),
                              distribution = c("posnorm", "posnorm", "posnorm", "posnorm"),
                              label = c("Yield (kg/ha)", "Price (USD/kg)", "Labor cost (USD/ha)", "Management cost (USD/ha)"),
                              Description = c("Yield in a sweet cherry farm under normal conditions",
                                              "Price of sweet cherry in a normal season",
                                              "Labor costs in a normal season",
                                              "Management costs in a normal season"))

input_estimates

# Add a new line of code that summarizes the Labor_cost and Management_cost 
# into overall_costs, then subtract these from the income to calculate final_result.

model_function <- function(){
  
  # Estimate the income in a normal season
  income <- Yield * Market_price
  
  # Estimate the costs as overall costs
  overall_costs<- Labor_cost + Management_cost
  
  # Estimate the final results from the model
  final_result <- income - overall_costs
  
  # Generate the list of outputs from the Monte Carlo simulation
  return(list(final_result = final_result))
}

# Run the Monte Carlo simulation using the model function
chile_mc_simulation <- mcSimulation(estimate = as.estimate(input_estimates),
                                    model_function = model_function,
                                    numberOfModelRuns = 800,
                                    functionSyntax = "plainNames")

chile_mc_simulation

plot_distributions(mcSimulation_object = chile_mc_simulation,
                   vars = "final_result",
                   method = "hist_simple_overlay",
                   old_names = "final_result",
                   new_names = "Outcome distribution for profits")




