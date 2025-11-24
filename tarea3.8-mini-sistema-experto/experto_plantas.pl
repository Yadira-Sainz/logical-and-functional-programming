:- module(experto_plantas, [
    inicio/0, limpiar/0, sugerir/1, explicar/1, recomendar/1
]).
:- dynamic conocido/2.

% ========== Base de conocimiento ==========
% problema(Nombre, [sintomas])
problema(arana_roja,       [telaranas_finas, puntitos_claros_en_hoja, hojas_amarillas, ambiente_seco_calido]).
problema(pulgon,           [melaza_pegajosa, presencia_hormigas, brotes_deformados, insectos_verdes_negros]).
problema(cochinilla,       [algodon_blanquecino, melaza_pegajosa, insectos_fijos, debilitamiento_general]).
problema(minador,          [galerias_en_hoja, hojas_reticuladas, brotes_tiernos_afectados]).
problema(fumagina,         [hollin_negro_sobre_hoja, melaza_pegajosa, hojas_opacas]).
problema(oruga_defoliadora,[bordes_comidos, excrementos_pequenios, presencia_gusanos]).
problema(estres_hidrico,   [hojas_caidas, sustrato_seco, bordes_crispados]).
problema(fitotoxicidad,    [manchas_aceitosas, hojas_quemadas, caida_hoja_post_tratamiento]).
problema(hongo_mildiu,     [manchas_amarillas_irregulares, polvillo_blanco_gris, alta_humedad]).
problema(trips,            [plata_en_hoja, cicatrices_lineales, flores_decoloradas, puntos_negros_excremento]).

% Etiquetas legibles para las preguntas
etq(telaranas_finas, 'hay telaranas finas en brotes o enves').
etq(puntitos_claros_en_hoja, 'ves puntitos claros (aspecto salpicado) en la hoja').
etq(hojas_amarillas, 'las hojas amarillean de forma difusa').
etq(ambiente_seco_calido, 'el ambiente esta seco y caluroso').
etq(melaza_pegajosa, 'hay melaza pegajosa en hojas o tallos').
etq(presencia_hormigas, 'hay hormigas sobre la planta').
etq(brotes_deformados, 'los brotes nuevos salen deformados').
etq(insectos_verdes_negros, 'ves pulgones (verdes o negros)').
etq(algodon_blanquecino, 'aparece material blanco algodonoso').
etq(insectos_fijos, 'hay insectos adheridos que casi no se mueven').
etq(debilitamiento_general, 'la planta se ve debilitada en general').
etq(galerias_en_hoja, 'ves galerias o minas dentro de la hoja').
etq(hojas_reticuladas, 'hojas con patron reticulado interno').
etq(brotes_tiernos_afectados, 'el dano se concentra en brotes tiernos').
etq(hollin_negro_sobre_hoja, 'hay hollin negro sobre la hoja').
etq(hojas_opacas, 'las hojas lucen opacas o grisaceas').
etq(bordes_comidos, 'los bordes de hojas estan comidos').
etq(excrementos_pequenios, 'hay pequenos granulos (excremento) en hojas/sustrato').
etq(presencia_gusanos, 'ves orugas o gusanos en la planta').
etq(hojas_caidas, 'las hojas estan lacias o caidas').
etq(sustrato_seco, 'el sustrato esta muy seco al tacto').
etq(bordes_crispados, 'los bordes se ven crispados o quemados').
etq(manchas_aceitosas, 'aparecen manchas aceitosas/translucidas').
etq(hojas_quemadas, 'hojas quemadas tras un tratamiento').
etq(caida_hoja_post_tratamiento, 'caida de hoja tras aplicar producto').
etq(manchas_amarillas_irregulares, 'manchas amarillas irregulares').
etq(polvillo_blanco_gris, 'polvillo blanco/gris en la hoja').
etq(alta_humedad, 'ambiente con humedad alta o poca ventilacion').
etq(plata_en_hoja, 'brillo plateado en la hoja').
etq(cicatrices_lineales, 'cicatrices lineales o raspaduras').
etq(flores_decoloradas, 'flores decoloradas o danadas').
etq(puntos_negros_excremento, 'puntos negros (excremento de trips)').

