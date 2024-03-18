data {
  int<lower=1> N;       // number of observations
  vector[N] aff_i_c;    // 
  int<lower=0> observe_i[N];   //
  vector[N] expect_i;     // 
}
parameters {
  vector[N] alpha_i;
  real beta;
}
model {
  
  //priors
  alpha_i ~ normal(0, 1);
  beta ~ normal(0, 1);
  
  // likelihood
  vector[N] log_lambda;
  for (n in 1:N) {
    log_lambda[n] = alpha_i[n] + beta * aff_i_c[n] + log(expect_i[n]);
  }
  
  observe_i ~ poisson_log(log_lambda);
}
generated quantities{
  vector[N] log_lik;
  for (n in 1:N){
    real log_lambda_hat_n = alpha_i[n] + beta * aff_i_c[n] + log(expect_i[n]);
    log_lik[n] = poisson_log_lpmf(observe_i[n] | log_lambda_hat_n);
  }
}