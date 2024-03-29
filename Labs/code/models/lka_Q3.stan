
data {
  int<lower=0> N; // number of observations
  int<lower=0> T; //number of years
  int<lower=0> P; //number of projections
  int<lower=0> mid_year; // mid-year of study
  vector[N] y; //log ratio
  vector[N] se; // standard error around observations
  vector[T] years; // unique years of study
  int<lower=0> year_i[N]; // year index of observations
  
}

parameters {
  real<lower=-1,upper=1> rho;
  real<lower=0> sigma_mu;
  vector[T] mu;
}

model {
  
  //likelihood
  y ~ normal(mu[year_i], se);
  mu[1] ~ normal(0, sigma_mu/sqrt(1-rho^2));
  mu[2:T] ~ normal(rho * mu[1:(T-1)], sigma_mu);
  
  //priors
  rho ~ uniform(-1, 1);
  sigma_mu ~ normal(0, 1);
}

generated quantities {

  vector[P] future_mu; 
  future_mu[1] = normal_rng(rho * mu[T], sigma_mu);
  for (p in 2:P) {
    future_mu[p] = normal_rng(rho * future_mu[p-1], sigma_mu);
  }
}
