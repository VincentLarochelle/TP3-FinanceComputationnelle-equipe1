using Statistics

function mc_arbre()
    S0, σ, r, K, Δt, n_sim = 20.0, 0.3, 0.06, 21.0, 1/52, 100000
    u, d = exp(σ * sqrt(Δt)), exp(-σ * sqrt(Δt))
    C, p_th, p_reel = 0.1834, 0.5, 0.6
    
    println("=== SIMULATION MONTE CARLO ===")
    
    # Cas 1: C′ = C, p = 0.5
    gains1 = [let S = S0; for _ in 1:2; S *= rand() < p_th ? u : d; end; max(S-K,0) end for _ in 1:n_sim]
    println("Cas 1 - C′ = C, p=0.5: Gain moyen = ", round(mean(gains1), digits=4))
    
    # Cas 2: C′ = 3C/2, p = 0.5  
    gains2 = [g - 1.5*C for g in gains1]
    println("Cas 2 - C′ = 3C/2, p=0.5: Gain moyen = ", round(mean(gains2), digits=4))
    
    # Cas 3: C′ = C, p = 0.6
    gains3 = [let S = S0; for _ in 1:2; S *= rand() < p_reel ? u : d; end; max(S-K,0) end for _ in 1:n_sim]
    println("Cas 3 - C′ = C, p=0.6: Gain moyen = ", round(mean(gains3), digits=4))
    
end

mc_arbre()