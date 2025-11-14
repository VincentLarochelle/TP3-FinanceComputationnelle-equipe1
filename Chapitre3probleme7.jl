# Question 3a) - Prix d'option call avec arbre binomial
S0, K, r, sigma, T, n = 36.0, 34.0, 0.02, 0.3, 28/365, 4

# Paramètres de l'arbre
delta_t = T / n
u = exp(sigma * sqrt(delta_t))
d = 1/u
p = (exp(r * delta_t) - d) / (u - d)
df = exp(-r * delta_t)

# Arbre des prix
stock = zeros(n+1, n+1)
option = zeros(n+1, n+1)

for i in 0:n, j in 0:i
    stock[j+1, i+1] = S0 * u^(i-j) * d^j
end

# Payoffs finaux
for j in 0:n
    option[j+1, n+1] = max(0, stock[j+1, n+1] - K)
end

# Rétropropagation
for i in (n-1):-1:0, j in 0:i
    option[j+1, i+1] = df * (p * option[j+1, i+2] + (1-p) * option[j+2, i+2])
end

println("3a) Prix de l'option call (arbre binomial à 4 étapes): ", round(option[1,1], digits=4))

# Question 3b) - Prix Black-Scholes et probabilité in-the-money
using Distributions

# Prix Black-Scholes
function black_scholes_call(S, K, r, sigma, T)
    d1 = (log(S/K) + (r + 0.5*sigma^2)*T) / (sigma*sqrt(T))
    d2 = d1 - sigma*sqrt(T)
    S * cdf(Normal(), d1) - K * exp(-r*T) * cdf(Normal(), d2)
end

# Probabilité que l'option termine in-the-money
function prob_in_the_money(S, K, r, sigma, T)
    d2 = (log(S/K) + (r - 0.5*sigma^2)*T) / (sigma*sqrt(T))
    cdf(Normal(), d2)
end

bs_price = black_scholes_call(S0, K, r, sigma, T)
prob_itm = prob_in_the_money(S0, K, r, sigma, T)

println("3b) Prix Black-Scholes: ", round(bs_price, digits=4))
println("3b) Probabilité in-the-money: ", round(prob_itm, digits=4))