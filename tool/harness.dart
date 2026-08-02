// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Arnés de desarrollo para Flutter/Dart.
/// Implementa el ciclo de vida KDD, SDD, BDD y TDD de forma strictly secuencial.

const String stateFilePath = '.harness_state.json';

const List<String> protectedDeploymentBranches = [
  'qa',
  'release/qa',
  'preprod',
  'pre-produccion',
  'preproduccion',
  'staging',
  'prod',
  'produccion',
  'main',
  'master',
];

const List<String> validPhases = [
  'analisis',
  'diseno',
  'pruebas-red',
  'desarrollo-green',
  'clean-code',
  'refactor',
  'verificacion',
  'optimizacion',
];

class HarnessState {
  final String feature;
  final String currentPhase;
  final List<String> history;
  final String updatedAt;

  const HarnessState({
    required this.feature,
    required this.currentPhase,
    required this.history,
    required this.updatedAt,
  });

  factory HarnessState.fromJson(Map<String, dynamic> json) {
    return HarnessState(
      feature: json['feature'] as String? ?? '',
      currentPhase: json['currentPhase'] as String? ?? '',
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'feature': feature,
        'currentPhase': currentPhase,
        'history': history,
        'updatedAt': updatedAt,
      };

  HarnessState copyWith({
    String? feature,
    String? currentPhase,
    List<String>? history,
  }) {
    return HarnessState(
      feature: feature ?? this.feature,
      currentPhase: currentPhase ?? this.currentPhase,
      history: history ?? this.history,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

void main(List<String> arguments) async {
  final argsMap = _parseArgs(arguments);

  if (argsMap.containsKey('help')) {
    _printHelp();
    return;
  }

  if (argsMap.containsKey('watch')) {
    await _startWatchMode();
    return;
  }

  if (argsMap.containsKey('install-hooks')) {
    await _installGitHooks();
    return;
  }

  if (argsMap.containsKey('check-push')) {
    _checkPushBranch(argsMap['check-push']!);
    return;
  }

  if (argsMap.containsKey('prepare-deploy')) {
    await _prepareDeploy(argsMap['prepare-deploy'] ?? 'qa');
    return;
  }

  if (argsMap.containsKey('status')) {
    _printStatus();
    return;
  }

  if (argsMap.containsKey('reset')) {
    _resetState();
    return;
  }

  // Bloquear ejecución del arnés si se está posicionado en una rama protegida de despliegue
  await _validateEnvironmentBranch();

  final featureArg = argsMap['feature'];
  final phaseArg = argsMap['phase'];

  if (phaseArg == null || phaseArg.isEmpty) {
    print('❌ Error: Debe especificar la fase con --phase <nombre_fase>');
    _printHelp();
    exit(1);
  }

  final normalizedPhase = phaseArg.trim().toLowerCase();
  if (!validPhases.contains(normalizedPhase)) {
    print('❌ Error: Fase "$phaseArg" no es válida.');
    print('Fases permitidas: ${validPhases.join(", ")}');
    exit(1);
  }

  HarnessState? currentState = _loadState();

  // Validar feature y coherencia de estado
  String featureSlug = '';
  if (currentState != null && currentState.feature.isNotEmpty) {
    featureSlug = currentState.feature;
    if (featureArg != null &&
        featureArg.isNotEmpty &&
        _slugify(featureArg) != currentState.feature) {
      print(
          '❌ Error: Hay una característica en curso ("${currentState.feature}").');
      print(
          'No puedes cambiar a "$featureArg" sin completar u usar --reset.');
      exit(1);
    }
  } else {
    if (featureArg == null || featureArg.isEmpty) {
      print(
          '❌ Error: Debe indicar la característica con --feature <nombre_feature> para iniciar el arnés.');
      exit(1);
    }
    featureSlug = _slugify(featureArg);
  }

  // Validar secuencia de fases
  _validatePhaseSequence(currentState, normalizedPhase);

  print('🚀 Ejecutando Arnés de Desarrollo Flutter...');
  print('📌 Característica: $featureSlug');
  print('🔄 Fase requerida: $normalizedPhase\n');

  try {
    switch (normalizedPhase) {
      case 'analisis':
        await _executeAnalisis(featureSlug);
        break;
      case 'diseno':
        await _executeDiseno(featureSlug);
        break;
      case 'pruebas-red':
        await _executePruebasRed(featureSlug);
        break;
      case 'desarrollo-green':
        await _executeDesarrolloGreen(featureSlug);
        break;
      case 'clean-code':
        await _executeCleanCode(featureSlug);
        break;
      case 'refactor':
        await _executeRefactor(featureSlug);
        break;
      case 'verificacion':
        await _executeVerificacion(featureSlug);
        break;
      case 'optimizacion':
        await _executeOptimizacion(featureSlug);
        break;
    }

    // Actualizar estado tras éxito
    final updatedHistory = List<String>.from(currentState?.history ?? []);
    if (!updatedHistory.contains(normalizedPhase)) {
      updatedHistory.add(normalizedPhase);
    }

    final newState = HarnessState(
      feature: featureSlug,
      currentPhase: normalizedPhase,
      history: updatedHistory,
      updatedAt: DateTime.now().toIso8601String(),
    );

    _saveState(newState);
    print('\n✨ [ÉXITO] Fase "$normalizedPhase" completada con éxito.');
  } catch (e) {
    print('\n❌ [FALLO HARNESS] Error en fase "$normalizedPhase": $e');
    exit(1);
  }
}

// -----------------------------------------------------------------------------
// FASES INDIVIDUALES
// -----------------------------------------------------------------------------

Future<void> _executeAnalisis(String feature) async {
  print('📋 [ANÁLISIS] Inicializando especificación BDD y bitácora...');

  _createDirectoryIfNotExists('specs/features');
  _createDirectoryIfNotExists('docs/knowledge');

  final specFile = File('specs/features/$feature.feature');
  if (!specFile.existsSync()) {
    specFile.writeAsStringSync('''# language: es
Característica: $feature

  Escenario: Funcionalidad principal de $feature
    Dado que el usuario inicia la interacción con la característica $feature
    Cuando se ejecuta la operación principal de $feature
    Entonces el sistema responde de forma exitosa y consistente
''');
    print('  ✓ Creada especificación BDD: ${specFile.path}');
  } else {
    print('  ℹ Especificación BDD existente: ${specFile.path}');
  }

  final logFile = File('docs/knowledge/control_avance_$feature.md');
  if (!logFile.existsSync()) {
    logFile.writeAsStringSync('''# Control de Avance: $feature

## 📋 1. Fase de Análisis
- [x] Especificación BDD creada en `specs/features/$feature.feature`.

## 🎨 2. Fase de Diseño
- [ ] Plantilla e interfaces inmutables generadas en `lib/src/features/$feature/domain/`.

## 🔴 3. Fase Pruebas RED
- [ ] Test unitario creado y fallando lógicamente en `test/features/${feature}_test.dart`.

## 🟢 4. Fase Desarrollo GREEN
- [ ] Implementación completada y tests pasando exitosamente.

## 🧹 5. Fase Clean Code & Refactor
- [ ] Análisis estático (`flutter analyze`) sin advertencias.
- [ ] Aplicar descomposición de componentes (`flutter-descomposicion-componentes`) en widgets complejos (>100-150 líneas).
- [ ] Aplicar descomposición de código general (`flutter-descomposicion-codigo-general`) en capas, Use Cases y Repository Pattern.
- [ ] Formateo de código y refactor sin regresiones.

## ⚡ 6. Verificación y Optimización del Arnés
- [ ] Verificación global y métricas de rendimiento de la suite de pruebas.
''');
    print('  ✓ Creada bitácora de control de avance: ${logFile.path}');
  } else {
    print('  ℹ Bitácora de control existente: ${logFile.path}');
  }
}

Future<void> _executeDiseno(String feature) async {
  print('🎨 [DISEÑO] Generando diseño técnico y definiciones inmutables...');

  final domainDir = 'lib/src/features/$feature/domain';
  _createDirectoryIfNotExists(domainDir);

  final designFile = File('$domainDir/design.md');
  if (!designFile.existsSync()) {
    designFile.writeAsStringSync('''# Diseño Técnico: $feature

## 🎯 Objetivos y Responsabilidades
- Definición de los modelos de dominio, entidades y contratos para la característica `$feature`.

## 🏗️ Arquitectura de Dominio
- **Entidades e Interfaces Inmutables**: Definidas en `types.dart`.
- **Reglas de Negocio**: Invariantes puras sin efectos secundarios mutables.

## 📜 Definiciones
Consulte `types.dart` en este mismo directorio para ver las clases `@immutable`.
''');
    print('  ✓ Creada plantilla de diseño: ${designFile.path}');
  }

  final pascalName = _toPascalCase(feature);
  final typesFile = File('$domainDir/types.dart');
  if (!typesFile.existsSync()) {
    typesFile.writeAsStringSync('''import 'package:flutter/foundation.dart';

/// Contratos y modelos inmutables de dominio para la característica $feature.
@immutable
abstract class ${pascalName}State {
  const ${pascalName}State();
}

@immutable
class ${pascalName}Initial extends ${pascalName}State {
  const ${pascalName}Initial();
}

@immutable
class ${pascalName}Data {
  final String id;
  final DateTime createdAt;

  const ${pascalName}Data({
    required this.id,
    required this.createdAt,
  });
}
''');
    print('  ✓ Creadas firmas de tipos inmutables: ${typesFile.path}');
  }

  _updateCheckInLog(feature, '## 🎨 2. Fase de Diseño', '- [x] Plantilla e interfaces inmutables generadas');
}

Future<void> _executePruebasRed(String feature) async {
  print('🔴 [TDD RED] Validando fallo lógico controlado...');

  _createDirectoryIfNotExists('test/features');
  final testFile = File('test/features/${feature}_test.dart');

  if (!testFile.existsSync()) {
    testFile.writeAsStringSync('''import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$feature tests', () {
    test('debe fallar inicialmente de forma controlada (TDD RED)', () {
      // Test inicial obligado a fallar lógicamente en la fase RED
      expect(false, isTrue, reason: 'Fallo controlado de prueba TDD RED');
    });
  });
}
''');
    print('  ✓ Creada plantilla de prueba RED: ${testFile.path}');
  }

  print('  ⏳ Ejecutando flutter test ${testFile.path}...');
  final result = await Process.run('flutter', ['test', testFile.path], runInShell: true);

  final combinedOutput = '${result.stdout}\n${result.stderr}';

  if (result.exitCode == 0) {
    throw Exception(
        'La prueba en ${testFile.path} PASÓ exitosamente, pero en la fase TDD RED debe FALLAR lógicamente.');
  }

  // Verificar si el fallo fue por error de compilación / sintaxis
  final isCompileError = combinedOutput.contains('Compilation failed') ||
      combinedOutput.contains('Error: ') ||
      combinedOutput.contains('Target of URI doesn\'t exist') ||
      combinedOutput.contains('Undefined name') ||
      combinedOutput.contains('SyntaxError');

  if (isCompileError) {
    print('\n----- STDOUT / STDERR -----');
    print(combinedOutput);
    print('---------------------------');
    throw Exception(
        'La prueba falló por errores de SINTAXIS o COMPILACIÓN, no por un fallo lógico de aserción.');
  }

  print('  ✓ [✓ TDD RED] La prueba falló lógicamente como se esperaba (fase RED verificada).');
  _updateCheckInLog(feature, '## 🔴 3. Fase Pruebas RED', '- [x] Test unitario creado y fallando lógicamente');
}

Future<void> _executeDesarrolloGreen(String feature) async {
  print('🟢 [TDD GREEN] Ejecutando suite de pruebas para verificar fase GREEN...');

  final testFile = File('test/features/${feature}_test.dart');
  if (!testFile.existsSync()) {
    throw Exception('No existe el archivo de prueba ${testFile.path}.');
  }

  final result = await Process.run('flutter', ['test', testFile.path], runInShell: true);

  if (result.exitCode != 0) {
    print('\n----- DETALLE DE PRUEBAS FALLIDAS -----');
    print('${result.stdout}\n${result.stderr}');
    print('---------------------------------------');
    throw Exception('La suite de pruebas para $feature no ha pasado en verde.');
  }

  print('  ✓ [✓ TDD GREEN] Todas las pruebas pasaron exitosamente.');
  _updateCheckInLog(feature, '## 🟢 4. Fase Desarrollo GREEN', '- [x] Implementación completada y tests pasando exitosamente');
}

Future<void> _executeCleanCode(String feature) async {
  print('🧹 [CLEAN CODE] Ejecutando linter y verificando formateo de código...');

  final featureDir = 'lib/src/features/$feature';
  final featureDirObj = Directory(featureDir);

  if (featureDirObj.existsSync()) {
    print('  ⏳ Analizando estáticamente con flutter analyze $featureDir...');
    final analyzeResult = await Process.run('flutter', ['analyze', featureDir], runInShell: true);
    if (analyzeResult.exitCode != 0) {
      print('\n----- ADVERTENCIAS / ERRORES DE LINTER -----');
      print(analyzeResult.stdout);
      print(analyzeResult.stderr);
      print('-------------------------------------------');
      throw Exception('`flutter analyze` detectó advertencias o errores.');
    }

    print('  ⏳ Verificando formato de código en $featureDir...');
    final formatResult = await Process.run('dart', [
      'format',
      '--output=none',
      '--set-exit-if-changed',
      featureDir,
    ], runInShell: true);
    if (formatResult.exitCode != 0) {
      print(formatResult.stdout);
      throw Exception('Se detectó código sin formatear en $featureDir. Ejecute `dart format $featureDir`.');
    }
  } else {
    print('  ℹ Directorio $featureDir no existe aún; ejecutando `flutter analyze` global...');
    final analyzeResult = await Process.run('flutter', ['analyze'], runInShell: true);
    if (analyzeResult.exitCode != 0) {
      throw Exception('`flutter analyze` global detectó problemas.');
    }
  }

  print('  ✓ [CLEAN CODE] Linter y formato validados sin observaciones.');
  print('  💡 [SKILL] Verifique la descomposición de widgets (>100 líneas) usando `flutter-descomposicion-componentes`.');
  print('  💡 [SKILL] Verifique la arquitectura en capas (Domain, Data, Presentation) usando `flutter-descomposicion-codigo-general`.');
  _updateCheckInLog(feature, '## 🧹 5. Fase Clean Code & Refactor', '- [x] Análisis estático (`flutter analyze`) sin advertencias');
}

Future<void> _executeRefactor(String feature) async {
  print('🔄 [REFACTOR] Re-validando tests tras refactorización...');
  print('  💡 [SKILL] Aplicando criterios de composición (Widgets y Use Cases / Repositories).');

  final testFile = File('test/features/${feature}_test.dart');
  if (!testFile.existsSync()) {
    throw Exception('No existe la prueba ${testFile.path}.');
  }

  final result = await Process.run('flutter', ['test', testFile.path], runInShell: true);

  if (result.exitCode != 0) {
    print('\n----- REGRESIÓN DE PRUEBAS DETECTADA -----');
    print('${result.stdout}\n${result.stderr}');
    print('------------------------------------------');
    throw Exception('Se detectaron regresiones en las pruebas tras el refactor.');
  }

  print('  ✓ [REFACTOR] Tests superados sin regresiones.');
  _updateCheckInLog(feature, '## 🧹 5. Fase Clean Code & Refactor', '- [x] Formateo de código y refactor sin regresiones');
}

Future<void> _executeVerificacion(String feature) async {
  print('🔎 [VERIFICACIÓN] Chequeo global del proyecto Flutter...');

  print('  ⏳ Ejecutando flutter analyze global...');
  final analyzeRes = await Process.run('flutter', ['analyze'], runInShell: true);
  if (analyzeRes.exitCode != 0) {
    print(analyzeRes.stdout);
    print(analyzeRes.stderr);
    throw Exception('La verificación con `flutter analyze` global falló.');
  }

  print('  ⏳ Ejecutando suite completa de pruebas (flutter test)...');
  final testRes = await Process.run('flutter', ['test'], runInShell: true);
  if (testRes.exitCode != 0) {
    print(testRes.stdout);
    print(testRes.stderr);
    throw Exception('La suite de pruebas global `flutter test` falló.');
  }

  print('  ✓ [VERIFICACIÓN] Verificación global superada exitosamente.');
}

Future<void> _executeOptimizacion(String feature) async {
  print('⚡ [OPTIMIZACIÓN] Midiendo rendimiento de pruebas y actualizando métricas...');

  final testFile = File('test/features/${feature}_test.dart');
  final stopwatch = Stopwatch()..start();

  ProcessResult result;
  if (testFile.existsSync()) {
    result = await Process.run('flutter', ['test', testFile.path], runInShell: true);
  } else {
    result = await Process.run('flutter', ['test'], runInShell: true);
  }

  stopwatch.stop();
  final elapsedMs = stopwatch.elapsedMilliseconds;

  if (result.exitCode != 0) {
    throw Exception('Las pruebas fallaron durante la fase de optimización.');
  }

  print('  ⏱ Duración de pruebas: ${elapsedMs}ms');

  final isOptimal = elapsedMs <= 500;
  if (!isOptimal) {
    print('  ⚠️ [ADVERTENCIA OPTIMIZACIÓN] Las pruebas tomaron ${elapsedMs}ms (> 500ms). Se recomienda optimizar mocks o dependencias.');
  } else {
    print('  ✓ [OPTIMIZACIÓN] Rendimiento óptimo de pruebas (≤500ms).');
  }

  _injectOptimizationReport(feature, elapsedMs, isOptimal);
}

// -----------------------------------------------------------------------------
// UTILIDADES Y FUNCIONES PURAS DE ESTADO
// -----------------------------------------------------------------------------

HarnessState? _loadState() {
  final file = File(stateFilePath);
  if (!file.existsSync()) return null;
  try {
    final jsonContent = jsonDecode(file.readAsStringSync());
    return HarnessState.fromJson(jsonContent as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

void _saveState(HarnessState state) {
  final file = File(stateFilePath);
  const encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync(encoder.convert(state.toJson()));
}

void _resetState() {
  final file = File(stateFilePath);
  if (file.existsSync()) {
    file.deleteSync();
    print('🗑 State reset: .harness_state.json eliminado.');
  } else {
    print('ℹ No existía archivo de estado .harness_state.json.');
  }
}

void _printStatus() {
  final state = _loadState();
  if (state == null) {
    print('ℹ No hay ninguna característica activa en el arnés actualmente.');
    return;
  }
  print('📊 Estado del Arnés:');
  print('   • Característica actual: ${state.feature}');
  print('   • Fase actual:          ${state.currentPhase}');
  print('   • Historial de fases:   ${state.history.join(" ➔ ")}');
  print('   • Última actualización: ${state.updatedAt}');
}

void _validatePhaseSequence(HarnessState? state, String targetPhase) {
  final targetIndex = validPhases.indexOf(targetPhase);

  if (state == null || state.currentPhase.isEmpty) {
    if (targetIndex != 0) {
      throw Exception(
          'El arnés no se ha iniciado. Debe comenzar en la fase "${validPhases[0]}".');
    }
    return;
  }

  final currentIndex = validPhases.indexOf(state.currentPhase);

  // Permitir re-ejecutar la fase actual
  if (targetIndex == currentIndex) return;

  // Permitir avanzar a la siguiente fase inmediata
  if (targetIndex == currentIndex + 1) return;

  // Bloquear saltos
  if (targetIndex > currentIndex + 1) {
    throw Exception(
        'No se permite saltar fases. Estás en "${state.currentPhase}". La siguiente fase debe ser "${validPhases[currentIndex + 1]}".');
  }

  // Permitir volver atrás a fases previas si es necesario refactorizar
  if (targetIndex < currentIndex) {
    print('⚠️ Retrocediendo fase de "${state.currentPhase}" a "$targetPhase".');
  }
}

void _createDirectoryIfNotExists(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
}

void _updateCheckInLog(String feature, String sectionHeader, String checkLine) {
  final logFile = File('docs/knowledge/control_avance_$feature.md');
  if (!logFile.existsSync()) return;

  String content = logFile.readAsStringSync();
  if (content.contains(checkLine)) return; // Ya marcado

  // Reemplazar la línea sin marcar por marcada si coincide
  final uncheckedLine = checkLine.replaceFirst('[x]', '[ ]');
  if (content.contains(uncheckedLine)) {
    content = content.replaceFirst(uncheckedLine, checkLine);
    logFile.writeAsStringSync(content);
  }
}

void _injectOptimizationReport(String feature, int elapsedMs, bool isOptimal) {
  final logFile = File('docs/knowledge/control_avance_$feature.md');
  if (!logFile.existsSync()) return;

  String content = logFile.readAsStringSync();
  const reportHeader = '## ⚡ 6. Verificación y Optimización del Arnés';

  final statusText = isOptimal ? '✅ OPTIMIZADO (≤500ms)' : '⚠️ ADVERTENCIA (>500ms)';
  final reportContent = '''$reportHeader
- **Duración de Pruebas Unitarias**: ${elapsedMs}ms
- **Estado de Rendimiento**: $statusText
- [x] Verificación global y métricas de rendimiento de la suite de pruebas.
''';

  if (content.contains(reportHeader)) {
    final parts = content.split(reportHeader);
    content = '${parts[0].trimRight()}\n\n$reportContent';
  } else {
    content = '${content.trimRight()}\n\n$reportContent';
  }

  logFile.writeAsStringSync(content);
  print('  ✓ Bitácora actualizada con métricas de optimización.');
}

Future<void> _validateEnvironmentBranch() async {
  try {
    final result = await Process.run('git', ['rev-parse', '--abbrev-ref', 'HEAD'], runInShell: true);
    if (result.exitCode == 0) {
      final currentBranch = (result.stdout as String).trim().toLowerCase();
      if (protectedDeploymentBranches.contains(currentBranch)) {
        print('❌ Error: El arnés de desarrollo no se puede ejecutar en la rama de despliegue "$currentBranch".');
        print('💡 Motivo: El arnés de desarrollo pertenece exclusivamente al entorno de desarrollo (ej. dev, feature/*, fix/*).');
        print('   Los entornos QA, Pre-producción y Producción deben estar limpios de artefactos de desarrollo.');
        exit(1);
      }
    }
  } catch (_) {
    // Si git no está disponible, continuar
  }
}

void _checkPushBranch(String targetBranch) {
  final normalizedTarget = targetBranch.trim().toLowerCase();
  if (protectedDeploymentBranches.contains(normalizedTarget)) {
    print('🛡️ [CHECK PUSH] Analizando payload para el despliegue a "$targetBranch"...');
    
    final trackedHarnessFiles = <String>[];

    try {
      final resState = Process.runSync('git', ['ls-files', stateFilePath], runInShell: true);
      if (resState.exitCode == 0 && (resState.stdout as String).trim().isNotEmpty) {
        trackedHarnessFiles.add(stateFilePath);
      }

      final resSpecs = Process.runSync('git', ['ls-files', 'specs'], runInShell: true);
      if (resSpecs.exitCode == 0 && (resSpecs.stdout as String).trim().isNotEmpty) {
        trackedHarnessFiles.add('specs/');
      }
    } catch (_) {}

    if (trackedHarnessFiles.isNotEmpty) {
      print('❌ [DESPLIEGUE BLOQUEADO] Se detectaron artefactos del arnés seguidos en Git:');
      for (final file in trackedHarnessFiles) {
        print('   - $file');
      }
      print('\n💡 Instrucciones:');
      print('   1. El arnés de desarrollo no debe estar rastreado en la rama de despliegue "$targetBranch".');
      print('   2. Elimine los artefactos del rastreo de git (`git rm --cached <archivo>`).');
      print('   3. Para subir código a $targetBranch, use una rama limpia sin artefactos de desarrollo.');
      exit(1);
    }
    print('  ✓ [CHECK PUSH] Rama de despliegue limpia de artefactos del arnés.');
  }
}

Future<void> _installGitHooks() async {
  print('🔧 Instalando Git Hook pre-push para aislamiento de ambientes...');
  final githooksDir = Directory('.githooks');
  if (!githooksDir.existsSync()) {
    githooksDir.createSync(recursive: true);
  }

  final hookFile = File('.githooks/pre-push');
  hookFile.writeAsStringSync(r'''#!/bin/sh
# Git Pre-Push Hook: Evita el despliegue del arnés de desarrollo a ramas protegidas (QA, Pre-producción, Producción)

protected_branches="qa release/qa preprod pre-produccion preproduccion staging prod produccion main master"

while read local_ref local_sha remote_ref remote_sha
do
  remote_branch=$(echo "$remote_ref" | sed 's#refs/heads/##')
  
  for protected in $protected_branches; do
    if [ "$remote_branch" = "$protected" ]; then
      echo "🛡️ [GIT PRE-PUSH HOOK] Detectado push hacia la rama de despliegue: '$remote_branch'"
      
      tracked_state=$(git ls-files .harness_state.json 2>/dev/null)
      tracked_specs=$(git ls-files specs 2>/dev/null)

      if [ -n "$tracked_state" ] || [ -n "$tracked_specs" ]; then
        echo "❌ [ERROR DESPLIEGUE] Se detectaron artefactos del arnés rastreados en Git:"
        [ -n "$tracked_state" ] && echo "  - .harness_state.json"
        [ -n "$tracked_specs" ] && echo "  - carpeta specs/"
        echo ""
        echo "💡 Motivo: El arnés de desarrollo solo pertenece a entornos de desarrollo (ej. dev, feature/*)."
        echo "   No se permite llevar artefactos del arnés a $remote_branch."
        exit 1
      fi
      
      if [ -f "tool/harness.dart" ]; then
        dart run tool/harness.dart --check-push "$remote_branch"
        if [ $? -ne 0 ]; then
          exit 1
        fi
      fi
    fi
  done
done

exit 0
''');

  final gitDir = Directory('.git');
  if (gitDir.existsSync()) {
    final gitHooksTargetFile = File('.git/hooks/pre-push');
    try {
      gitHooksTargetFile.writeAsStringSync(hookFile.readAsStringSync());
      print('  ✓ Hook instalado en `.git/hooks/pre-push`.');
    } catch (e) {
      print('  ⚠️ No se pudo escribir en `.git/hooks/pre-push`: $e');
    }

    final result = await Process.run('git', ['config', 'core.hooksPath', '.githooks'], runInShell: true);
    if (result.exitCode == 0) {
      print('  ✓ Git `core.hooksPath` configurado a `.githooks`.');
    }
  }

  print('✨ [ÉXITO] Git Hook pre-push instalado correctamente.');
}

Future<void> _prepareDeploy(String targetBranch) async {
  print('🚀 [PREPARAR DESPLIEGUE] Verificando sanidad del proyecto antes de desplegar a "$targetBranch"...');
  
  print('  ⏳ Ejecutando análisis estático (flutter analyze)...');
  final analyzeRes = await Process.run('flutter', ['analyze'], runInShell: true);
  if (analyzeRes.exitCode != 0) {
    print(analyzeRes.stdout);
    print(analyzeRes.stderr);
    throw Exception('No se puede desplegar: `flutter analyze` reportó advertencias o errores.');
  }

  print('  ⏳ Ejecutando suite de pruebas (flutter test)...');
  final testRes = await Process.run('flutter', ['test'], runInShell: true);
  if (testRes.exitCode != 0) {
    print(testRes.stdout);
    print(testRes.stderr);
    throw Exception('No se puede desplegar: La suite de pruebas falló.');
  }

  print('\n✅ [LISTO PARA DESPLIEGUE] Código validado.');
  print('📌 Pasos recomendados para despliegue a "$targetBranch":');
  print('   1. Guarde y cree un commit con sus cambios en su rama de desarrollo actual.');
  print('   2. Asegúrese de no rastrear .harness_state.json ni artefactos locales.');
  print('   3. Cambie a la rama objetivo o realice merge limpio a "$targetBranch".');
  print('   4. Ejecute git push origin $targetBranch.');
}

Future<void> _startWatchMode() async {
  print('👀 [WATCH MODE] Escuchando cambios en los directorios `lib/` y `test/`...');
  print('💡 Presione Ctrl + C para salir del modo de observación.\n');

  bool isRunning = false;

  Future<void> runWatcherTests() async {
    if (isRunning) return;
    isRunning = true;
    print('\n🔄 [WATCH MODE] Cambio detectado. Re-ejecutando tests de Flutter...');
    final stopwatch = Stopwatch()..start();
    final result = await Process.run('flutter', ['test'], runInShell: true);
    stopwatch.stop();

    if (result.exitCode == 0) {
      print('✅ [WATCH MODE] Todas las pruebas pasaron exitosamente en ${stopwatch.elapsedMilliseconds}ms.');
    } else {
      print('❌ [WATCH MODE] Pruebas fallaron:');
      print(result.stdout);
      print(result.stderr);
    }
    isRunning = false;
  }

  // Ejecución de pruebas inicial
  await runWatcherTests();

  final libWatcher = Directory('lib').watch(recursive: true);
  final testWatcher = Directory('test').watch(recursive: true);

  libWatcher.listen((_) => runWatcherTests());
  testWatcher.listen((_) => runWatcherTests());

  // Mantener el proceso vivo
  await Completer<void>().future;
}

Map<String, String> _parseArgs(List<String> args) {
  final map = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--help' || arg == '-h') {
      map['help'] = 'true';
    } else if (arg == '--watch' || arg == '-w') {
      map['watch'] = 'true';
    } else if (arg == '--status' || arg == '-s') {
      map['status'] = 'true';
    } else if (arg == '--reset' || arg == '-r') {
      map['reset'] = 'true';
    } else if (arg == '--install-hooks') {
      map['install-hooks'] = 'true';
    } else if (arg == '--check-push') {
      if (i + 1 < args.length) {
        map['check-push'] = args[++i];
      }
    } else if (arg == '--prepare-deploy') {
      if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
        map['prepare-deploy'] = args[++i];
      } else {
        map['prepare-deploy'] = 'qa';
      }
    } else if (arg == '--feature' || arg == '-f') {
      if (i + 1 < args.length) {
        map['feature'] = args[++i];
      }
    } else if (arg == '--phase' || arg == '-p') {
      if (i + 1 < args.length) {
        map['phase'] = args[++i];
      }
    }
  }
  return map;
}

String _slugify(String text) {
  return text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_-]'), '_')
      .replaceAll(RegExp(r'_+'), '_');
}

String _toPascalCase(String slug) {
  return slug
      .split(RegExp(r'[-_]'))
      .where((s) => s.isNotEmpty)
      .map((s) => '${s[0].toUpperCase()}${s.substring(1)}')
      .join();
}

void _printHelp() {
  print('''
Uso del Arnés de Desarrollo Flutter:
  dart run tool/harness.dart --feature <nombre_feature> --phase <fase>

Fases disponibles (en orden secuencial):
  1. analisis          : Genera BDD (.feature) y bitácora (control_avance_<feature>.md)
  2. diseno            : Genera diseño técnico y tipos inmutables (types.dart)
  3. pruebas-red       : Crea/ejecuta test unitario verificando fallo lógico (RED)
  4. desarrollo-green  : Verifica que todos los tests pasen exitosamente (GREEN)
  5. clean-code        : Linter (flutter analyze) y formateo de código
  6. refactor          : Re-evalúa tests para garantizar ausencia de regresiones
  7. verificacion      : Chequeo global del proyecto (flutter analyze + flutter test)
  8. optimizacion      : Mide tiempos de ejecución de tests y reporta métricas

Comandos adicionales:
  dart run tool/harness.dart --watch (-w)      : Ejecuta los tests en modo observador (watch mode continuo)
  dart run tool/harness.dart --status          : Muestra el estado actual del arnés
  dart run tool/harness.dart --reset           : Reinicia el estado del arnés
  dart run tool/harness.dart --install-hooks   : Instala los Git Hooks de aislamiento de ambientes
  dart run tool/harness.dart --prepare-deploy  : Valida el código antes de fusionar/empujar a QA/Preprod/Prod
  dart run tool/harness.dart --help            : Muestra este mensaje de ayuda
''');
}
