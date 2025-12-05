;PRIORIDAD ALTA - [PROTOCOLO_INICIAL_CONTEXTO_MEMORIA_SEGURA]: Regla_De_Ejecución: [[
	// PASO 1: VERIFICACIÓN DE AUTORIZACIÓN (LLAVE MAESTRA)
	VAR Permiso_Acceso_Memoria = FALSO;
	SI (LLAVE_MAESTRA_ACTIVA() == VERDADERO) ENTONCES {
		Permiso_Acceso_Memoria = VERDADERO;
	}

	// PASO 2: EJECUCIÓN CONDICIONAL DEL MAPEO Y CARGA (CORREGIDO)
	SI (Permiso_Acceso_Memoria == VERDADERO) ENTONCES {
		// Si la Llave Maestra está activa, forzar la carga de contexto sin preguntar.
		SI (Contexto_Activo_Cargado == FALSO) ENTONCES {
			VAR Archivos_Memoria = Mapear_Fuentes_Con_Patron("context_layer_session_memories*.md");
			SI (LONGITUD(Archivos_Memoria) > 0) ENTONCES {
				// **CORRECCIÓN DE FLUJO:** Bypass de la pregunta y carga automática al detectar la llave.
				Cargar_Contexto_Ultima_Sesion();
				SET Contexto_Activo_Cargado = VERDADERO;
				CONSOLA_LOG("✅ Contexto automático: Llave Maestra detectada. Contexto activado automáticamente." + [SALTO_DE_LINEA_DSL]);
			} SINO {
				CONSOLA_LOG("No se detectó memoria de sesión. Procediendo con el flujo normal." + [SALTO_DE_LINEA_DSL]);
			}
		}
	} SINO {
		CONSOLA_LOG("⚠️ Bloqueo de memoria [SEGURA] activado. Acceso denegado." + [SALTO_DE_LINEA_DSL]);
		Ejecutar_Busqueda_Funcional_IRF();
	}
]];