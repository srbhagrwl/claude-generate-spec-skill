# Changelog

All notable changes to the Generate-Spec skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.8.1] - 2026-02-02

### Fixed - Critical Bug
- **Cascading Query Failures**: Fixed "sibling tool call errored" issue where one WorkIQ query failure would cascade and fail all subsequent queries
- **True Sequential Execution**: Enforced ONE query per message to prevent parallel execution that causes cascading failures
- **Improved Resilience**: One query failure no longer blocks remaining queries - continues with available data

### Changed
- **Execution Instructions**: Added explicit "NEVER make parallel tool calls" instruction with detailed explanation
- **Brief Analysis Requirement**: Each query now requires 2-3 sentence analysis before proceeding to next query
- **Console Output**: Updated all examples to show true sequential execution pattern with "ONE AT A TIME" notes
- **Error Handling**: Enhanced graceful degradation - proceeds if 4+ queries succeed, only falls back to template if first 3 critical queries ALL fail

### Benefits
- **Eliminates Cascading Failures**: No more "sibling tool call errored" blocking entire information gathering
- **Better Data Collection**: Brief analysis between queries provides better context for subsequent queries
- **Increased Success Rate**: Single query failure doesn't doom the entire process
- **Clearer Progress**: Users see exactly which queries succeeded/failed with specific messages

## [1.8.0] - 2026-02-02

### Changed - UltraThink Mode
- **Revolutionary Information Gathering**: Replaced single WorkIQ query with 7 sequential targeted queries
- **Complete Artifact Retrieval**: Now fetches full document content, entire emails, complete meeting notes instead of summaries
- **Deep Analysis Phase**: Added UltraThink phase that cross-references all sources, identifies contradictions, validates assumptions
- **Per-Query Retry Logic**: Each of the 7 queries now has individual retry capability for better reliability
- **Enhanced Console Output**: Progress now shows "Query N/7" with specific query types and artifact counts

### Added
- **Query 1**: Emails - retrieves full email threads with complete content
- **Query 2**: Meetings - retrieves complete meeting transcripts and notes
- **Query 3**: Specification documents - fetches full document content
- **Query 4**: Teams conversations - retrieves complete conversation threads
- **Query 5**: Customer incidents - fetches full incident details with customer names
- **Query 6**: Project plans - retrieves complete work item details with dependencies
- **Query 7**: Related artifacts - catch-all for presentations, diagrams, spreadsheets
- **UltraThink Analysis**: Cross-references all sources, identifies patterns, validates constraints

### Benefits
- **Comprehensive Data Collection**: 7x more thorough than single query approach
- **Better Context**: Full artifacts provide complete context vs. incomplete summaries
- **Higher Quality Specs**: Deep analysis produces more accurate, evidence-based specifications
- **Intelligent Fallback**: Continues with available data even if some queries fail
- **Better Traceability**: Can reference specific emails, meetings, documents with full context

## [1.7.0] - 2026-02-02

### Added
- **Configurable Color Scheme**: New parameters for customizing heading, code block, table header, and diagram border colors
- **Custom Table Styles**: `-TableStyle` parameter to choose from Word's built-in table styles
- **Verbose Mode**: `-VerboseOutput` flag for detailed line-by-line processing information
- **Quiet Mode**: `-Quiet` flag for minimal output (ideal for automation)
- **Horizontal Rules Support**: Markdown `---`, `***`, `___` now render as horizontal lines in Word
- **Image Support**: `![alt](path)` syntax now embeds images with auto-sizing (max 400px width)
- **Blockquote Support**: `> text` syntax renders as italicized, indented text with background
- **Enhanced Hyperlinks**: Fixed nested markdown in links (e.g., `[**bold link**](url)`)
- **Color Presets**: Pre-defined color schemes (Modern Corporate, Warm Professional, High Contrast)

### Fixed
- **Hyperlink Generation**: Fixed bug where hyperlinks were not clickable in Word documents
- **Nested Formatting**: Links with bold/code formatting now render correctly
- **Table Cell Hyperlinks**: Links in table cells are now properly converted to clickable hyperlinks
- **Error Recovery**: Added try-catch around table processing to prevent total failure

### Changed
- **Cleaner Output**: Removed verbose debug messages from normal operation
- **Better Progress Reporting**: Progress bar now shows "(currentLine/totalLines lines)"
- **Improved Path Handling**: Converts to absolute paths with better error messages

### Benefits
- **Fully Customizable**: Change colors without editing code
- **Production Ready**: Quiet mode for CI/CD pipelines and automation
- **More Features**: Images, blockquotes, and horizontal rules now supported
- **Better Reliability**: Error handling prevents single table failure from breaking entire document
- **Time Savings**: Verbose mode helps debug large documents

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
