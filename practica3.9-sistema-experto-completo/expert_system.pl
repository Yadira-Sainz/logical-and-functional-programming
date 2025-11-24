% Uso en SWI-Prolog:
%    ?- [expert_system].
%    ?- inicio.
%    ?- limpiar.   % reinicia respuestas
% =========================

% Declaración de predicado dinámico para almacenar respuestas del usuario
:- dynamic respuesta/2.

% -------------------------
% INTERFAZ DE USUARIO
% -------------------------

% Predicado principal que inicia el sistema experto
% Este es el punto de entrada del sistema experto
inicio :-
    writeln('========================================'),
    writeln('SISTEMA EXPERTO DE DIAGNOSTICO MEDICO'),
    writeln('========================================'),
    writeln('Evaluacion de sintomas comunes — responde si/no.'), nl,
    % Evalúa primero los signos de alarma (red flags)
    ( red_flags -> true ; true ),
    % Busca un diagnóstico basado en los síntomas
    buscar_diagnostico(D),
    % Si se encontró un diagnóstico, lo muestra con explicación
    ( D \= ninguno ->
        formato_diagnostico(D),
        nl, writeln('--- Justificacion del diagnostico ---'),
        por_que(D),
        nl, rastrear_sintomas(D),
        nl, explica(D)
    % Si no se encontró diagnóstico, muestra mensaje informativo
    ; writeln('No fue posible proponer una categoria probable con la informacion dada.'),
      writeln('Considera consultar a un profesional de la salud.')
    ),
    nl, writeln('========================================').

% Formatea la presentación del diagnóstico
formato_diagnostico(D) :-
    write('> Categoria/diagnostico probable: '), writeln(D).

% Limpia todas las respuestas almacenadas previamente
limpiar :-
    retractall(respuesta(_, _)),
    writeln('Hechos previos eliminados.').

% Predicado que verifica si un síntoma está presente
% Retorna true solo si la respuesta es "si"
pregunta(P) :-
    obten_respuesta(P, R),
    R = si.

% Obtiene la respuesta a una pregunta, con memoización
% Si la respuesta ya existe en la base de hechos, la retorna
% Si no existe, pregunta al usuario y la almacena
obten_respuesta(P, R) :-
    respuesta(P, R), !.  % Si ya existe, la retorna (corte)
obten_respuesta(P, R) :-
    formato_pregunta(P, Texto),
    write(Texto), write(' (si/no): '),
    lee_respuesta(R),
    assertz(respuesta(P, R)).  % Almacena la respuesta para futuras consultas

% Lee la respuesta del usuario desde la entrada estándar
lee_respuesta(R) :-
    read_line_to_string(user_input, S),
    normaliza(S, SN),
    ( SN = "si" -> R = si
    ; SN = "no" -> R = no
    ; writeln('Por favor responde si/no.'),
      lee_respuesta(R)  % Solicita nueva respuesta si es inválida
    ).

% Normaliza la entrada del usuario: convierte a minúsculas y elimina espacios
normaliza(S, SN) :-
    string_lower(S, SL),                      % SWI-Prolog: convierte a minúsculas
    split_string(SL, " \t\r\n", " \t\r\n", Parts),
    ( Parts = [SN|_] -> true ; SN = SL ).

% -------------------------
% BASE DE CONOCIMIENTOS: CATÁLOGO DE SÍNTOMAS
% -------------------------
%
% Esta sección contiene la base de conocimientos del sistema experto.
% Define los hechos (síntomas) que el sistema puede reconocer.
% Cada síntoma tiene asociada una pregunta en lenguaje natural para el usuario.
%
% Hechos que definen las preguntas asociadas a cada síntoma
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

% Evalúa signos de alarma y muestra advertencia si se detectan
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
red_flags.  % Si no hay signos de alarma, simplemente continúa

