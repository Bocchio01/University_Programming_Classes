function [M, K] = assembly(incidenze, l, m, EA, EJ, gamma, idb)

[n_el, nc] = size(incidenze);

assert(nc == 6, 'Number of columns of incidence matrix different from 6');
assert(length(l) == n_el, 'Number of elements in l differenc from n');
assert(length(m) == n_el , 'Number of elements in m differenc from number of elements');
assert(length(EA) == n_el, 'Number of elements in EA differenc number of elements');
assert(length(EJ) == n_el, 'Number of elements in EJ differenc number of elements');
assert(length(gamma) == n_el, 'Number of elements in alpha differenc number of elements');
assert(min(incidenze, [], "all") == 1 , 'DOF sequence does not start from 1');

n_dof = max(max(idb));

% Assembling matrices M and K
M = zeros(n_dof, n_dof);
K = zeros(n_dof, n_dof);

for k = 1:n_el

    [mG, kG] = compute_elemental_matrices(l(k),m(k),EA(k),EJ(k),gamma(k));
    
    for iri=1:6
        for ico=1:6
        
            i1=incidenze(k,iri);
            i2=incidenze(k,ico);
            M(i1,i2)=M(i1,i2)+mG(iri,ico);
            K(i1,i2)=K(i1,i2)+kG(iri,ico);
    
        end
    end

end

end