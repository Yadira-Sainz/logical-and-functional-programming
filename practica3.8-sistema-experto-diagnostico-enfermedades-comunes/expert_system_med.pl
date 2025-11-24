%  Uso en SWI-Prolog:
%    ?- [expert_system_med].
%    ?- inicio.
%    ?- limpiar.   % reinicia respuestas
% =========================

:- dynamic respuesta/2.

% -------------------------
% Interfaz de Usuario
% -------------------------

inicio :-
    writeln('Evaluacion de sintomas comunes — responde si/no.'), nl,
    ( red_flags -> true ; true ),
    ( diagnostico(D) ->
        formato_diagnostico(D),
        explica(D),
        nl, por_que(D)
    ; writeln('No fue posible proponer una categoria probable con la informacion dada.'),
      writeln('Considera consultar a un profesional de la salud.')
    ).

formato_diagnostico(D) :-
    write('> Categoria/diagnostico probable: '), writeln(D).

% Limpiar hechos/respuestas previas
limpiar :-
    retractall(respuesta(_, _)),
    writeln('Hechos previos eliminados.').

% Preguntar con memoizacion
pregunta(P) :-
    obten_respuesta(P, R),
    R = si.

obten_respuesta(P, R) :-
    respuesta(P, R), !.
obten_respuesta(P, R) :-
    formato_pregunta(P, Texto),
    write(Texto), write(' (si/no): '),
    lee_respuesta(R),
    assertz(respuesta(P, R)).

lee_respuesta(R) :-
    read_line_to_string(user_input, S),
    normaliza(S, SN),
    ( SN = "si" -> R = si
    ; SN = "no" -> R = no
    ; writeln('Por favor responde si/no.'),
      lee_respuesta(R)
    ).

% Normaliza: a minusculas y recorta espacios
normaliza(S, SN) :-
    string_lower(S, SL),                      % SWI-Prolog: convierte a minusculas
    split_string(SL, " \t\r\n", " \t\r\n", Parts),
    ( Parts = [SN|_] -> true ; SN = SL ).

% -------------------------
% Catalogo de sintomas
% -------------------------

formato_pregunta(sintoma(fiebre_alta),
  '¿tienes fiebre alta (te sientes caliente/escalofrios)?').
formato_pregunta(sintoma(tos),
  '¿tienes tos?').
formato_pregunta(sintoma(tos_seca),
  '¿la tos es seca (sin flema)?').
formato_pregunta(sintoma(goteo_nasal),
  '¿tienes escurrimiento o congestion nasal?').
formato_pregunta(sintoma(estornudos),
  '¿estas estornudando con frecuencia?').
formato_pregunta(sintoma(dolor_garganta),
  '¿tienes dolor de garganta importante?').
formato_pregunta(sintoma(sin_tos),
  '¿NO tienes tos?').
formato_pregunta(sintoma(dolor_cabeza),
  '¿tienes dolor de cabeza?').
formato_pregunta(sintoma(mialgias),
  '¿tienes dolores musculares/cuerpo cortado?').
formato_pregunta(sintoma(fatiga),
  '¿tienes fatiga marcada?').
formato_pregunta(sintoma(anosmia),
  '¿perdiste el olfato o el gusto recientemente?').
formato_pregunta(sintoma(disnea),
  '¿te falta el aire o te cuesta respirar?').
formato_pregunta(sintoma(nausea_vomito),
  '¿tienes nausea o vomito?').
formato_pregunta(sintoma(diarrea),
  '¿tienes diarrea?').
formato_pregunta(sintoma(dolor_abdominal),
  '¿tienes dolor abdominal?').
formato_pregunta(sintoma(foto_fonofobia),
  '¿te molestan la luz o los sonidos?').
formato_pregunta(sintoma(lateralizado),
  '¿el dolor de cabeza es de un solo lado y late?').
formato_pregunta(sintoma(disuria),
  '¿ardor al orinar (disuria)?').
formato_pregunta(sintoma(frecuencia_urinaria),
  '¿aumento de frecuencia/urgencia para orinar?').
formato_pregunta(sintoma(dolor_flanco_fiebre),
  '¿dolor en la espalda/riñones o fiebre con escalofrios?').
formato_pregunta(sintoma(prurito_ocular),
  '¿ojos llorosos o con comezon junto con estornudos?').

% Red flags / signos de alarma
formato_pregunta(sintoma(dolor_pecho),
  '¿presentas dolor en el pecho?').
formato_pregunta(sintoma(confusion),
  '¿te sientes confuso/a o muy somnoliento/a?').
formato_pregunta(sintoma(vomito_persistente),
  '¿vomitos persistentes que impiden hidratarte?').
formato_pregunta(sintoma(deshidratacion),
  '¿boca muy seca, orina oscura o mareo al ponerte de pie?').

