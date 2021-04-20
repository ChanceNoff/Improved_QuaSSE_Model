plan.model <- drake_plan(
  set.seed(1),
  phy = tree.quasse(c(lambda, mu, char), max.taxa=15, x0=0, single.lineage=FALSE), ## simulating a tree
  mytree = ape::plot.phylo(phy, type="fan", cex=0.2),
  states = phy$tip.state,
  states.sd = 1/200,
  lik = make.quasse(phy, states, states.sd, sigmoid.x, constant.x), # building liklihood, have to specify the speciation and extinction functions (here, sigmoid.x and constant.x, respectively). There are a number of other provided functions (see ?constant.x for a list), but any function that takes x as the first argument may be used.
  p = starting.point.quasse(phy, states), #function that may be useful in selecting sensible starting points, but some effort is still required to convert this into a full vector as it just returns constant rate speciation, extinction, and diffusion rates
  lik.nodrift = constrain(lik, drift ~ 0), #ignoring drift
  p.start = c(p[1], p[1], mean(states), 1, p[2:3]), #this is the sensible starting point for the simulation from the example
  p.start.named = namesforpstart(p.start, lik.nodrift),
  lower = c(0, 0, min(states), -Inf, 0, 0), #lower bounds
  fit = find.mle(lik.nodrift, p.start.named, control=list(parscale=.1),lower=lower, verbose=0, method="subplex"), #Then run find.mle, as usual. The control argument here just tells the subplex algorithm to use an initial step size of 0.1 (rather than 1), which reduces the number of function evaluations somewhat
  
  ##Compare this against the constant rate speciation fit:
  lik.constant = constrain(lik.nodrift, l.y1 ~ l.y0, l.xmid ~ 0, l.r ~ 1),
  fit.constant = find.mle(lik.constant, p.start.named[argnames(lik.constant)], control=list(parscale=.1), lower=0.0001, verbose=0), #try plotting function vs input values, or fixing lower and upper bounds
  
  #Compare the models
  anova(fit, constant=fit.constant)
)