# Changelog

All notable changes to the Generate-Spec skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.0] - 2026-02-02

### Removed
- **improve-diagrams.ps1**: Removed script from workflow as it degraded document quality
- Diagram improvement phase from instructions
- improve-diagrams.ps1 references from all documentation

### Changed
- Simplified workflow: Markdown → Word (no diagram post-processing)
- convert-to-word.ps1 now solely responsible for diagram formatting
- Updated messaging from "improved diagrams" to "formatted diagrams"
- Documentation cleanup across README.md, skill.md, QUICKSTART.md

### Benefits
- Better document quality with simpler workflow
- ASCII diagrams preserved in professional bordered boxes via convert-to-word.ps1
- Reduced complexity and maintenance burden
- More reliable output without additional processing step

## [1.5.0] - 2026-02-02

### Added
- **skill.md**: Comprehensive skill documentation file

### Benefits
- Better discoverability for users
- Complete usage documentation in one place

## [1.4.0] - 2026-02-02

### Added
- **Template Fallback Mode**: Skill now creates structured templates when WorkIQ is unavailable
- `[TO BE FILLED]` markers with inline guidance in templates
- Example tables and structures showing proper format
- Comprehensive error handling in instructions.md
- Template mode documentation in all guides

### Changed
- WorkIQ is now optional (was required)
- Skill never fails - always produces useful output (automatic or template mode)
- Updated all documentation to explain template mode

### Benefits
- Graceful degradation when WorkIQ unavailable
- Still saves 6-8 hours vs starting from scratch
- Educational tool for learning spec structure

## [1.3.0] - 2026-02-02

### Changed
- **Output Path**: Files now save to current working directory instead of OneDrive
- Users control output location by navigating before running command
- Simplified path logic - no detection needed
- Universal compatibility (OneDrive, local, network, WSL)

### Updated
- instructions.md - Changed save paths to `./`
- README.md - Updated "Files Generated" section
- QUICKSTART.md - Updated "What You Get" section
- INSTALL-generate-spec-skill.md - Updated all path references

### Benefits
- Simpler, more predictable output location
- No path detection complexity
- Works everywhere without configuration

## [1.2.0] - 2026-02-02

### Changed
- **Renamed** `CLAUDE.md` → `FORMATTING-GUIDELINES.md` for clarity
- Updated title inside formatting guidelines file
- More descriptive and professional filename

### Updated
- All 20+ references across skill files
- instructions.md - Updated file read path
- README.md - Updated all mentions
- QUICKSTART.md - Updated references
- INSTALL-generate-spec-skill.md - Updated documentation

### Benefits
- Self-explanatory filename
- More professional appearance
- Clearer purpose for new users

## [1.1.0] - 2026-02-02

### Added
- **Bundled FORMATTING-GUIDELINES.md** inside skill folder
- Self-contained package - no external dependencies

### Changed
- Removed hardcoded OneDrive path to CLAUDE.md
- Now reads formatting guidelines from within skill directory
- Updated instructions.md to use relative path

### Removed
- External file dependency on user's OneDrive path

### Benefits
- Fully portable - works on any machine
- Simplified installation (from 4 steps to 2 steps)
- Reduced sharing requirements (from 3 files to 2 files)

## [1.0.0] - 2026-01-30

### Added
- **Initial release** of Generate-Spec skill
- Automatic information gathering from WorkIQ
  - Emails, meetings, documents, Teams conversations
  - Stakeholder identification
  - Technical details and decisions
- Comprehensive specification generation
  - Problem statement with evidence
  - Solution approach with architecture
  - Requirements tables (P0/P1/P2)
  - Evaluation criteria and test scenarios
  - Project plan with DRIs and timelines
  - Open questions and references
- Professional Word document conversion
  - Proper heading hierarchy
  - Formatted tables (Grid Table 4 - Accent 1)
  - Code blocks with styling
- Diagram improvement system
  - ASCII diagrams → Professional flowcharts
  - Dependency grids with color coding
  - Microsoft styling (blue borders, light backgrounds)
- Complete documentation
  - README.md - Full documentation
  - QUICKSTART.md - Quick start guide
  - skill.json - Skill metadata
  - instructions.md - Claude instructions
- PowerShell automation scripts
  - convert-to-word.ps1 - Markdown to Word converter with diagram formatting

### Features
- Saves 8-12 hours of manual work per specification
- Microsoft standard formatting compliance
- Professional diagrams and tables
- Comprehensive information gathering
- Ready-to-share Word documents

---

## Version Format

**[MAJOR.MINOR.PATCH]**

- **MAJOR**: Breaking changes or fundamental architecture changes
- **MINOR**: New features, significant improvements (backward compatible)
- **PATCH**: Bug fixes, documentation updates, minor tweaks

## Release Links

- [v1.4.0](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/tag/v1.4.0) - Template Fallback Edition
- [v1.3.0](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/tag/v1.3.0) - Current Directory Output
- [v1.2.0](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/tag/v1.2.0) - Descriptive Naming
- [v1.1.0](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/tag/v1.1.0) - Portable Edition
- [v1.0.0](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/tag/v1.0.0) - Initial Release
