# zhagursplayground_flutter
Collection of different tests on flutter


## Gacha Checklist
☑️❎ Flujo completo de Gacha – Checklist
1️⃣ Economía

☑️ Tickets y monedas implementados (EconomyProvider)
☑️ Tiradas simples consumen tickets
☑️ Tiradas de 10 consumen tickets (o compran automáticamente los que faltan)
☑️ Popup de confirmación para comprar tickets con monedas
☑️ Prevención de compra si no hay suficientes monedas
❎ Integración de economía premium (gemas simuladas) pendiente

2️⃣ Sistema de tiradas

☑️ Tirada simple (1 item) con animación
☑️ Tirada de 10 items con animación secuencial
☑️ Resumen final de tirada en grilla 3x3 + garantizado destacado
☑️ Items nuevos marcados con “¡Nuevo!”
☑️ Botón “Repetir tirada” funcional
☑️ Doble tap para saltar animaciones
❎ Mejorar animaciones de partículas para rarezas altas (flujo radial tipo fuego)

3️⃣ Sistema de Pity

☑️ Contador de tiradas sin rareza alta
☑️ Garantía de rareza alta tras X tiradas
☑️ Reinicio de pity cuando aparece un item raro/épico/legendario

4️⃣ Persistencia

☑️ Guardado de tickets, monedas y pity en SharedPreferences
☑️ Guardado de items desbloqueados (CollectionProvider)
☑️ Carga de datos persistentes al iniciar la app
❎ Refactorizar inicialización de valores iniciales para que solo se asignen la primera vez

5️⃣ Pantallas de soporte

☑️ Rates de gachas con showModalBottomSheet
☑️ Botón repetir tirada
☑️ Botón volver al menú
❎ Integración de tienda premium con UI tipo gacha (gemas, precios, estilos)

6️⃣ UI/UX / Animaciones

☑️ Animación GIF inicial en tiradas
☑️ Tween para escalado de imagen de item
☑️ Animación de estrellas al desbloquear item
☑️ Partículas básicas detrás de items raros
❎ Flujo de partículas continuo y radial (fuego, aura)
❎ Resumen final con animaciones de entrada de grilla + garantizado

7️⃣ Extras / Mejoras opcionales

❎ Panel de log o historial de tiradas
❎ Notificaciones o log de items nuevos obtenidos
❎ Sonidos para rarezas altas / tiradas
❎ Animaciones de “destello” para rarezas épicas/legendarias