red_flags :-
    ( pregunta(sintoma(disnea))
    ; pregunta(sintoma(dolor_pecho))
    ; pregunta(sintoma(confusion))
    ; pregunta(sintoma(vomito_persistente))
    ; pregunta(sintoma(deshidratacion))
    ),
    writeln('** ALARMA **: Tus respuestas sugieren signos de alarma.'),
    writeln('Por favor considera atencion medica inmediata si los sintomas son severos o progresan.'),
    nl, !.
red_flags.

% -------------------------
% Reglas de Diagnostico (categorias probables)
% -------------------------

diagnostico(influenza) :-
    pregunta(sintoma(fiebre_alta)),
    pregunta(sintoma(mialgias)),
    pregunta(sintoma(fatiga)),
    pregunta(sintoma(tos)).

diagnostico(covid_19) :-
    ( pregunta(sintoma(fiebre_alta)) ; pregunta(sintoma(tos)) ),
    ( pregunta(sintoma(anosmia)) ; pregunta(sintoma(disnea)) ).

diagnostico(resfriado_comun) :-
    pregunta(sintoma(goteo_nasal)),
    pregunta(sintoma(estornudos)),
    \+ pregunta(sintoma(fiebre_alta)).

diagnostico(faringitis_estreptococica) :-
    pregunta(sintoma(dolor_garganta)),
    pregunta(sintoma(fiebre_alta)),
    pregunta(sintoma(sin_tos)).

diagnostico(gastroenteritis_viral) :-
    ( pregunta(sintoma(nausea_vomito)) ; pregunta(sintoma(diarrea)) ),
    pregunta(sintoma(dolor_abdominal)).

diagnostico(migrana) :-
    pregunta(sintoma(dolor_cabeza)),
    pregunta(sintoma(lateralizado)),
    pregunta(sintoma(foto_fonofobia)),
    ( pregunta(sintoma(nausea_vomito)) ; true ).

diagnostico(infeccion_urinaria_baja_cistitis) :-
    pregunta(sintoma(disuria)),
    pregunta(sintoma(frecuencia_urinaria)),
    \+ pregunta(sintoma(dolor_flanco_fiebre)).

diagnostico(rinitis_alergica) :-
    pregunta(sintoma(estornudos)),
    pregunta(sintoma(prurito_ocular)),
    \+ pregunta(sintoma(fiebre_alta)).

% -------------------------
% Justificacion y Recomendaciones
% -------------------------

por_que(influenza) :-
    writeln('Justificacion: fiebre alta de inicio agudo con mialgias, fatiga y tos es tipico de influenza.').
por_que(covid_19) :-
    writeln('Justificacion: fiebre/tos con anosmia o disnea es compatible con COVID-19.').
por_que(resfriado_comun) :-
    writeln('Justificacion: congestion/goteo nasal y estornudos sin fiebre alta sugieren resfriado comun.').
por_que(faringitis_estreptococica) :-
    writeln('Justificacion: dolor de garganta + fiebre con ausencia de tos (criterios tipo Centor).').
por_que(gastroenteritis_viral) :-
    writeln('Justificacion: nausea/diarrea con dolor abdominal sugiere cuadro gastrointestinal viral.').
por_que(migrana) :-
    writeln('Justificacion: cefalea unilateral pulsatil con foto/sonofobia y nausea es tipico de migraña.').
por_que(infeccion_urinaria_baja_cistitis) :-
    writeln('Justificacion: disuria y aumento de frecuencia sin dolor en flanco sugiere cistitis.').
por_que(rinitis_alergica) :-
    writeln('Justificacion: estornudos y prurito ocular sin fiebre alta es compatible con rinitis alergica.').

explica(influenza) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Hidratacion, reposo, analgesicos/antipireticos segun indicacion profesional.'),
    writeln('- Si hay factores de riesgo o sintomas severos, consulta medica para valorar antiviral.').

explica(covid_19) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Aislamiento, cubrebocas, ventilacion; hidratacion y reposo.'),
    writeln('- Consulta medica si disnea, saturacion baja o comorbilidades.').

explica(resfriado_comun) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Lavados nasales, descanso, analgesicos suaves si es necesario.').

explica(faringitis_estreptococica) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Requiere valoracion medica; podria ameritar prueba rapida y antibiotico si se confirma.').

explica(gastroenteritis_viral) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Hidratacion fraccionada, suero oral; dieta liviana.'),
    writeln('- Acudir si hay signos de deshidratacion o sangre en heces.').

explica(migrana) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Reposo en lugar oscuro y silencioso; analgesicos/anti-migrañosos bajo indicacion medica.'),
    writeln('- Identificar y evitar desencadenantes.').

explica(infeccion_urinaria_baja_cistitis) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Aumentar ingesta de liquidos; consultar para uroanalisis y posible antibiotico.'),
    writeln('- Acudir urgente si fiebre o dolor en flancos (posible pielonefritis).').

explica(rinitis_alergica) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Evitar alergenos; irrigacion nasal; valorar antihistaminico intranasal/oral.').
