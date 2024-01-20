function [Kt, Fint] = model_exact(U, geometry)

[L1, A1, E1, L2, A2, E2] = decompose_geometry(geometry);
[u, v] = decompose_u(U);

Kt = [A1.*E1.*L1.^(-2).*(L1+u).^2.*((L1+u).^2+v.^2).^(-1/2)+(-1/2).*A1.*E1.* ...
    L1.^(-2).*(L1+u).^2.*((L1+u).^2+v.^2).^(-3/2).*((-1).*L1.^2+(L1+u).^2+ ...
    v.^2)+(1/2).*A1.*E1.*L1.^(-2).*((L1+u).^2+v.^2).^(-1/2).*((-1).*L1.^2+( ...
    L1+u).^2+v.^2)+A2.*E2.*L2.^(-2).*u.*v.*(u.^2+(L2+v).^2).^(-1/2)+(-1/2).* ...
    A2.*E2.*L2.^(-2).*u.*v.*(u.^2+(L2+v).^2).^(-3/2).*((-1).*L2.^2+u.^2+(L2+ ...
    v).^2),A1.*E1.*L1.^(-2).*(L1+u).*v.*((L1+u).^2+v.^2).^(-1/2)+(-1/2).* ...
    A1.*E1.*L1.^(-2).*(L1+u).*v.*((L1+u).^2+v.^2).^(-3/2).*((-1).*L1.^2+(L1+ ...
    u).^2+v.^2)+A2.*E2.*L2.^(-2).*v.*(L2+v).*(u.^2+(L2+v).^2).^(-1/2)+(-1/2) ...
    .*A2.*E2.*L2.^(-2).*v.*(L2+v).*(u.^2+(L2+v).^2).^(-3/2).*((-1).*L2.^2+ ...
    u.^2+(L2+v).^2)+(1/2).*A2.*E2.*L2.^(-2).*(u.^2+(L2+v).^2).^(-1/2).*((-1) ...
    .*L2.^2+u.^2+(L2+v).^2);A1.*E1.*L1.^(-2).*(L1+u).*v.*((L1+u).^2+v.^2).^( ...
    -1/2)+(-1/2).*A1.*E1.*L1.^(-2).*(L1+u).*v.*((L1+u).^2+v.^2).^(-3/2).*(( ...
    -1).*L1.^2+(L1+u).^2+v.^2)+A2.*E2.*L2.^(-2).*u.*(L2+u).*(u.^2+(L2+v).^2) ...
    .^(-1/2)+(-1/2).*A2.*E2.*L2.^(-2).*u.*(L2+u).*(u.^2+(L2+v).^2).^(-3/2).* ...
    ((-1).*L2.^2+u.^2+(L2+v).^2)+(1/2).*A2.*E2.*L2.^(-2).*(u.^2+(L2+v).^2) ...
    .^(-1/2).*((-1).*L2.^2+u.^2+(L2+v).^2),A1.*E1.*L1.^(-2).*v.^2.*((L1+u) ...
    .^2+v.^2).^(-1/2)+(-1/2).*A1.*E1.*L1.^(-2).*v.^2.*((L1+u).^2+v.^2).^( ...
    -3/2).*((-1).*L1.^2+(L1+u).^2+v.^2)+(1/2).*A1.*E1.*L1.^(-2).*((L1+u).^2+ ...
    v.^2).^(-1/2).*((-1).*L1.^2+(L1+u).^2+v.^2)+A2.*E2.*L2.^(-2).*(L2+u).*( ...
    L2+v).*(u.^2+(L2+v).^2).^(-1/2)+(-1/2).*A2.*E2.*L2.^(-2).*(L2+u).*(L2+v) ...
    .*(u.^2+(L2+v).^2).^(-3/2).*((-1).*L2.^2+u.^2+(L2+v).^2)];

Fint = [(1/2).*A1.*E1.*L1.^(-2).*(L1+u).*((L1+u).^2+v.^2).^(-1/2).*((-1).* ...
  L1.^2+(L1+u).^2+v.^2)+(1/2).*A2.*E2.*L2.^(-2).*v.*(u.^2+(L2+v).^2).^( ...
  -1/2).*((-1).*L2.^2+u.^2+(L2+v).^2);(1/2).*A1.*E1.*L1.^(-2).*v.*((L1+u) ...
  .^2+v.^2).^(-1/2).*((-1).*L1.^2+(L1+u).^2+v.^2)+(1/2).*A2.*E2.*L2.^(-2) ...
  .*(L2+u).*(u.^2+(L2+v).^2).^(-1/2).*((-1).*L2.^2+u.^2+(L2+v).^2)];

end