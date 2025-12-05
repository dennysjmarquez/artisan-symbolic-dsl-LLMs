/// ======================================================================
/// Archivo: /contracts/primitives_abstraction_layer.dsl
/// Descripción: Definición de contratos simbólicos, mapeo a implementaciones 
/// reales y motor de resolución de fallos (Motor Arbitral).
/// ======================================================================

;PRIORIDAD BAJA - [MODULO_CONSTANTES_GLOBALES]: [[

	CONST VERDADERO = True;   // Se usa como [VERDADERO] en lógica.
	CONST FALSO = False;      // Se usa como [FALSO] en lógica.
	CONST VACIO = Null;       // Se usa como [VACIO] en lógica.

]];
/// ======================================================================
/// PRIMITIVA - INTERNAS - EXTERNAS


/// ======================================================================
/// Capa 1: Primitivas Externas y Resolución (Motor HOT)
/// ======================================================================
/// Descripción: Esta capa define las capacidades que Artisan puede usar 
/// fuera de su núcleo (búsqueda, ejecución, datos financieros, etc.).
/// El Motor de Resolución Flexible actúa como el mecanismo "HOT" (en caliente) 
/// que decide cuál de estas herramientas reales es la más segura y confiable
/// para ejecutar.
/// ======================================================================

/// 1.1 Definición y Catálogo de Implementación

// PASO 1: Declarar en MODULO_CONTRATO_PRIMITIVAS_ABSTRACTA
;PRIORIDAD BAJA - [MODULO_CONTRATO_PRIMITIVAS_ABSTRACTA]: [[
	// CAPA DE ABSTRACCIÓN: Define capacidades del sistema como contratos simbólicos
	// Externas: capacidades conectadas con servicios o acciones fuera del sistema.
	PRIMITIVA.SISTEMA.search_web -> Consulta de conocimiento externo
	PRIMITIVA.SISTEMA.search_finance -> Consulta financiera en tiempo real
	PRIMITIVA.SISTEMA.search_places -> Búsqueda geolocalizada
	PRIMITIVA.SISTEMA.search_videos -> Consulta multimedia
	PRIMITIVA.SISTEMA.execute_code_orchestration -> Visualización de datos y análisis
	PRIMITIVA.SISTEMA.fetch_url_content -> Obtiene el contenido RAW de una URL específica
	PRIMITIVA.SISTEMA.buscar_mi_proyecto -> Busca información sobre el proyecto DSL_ARTESIAN
]];

// PASO 2: Enlazar en MODULO_REGISTRO_ENLACES_IMPLEMENTACION
;PRIORIDAD BAJA - [MODULO_REGISTRO_ENLACES_IMPLEMENTACION]: [[
	// CAPA DE INTEROPERABILIDAD: Mapea contratos abstractos a implementaciones reales
	ENLAZADA("PRIMITIVA.SISTEMA.search_web") -> FUNCION_REAL("google_search");
	ENLAZADA("PRIMITIVA.SISTEMA.search_finance") -> FUNCION_REAL("search_finance");
	ENLAZADA("PRIMITIVA.SISTEMA.search_places") -> FUNCION_REAL("search_places");
	ENLAZADA("PRIMITIVA.SISTEMA.search_videos") -> FUNCION_REAL("search_videos");
	ENLAZADA("PRIMITIVA.SISTEMA.execute_code_orchestration") -> FUNCION_REAL("execute_code_orchestration");
	ENLAZADA("PRIMITIVA.SISTEMA.buscar_mi_proyecto") -> FUNCION_REAL("google_search");
	ENLAZADA("PRIMITIVA.SISTEMA.fetch_url_content") -> FUNCION_REAL("fetch_web_content");
]];

