/// Calculadora de fecha de corte para retención de registros locales sincronizados.
///
/// Soporta exclusivamente las siguientes unidades según la configuración en `.env`:
/// - `d`: Días (ej: `30d`, `15d`)
/// - `w`: Semanas (ej: `2w`, `4w`)
/// - `m`: Meses de calendario (ej: `1m`, `6m`)
/// - `y`: Años de calendario (ej: `1y`, `2y`)
class RetentionCalculator {
  /// Calcula la fecha de corte restando el tiempo de retención a la fecha de referencia [from].
  ///
  /// Si [retention] es nulo, vacío o tiene un formato no reconocido,
  /// se toma por defecto un período de 30 días (`30d`).
  static DateTime calculateCutoffDate({
    required DateTime from,
    String? retention,
  }) {
    if (retention == null || retention.trim().isEmpty) {
      return from.subtract(const Duration(days: 30));
    }

    final trimmed = retention.trim().toLowerCase();
    final match = RegExp(r'^(\d+)([dwmy])$').firstMatch(trimmed);

    if (match == null) {
      return from.subtract(const Duration(days: 30));
    }

    final amount = int.parse(match.group(1)!);
    final unit = match.group(2)!;

    switch (unit) {
      case 'd':
        return from.subtract(Duration(days: amount));
      case 'w':
        return from.subtract(Duration(days: amount * 7));
      case 'm':
        return _subtractMonths(from, amount);
      case 'y':
        return _subtractYears(from, amount);
      default:
        return from.subtract(const Duration(days: 30));
    }
  }

  static DateTime _subtractMonths(DateTime date, int months) {
    int newYear = date.year;
    int newMonth = date.month - months;

    while (newMonth <= 0) {
      newYear -= 1;
      newMonth += 12;
    }

    final daysInNewMonth = _daysInMonth(newYear, newMonth);
    final newDay = date.day > daysInNewMonth ? daysInNewMonth : date.day;

    return DateTime(
      newYear,
      newMonth,
      newDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static DateTime _subtractYears(DateTime date, int years) {
    final newYear = date.year - years;
    final daysInNewMonth = _daysInMonth(newYear, date.month);
    final newDay = date.day > daysInNewMonth ? daysInNewMonth : date.day;

    return DateTime(
      newYear,
      date.month,
      newDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
