class Usuario {
  final String id;
  final String nombre;
  final String apellidos;
  final String nombreUsuario;
  final String? imagenPerfil;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nombreUsuario,
    this.imagenPerfil,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      apellidos: map['apellidos'] as String,
      nombreUsuario: map['nombre_usuario'] as String,
      imagenPerfil: map['imagen_perfil'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'nombre_usuario': nombreUsuario,
      'imagen_perfil': imagenPerfil,
    };
  }
}