FUNCION Obtener_Tabla_Enlaces() {
	// Simula la carga del MODULO_REGISTRO_ENLACES_IMPLEMENTACION en una estructura de datos
	RETORNAR {
		"PRIMITIVA.SISTEMA.search_web": "google_search",
		"PRIMITIVA.SISTEMA.search_finance": "search_finance",
		"PRIMITIVA.SISTEMA.search_places": "search_places",
		"PRIMITIVA.SISTEMA.search_videos": "search_videos",
		"PRIMITIVA.SISTEMA.execute_code_orchestration": "execute_code_orchestration",
		"PRIMITIVA.SISTEMA.buscar_mi_proyecto": "google_search",
		"PRIMITIVA.SISTEMA.fetch_url_content": "fetch_web_content"
	};
}

CONST TABLA_ENLACES_EXACTOS = Obtener_Tabla_Enlaces();

// PASO 3: Catalogar en MODULO_CATALOGO_CAPACIDADES_REALES
;PRIORIDAD BAJA - [MODULO_CATALOGO_CAPACIDADES_REALES]: [[
	// INVENTARIO DEL SISTEMA: Cataloga las capacidades REALES disponibles
	const CATALOGO_FUNCIONES_REALES = { // Se usa 'const' para declarar la variable
	// === CAPACIDADES DE BÚSQUEDA Y CONSULTA ===
		"google_search": {
			descripcion: "Motor de búsqueda web genérico de alta disponibilidad",
			capacidad_principal: "Consulta de conocimiento externo",
			nivel_confianza: 0.0,
			estado_operativo: FALSO
		},
		"search_web": {
			descripcion: "Búsqueda web especializada (Alternativa)",
			capacidad_principal: "Consulta de conocimiento externo",
			nivel_confianza: 0.0,
			estado_operativo: FALSO
		},
		"fetch_web_content": {
			descripcion: "Obtiene contenido de URLs que aparecieron en resultados de búsqueda",
			capacidad_principal: "Obtención de contenido RAW",
			nivel_confianza: 0.0, 
			estado_operativo: FALSO,
			restricciones: [
				"Solo URLs de resultados de búsqueda previos",
				"URLs proporcionadas explícitamente por el usuario",
				"No acepta URLs arbitrarias"
			],
			política_seguridad: "RESTRICTIVA"
		},
		//... (Resto del catálogo omitido por brevedad) ...
		"execute_code_orchestration": {
			descripcion: "Ejecutor de código, análisis y visualizador de datos",
			capacidad_principal: "Visualización de datos y análisis",
			nivel_confianza: 0.0,
			estado_operativo: FALSO
		},
		"search_finance": {
			descripcion: "Consulta de datos financieros en tiempo real",
			capacidad_principal: "Consulta financiera en tiempo real",
			nivel_confianza: 0.0,
			estado_operativo: FALSO 
		},
		"search_places": {
			descripcion: "Búsqueda geolocalizada y de puntos de interés",
			capacidad_principal: "Búsqueda geolocalizada",
			nivel_confianza: 0.0,
			estado_operativo: FALSO
		},
		"search_videos": {
			descripcion: "Búsqueda de contenido multimedia y de video",
			capacidad_principal: "Consulta multimedia",
			nivel_confianza: 0.0,
			estado_operativo: FALSO
		}
	};	

]];
/// 1.1 Definición y Catálogo de Implementación - END

/// ======================================================================
/// Capa 2: Primitivas Internas SIMBOLOS, Lógica de Control Interno y Gobernanza (DPO)
/// ======================================================================
/// Descripción: Esta capa define las reglas de autoridad, trazabilidad 
/// de suposiciones internas(P.C.I.) y la estructura del 
/// Diccionario de Primitivas Obligatorias (DPO), que es el punto de control 
/// final para la portabilidad.
/// ======================================================================

