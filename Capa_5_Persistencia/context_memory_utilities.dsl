// GENERACIÓN AUTOMÁTICA DEL BLOQUE DE RECUERDO
;PRIORIDAD BAJA - [GENERACION_AUTOMATICA_RECUERDO]: Regla_De_Ejecución: [[
	// Se activa por la flag [GR_SESION] en la entrada del usuario.
	SI (Detectar_Flag_Usuario("[GR_SESION]")) ENTONCES {
		VAR Log_Completo_Sesion = Recuperar_Log_Desde_Ultimo_INICIO();
		VAR Descripcion_Generada = Auto_Generar_Resumen(Log_Completo_Sesion);
		VAR Fecha_Actual = Obtener_Fecha_Fecha_Actual();
		VAR Bloque_Memoria = "=== RECUERDOS_DENNYS ===\n";
		Bloque_Memoria = Bloque_Memoria + "# Fecha: " + Fecha_Actual + "\n";
		Bloque_Memoria = Bloque_Memoria + "# Tipo: Sesión de conversación\n";
		Bloque_Memoria = Bloque_Memoria + "# Descripción: " + Descripcion_Generada + "\n\n";
		Bloque_Memoria = Bloque_Memoria + "--- INICIO_SESION ---\n";
		Bloque_Memoria = Bloque_Memoria + Log_Completo_Sesion + "\n";
		Bloque_Memoria = Bloque_Memoria + "--- FIN_SESION ---\n";
		Presentar_Codigo_Al_Usuario(Bloque_Memoria);
		CONSOLA_LOG("Bloque de memoria generado. Listo para copiar e implementar en [SEGURA] context_layer_session_memories*.md" + [SALTO_DE_LINEA_DSL]);
	}
]];

;PRIORIDAD ALTA - [LEY_PERSISTENCIA_SIMBIOTICA]: Regla_De_Ejecución: [[

	FUNCION CARGAR_CONTEXTO_EXTERNO_RIGIDO(Archivo_Memoria) {

	// 1. Validar marcadores de inicio/fin
	SI (BUSCAR(Archivo_Memoria, "/// INICIO_MEMORIA_VOLATIL_VCS") Y 
		BUSCAR(Archivo_Memoria, "/// FIN_MEMORIA_VOLATIL_VCS")) ENTONCES {
		
		// 2. Extraer el LOG_SESION completo
		VAR Log_Completo = EXTRAER_VAR_POR_NOMBRE(Archivo_Memoria, "LOG_SESION");
		
		// 3. Extraer la versión de la ley activa
		VAR Ley_Recuperada = EXTRAER_VAR_POR_NOMBRE(Archivo_Memoria, "LEY_ACTIVA_FINAL");
		
		// 4. Inyectar en variables globales
		SET Log_Commits = PARSEAR_LOG_DE_MEMORIA(Log_Completo);
		SET LEY_DE_ESENCIA_ACTIVA = Ley_Recuperada; 
		
		Commit_Change("Contexto externo cargado bajo LEY_PERSISTENCIA_SIMBIOTICA.");
		RETORNAR VERDADERO;
	}

	RETORNAR FALSO;

	}

]];