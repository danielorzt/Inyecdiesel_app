// Ruta: lib/core/utils/whatsapp_service.dart

import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

/// Servicio para interactuar con WhatsApp
class WhatsAppService {
  // Número de WhatsApp de la empresa (incluir código de país sin el '+')
  // Ejemplo: '5219876543210' para un número mexicano
  final String phoneNumber;

  WhatsAppService({required this.phoneNumber});

  /// Abre WhatsApp con un mensaje predefinido
  ///
  /// Retorna `true` si WhatsApp se abrió correctamente,
  /// `false` en caso contrario.
  Future<bool> openWhatsApp(String message) async {
    try {
      // Codificar el mensaje para URL
      final encodedMessage = Uri.encodeComponent(message);

      // Construir la URL según la plataforma
      String url;

      if (Platform.isAndroid) {
        // URL para Android
        url = "whatsapp://send?phone=$phoneNumber&text=$encodedMessage";
      } else if (Platform.isIOS) {
        // URL para iOS
        url = "https://wa.me/$phoneNumber?text=$encodedMessage";
      } else {
        // URL para web (también funciona en otros dispositivos)
        url = "https://web.whatsapp.com/send?phone=$phoneNumber&text=$encodedMessage";
      }

      // Parsear la URL
      final Uri uri = Uri.parse(url);

      // Verificar si se puede lanzar la URL
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Intentar con la URL alternativa para web
        final Uri webUri = Uri.parse("https://wa.me/$phoneNumber?text=$encodedMessage");
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
          return true;
        }
        return false;
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
      return false;
    }
  }
}