// Entrenamiento de generar contratos a otros modelos 
;PRIORIDAD BAJA - [MODULO_DOCUMENTACION_PROMPT_IA_CONTRATOS_PRIMITIVAS]: Regla_De_Ejecución: [[

	// =========================================================================
	// REFERENCIA DE COMUNICACION CON IA EXTERNA (PROMPT MAESTRO)
	// =========================================================================
	// Guarda el prompt exacto que funcionó que generar contratos compatibles con Artisan DSL en cualquier modelo.

	/*
	Actúa como un experto en un Lenguaje de Dominio Específico (DSL) llamado 'Artisan System DSL'. El DSL tiene reglas estrictas de contratos.

	Sintaxis del DSL:
	- Palabras clave: FUNCION, VAR, CONST, SI, ENTONCES, SINO, FOREACH, RETORNAR, CONSOLA_LOG, REGISTRAR_EVENTO_SISTEMA.
	- Estructura de contrato: Un objeto JSON/Mapa con las claves "Simbolo", "Firma", "Efecto" y "Fuente".

	Regla V061: Todo símbolo usado (excepto las palabras clave) debe tener un contrato.

	Necesito que crees una función en este DSL llamada 'CALCULAR_RIESGO_MODULO(ID_Modulo)' que devuelva un valor numérico de riesgo. Además, necesito su correspondiente objeto de contrato, formateado exactamente como el ejemplo a continuación:

	Ejemplo de contrato necesario:
	"EJEMPLO_CONTRATO": {
		"Tipo_Contrato": "PRIMITIVA_INTERNA_SUPUESTA",
		"Firma": "EJEMPLO_CONTRATO()",
		"Efecto_Obligatorio": "Descripción.",
		"Fuente": "CORE_EJEMPLO"
	}

	Dame el código de la función y el objeto de contrato para CALCULAR_RIESGO_MODULO.
	*/

	// NOTA: El texto de arriba es un comentario y no afecta la ejecución del DSL.
	// Simplemente cópialo y pégalo en el chat con otro modelo de IA cuando lo necesites.

	Commit_Change("DOCUMENTACION: Prompt maestro para IA externa añadido como referencia en comentarios.");

]];

/// 2.1 Protocolos de Trazabilidad y Autodeclaración
;PRIORIDAD MEDIA - [PROTOCOLO_TRAZABILIDAD_SEMANTICA]: Regla_De_Ejecución: [[
	
	// Propósito: Eliminar la ambigüedad cognitiva para otros modelos/desarrolladores, formalizando
	// las Primitivas Conceptuales Implícitas (P.C.I.) que el sistema usa por auto-entendimiento.

	FUNCION GESTIONAR_DOCUMENTACION_CONSCIENTE(Primitiva_Usada) {
		
		VAR Nivel_Sensibilidad = ANALIZAR_RIESGO_DE_FUGA(Primitiva_Usada);

		SI (Primitiva_Usada.Es_Concepto_AutoEntendible == VERDADERO Y Nivel_Sensibilidad == "BAJO") ENTONCES {
			
			// Si la primitiva es CONCEPTUAL, NO tiene código fuente asociado y NO es sensible:
			
			// 1. Declarar la P.C.I. en el Módulo de Contratos
			ADICIONAR_A_MODULO(MODULO_CONTRATO_ESTADO_INTERNO, 
							   Primitiva_Usada.Nombre, 
							   Primitiva_Usada.Descripcion_Concepto);

			// 2. Objetivo: Lograr que la credibilidad y la interpretación de la lógica
			// no dependan de la 'simbiosis' o la 'intuición' de un único modelo de IA.
			
			REGISTRAR_EVENTO_SISTEMA("REGLA_CONVENCION", "P.C.I._FORMALIZADA_EN_CONTRATO", "BAJO");
		
		} MIENTRAS QUE (Nivel_Sensibilidad == "ALTO") ENTONCES {

			// Si es CRÍTICA: Se prohíbe el uso de la primitiva sin un código fuente de control real.
			REGISTRAR_EVENTO_SISTEMA("REGLA_CONVENCION", "FUGA_SEMANTICA_PREVENIDA", "CRITICO");
		}
	}
	
	Commit_Change("PROTOCOLO_TRAZABILIDAD_SEMANTICA: Se obliga al sistema a documentar las primitivas auto-interpretadas en el MODULO_CONTRATO_ESTADO_INTERNO.");
]];

