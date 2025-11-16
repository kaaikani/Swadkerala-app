import '../controllers/order/ordermodels.dart';

class ShippingUtils {
  const ShippingUtils._();

  static String? buildDeliveryNote(List<ShippingMethod> methods) {
    if (methods.isEmpty) return null;

    final lowerNames =
        methods.map((method) => method.name.toLowerCase()).toList();

    final hasTomorrowMorning = lowerNames.any(
      (name) => name.contains('tomorrow') && name.contains('morning'),
    );
    final hasTomorrowEvening = lowerNames.any(
      (name) => name.contains('tomorrow') && name.contains('evening'),
    );

    if (hasTomorrowMorning && hasTomorrowEvening) {
      return 'If you order today you will get your order tomorrow morning or evening.';
    }
    if (hasTomorrowMorning) {
      return 'If you order today you will get your order tomorrow morning.';
    }
    if (hasTomorrowEvening) {
      return 'If you order today you will get your order tomorrow evening.';
    }

    return null;
  }
}