% -------------------------
% MOTOR DE INFERENCIA: REGLAS DE DIAGNÓSTICO
% -------------------------
%
% Esta sección contiene el motor de inferencia del sistema experto.
% El motor de inferencia aplica las reglas de diagnóstico a los síntomas
% proporcionados por el usuario para llegar a una conclusión.
%
% ESTRATEGIA DE INFERENCIA:
% - Orden de evaluación: de más específico a más general
% - Esto evita que un diagnóstico general se active cuando hay uno más específico
% - Utiliza encadenamiento hacia adelante (forward chaining)
%
% Motor de búsqueda de diagnóstico: evalúa en orden de especificidad
% Esto evita que un diagnóstico general se active cuando hay uno más específico
buscar_diagnostico(D) :-
    ( diagnostico(migrana) -> D = migrana
    ; diagnostico(infeccion_urinaria_baja_cistitis) -> D = infeccion_urinaria_baja_cistitis
    ; diagnostico(gastroenteritis_viral) -> D = gastroenteritis_viral
    ; diagnostico(faringitis_estreptococica) -> D = faringitis_estreptococica
    ; diagnostico(covid_19) -> D = covid_19
    ; diagnostico(rinitis_alergica) -> D = rinitis_alergica
    ; diagnostico(resfriado_comun) -> D = resfriado_comun
    ; diagnostico(influenza) -> D = influenza
    ; D = ninguno  % Si ninguna regla se cumple
    ).

% Regla de diagnóstico: MIGRAÑA
% Características: dolor de cabeza lateralizado con fotofobia/fonofobia
% Justificación: La migraña se caracteriza por cefalea unilateral pulsátil,
% fotofobia/fonofobia y frecuentemente náusea, sin fiebre.
% Esta regla se evalúa primero por ser muy específica.
diagnostico(migrana) :-
    pregunta(sintoma(dolor_cabeza)),
    pregunta(sintoma(lateralizado)),
    pregunta(sintoma(foto_fonofobia)),
    ( pregunta(sintoma(nausea_vomito)) ; true ),  % Náusea opcional
    \+ pregunta(sintoma(fiebre_alta)).  % NO debe tener fiebre

% Regla de diagnóstico: INFECCIÓN URINARIA BAJA (CISTITIS)
% Características: síntomas urinarios sin fiebre ni dolor en flancos
% Justificación: La cistitis se caracteriza por disuria y frecuencia urinaria
% sin fiebre ni dolor en flancos (que sugeriría pielonefritis).
% Se evalúa temprano por ser específica.
diagnostico(infeccion_urinaria_baja_cistitis) :-
    pregunta(sintoma(disuria)),
    pregunta(sintoma(frecuencia_urinaria)),
    \+ pregunta(sintoma(dolor_flanco_fiebre)),  % Excluye pielonefritis
    \+ pregunta(sintoma(fiebre_alta)).

% Regla de diagnóstico: GASTROENTERITIS VIRAL
% Características: síntomas gastrointestinales sin fiebre
% Justificación: Náusea, vómito o diarrea con dolor abdominal sin fiebre
% sugiere gastroenteritis viral. Se evalúa temprano por ser específica.
diagnostico(gastroenteritis_viral) :-
    ( pregunta(sintoma(nausea_vomito)) ; pregunta(sintoma(diarrea)) ),  % Náusea O diarrea
    pregunta(sintoma(dolor_abdominal)),
    \+ pregunta(sintoma(fiebre_alta)).

% Regla de diagnóstico: FARINGITIS ESTREPTOCÓCICA
% Características: dolor de garganta con fiebre pero sin tos ni mialgias
% Justificación: Basada en criterios tipo Centor modificados: dolor de garganta
% con fiebre y ausencia de tos sugiere faringitis estreptocócica.
% Se diferencia de influenza por ausencia de mialgias.
diagnostico(faringitis_estreptococica) :-
    pregunta(sintoma(dolor_garganta)),
    pregunta(sintoma(fiebre_alta)),
    \+ pregunta(sintoma(tos)),  % Ausencia de tos (usamos negación de la pregunta original)
    \+ pregunta(sintoma(mialgias)).  % Diferenciación de influenza

% Regla de diagnóstico: COVID-19
% Características: fiebre/tos con anosmia o disnea, sin mialgias
% Justificación: La combinación de fiebre o tos con anosmia o disnea
% es altamente sugestiva de COVID-19. Se diferencia de influenza
% por la ausencia de mialgias y presencia de anosmia/disnea.
diagnostico(covid_19) :-
    ( pregunta(sintoma(fiebre_alta)) ; pregunta(sintoma(tos)) ),  % Fiebre O tos
    ( pregunta(sintoma(anosmia)) ; pregunta(sintoma(disnea)) ),  % Anosmia O disnea
    \+ pregunta(sintoma(mialgias)).  % Diferenciación de influenza

