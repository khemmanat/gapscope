# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-27

### Added

#### Component Workbench
- Component and story system for design organization
- Interactive sidebar navigation
- Story canvas for real-time preview
- Addon framework with theme and device support
- Material 3 design system integration

#### Runtime QA Inspector
- Bounds inspection mode with visual widget boundaries
- Spacing analysis with distance measurements
- Flex layout detection and gap analysis
- Whitespace detection for spacing inconsistencies
- Overlay inspection (dialogs, bottom sheets, dropdowns)
- Tap target checking for Material Design compliance
- Constraint analysis for widget behavior understanding
- Interactive widget selection and measurement
- Real-time geometry snapshot capture

#### Export & Reporting
- Screenshot export system (PNG, WebP, JPEG)
- Quality and resolution controls
- QA report generation (JSON, HTML, Markdown)
- Issue tracking with severity levels
- Comprehensive metrics collection
- Golden testing integration
- CI/CD pipeline support with exit codes
- Batch screenshot processing

#### Cross-Platform Support
- Full Flutter Web support
- iOS and Android mobile optimization
- Desktop support (macOS, Windows, Linux)
- Platform-specific optimizations

#### Testing & Examples
- Comprehensive test suite (34+ tests)
- Example application with components
- Documentation and usage examples
- CI/CD integration examples

### Features

#### Inspector System
- 8 inspection modes for comprehensive UI analysis
- Real-time rendering with 30fps capture, 60fps display
- Safe render object access with geometry snapshots
- Interactive pointer event handling
- Spatial analysis and distance calculations

#### QA Capabilities
- Material Design tap target compliance (48x48dp)
- Flex spacing visualization with color coding
- Whitespace region detection
- Overlay-aware inspection for complex UIs
- Constraint understanding and debugging

#### Export Options
- Multiple screenshot formats with quality control
- Professional HTML report templates
- JSON export for automation
- Markdown for documentation
- Configurable report generation

#### Architecture
- All files respect 250-line constraint
- Clean package boundaries (apps/packages)
- No external state management dependencies
- Performance-optimized with CustomPainter
- Extensible addon system

### Technical Details

#### Dependencies
- Flutter SDK >=3.10.0
- Dart SDK >=3.0.0
- Material 3 design system
- No external state management
- Minimal dependency footprint

#### Performance
- Throttled render tree capture (30fps)
- Efficient repaint management
- Safe geometry snapshot copying
- Interactive selection with hit testing
- Optimized for production debugging

#### Testing
- Widget testing for UI components
- Unit testing for core systems
- Export system testing
- CI/CD integration testing
- Cross-platform validation

### Documentation
- Comprehensive README with examples
- API documentation for all public APIs
- Example application with 10+ components
- CI/CD integration guides
- Migration guides from other tools

### Breaking Changes
- None (initial release)

### Migration from Widgetbook
- Similar component/story structure
- Enhanced QA capabilities
- Better export options
- Cross-platform support
- Migration guide available in examples

## [Unreleased]

### Planned Features
- Additional inspector modes
- More export format options
- Enhanced CI/CD integrations
- Additional addon types
- Performance improvements
- Documentation enhancements

### Known Issues
- Some linting warnings (non-breaking)
- PDF export requires additional dependencies
- Advanced gesture recognition in development

---

## Version History

### 1.0.0 (2026-05-27)
- Initial stable release
- Complete 5-phase implementation
- Production-ready for design systems
- Comprehensive testing suite
- Full export ecosystem
- Cross-platform support

---

For more information about the project phases and architecture, see the main project documentation.