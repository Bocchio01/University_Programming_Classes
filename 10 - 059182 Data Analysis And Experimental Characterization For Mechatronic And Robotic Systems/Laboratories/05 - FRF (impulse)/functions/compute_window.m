function window = compute_window(window_type, parameters)

switch(window_type)
    
    case "Tukey"

        window = zeros(parameters.L, 1);
        window(1:parameters.N) = tukeywin(parameters.N, parameters.r);

    case "Exponential"

        tau_e = -parameters.N / log(parameters.P);
        window = exp(-(1:parameters.N) / tau_e);

    otherwise
        
        error('Window type unknown')

end

