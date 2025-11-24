% --- familia.pl ---
% Hechos
padre(juan, pedro).
padre(pedro, luis).

% Reglas
abuelo(X, Y) :- padre(X, Z), padre(Z, Y).
