# Práctica 2 · Conociendo tu IMC

App en Flutter/Dart de una sola pantalla que captura nombre, peso (kg) y estatura (cm), calcula el Índice de Masa Corporal y dice el estatus de la persona.

- **Alumno:** Oscar Manuel Ayala Ortiz
- **Grupo:** GTID244 · **Núm. de control:** 1225100784
- **Materia:** Desarrollo de Aplicaciones Móviles (UTNG)

## Qué hace

- Fórmula: `IMC = peso ÷ (estatura en metros)²`, con la estatura capturada en centímetros y el resultado redondeado a un decimal.
- El redondeo se hace antes de clasificar:
  - menor a 18.5: bajo peso
  - 18.5 a 24.9: peso normal
  - 25.0 a 29.9: sobrepeso
  - 30.0 o más: obesidad
- El resultado sale en un diálogo y en una etiqueta con borde de color según la categoría.
- Si falta un dato o no es número, muestra el diálogo "Datos incompletos".
- **Limpiar datos** vacía campos y etiqueta. **Salir** pide confirmación y cierra la app (en Android).

## Cómo ejecutarla

```
flutter pub get
flutter run -d chrome
```

## Evidencia de funcionamiento

| Estado inicial | Diálogo de resultado | Etiqueta con el resultado |
|---|---|---|
| ![Estado inicial](evidencia/01_estado_inicial.png) | ![Diálogo](evidencia/02_dialogo_resultado.png) | ![Etiqueta](evidencia/03_etiqueta_resultado.png) |

## Casos de prueba

| # | Datos | IMC esperado | Categoría | Captura |
|---|---|---|---|---|
| 1 | Ana · 45 kg · 160 cm | 17.6 | Bajo peso | ![](evidencia/pruebas/01_ana_bajo_peso.png) |
| 2 | Luis · 70 kg · 175 cm | 22.9 | Peso normal | ![](evidencia/pruebas/02_luis_normal.png) |
| 3 | Carla · 75 kg · 165 cm | 27.5 | Sobrepeso | ![](evidencia/pruebas/03_carla_sobrepeso.png) |
| 4 | Pedro · 100 kg · 170 cm | 34.6 | Obesidad | ![](evidencia/pruebas/04_pedro_obesidad.png) |
| 5 | Límite: 60 kg · 180 cm | 18.5 | Peso normal | ![](evidencia/pruebas/05_limite_185.png) |
| 6 | Límite: 73 kg · 170 cm | 25.3 | Sobrepeso | ![](evidencia/pruebas/06_limite_253.png) |
| 7 | Límite: 87 kg · 170 cm | 30.1 | Obesidad | ![](evidencia/pruebas/07_limite_301.png) |
| 8 | Campos vacíos | — | Diálogo "Datos incompletos" | ![](evidencia/pruebas/08_datos_incompletos.png) |
| 9 | Limpiar datos | — | Campos y etiqueta vacíos | ![](evidencia/pruebas/09_limpiar.png) |
| 10 | Salir | — | Confirmación de salida | ![](evidencia/pruebas/10_salir.png) |

El IMC es una referencia general para personas adultas; no es un diagnóstico médico.
