/// Utilidades para formateo y parseo estándar de fechas de la aplicación
/// según los requerimientos de la UI y de la API Oracle ORDS.
class DateFormatter {
  static const List<String> mesesEs = [
    '',
    'ENE',
    'FEB',
    'MAR',
    'ABR',
    'MAY',
    'JUN',
    'JUL',
    'AGO',
    'SEP',
    'OCT',
    'NOV',
    'DIC',
  ];

  static const Map<String, int> mesesMap = {
    'ENE': 1, 'JAN': 1,
    'FEB': 2,
    'MAR': 3,
    'ABR': 4, 'APR': 4,
    'MAY': 5,
    'JUN': 6,
    'JUL': 7,
    'AGO': 8, 'AUG': 8,
    'SEP': 9, 'SET': 9,
    'OCT': 10,
    'NOV': 11,
    'DIC': 12, 'DEC': 12,
  };

  /// Formato unificado para visualización en listas y tablas: DD MON YYYY (ej. '26 SEP 2026')
  static String formatDdMonYyyy(DateTime dt) {
    final localDt = dt.toLocal();
    final day = localDt.day.toString().padLeft(2, '0');
    final monthStr = (localDt.month >= 1 && localDt.month <= 12) ? mesesEs[localDt.month] : 'ENE';
    return '$day $monthStr ${localDt.year}';
  }

  /// Formato unificado para visualización con hora: DD MON YYYY HH24:MI:SS (ej. '26 SEP 2026 14:30:00')
  static String formatDdMonYyyyHhMiSs(DateTime dt) {
    final localDt = dt.toLocal();
    final day = localDt.day.toString().padLeft(2, '0');
    final monthStr = (localDt.month >= 1 && localDt.month <= 12) ? mesesEs[localDt.month] : 'ENE';
    final h = localDt.hour.toString().padLeft(2, '0');
    final min = localDt.minute.toString().padLeft(2, '0');
    final s = localDt.second.toString().padLeft(2, '0');
    return '$day $monthStr ${localDt.year} $h:$min:$s';
  }

  /// Formato estándar de Oracle para sincronización con la API:
  /// YYYY-MM-DD HH24:MI:SS:THZ (ej. '2026-09-26 12:52:50:-03')
  static String formatOracleTimestamp(DateTime dt) {
    final localDt = dt.toLocal();
    final y = localDt.year.toString().padLeft(4, '0');
    final m = localDt.month.toString().padLeft(2, '0');
    final d = localDt.day.toString().padLeft(2, '0');
    final h = localDt.hour.toString().padLeft(2, '0');
    final min = localDt.minute.toString().padLeft(2, '0');
    final s = localDt.second.toString().padLeft(2, '0');

    final offset = localDt.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
    final tzh = '$sign$offsetHours';

    return '$y-$m-$d $h:$min:$s:$tzh';
  }

