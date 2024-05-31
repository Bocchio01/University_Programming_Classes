function [R, Q] = compute_rotational_matrices(gamma)

R = [
    cos(gamma) -sin(gamma) 0;
    sin(gamma) cos(gamma) 0;
    0 0 1;   
];

Q = [
    R zeros(3);
    zeros(3) R;
];

end