% Regla de diagnóstico: RINITIS ALÉRGICA
% Características: síntomas alérgicos sin fiebre ni tos
% Justificación: Estornudos y prurito ocular sin fiebre ni tos
% son característicos de rinitis alérgica. Se diferencia del resfriado
% común por la presencia de prurito ocular.
diagnostico(rinitis_alergica) :-
    pregunta(sintoma(estornudos)),
    pregunta(sintoma(prurito_ocular)),
    \+ pregunta(sintoma(fiebre_alta)),
    \+ pregunta(sintoma(tos)).

% Regla de diagnóstico: RESFRIADO COMÚN
% Características: síntomas nasales sin fiebre ni mialgias
% Justificación: Goteo nasal y estornudos sin fiebre alta ni mialgias
% son típicos del resfriado común. Se diferencia de influenza por
% ausencia de fiebre y mialgias, y de rinitis alérgica por ausencia
% de prurito ocular.
diagnostico(resfriado_comun) :-
    pregunta(sintoma(goteo_nasal)),
    pregunta(sintoma(estornudos)),
    \+ pregunta(sintoma(fiebre_alta)),
    \+ pregunta(sintoma(mialgias)).

% Regla de diagnóstico: INFLUENZA (más general, al final)
% Características: fiebre, mialgias, fatiga y tos, sin síntomas de COVID-19
% Justificación: Fiebre alta, mialgias, fatiga y tos son el cuadro clásico
% de influenza. Se evalúa al final por ser más general. Se diferencia de
% COVID-19 por ausencia de anosmia/disnea, y de faringitis por presencia de tos.
diagnostico(influenza) :-
    pregunta(sintoma(fiebre_alta)),
    pregunta(sintoma(mialgias)),
    pregunta(sintoma(fatiga)),
    pregunta(sintoma(tos)),  % Requiere presencia de tos
    \+ pregunta(sintoma(anosmia)),  % Excluye COVID-19
    \+ pregunta(sintoma(disnea)).   % Excluye COVID-19
    % Nota: No necesitamos verificar sin_tos porque ya verificamos que hay tos

% -------------------------
% SISTEMA DE JUSTIFICACIÓN Y RECOMENDACIONES
% -------------------------

% Justificaciones para cada diagnóstico
% Explica el razonamiento médico detrás de cada diagnóstico
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
por_que(ninguno) :-
    writeln('Justificacion: no se pudo determinar un diagnostico especifico.').

% Rastrea y muestra los síntomas que llevaron al diagnóstico
% Este predicado muestra qué síntomas fueron los que activaron la regla de diagnóstico
rastrear_sintomas(D) :-
    writeln('Sintomas que llevaron a este diagnostico:'),
    sintomas_diagnostico(D, Sintomas),
    mostrar_sintomas(Sintomas, 1).

% Define qué síntomas son relevantes para cada diagnóstico
% Nota: Para faringitis, la ausencia de tos se maneja con negación, no como síntoma positivo
sintomas_diagnostico(influenza, [fiebre_alta, mialgias, fatiga, tos]).
sintomas_diagnostico(covid_19, [fiebre_alta, tos, anosmia, disnea]).
sintomas_diagnostico(resfriado_comun, [goteo_nasal, estornudos]).
sintomas_diagnostico(faringitis_estreptococica, [dolor_garganta, fiebre_alta]).
sintomas_diagnostico(gastroenteritis_viral, [nausea_vomito, diarrea, dolor_abdominal]).
sintomas_diagnostico(migrana, [dolor_cabeza, lateralizado, foto_fonofobia, nausea_vomito]).
sintomas_diagnostico(infeccion_urinaria_baja_cistitis, [disuria, frecuencia_urinaria]).
sintomas_diagnostico(rinitis_alergica, [estornudos, prurito_ocular]).
sintomas_diagnostico(ninguno, []).

% Muestra los síntomas presentes de forma numerada
mostrar_sintomas([], _).
mostrar_sintomas([S|Resto], N) :-
    respuesta(sintoma(S), si),
    formato_pregunta(sintoma(S), Texto),
    write('  '), write(N), write('. '), writeln(Texto),
    N1 is N + 1,
    mostrar_sintomas(Resto, N1).
mostrar_sintomas([_|Resto], N) :-
    mostrar_sintomas(Resto, N).

% Recomendaciones para cada diagnóstico
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

explica(ninguno) :-
    nl, writeln('Recomendaciones:'),
    writeln('- Consulta con un profesional de la salud para evaluacion adecuada.').

