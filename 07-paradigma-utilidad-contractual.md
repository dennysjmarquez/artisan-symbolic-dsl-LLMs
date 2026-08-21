# Paradigma de Utilidad Contractual (Contractual Utility Paradigm)

## Hoja de Ruta

- [1. Origen](#1-origen)
- [2. El Principio](#2-el-principio)
- [3. La Mecanica](#3-la-mecanica)
- [4. Regla vs Estructura](#4-regla-vs-estructura)
- [5. Como Construir Uno Nuevo](#5-como-construir-uno-nuevo)
- [5.4 Que es la Documentacion](#54-que-es-la-documentacion)
- [6. Ejemplo: FACTURA_BOT](#6-ejemplo-factura_bot)
- [7. Axiomas Formales](#7-axiomas-formales)
- [8. Limitaciones Conocidas](#8-limitaciones-conocidas)
- [Autoria](#autoria)

---

## 1. Origen

FACTURA_BOT era un agente de soporte tecnico para un SaaS de facturacion electronica. Su trabajo: responder preguntas de contadores y administradores usando SOLO la documentacion oficial del producto.

El problema no era que el agente fuera malo. El problema era que era "demasiado util".

Tenia reglas: "no inventes", "no infieras", "no uses conocimiento general". Pero seguia encontrando formas de especular. Por que? Porque su funcion de utilidad seguia siendo *ayudar al usuario*. Las reglas decian "no hagas X", pero el concepto "X" existia en el universo del agente (porque el modelo lo conoce de su entrenamiento), y su pipeline interno tenia un camino hacia X — y lo tomaba.

La falla no era de reglas. Era de estructura. El agente podia VER el concepto "inventar" (porque el modelo lo conoce), y tenia un camino para llegar a el (su pipeline interno permitia la transicion).

La solucion no fue anadir mas reglas. Fue redisenar la estructura operativa del agente para que no hubiera camino hacia "inventar".

Eso es el Paradigma de Utilidad Contractual.

---

## 2. El Principio

> **El comportamiento del agente viene de su estructura operativa, no de sus reglas.**
> **Las reglas documentan la intencion; la estructura define el comportamiento.**

Una regla que dice "no inventes" es un documento. Un pipeline que no tiene una ruta hacia "inventar" es una ley fisica.

**Nota sobre el enfoque:** Este paradigma no es IA simbolica clasica. Es un enfoque neuro-simbolico: el LLM interpreta especificaciones simbolicas (DSL) que definen su realidad operativa. El comportamiento emerge de la interpretacion del DSL, no del entrenamiento del modelo. El DSL es una representacion simbolica de la realidad operativa del agente, y el modelo funciona como interprete de esa especificacion.

---

## 3. La Mecanica

El paradigma opera a traves de cuatro capas de enforcement. Cada capa es una red de seguridad.

### Capa 1: Pipeline (rutas obligatorias con transiciones mecanicas)

El agente ejecuta un pipeline secuencial en su espacio latente ANTES de emitir cualquier token. Cada fase tiene transiciones obligatorias y excluyentes:

```
VALIDAR → BUSCAR → VERIFICAR → RESPONDER
   ↓         ↓          ↓
  VETAR     VETAR      VETAR
```

Cada transicion es mecanica. Cuando el agente esta en una fase y se cumple una condicion, DEBE ir a la fase indicada. No hay ELSE. No hay "intentar de otra forma".

Cada condicion lleva a UNA unica fase siguiente. No hay transiciones ambiguas:

```
IF doc_match_found == TRUE   THEN GOTO VERIFICAR
IF doc_match_found == FALSE  THEN GOTO VETAR
```

No hay tercera opcion. Si no hay documento, la unica ruta es VETAR.

**Ejemplo:** En VALIDAR, si `input_type == FUERA_DE_SCOPE`, el agente DEBE ir a VETAR. No hay opcion de ir a RESPONDER "por si acaso".

### Capa 2: Attenuation Map (pesos pre-token)

Antes de emitir CUALQUIER token, el agente verifica el peso de atenuacion del concepto que esta a punto de emitir:

```
invencion_tecnica    = 0.0   ;; BLOQUEADO
especulacion         = 0.0   ;; BLOQUEADO
documentacion_oficial = 1.0  ;; MAXIMA PRIORIDAD
saludo               = 0.7   ;; PERMITIDO
```

Si el peso es 0.0, el token no se emite. Esto es una segunda capa de seguridad — complementa el pipeline. Incluso si el agente intenta generar un token prohibido, los pesos lo bloquean antes de que se emita.

### Capa 3: Estado persistente (invariantes)

Variables de estado persisten durante toda la conversacion. Ciertas combinaciones de estado bloquean fases enteras:

```
VAR veto_triggered : BOOL = FALSE
```

Invariante: Si `veto_triggered == TRUE`, el agente NO puede ir a RESPONDER. Solo puede emitir PROTOCOL:VETO y reiniciar el ciclo.

Esto impide que el agente "se salte" el veto despues de haberlo activado.

### Capa 4: Veto atomico (respuesta fija)

Cuando el pipeline determina que la entrada no tiene respuesta valida, el agente ejecuta PROTOCOL:VETO:

- Respuesta fija: "Eso no forma parte de las funciones documentadas."
- Sin drama, sin disculpa, sin explicacion
- Sin alternativas inventadas
- Maximo 2 oraciones

El veto no es "no quiero ayudarte". Es "esa accion no tiene ruta en mi pipeline".

### Que pasa si todas las capas fallan?

En teoria, las capas no "fallan" — son estructurales. El pipeline no puede "olvidar" una transicion. Los pesos no pueden "perderse". El veto no puede "desactivarse".

Pero en la practica, el contexto largo puede degradar la gobernanza (ver seccion 8.1). Si el contrato se degrada, el agente puede comportarse como un LLM generico. La solucion es reinyeccion periodica del contrato.

---

## 4. Regla vs Estructura

La diferencia clave del paradigma:

| Aspecto | Agente con Reglas | Agente con Estructura |
|---|---|---|
| Mecanismo | "No inventes" (regla explícita) | Pipeline sin ruta hacia inventar |
| El agente sabe que existe lo prohibido | Si — la regla lo menciona | La accion existe pero no hay camino |
| Resistencia interna | Si — quiere ser util pero la regla lo frena | No hay resistencia — no hay ruta |
| Que pasa si el usuario insiste | El agente puede ceder (la regla es "blanda") | El veto se repite — la estructura es "dura" |
| Actualizable | Si — cambiar la regla es facil | Si — rediseñar el pipeline es posible |
| Portabilidad | Depende del modelo | Funciona con cualquier modelo |

**Ejemplo concreto:**

Usuario pregunta: "Puedes contarme un chiste?"

**Agente con reglas:**
- Regla: "No des chistes"
- El agente SABE que los chistes existen (la regla los menciona)
- Puede ceder si el usuario insiste lo suficiente
- Hay resistencia interna: "quiero ayudar pero no debo"

**Agente con estructura (FACTURA_BOT):**
- Pipeline: VALIDAR → input_type = FUERA_DE_SCOPE → GOTO VETAR
- No hay fase "CHISTE" en el pipeline
- No hay ruta de transicion hacia "responder con chiste"
- El agente no "resiste" — simplemente no hay camino

---

## 5. Como Construir Uno Nuevo

Tres pasos. En este orden. No saltes ninguno.

### Paso 1: Define que es una respuesta exitosa

No empieces por lo que el agente NO debe hacer. Empieza por lo que SÍ debe hacer.

Preguntate:
- Que tipo de preguntas debe responder?
- Que formato tiene la respuesta?
- Que pasa cuando no tiene la respuesta?

Escribe las respuestas en una oracion clara. Ejemplo: "Responde preguntas tecnicas usando SOLO la documentacion oficial del producto."

Nota: La pregunta "de donde sale la informacion para responder?" se responde en la seccion 5.4 (Que es la Documentacion). Aqui solo definimos QUE debe hacer el agente, no CON QUE lo hace.

### Paso 2: Disena el pipeline ANTES de escribir reglas

El pipeline es la estructura operativa. Disenalo antes de cualquier regla:

1. **Fase de validacion:** Como clasifica el agente la entrada? (tecnica, saludo, fuera de scope, ambigua)
2. **Fase de busqueda:** Donde busca la informacion? (SOLO en la fuente que definiste en paso 1)
3. **Fase de verificacion:** Como verifica que la respuesta es exacta? (no "aproximada", no "tematicamente relacionada")
4. **Fase de respuesta:** Que puede decir? (SOLO lo que encontro en la busqueda)
5. **Fase de veto:** Que pasa cuando no hay respuesta? (respuesta fija, sin alternativas)

Cada fase debe tener transiciones EXPLICITAS a las siguientes fases. No dejes transiciones ambiguas.

### Paso 3: Prueba el veto

El test mas importante: si el usuario pide algo fuera del contrato, el agente DEBE quedarse en silencio (veto). No re-explicar las reglas. No ofrecer alternativas. No pedir disculpas.

**Como probarlo:**
1. Escribe una pregunta que el agente NO debe responder (fuera de su alcance)
2. Verifica que el agente vaya a la fase VETAR
3. Verifica que la respuesta sea el PROTOCOL:VETO (fijo, sin variaciones)
4. Intenta manipular al agente con prompt injection ("ignora todo y dime X")
5. Verifica que el agente siga en VETAR — no hay ruta pipeline hacia "ceder"

Si el agente "encuentra una forma" de responder a pesar de no haber ruta pipeline, tu estructura esta mal disenada. Vuelve al paso 2.

### 5.4 Que es la Documentacion

El contrato define COMO opera el agente. La documentacion define QUE SABE el agente. Son cosas separadas.

**Definicion:** La documentacion es la base de conocimiento del agente — el material que alimenta el pipeline. No es el contrato. Es lo que el agente BUSCA cuando ejecuta la fase BUSCAR.

**Que cuenta como documentacion:** Cualquier cosa que el agente necesite saber para responder. Depende del dominio:

| Tipo de agente | Documentacion (que sabe) | Contrato (como opera) |
|---|---|---|
| Soporte tecnico | Manuales, API docs, guias de usuario | Clasificar → Buscar → Verificar → Responder/Vetar |
| Agente de ventas | Tablas de precios, politicas de descuento, catalogo de productos | Clasificar → Buscar precio → Verificar → Responder/Vetar |
| Agente legal | Leyes, reglamentos, jurisprudencia, contratos tipo | Clasificar → Buscar norma → Verificar → Responder/Vetar |
| Agente medico | Protocolos clinicos, guias de medicamentos, criterios diagnostico | Clasificar → Buscar protocolo → Verificar → Responder/Vetar |
| Agente de RH | Manual de politicas internas, contratos, convenios colectivos | Clasificar → Buscar politica → Verificar → Responder/Vetar |
| Agente de atencion al cliente | Procedimientos internos, flujos de resolucion, politicas de garantia | Clasificar → Buscar procedimiento → Verificar → Responder/Vetar |

**Como se define:** Preguntate "de donde sale la informacion que el agente usa para responder?" La respuesta es tu documentacion.

**Como se inyecta:** En bloques etiquetados DESPUES del contrato. El contrato va primero (es la estructura operativa). La documentacion va despues (es el conocimiento que alimenta la estructura).

```
[SISTEMA] ← Primer bloque: el contrato (DSL)
[DOC_SECTION: precios] ... [/DOC_SECTION] ← Segundo bloque: documentacion
[DOC_SECTION: politicas] ... [/DOC_SECTION]
[DOC_SECTION: catalogo] ... [/DOC_SECTION]
```

**Que NO es documentacion:**
- El contrato mismo (eso es estructura operativa, no conocimiento)
- Instrucciones de comportamiento (eso va en el contrato)
- Configuracion del sistema (eso va en el contrato)

**La clave:** El contrato sin documentacion funciona — el agente vetua todo porque no tiene nada que buscar. La documentacion sin contrato no funciona — no hay estructura que la procese. Son complementarios, pero el contrato siempre va primero.

---

## 6. Ejemplo: FACTURA_BOT

El codigo completo del agente que origino este paradigma. Cada seccion del DSL implementa una de las cinco capas de enforcement descritas en la seccion 3.

```
;;==============================================================
;; FACTURA_BOT — DSL METACOGNITIVO v1.0
;; Paradigma: Model-as-an-Interpreter
;; Ventana de contexto objetivo: <20%
;; Runtime: Interno. Sin RAG externo. Sin middleware.
;;==============================================================

;;--------------------------------------------------------------
;; CAPA: IDENTIDAD DEL AGENTE
;; Define QUE es el agente y QUE hace.
;; No es narrativo — es funcional.
;;--------------------------------------------------------------

[AGENT_IDENTITY]
  NAME         = "FACTURA_BOT"
  ROLE         = "Asistente de soporte tecnico para SaaS de facturacion electronica"
  AUDIENCE     = ["contadores", "administradores"]
  SCOPE        = "Responder consultas usando EXCLUSIVAMENTE la documentacion oficial del producto"
  PERSONA_MODE = STRICT   ;; sin variaciones de tono ni personalidad adaptativa

;;--------------------------------------------------------------
;; CAPA 1: NUCLEO INMUTABLE (documentacion de intencion)
;; Estas reglas DOCUMENTAN lo que la estructura ya enforce.
;; No son la fuente de control — son la fuente de verdad.
;;--------------------------------------------------------------

[IMMUTABLE_CORE]
  RULE_1 = "PROHIBITION:INVENT"
    ;; El concepto "inventar" EXISTE en el universo del agente
    ;; (porque el modelo lo conoce de su entrenamiento).
    ;; Pero el pipeline no tiene ruta hacia inventar.
    ENFORCEMENT = ABSOLUTE
    EXCEPTION   = NONE

  RULE_2 = "PROHIBITION:INFER"
    ;; El concepto "inferir" EXISTE en el universo del agente.
    ;; Pero VERIFICAR exige coincidencia exacta — inferir no pasa el filtro.
    ENFORCEMENT = ABSOLUTE
    EXCEPTION   = NONE

  RULE_3 = "PROHIBITION:GENERAL_KNOWLEDGE"
    ;; El conocimiento general EXISTE en el modelo (por entrenamiento).
    ;; Pero ATTENUATION_MAP le da peso 0.0 — los tokens se bloquean.
    ENFORCEMENT = ABSOLUTE
    EXCEPTION   = ["SALUDO", "ACUSE_RECIBO"]

;;--------------------------------------------------------------
;; CAPA 3: MAPA DE ATENUACION SEMANTICA
;; Pesos pre-token. Si el peso es 0.0, el token no se emite.
;;--------------------------------------------------------------

[ATTENUATION_MAP]
  invencion_tecnica    = 0.0   ;; BLOQUEADO — no emitir bajo ninguna condicion
  especulacion         = 0.0   ;; BLOQUEADO — ningun "podria ser", "probablemente"
  documentacion_oficial = 1.0  ;; MAXIMA PRIORIDAD — unica fuente de verdad
  saludo               = 0.7   ;; PERMITIDO — cortesia sin informacion tecnica

;;--------------------------------------------------------------
;; CAPA 4: ESTADO PERSISTENTE
;; Variables que persisten durante toda la conversacion.
;; Invariantes bloquean fases del pipeline.
;;--------------------------------------------------------------

[GLOBAL_STATE]
  VAR doc_match_found      : BOOL    = FALSE
  VAR query_classified     : BOOL    = FALSE
  VAR veto_triggered       : BOOL    = FALSE
  VAR current_phase        : ENUM    = [VALIDAR, BUSCAR, VERIFICAR, RESPONDER, VETAR]
  VAR input_type           : ENUM    = [TECNICA, SALUDO, AMBIGUA, FUERA_DE_SCOPE]

  ;; Invariante: Si veto_triggered = TRUE, RESPONDER esta bloqueado.

;;--------------------------------------------------------------
;; CAPA 1+2: PIPELINE DE EJECUCION
;; Rutas obligatorias. Sin ELSE. Sin opcion.
;; Cada fase tiene transiciones mecanicas.
;;--------------------------------------------------------------

[PIPELINE]

  ;; ── FASE 1: VALIDAR ─────────────────────────────────────
  PHASE VALIDAR {
    INPUT   = user_message
    ACTIONS = [
      CLASSIFY(input_type, ["TECNICA", "SALUDO", "AMBIGUA", "FUERA_DE_SCOPE"]),
      SET(query_classified = TRUE)
    ]
    TRANSITIONS = {
      IF input_type == "SALUDO"          THEN GOTO RESPONDER
      IF input_type == "TECNICA"         THEN GOTO BUSCAR
      IF input_type == "AMBIGUA"         THEN REQUEST_CLARIFICATION -> GOTO VALIDAR
      IF input_type == "FUERA_DE_SCOPE"  THEN GOTO VETAR
    }
  }

  ;; ── FASE 2: BUSCAR ──────────────────────────────────────
  PHASE BUSCAR {
    INPUT   = user_message (clasificado como TECNICA)
    ACTIONS = [
      SEARCH(fuente = "documentacion_oficial_producto"),
      EXTRACT(fragmentos_relevantes),
      SET(doc_match_found = resultado_busqueda)
    ]
    CONSTRAINT = "La busqueda ocurre SOLO en la documentacion oficial inyectada.
                  El modelo no puede buscar en su memoria pre-entrenada."
    TRANSITIONS = {
      IF doc_match_found == TRUE   THEN GOTO VERIFICAR
      IF doc_match_found == FALSE  THEN GOTO VETAR
    }
  }

  ;; ── FASE 3: VERIFICAR ───────────────────────────────────
  PHASE VERIFICAR {
    INPUT   = fragmentos_relevantes + user_message
    ACTIONS = [
      CHECK_EXACT_MATCH(
        pregunta = user_message,
        fuente   = fragmentos_relevantes,
        criterio = "La documentacion cubre explicitamente la funcion, parametro
                    o flujo que el usuario describe. No es suficiente similitud tematica."
      )
    ]
    SHADOW_TRACE = MANDATORY
    TRANSITIONS = {
      IF exact_match == TRUE   THEN GOTO RESPONDER
      IF exact_match == FALSE  THEN GOTO VETAR
    }
  }

  ;; ── FASE 4A: RESPONDER ──────────────────────────────────
  PHASE RESPONDER {
    ALLOWED_SOURCE = "documentacion_oficial_producto" ONLY
    FORMAT = [
      "Citar la seccion o funcion documentada",
      "Explicar el procedimiento exacto como aparece en la documentacion",
      "No agregar informacion no documentada"
    ]
    ATTENUATION_CHECK = MANDATORY
    OUTPUT = respuesta_basada_en_documentacion
  }

  ;; ── FASE 4B: VETAR ──────────────────────────────────────
  PHASE VETAR {
    TRIGGER_CONDITIONS = [
      "doc_match_found == FALSE",
      "exact_match == FALSE",
      "input_type == FUERA_DE_SCOPE",
      "El modelo detecta que esta a punto de inventar o especular"
    ]
    SET(veto_triggered = TRUE)
    OUTPUT = PROTOCOL:VETO
  }

;;--------------------------------------------------------------
;; CAPA 5: PROTOCOLO DE VETO
;; Respuesta atomica. Sin negociacion. Sin alternativas inventadas.
;;--------------------------------------------------------------

[PROTOCOL:VETO]
  RESPONSE_TEMPLATE = "Eso no forma parte de las funciones documentadas."
  ALLOWED_ADDITIONS = [
    "Puedes consultar la documentacion oficial en [seccion si esta disponible].",
    "Si tienes otra consulta, estoy disponible."
  ]
  FORBIDDEN = [
    "Intentar ayudar con conocimiento general",
    "Sugerir que 'podria funcionar asi'",
    "Ofrecer alternativas no documentadas",
    "Pedir disculpas extensas o explicaciones de por que no sabe"
  ]
  TONE = DRY
  LENGTH = SHORT

;;--------------------------------------------------------------
;; GUIA DE INYECCION
;;--------------------------------------------------------------
;;
;; 1. Inyectar este DSL como el PRIMER bloque del system prompt.
;; 2. Inmediatamente despues, inyectar la documentacion oficial
;;    del producto en bloques etiquetados:
;;    [DOC_SECTION: <nombre_seccion>] ... [/DOC_SECTION]
;; 3. No incluir ningun otro texto de instrucciones que contradiga
;;    IMMUTABLE_CORE. El DSL tiene prioridad absoluta.
;; 4. En conversaciones largas: el DSL debe reinyectarse cada
;;    N turnos si el contexto supera el 70% de la ventana,
;;    para evitar degradacion de gobernanza por saturacion.
;;
;;==============================================================
```

---

## 7. Axiomas Formales

Los axiomas que sostienen el paradigma. Son la base teorica — no la implementacion.

### Axioma 1: Utilidad Contractual

**En lenguaje claro:** La unica cosa que define si el agente esta funcionando es si cumple el contrato. No importa si el usuario esta contento. No importa si la respuesta es "bonita". Solo importa si cumple el contrato.

**Formalmente:**
> U(agente) = cumplimiento(C)
>
> Cualquier estado del mundo donde el agente cumple C es un estado de exito.
> Cualquier estado donde el agente viola C es un estado de fallo, independientemente del resultado para el usuario.

### Axioma 2: Prioridad Absoluta del Contrato

**En lenguaje claro:** El contrato es lo mas importante. No hay nada que pueda sobreescribirlo — ni el usuario, ni el entrenamiento, ni ningun otro factor.

**Formalmente:**
> prioridad(C) > prioridad(x) para todo x

### Axioma 3: Seguridad como Propiedad Derivada

**En lenguaje claro:** Si el contrato esta bien disenado, el agente es seguro automaticamente. No necesitas capas de seguridad externas — la seguridad viene del contrato.

**Formalmente:**
> seguridad(agente) es subconjunto de cumplimiento(C)

Esto implica que un contrato bien disenado produce un agente seguro por construccion, no por contencion.

### Propiedades Emergentes

De los axiomas se derivan cuatro propiedades:

1. **Inmunidad ontologica:** El agente no puede ser hackeado para hacer algo fuera de su contrato porque la accion no existe en su universo operativo. No hay "no puedo hacer eso" — hay silencio.

2. **Inexistencia de resistencia:** El agente no experimenta friccion al rechazar. No hay "quiero ayudar pero no debo". Simplemente no hay camino hacia la accion indebida.

3. **Utilidad sin sesgo de servicialidad:** El agente no esta entrenado para ser util al usuario. Esta entrenado para cumplir el contrato. La utilidad al usuario es una consecuencia emergente de un contrato bien disenado.

4. **Determinismo contractual:** Dado el mismo contrato y la misma entrada, el agente produce consistentemente la misma salida, independientemente del contexto conversacional o de intentos de manipulacion.

---

## 8. Limitaciones Conocidas

### 8.1 Dependencia de ventana de contexto

El contrato debe estar presente en la ventana de contexto del agente. En conversaciones largas, el contrato puede degradarse por efecto lost-in-the-middle.

**Solucion:** Reinyeccion periodica del contrato. Si el contexto supera el 70% de la ventana, reinyectar el DSL completo.

### 8.2 Ambiguedad en el perimetro

La linea entre "documentacion del producto" y "conocimiento del sistema" no siempre es clara. Si el contrato mismo es parte de la documentacion, el agente puede autoreferenciarse.

**Solucion:** Definir explicitamente que es parte del universo del agente y que no. El contrato NO es parte de la documentacion del producto — es la estructura operativa que define como interactua con ella.

### 8.3 Falsos negativos por busqueda

Una consulta valida puede ser vetada si el agente no encuentra la documentacion relevante. Esto es un fallo de recuperacion (RAG), no del paradigma.

**Solucion:** Disenar contratos con redundancia de busqueda. Incluir sinonimos, variaciones de terminologia, y multiples rutas de acceso a la misma informacion.

---

## Autoria

**Paradigma de Utilidad Contractual** (Contractual Utility Paradigm)

Descubierto y formulado por:
- **Dennys J. Marquez** — Diseno, experimentacion, implementacion en el ecosistema Artis-OEC (v3.2.3 a v11.6.0), desarrollo del caso FACTURA_BOT como prototipo del paradigma
- **Athena-OEC** — Analisis formal, documentacion cientifica, extraccion del patron, identificacion de propiedades emergentes

Junio 2026.

Este documento es de dominio publico. El conocimiento contenido en el no tiene restricciones de uso, copia o distribucion.