  /// Parseo flexible de fechas que admite formatos ISO, Oracle Timestamp, DD MON YYYY, DD/MM/YYYY, etc.
  static DateTime? parseFlexible(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val.toLocal();
    final str = val.toString().trim();
    if (str.isEmpty) return null;

    // 1. ISO-8601 estándar
    final iso = DateTime.tryParse(str);
    if (iso != null) return iso.toLocal();

    // 2. Formato Oracle Timestamp: YYYY-MM-DD HH24:MI:SS:TZH (ej. "2026-09-26 12:52:50:-03" o "2026-09-26 12:52:50-03:00")
    final oracleTzRegex = RegExp(
      r'^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})(?::?([+-]\d{1,2}))?(?::(\d{1,2}))?',
    );
    final otzMatch = oracleTzRegex.firstMatch(str);
    if (otzMatch != null) {
      final y = otzMatch.group(1)!.padLeft(4, '0');
      final m = otzMatch.group(2)!.padLeft(2, '0');
      final d = otzMatch.group(3)!.padLeft(2, '0');
      final h = otzMatch.group(4)!.padLeft(2, '0');
      final min = otzMatch.group(5)!.padLeft(2, '0');
      final s = otzMatch.group(6)!.padLeft(2, '0');
      final tzSignAndHours = otzMatch.group(7);
      final tzMinutes = otzMatch.group(8) ?? '00';

      if (tzSignAndHours != null && tzSignAndHours.isNotEmpty) {
        final sign = tzSignAndHours.startsWith('-') ? '-' : '+';
        final rawHours = tzSignAndHours.replaceAll(RegExp(r'[^0-9]'), '').padLeft(2, '0');
        final isoWithTz = '$y-$m-${d}T$h:$min:$s$sign$rawHours:$tzMinutes';
        final parsedTz = DateTime.tryParse(isoWithTz);
        if (parsedTz != null) return parsedTz.toLocal();
      }

      final year = int.tryParse(y) ?? 2000;
      final month = int.tryParse(m) ?? 1;
      final day = int.tryParse(d) ?? 1;
      final hour = int.tryParse(h) ?? 0;
      final minute = int.tryParse(min) ?? 0;
      final second = int.tryParse(s) ?? 0;
      return DateTime(year, month, day, hour, minute, second);
    }

    // 3. Formato DD MON YYYY / DD-MON-YYYY (ej. "26 SEP 2026", "26-SEP-26")
    final monRegex = RegExp(
      r'^(\d{1,2})[\s\-]+([A-Za-z]{3})[\s\-]+(\d{2,4})(?:\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?)?',
    );
    final monMatch = monRegex.firstMatch(str);
    if (monMatch != null) {
      final day = int.tryParse(monMatch.group(1)!) ?? 1;
      final monStr = monMatch.group(2)!.toUpperCase();
      int year = int.tryParse(monMatch.group(3)!) ?? 2000;
      if (year < 100) year += 2000;
      final month = mesesMap[monStr] ?? 1;
      final hour = monMatch.group(4) != null ? (int.tryParse(monMatch.group(4)!) ?? 0) : 0;
      final minute = monMatch.group(5) != null ? (int.tryParse(monMatch.group(5)!) ?? 0) : 0;
      final second = monMatch.group(6) != null ? (int.tryParse(monMatch.group(6)!) ?? 0) : 0;
      return DateTime(year, month, day, hour, minute, second);
    }

    // 4. Formato dd/MM/yyyy o dd-MM-yyyy con hora opcional
    final dmyRegex = RegExp(
      r'^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})(?:\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?)?',
    );
    final dmyMatch = dmyRegex.firstMatch(str);
    if (dmyMatch != null) {
      final day = int.tryParse(dmyMatch.group(1)!) ?? 1;
      final month = int.tryParse(dmyMatch.group(2)!) ?? 1;
      final year = int.tryParse(dmyMatch.group(3)!) ?? 2000;
      final hour = dmyMatch.group(4) != null ? (int.tryParse(dmyMatch.group(4)!) ?? 0) : 0;
      final minute = dmyMatch.group(5) != null ? (int.tryParse(dmyMatch.group(5)!) ?? 0) : 0;
      final second = dmyMatch.group(6) != null ? (int.tryParse(dmyMatch.group(6)!) ?? 0) : 0;
      return DateTime(year, month, day, hour, minute, second);
    }

    // 5. Formato yyyy/MM/dd o yyyy-MM-dd con hora opcional
    final ymdRegex = RegExp(
      r'^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})(?:\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?)?',
    );
    final ymdMatch = ymdRegex.firstMatch(str);
    if (ymdMatch != null) {
      final year = int.tryParse(ymdMatch.group(1)!) ?? 2000;
      final month = int.tryParse(ymdMatch.group(2)!) ?? 1;
      final day = int.tryParse(ymdMatch.group(3)!) ?? 1;
      final hour = ymdMatch.group(4) != null ? (int.tryParse(ymdMatch.group(4)!) ?? 0) : 0;
      final minute = ymdMatch.group(5) != null ? (int.tryParse(ymdMatch.group(5)!) ?? 0) : 0;
      final second = ymdMatch.group(6) != null ? (int.tryParse(ymdMatch.group(6)!) ?? 0) : 0;
      return DateTime(year, month, day, hour, minute, second);
    }

    // 6. Timestamp en milisegundos o segundos
    final numVal = int.tryParse(str);
    if (numVal != null && numVal > 0) {
      if (str.length > 10) {
        return DateTime.fromMillisecondsSinceEpoch(numVal);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(numVal * 1000);
      }
    }

    return null;
  }
}
