using Distributions

S0, K, r, σ, T, n = 36.0, 34.0, 0.02, 0.3, 28/365, 4

function binomial_call(S0, K, r, σ_func, T, n)
    Δt, opt, stock = T/n, zeros(n+1,n+1), zeros(n+1,n+1)
    
    for i in 0:n, j in 0:i
        σ_curr = σ_func(i)
        u, d = exp(σ_curr*√Δt), exp(-σ_curr*√Δt)
        stock[j+1,i+1] = S0 * u^(i-j) * d^j
    end
    
    for j in 0:n opt[j+1,n+1] = max(0, stock[j+1,n+1] - K) end
    
    for i in (n-1):-1:0, j in 0:i
        σ_curr = σ_func(i)
        u, d = exp(σ_curr*√Δt), exp(-σ_curr*√Δt)
        p, df = (exp(r*Δt)-d)/(u-d), exp(-r*Δt)
        opt[j+1,i+1] = df * (p * opt[j+1,i+2] + (1-p) * opt[j+2,i+2])
    end
    return opt[1,1]
end

# 4a) Volatilité +10% par semaine
price_4a = binomial_call(S0, K, r, i -> σ*(1.1)^i, T, n)

# 4b) Volatilité -10% par semaine  
price_4b = binomial_call(S0, K, r, i -> σ*(0.9)^i, T, n)

# Référence
price_ref = binomial_call(S0, K, r, i -> σ, T, n)

println("4a) Volatilité ↗ 10%/semaine: $(round(price_4a, digits=4))")
println("4b) Volatilité ↘ 10%/semaine: $(round(price_4b, digits=4))")
println("Référence (volatilité constante): $(round(price_ref, digits=4))")