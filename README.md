# Generate-Spec Skill for Claude Code

> Automatically generate comprehensive specification documents following Microsoft standards.

**Time Savings:** 8-12 hours of manual work → 5 minutes automated ⚡

[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🚀 Features

| Feature | Description |
|---------|-------------|
| 🤖 **Automatic Information Gathering** | Queries WorkIQ for emails, meetings, documents, Teams conversations |
| 📝 **Professional Formatting** | Microsoft-standard specs with tables, diagrams, and proper structure |
| 📄 **Word Document Generation** | Converts to beautifully formatted .docx files with improved diagrams |
| 🔄 **Template Fallback Mode** | Creates structured templates when WorkIQ unavailable |
| ⚡ **Massive Time Savings** | Reduces 8-12 hours of work to ~5 minutes |
| 🎯 **Never Fails** | Always produces useful output - automatic or template mode |

## 📦 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/claude-generate-spec-skill.git

# Copy to Claude skills directory (Windows)
cd claude-generate-spec-skill
xcopy /E /I /Y . "%USERPROFILE%\.claude\skills\generate-spec\"
```

### Manual Install

1. Download the [latest release](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/releases/latest)
2. Extract to: `C:\Users\<YourName>\.claude\skills\generate-spec\`
3. Verify in Claude Code CLI: `/help` should list `generate-spec`

### Prerequisites

- ✅ Windows with PowerShell 5.1+
- ✅ [Claude Code CLI](https://github.com/anthropics/claude-code) installed
- ✅ Microsoft Word (for .docx generation)
- ⚠️ WorkIQ access (optional - template mode available)

## 🎯 Usage

### Basic Command

```bash
# Navigate to where you want the spec files
cd "C:\Your\Desired\Folder"

# Generate specification
/generate-spec <topic>
```

### Real Examples

```bash
# Example 1: Feature specification
/generate-spec folder affinity

# Example 2: Support feature
/generate-spec voicemail support

# Example 3: Search functionality
/generate-spec shared mailbox search
```

### Output Files

Two files created in your current directory:

```
./
├── <Topic> - Specification.md      ← Markdown source (editable)
└── <Topic> - Specification.docx    ← Word document (ready to share)
```

## 📊 What Gets Generated

Every specification includes:

<table>
<tr>
<td width="50%">

**Problem Details**
- Customer escalations
- IcM incidents
- User asks
- Evidence with names

**Solution Approach**
- North Star vision
- Architecture diagrams
- Scope (in/out)
- Technical approach

**Requirements**
- Functional requirements (P0/P1/P2)
- Non-functional requirements
- Sample scenarios
- Utterance examples

</td>
<td width="50%">

**Evaluation Criteria**
- Query sets
- Success metrics
- Test scenarios
- Assertions

**Project Plan**
- Phased breakdown
- Task tables with DRIs
- ETAs and timelines
- Dependencies

**Additional Sections**
- Open questions
- References
- Technical appendices

</td>
</tr>
</table>

## 🎬 How It Works

### Automatic Mode (With WorkIQ)

```
📋 /generate-spec folder affinity

🔍 Phase 1: Information Gathering
   ✓ Found 15 emails
   ✓ Found 3 meetings
   ✓ Found 8 documents
   ✓ Found 42 Teams conversations
   ✓ Identified 12 stakeholders

📝 Phase 2: Document Generation
   ✓ Created comprehensive specification (742 lines)
   ✓ Included 23 tables and 2 diagrams
   ✓ Saved: ./Folder Affinity - Specification.md

📄 Phase 3: Word Conversion
   ✓ Converted to Word format
   ✓ Improved 2 diagrams
   ✓ Saved: ./Folder Affinity - Specification.docx

✅ Done! Share the .docx with stakeholders.
```

### Template Mode (Without WorkIQ)

```
📋 /generate-spec new feature

⚠️ WorkIQ not available - creating template

📝 Generated template specification
   ✓ All required sections included
   ✓ Example tables with sample rows
   ✓ [TO BE FILLED] markers for manual completion
   ✓ Inline guidance on what to include

✏️ Next: Fill in [TO BE FILLED] markers (34 found)
```

## 📖 Documentation

- [**QUICKSTART.md**](QUICKSTART.md) - Get started in 5 minutes
- [**README.md**](README.md) - Full documentation
- [**FORMATTING-GUIDELINES.md**](FORMATTING-GUIDELINES.md) - Microsoft spec standards
- [**Installation Guide**](INSTALL-generate-spec-skill.md) - Detailed installation

## ⚙️ Customization

### Modify Diagram Styles

Edit `improve-diagrams.ps1` to customize:
- Colors (borders, backgrounds)
- Fonts and sizes
- Component layouts
- Arrow styles

### Change Document Structure

Edit `instructions.md` to modify:
- Section order
- Required sections
- Table formats
- Priority labeling (P0/P1/P2)

### Adjust Word Formatting

Edit `convert-to-word.ps1` to customize:
- Page margins
- Heading styles
- Table styles
- Code block appearance

## 🐛 Troubleshooting

<details>
<summary><b>WorkIQ not available</b></summary>

**No problem!** Skill automatically creates a structured template.

1. Template includes all sections with `[TO BE FILLED]` markers
2. Fill in manually with your information
3. Still saves 6-8 hours vs. starting from scratch
4. Re-run if WorkIQ becomes available later

</details>

<details>
<summary><b>Skill not found in /help</b></summary>

Check installation path:
```bash
dir "%USERPROFILE%\.claude\skills\generate-spec"
```

Should contain: `skill.json`, `instructions.md`, etc.

Restart Claude Code CLI after installation.

</details>

<details>
<summary><b>Word conversion fails</b></summary>

1. Verify Microsoft Word is installed
2. Check PowerShell execution policy: `Get-ExecutionPolicy`
3. Try markdown-only: Edit `instructions.md` and skip Word conversion phase
4. Manually convert markdown to Word later

</details>

<details>
<summary><b>No information found for topic</b></summary>

1. Try variations of the topic name
2. Use more specific phrases
3. Check that data exists in your M365 environment
4. Skill will create template if no data found

</details>

## 📈 Time Savings

| Task | Manual Process | With This Skill |
|------|----------------|-----------------|
| **Research** | 2-3 hours | 1 minute |
| **Writing** | 4-6 hours | 2 minutes |
| **Formatting** | 1-2 hours | 1 minute |
| **Diagrams** | 1 hour | 30 seconds |
| **Total** | **8-12 hours** | **~5 minutes** |

**ROI:** ~96% time reduction per specification

## 🔄 Version History

- **v1.4.0** (2026-02-02) - Template fallback mode for WorkIQ unavailability
- **v1.3.0** (2026-02-02) - Current directory output for file control
- **v1.2.0** (2026-02-02) - Renamed to FORMATTING-GUIDELINES.md for clarity
- **v1.1.0** (2026-02-02) - Bundled formatting guidelines for portability
- **v1.0.0** (2026-01-30) - Initial release with full automation

See [CHANGELOG.md](CHANGELOG.md) for detailed changes.

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Saurabh Agarwal**

- GitHub: [@YOUR-USERNAME](https://github.com/YOUR-USERNAME)
- Email: sauagarwal@microsoft.com

## 🙏 Acknowledgments

- Built for use with [Claude Code CLI](https://github.com/anthropics/claude-code)
- Integrates with Microsoft 365 Copilot (WorkIQ)
- Follows Microsoft specification writing standards

## ⭐ Star History

If this skill saves you time, consider giving it a star! ⭐

---

**Status:** Production Ready ✅ | **Package Size:** 21 KB | **Platform:** Windows

[Report Bug](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/issues) · [Request Feature](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/issues) · [Documentation](https://github.com/YOUR-USERNAME/claude-generate-spec-skill/wiki)
