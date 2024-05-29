function [mG, kG] = compute_elemental_matrices(L, m, EA, EJ, gamma)

kG = [
    EA/L 0 0 -EA/L 0 0;
    0 12*EJ/L^3 6*EJ/L^2 0 -12*EJ/L^3 6*EJ/L^2;
    0 6*EJ/L^2 4*EJ/L 0 -6*EJ/L^2 2*EJ/L;
    
    -EA/L 0 0 EA/L 0 0;
    0 -12*EJ/L^3 -6*EJ/L^2 0 12*EJ/L^3 -6*EJ/L^2;
    0 6*EJ/L^2 2*EJ/L 0 -6*EJ/L^2 4*EJ/L;
];

mG = 1/420 * m*L * [
    140 0 0 70 0 0;
    0 156 22*L 0 54 -13*L;
    0 22*L 4*L^2 0 13*L -3*L^2;
    70 0 0 140 0 0;
    0 54 13*L 0 156 -22*L;
    0 -13*L -3*L^2 0 -22*L 4*L^2; 
];

R = [
    cos(gamma) -sin(gamma) 0;
    sin(gamma) cos(gamma) 0;
    0 0 1;   
];

Q = [
    R zeros(3);
    zeros(3) R;
];

kG = Q' * kG * Q;
mG = Q' * mG * Q;

end