% Recomendaciones por diagnostico
reco(arana_roja, [
   'Aumenta humedad ambiental; ducha suave 2-3 veces por semana.',
   'Aplica jabon potasico o extracto de neem cada 5-7 dias (no al sol).',
   'Mejora ventilacion y evita estres hidrico.'
]).
reco(pulgon, [
   'Lava con agua a presion moderada y retira colonias.',
   'Jabon potasico cada 5 dias; neem por la noche si persiste.',
   'Controla hormigas con cebos para cortar el intercambio de melaza.'
]).
reco(cochinilla, [
   'Retira manualmente con cotonete y alcohol 70%.',
   'Aceite horticola/neem semanal.',
   'Revisa axilas de hojas y tallos lenosos.'
]).
reco(minador, [
   'Retira hojas muy afectadas y desechalas.',
   'Trampas cromaticas amarillas; protege brotes tiernos.',
   'Evita exceso de nitrogeno que promueve brotes blandos.'
]).
reco(fumagina, [
   'Limpia hojas con pano humedo y trata la plaga base (pulgon/cochinilla).',
   'Mejora ventilacion y reduce melaza.',
   'Evita mojar follaje por la noche.'
]).
reco(oruga_defoliadora, [
   'Retira orugas a mano (inspeccion nocturna).',
   'Aplica Bacillus thuringiensis en brotes jovenes.',
   'Retira restos de hojas caidas.'
]).
reco(estres_hidrico, [
   'Ajusta riego: profundo pero menos frecuente.',
   'Verifica drenaje; evita encharcar.',
   'Sombrea en olas de calor.'
]).
reco(fitotoxicidad, [
   'Suspende productos por 10-14 dias.',
   'Riega y permite recuperacion; poda minima de dano severo.',
   'Siempre prueba en 1-2 hojas antes de aplicar a toda la planta.'
]).
reco(hongo_mildiu, [
   'Retira hojas muy afectadas.',
   'Mejora ventilacion; evita mojar follaje de noche.',
   'Fungicida preventivo suave (azufre micronizado/bicarbonato; no al sol).'
]).
reco(trips, [
   'Trampas azules; ducha suave de follaje.',
   'Jabon potasico/neem alternado; inspecciona flores y brotes.',
   'Aisla planta muy afectada para cortar ciclo.'
]).

% ========== Interaccion si/no con cache ==========
tiene(S) :- conocido(S, si), !.
tiene(S) :- conocido(S, no), !, fail.
tiene(S) :-
    etq(S, Texto),
    format('¿~w? (si/no): ', [Texto]),
    read(R), nl,
    ( R == si -> assertz(conocido(S, si))
    ; assertz(conocido(S, no)), fail ).

% ========== Diagnostico determinista ==========
cumple_todos([]).
cumple_todos([H|T]) :- tiene(H), cumple_todos(T).

diagnostico_determinista(P) :-
    problema(P, Ss),
    cumple_todos(Ss).

% ========== Coincidencia parcial (puntaje) ==========
sintoma_presente(S) :- (conocido(S, si) -> true ; (tiene(S) -> true ; fail)).

puntaje(P, Score, Coinc) :-
    problema(P, Ss),
    include(sintoma_presente, Ss, Coinc),
    length(Coinc, C),
    length(Ss, T),
    Score is C / T.

ranking(TopN, Lista) :-
    setof(Score-Prob-Coinc, (problema(Prob,_), puntaje(Prob, Score, Coinc)), Pares),
    sort(Pares, Asc),
    reverse(Asc, Desc),
    take(TopN, Desc, Seleccion),
    maplist(formatear, Seleccion, Lista).

take(0, _, []) :- !.
take(_, [], []).
take(N, [X|Xs], [X|Ys]) :- N1 is N-1, take(N1, Xs, Ys).

formatear(Score-Prob-Coinc, item(Prob, Score, Coinc)).

% ========== Explicacion y recomendaciones ==========
explicar(P) :-
    problema(P,_),
    puntaje(P, S, Coinc),
    Porc is round(S*100),
    format('Explicacion para ~w (~d%% coincidencia):~n', [P, Porc]),
    maplist(mostrar_tick, Coinc),
    faltantes(P).

faltantes(P) :-
    problema(P, Ss),
    findall(S, (member(S,Ss), \+ conocido(S, si)), Faltan),
    ( Faltan = [] -> true
    ; writeln('  (Faltaron/negados):'), maplist(mostrar_bullet, Faltan)
    ).

mostrar_tick(S)   :- etq(S,T), format('  ✓ ~w~n', [T]).
mostrar_bullet(S) :- etq(S,T), format('  • ~w~n', [T]).

recomendar(P) :-
    reco(P, Rs), writeln('Recomendaciones:'), maplist(mostrar_rec, Rs).
mostrar_rec(T) :- format('  - ~w~n', [T]).

% ========== API de alto nivel ==========
inicio :-
    retractall(conocido(_,_)),
    writeln('Diagnostico de plagas/enfermedades — responde si/no.'), nl,
    (   diagnostico_determinista(P) ->
        format('Diagnostico (coincidencia total): ~w~n', [P]),
        explicar(P), recomendar(P)
    ;   ranking(3, Top),
        writeln('Posibles causas (mejor a peor):'),
        maplist(imprimir_item, Top),
        writeln('Sugerencia: valida el primero y aplica recomendaciones.')
    ).

imprimir_item(item(P,S,_)) :-
    Porc is round(S*100),
    format('- ~w (~d%%)~n', [P, Porc]).

sugerir(P) :- ranking(1, [item(P,_,_)|_]).

limpiar :- retractall(conocido(_,_)).
