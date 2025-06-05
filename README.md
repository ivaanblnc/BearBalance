# tfg_ivandelllanoblanco

# 🐻 BearBalance

**BearBalance** es una aplicación de finanzas personales multiplataforma desarrollada con **Flutter**, cuyo propósito es ayudarte a tomar el control de tus finanzas de forma visual, interactiva y personalizada.

Ofrece un completo seguimiento de tus movimientos económicos, metas financieras y hábitos, todo sincronizado en la nube gracias a **Supabase**.

---

## ✨ Funcionalidades principales

### 📊 Pantalla principal (Dashboard)
- **Gráfico trimestral** con análisis de ingresos y gastos.
- **Resumen financiero** por trimestres.
- Visualización rápida de **metas activas**.

### 💸 Movimientos financieros
- Añadir, editar y eliminar **ingresos y gastos**.
- Filtrar movimientos por **fecha o tipo**.
- Visualización de:
  - Saldo total
  - Total de ingresos
  - Total de gastos
- **Gráfico detallado** de evolución financiera.
- Almacenamiento persistente en la **nube con Supabase**.

### 🎯 Gestión de metas
- Añadir, editar o eliminar **metas financieras**.
- Visualización de metas activas y completadas.
- Enlace directo a **cursos de Udemy** relacionados con finanzas personales y educación financiera.

### 👤 Perfil de usuario
- Modificar nombre, correo y **foto de perfil**.
- Cambiar **tema de la aplicación** (oscuro/claro).
- Información del usuario sincronizada con **Supabase Auth**.

---

## 🧪 Tecnologías utilizadas

- **Flutter** + **Dart**
- **Supabase** (Auth, Realtime Database, Storage)
- **Material Design** para UI moderna
- **Gráficos personalizados** con `fl_chart`
- **Responsive UI** para móvil y tablet

---

## 📂 Estructura del proyecto

```plaintext
BearBalance/
├── assets/                ¡
├── lib/
│   ├── models/            
│   ├── views/           
│   ├── widgets/         
│   ├── controllers/          
│   ├── components/
│   ├── entidades/           
│   └── main.dart
│   └── my_custom_scroll_behavior.dart         
├── pubspec.yaml          
└── README.md             

## 🚀 Instalación y ejecución local

1. **Clona el repositorio:**

```bash
git clone https://github.com/ivaanblnc/BearBalance.git
cd BearBalance
```
2. **Instala las dependencias:**
```bash
flutter pub get
```` 
3. **Crea un archivo .env o configura Supabase en lib/services/supabase.dart con tu URL y clave anónima.**
4. **Ejecuta la app:**
````bash
flutter run
````
Asegúrate de tener un emulador o dispositivo conectado.

📅 Roadmap (Próximas mejoras)
 - Notificaciones automáticas al acercarse a una meta

 - Widgets de balance en pantalla de inicio

 - Modo sin conexión (caché local)

 - Integración con bancos o CSV

 - Exportación de movimientos

 - Módulo de hábitos financieros

📜 Licencia
Este proyecto está licenciado bajo MIT License.

🤝 Contribuciones
¡Las contribuciones son bienvenidas!
Puedes abrir un Issue o enviar un Pull Request.


