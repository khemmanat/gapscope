# Development Guide

GapScope is a Melos-style Flutter workspace with a reusable package and a local studio app.

## Structure

```txt
packages/gapscope        Public reusable package
apps/gapscope_studio_app Local development app
docs                     Public documentation
```

The studio app may depend on `packages/gapscope`. The package must not depend on the app.

## Package Rules

- Keep public exports in `packages/gapscope/lib/gapscope.dart`.
- Keep implementation under `packages/gapscope/lib/src`.
- Prefer one responsibility per file.
- Keep files small where practical, ideally 100-250 lines.
- Avoid hard-coupling the package to app-only dependencies.

## State And Rendering

- Prefer `ValueNotifier`, `ChangeNotifier`, and Flutter primitives for package state.
- Prefer `CustomPainter` for inspector visualizations.
- Avoid rebuilding large app subtrees during pointer movement or inspection.
- Cache geometry snapshots and throttle repeated capture work.

## Useful Commands

```bash
dart pub get
cd packages/gapscope
flutter test
flutter analyze
```

For the development app:

```bash
cd apps/gapscope_studio_app
flutter run
```