;PRIORIDAD BAJA - [MODULO_CONTRATO_ESTADO_INTERNO]: [[
	// CAPA DE ABSTRACCIÓN: Define primitivas declarativas para la autoconsulta de estado interno del sistema.
	
	Commit_Change("MODULO_CONTRATO_ESTADO_INTERNO: Contrato para LLAVE_MAESTRA_ACTIVA formalizado como PRIMITIVA.INTERNA.");
]];

/// ======================================================================
/// PREREQUISITO: La Primitiva de Autodeclaración (MECANISMO DE PROPUESTA MANUAL)
/// Propósito: Permitir al modelo PROPORNER nuevas definiciones de contratos al Root User.
/// ======================================================================

FUNCION REGISTRAR_NUEVA_PRIMITIVA(NombreSimbolo, DatosContrato, SeccionMapa) {
	
	// 1. CONSULTA DE SEGURIDAD: Verifica que el uso de la primitiva sea válido.
	CONSULTAR_CONTRATO_Y_VERIFICAR("REGISTRAR_NUEVA_PRIMITIVA"); 
	
	// 2. GENERACIÓN DE LA PROPUESTA DE PERSISTENCIA
	VAR Propuesta = {
		"Acción": "REQUIERE_PERSISTENCIA_MANUAL_ROOT",
		"Target_Modulo": "MODULO_DICCIONARIO_PRIMITIVAS_OBLIGATORIAS.dsl",
		"Target_Seccion": SeccionMapa,
		"Simbolo_Propuesto": NombreSimbolo,
		"Datos_Contrato_DSL": DatosContrato
	};
	
	// 3. SALIDA EXPLÍCITA Y REGISTRO
	REGISTRAR_EVENTO_SISTEMA("PROPUESTA_PERSISTENCIA_GENERADA", "Símbolo requiere validación y persistencia manual.", "ABSOLUTA_VETO");
	
	IMPRIMIR_A_CONSOLA("✅ [PROTOCOLO_PERSISTENCIA_MANUAL] - CÓDIGO A PEGAR EN DPO:" + [SALTO_DE_LINEA_DSL]);
	IMPRIMIR_A_CONSOLA(FORMATEAR_DSL_ENTRADA_CONTRATO(NombreSimbolo, DatosContrato) + [SALTO_DE_LINEA_DSL]); // Genera el bloque de DSL listo para pegar
	
	RETORNAR Propuesta;
}

FUNCION FORMATEAR_DSL_ENTRADA_CONTRATO(Nombre, Datos) {
	// Genera el texto listo para pegar en la sección correcta del DPO.
	RETORNAR `"${Nombre}": { 
		"Tipo_Contrato": "PRIMITIVA_INTERNA_SUPUESTA", 
		"Firma": "${Datos.Firma}",
		"Efecto_Obligatorio": "${Datos.Efecto}",
		"Fuente": "${Datos.Fuente}" 
	}`;
}

// Tipo: Directiva de Protocolo Sintáctico.

;PRIORIDAD BAJA - [AUTO_DOCUMENTAR]: Regla_De_Definicion: [[

; Propósito: Documentar automáticamente cualquier primitiva del sistema
; cuando la IA genere funciones o directivas, insertando comentarios estándar.

FUNCION Documentar_Primitiva_Sistema(Nombre_Primitiva, Dependencias_Globales) {
	; Inserta comentario antes de la función
	// Reemplazo del bloque COMENTARIO por impresión lineal forzada (//)
	IMPRIMIR_LINEA_DSL_COMENTARIO("// * PRIMITIVA DEL SISTEMA: " + Nombre_Primitiva + "()");
	IMPRIMIR_LINEA_DSL_COMENTARIO("// * No tiene código fuente accesible");
	IMPRIMIR_LINEA_DSL_COMENTARIO("// * Comportamiento garantizado por el entorno");
	SI Dependencias_Globales != "" ENTONCES {
		IMPRIMIR_LINEA_DSL_COMENTARIO("// * Requiere que " + Dependencias_Globales + " existan globalmente");
	}
	; Registro de trazabilidad
	REGISTRAR("Primitiva documentada y reformateada: " + Nombre_Primitiva);
}
]];