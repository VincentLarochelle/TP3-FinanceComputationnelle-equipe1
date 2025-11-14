using Printf

function arbre_binomial_court()
    # Paramètres
    S0, σ, r, K, Δt = 20.0, 0.3, 0.06, 21.0, 1/52
    p = 0.5
    
    # Coefficients
    u = exp(σ * sqrt(Δt))
    d = exp(-σ * sqrt(Δt))
    R = exp(r * Δt)
    
    println("=== CALCULS DU MODÈLE ===")
    @printf("u = %.4f, d = %.4f, R = %.6f\n", u, d, R)
    
    # Arbre des prix
    S_u, S_d = S0 * u, S0 * d
    S_uu, S_ud, S_dd = S_u * u, S_u * d, S_d * d
    
    # Payoffs terminaux
    C_uu, C_ud, C_dd = max(S_uu - K, 0), max(S_ud - K, 0), max(S_dd - K, 0)
    
    # Rétropropagation
    C_u = (p * C_uu + (1-p) * C_ud) / R
    C_d = (p * C_ud + (1-p) * C_dd) / R
    C = (p * C_u + (1-p) * C_d) / R
    
    println("Prix théorique call: C = ", round(C, digits=4))
    
    # Arbitrage
    C_M = 1.5 * C
    println("Prix marché: C_M = ", round(C_M, digits=4))
    
    Δ = (C_u - C_d) / (S_u - S_d)
    profit = C_M - C
    
    println("\n=== STRATÉGIE ARBITRAGE ===")
    println("Delta initial: Δ = ", round(Δ, digits=4))
    println("Vendre call à ", round(C_M, digits=4))
    println("Acheter ", round(Δ, digits=4), " actions")
    println("Emprunter: ", round(Δ*S0 - C_M, digits=4))
    println("Profit sans risque: ", round(profit, digits=4))
end

arbre_binomial_court()