% =========================
%         HECHOS
% =========================

% Declarar predicados dispersos
:- discontiguous hombre/1.
:- discontiguous mujer/1.
:- discontiguous padre/2.
:- discontiguous madre/2.

% ---- Género ----
% --- Nivel 0  ---
hombre(fernando).
mujer(lia).
hombre(daniel_jr).

% --- Nivel 1  ---
mujer(yadira).
hombre(jesus).
mujer(esmeralda).

% Hijos de Jesús (sobrinos)
padre(jesus, fernando).
padre(jesus, daniel_jr).
padre(jesus, lia).

% --- Nivel 2  ---
mujer(martha).
hombre(joseluis).

% Hermanos de martha (mamá)
hombre(basilio).
mujer(hermelinda).
hombre(genaro).
mujer(amparo).
mujer(jovita).
mujer(raquel).
mujer(azuncion).
mujer(guadalupe).
hombre(eliseo).

% Hermano de joseluis (papá)
hombre(gustavo).
mujer(laura).

% --- Nivel 3  ---
% Abuelos maternos
mujer(emilia).
hombre(daniel).

% Abuelos paternos
mujer(maria).
hombre(antonio).

% --- Nivel 4  ---
% Padres de Emilia (materna)
mujer(ventura).
hombre(rafael).

% Padres de Daniel (materna)
mujer(luisa).
hombre(miguel).

% Padres de Maria (paterna)
mujer(teresa).
hombre(pedro).

% Padres de Antonio (paterna)
mujer(carmen).
hombre(jorge).

% ---- Matrimonios (datos) ----
matrimonio(joseluis, martha).
matrimonio(daniel, emilia).
matrimonio(antonio, maria).

matrimonio(rafael, ventura).
matrimonio(miguel, luisa).
matrimonio(pedro, teresa).
matrimonio(jorge, carmen).

% ---- Relaciones padre/madre -> hijo/a ----
% Hijos de JoseLuis y Martha (Nivel 1)
padre(joseluis, yadira).  madre(martha, yadira).
padre(joseluis, jesus).   madre(martha, jesus).
padre(joseluis, esmeralda). madre(martha, esmeralda).

% Hijos de los abuelos maternos (hermanos de mamá)
padre(daniel, basilio).    madre(emilia, basilio).
padre(daniel, hermelinda). madre(emilia, hermelinda).
padre(daniel, genaro).     madre(emilia, genaro).
padre(daniel, amparo).     madre(emilia, amparo).
padre(daniel, jovita).     madre(emilia, jovita).
padre(daniel, raquel).     madre(emilia, raquel).
padre(daniel, azuncion).   madre(emilia, azuncion).
padre(daniel, guadalupe).  madre(emilia, guadalupe).
padre(daniel, eliseo).     madre(emilia, eliseo).
padre(daniel, martha).     madre(emilia, martha).

% Hijos de los abuelos paternos (papá y su hermano)
padre(antonio, joseluis).  madre(maria, joseluis).
padre(antonio, gustavo).   madre(maria, gustavo).
padre(antonio, laura).     madre(maria, laura).

% Nivel 4: padres de los abuelos
% Materna (Emilia y Daniel)
padre(rafael, emilia).   madre(ventura, emilia).
padre(miguel, daniel).   madre(luisa, daniel).

% Paterna (Maria y Antonio)
padre(pedro, maria).     madre(teresa, maria).
padre(jorge, antonio).   madre(carmen, antonio).

% Hijos a los hermanos de la mamá (primos maternos)
hombre(evencio).
mujer(carla).
padre(basilio, evencio).
padre(basilio, carla).

mujer(soledad).
madre(hermelinda, soledad).

hombre(pablo).
mujer(sonia).
padre(genaro, pablo).
padre(genaro, sonia).

hombre(nicolas).
madre(amparo, nicolas).

hombre(esteban).
madre(jovita, esteban).

mujer(susana).
hombre(richard).
madre(raquel, susana).
madre(raquel, richard).

hombre(luis).
madre(azuncion, luis).

mujer(barbara).
hombre(felipe).
madre(guadalupe, barbara).
madre(guadalupe, felipe).

hombre(raudel).
padre(eliseo, raudel).

% Hijos a los hermanos del papá (primos paternos)
mujer(marisol).
padre(gustavo, marisol).

mujer(ana).
hombre(diego).
madre(laura, ana).
madre(laura, diego).

% =========================
%         REGLAS
% =========================

% Esposos (simetría)
esposos(A, B) :- matrimonio(A, B).
esposos(A, B) :- matrimonio(B, A).

% Progenitor (padre o madre)
progenitor(P, H) :- padre(P, H).
progenitor(P, H) :- madre(P, H).

% Hijo / Hija
hijo(H, P) :- hombre(H), progenitor(P, H).
hija(H, P) :- mujer(H), progenitor(P, H).

% Derivar padre/madre por género (si solo se conoce progenitor)
es_padre(P, H) :- hombre(P), progenitor(P, H).
es_madre(M, H) :- mujer(M), progenitor(M, H).

% Hermanos: comparten al menos un progenitor y no son la misma persona
hermanos(X, Y) :-
    X \= Y,
    progenitor(P, X),
    progenitor(P, Y).

% Hermano / Hermana
hermano(X, Y) :- hermanos(X, Y), hombre(X).
hermana(X, Y) :- hermanos(X, Y), mujer(X).

% Abuelos
abuelo(A, N) :- hombre(A), progenitor(A, P), progenitor(P, N).
abuela(A, N) :- mujer(A), progenitor(A, P), progenitor(P, N).

% Nietos
nieto(N, A)  :- hombre(N), progenitor(P, N), progenitor(A, P).
nieta(N, A)  :- mujer(N), progenitor(P, N), progenitor(A, P).

% Tíos / Tías (hermanos de un progenitor)
tio(T, S)  :- hombre(T), progenitor(P, S), hermanos(T, P).
tia(T, S)  :- mujer(T), progenitor(P, S), hermanos(T, P).

% Sobrinos / Sobrinas
sobrino(S, T)  :- hombre(S), progenitor(P, S), hermanos(P, T).
sobrina(S, T)  :- mujer(S), progenitor(P, S), hermanos(P, T).

% Primos / Primas: sus progenitores son hermanos (y no son hermanos entre sí)
primos(X, Y) :-
    X \= Y,
    progenitor(PX, X),
    progenitor(PY, Y),
    hermanos(PX, PY),
    \+ hermanos(X, Y).

primo(X, Y)  :- primos(X, Y), hombre(X).
prima(X, Y)  :- primos(X, Y), mujer(X).

% Nivel genealógico (opcional)
nivel(Persona, 0) :- \+ progenitor(_, Persona).
nivel(Persona, N) :- progenitor(P, Persona), nivel(P, N1), N is N1 + 1.
