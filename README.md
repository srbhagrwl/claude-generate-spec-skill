# Generate Specification Document Skill

A comprehensive skill for automatically creating Microsoft-standard specification documents by gathering information from WorkIQ and applying professional formatting.

**Works with or without WorkIQ** - Creates structured templates when WorkIQ is unavailable.

## What This Skill Does

This skill automates the entire process of creating a specification document:

**With WorkIQ (Automatic Mode):**
1. **Gathers information** from all sources (emails, meetings, documents, Teams conversations)
2. **Synthesizes** into a structured specification following Microsoft standards
3. **Generates** markdown document with proper formatting
4. **Converts** to professional Word document with improved diagrams
5. **Provides** summary and next steps

**Without WorkIQ (Template Mode):**
1. **Creates structured template** with all required sections
2. **Includes guidance** with `[TO BE FILLED]` markers
3. **Provides examples** showing proper format
4. **Converts to Word** - ready for manual completion
5. **Saves hours** vs. starting from scratch

## Usage

### Basic Usage

```
/generate-spec <topic>
```

**Example:**
```
/generate-spec folder affinity
```

### With Options

```
/generate-spec <topic> --format <md|docx|both>
```

**Examples:**
```
/generate-spec voicemail support --format docx
/generate-spec shared mailbox search --format both
```

## What Gets Generated

### Document Structure

The skill creates a comprehensive specification with these sections:

1. **Title** - Feature name
2. **Glossary** - Acronym definitions
3. **Introduction** - Context and overview
4. **Problem Details** - Evidence-based problem statement
   - Problem statement
   - User asks with real names
   - Current limitations
   - Evidence (customer names, incidents)
5. **Solution Approach** - Proposed solution
   - North Star vision
   - Technical architecture
   - In Scope / Out of Scope
6. **Detailed Requirements** - Actionable requirements
   - Functional requirements table
   - Non-functional requirements table
   - Scenarios with sample utterances
7. **Evaluation Set** - Testing strategy
   - Query sets
   - Success metrics
   - Test scenarios with assertions
8. **Project Plan** - Execution timeline
   - Phased breakdown
   - Task tables with DRIs and ETAs
   - Critical path
   - Roles & responsibilities
9. **Open Questions** - Unresolved items
10. **References** - Related documents and links
11. **Appendix** - Technical deep-dives

### Professional Formatting

**Markdown Output:**
- Clean hierarchy with proper headers
- Tables for all structured data
- Code blocks for technical content
- Inline links to references
- Priority labels (P0/P1/P2)

**Word Output:**
- Professional heading styles
- Grid Table 4 - Accent 1 for tables
- Improved diagrams:
  - Flowcharts with bordered boxes
  - Dependency grids with color coding
  - Clear typography and spacing
- Hyperlinked references
- 1-inch margins

## Files Generated

For a topic "folder affinity", the skill creates files in your **current working directory**:

```
./
├── Folder Affinity - Specification.md      (Markdown version)
└── Folder Affinity - Specification.docx    (Word version)
```

**Example:** If you're in `C:\Projects\`, the files will be saved there.

**Tip:** Navigate to your desired folder before running the command to control where files are saved.

## Information Gathered

The skill automatically queries WorkIQ for:

- ✓ All emails containing the topic
- ✓ All meetings and calendar events
- ✓ All documents (specs, drafts, presentations)
- ✓ All Teams conversations and threads
- ✓ All stakeholders (names, roles, teams)
- ✓ Technical details and architecture
- ✓ Decisions, action items, blockers
- ✓ Customer feedback and escalations
- ✓ Timeline discussions and ETAs

## Quality Standards

Every generated specification includes:

- [x] Problem grounded in evidence (customer names, IcMs)
- [x] Explicit scope definition (in/out of scope)
- [x] Specific, actionable requirements
- [x] Scenarios with sample utterances
- [x] Priority labels on all items
- [x] Project plan with DRIs and ETAs
- [x] Tables for complex information
- [x] Open Questions section
- [x] References to source documents
- [x] Technical appendices
- [x] Direct, economical language
- [x] Cross-team dependencies identified

## Example Output

### Console Output

```
📋 Generating specification for: folder affinity

🔍 Phase 1: Information Gathering
   ✓ Found 15 emails
   ✓ Found 3 meetings
   ✓ Found 8 documents
   ✓ Found 42 Teams conversations
   ✓ Identified 12 stakeholders

📝 Phase 2: Document Generation
   ✓ Created comprehensive specification (742 lines)
   ✓ Included 23 tables
   ✓ Included 2 diagrams
   ✓ Saved markdown: ./Folder Affinity - Specification.md

📄 Phase 3: Word Conversion
   ✓ Converted to Word format
   ✓ Improved 2 diagrams
   ✓ Saved Word document: ./Folder Affinity - Specification.docx

✅ Specification Complete!

Key Stakeholders:
- Saurabh Agarwal (PM, Email Ranker)
- Bryan Butteling (DRI, Moments)
- Ashish Jain (EM, Email Ranker)
- Mary Fe Garzon (PM, Moments)

Open Questions: 12 items requiring clarification

Next Steps:
1. Review with Bryan Butteling (Moments capacity)
2. Clarify affinity computation frequency
3. Schedule alignment meeting with stakeholders
```

## Customization

### Modifying Diagram Styles

Edit `improve-diagrams.ps1` to customize:
- Colors (background, borders)
- Fonts and sizes
- Component layouts
- Arrow styles

### Changing Document Structure

Edit `instructions.md` to modify:
- Section order
- Required vs optional sections
- Table formats
- Priority labeling scheme

### Adjusting Formatting

Edit `convert-to-word.ps1` to customize:
- Page margins
- Heading styles
- Table styles
- Code block appearance

## Troubleshooting

### Issue: No information found

**Cause:** Topic may be too vague or no data exists in WorkIQ

**Solution:** Try more specific topic names or variations

### Issue: Word conversion fails

**Cause:** Microsoft Word not installed or COM interface issues

**Solution:**
- Ensure Word is installed
- Use `--format md` to skip Word conversion
- Manually convert markdown to Word later

### Issue: Diagrams not improved

**Cause:** Diagram detection didn't find expected sections

**Solution:**
- Check that section headers match expected text
- Manually improve diagrams after generation
- Modify `improve-diagrams.ps1` search patterns

### Issue: Missing stakeholder information

**Cause:** Names not found in conversations

**Solution:**
- Review Open Questions section
- Manually add missing stakeholders
- Follow up with team to gather missing info

## Requirements

- Windows with PowerShell 5.1+
- Microsoft Word (for .docx generation)
- WorkIQ access configured (optional - see Template Mode below)

**Note:** Files are saved to your current working directory. Navigate to your desired folder before running the command.

**Note:** Formatting guidelines (FORMATTING-GUIDELINES.md) are bundled in the skill folder - no separate setup required!

### Template Mode (WorkIQ Optional)

If WorkIQ is not available, the skill automatically creates a **structured template specification** with:
- ✅ All required sections and tables
- ✅ `[TO BE FILLED]` markers with guidance
- ✅ Example content showing proper format
- ✅ Ready for manual completion
- ✅ Converts to Word document

This means you can still use the skill even without WorkIQ access - you'll just need to fill in the content manually.

## Version History

- **1.0.0** (2026-01-30) - Initial release
  - Full automation of spec generation
  - WorkIQ integration
  - Professional diagram improvement
  - Microsoft standard formatting

## Support

For issues or feature requests:
1. Check the troubleshooting section above
2. Review the instructions.md file
3. Modify scripts as needed for your use case

## Tips for Best Results

1. **Use specific topic names** - "folder affinity" vs "emails"
2. **Review before sharing** - Check Open Questions section
3. **Customize for audience** - Adjust detail level in Appendix
4. **Keep FORMATTING-GUIDELINES.md updated** - Formatting standards evolve
5. **Iterate** - Run multiple times as more information becomes available
6. **Verify names** - Ensure all stakeholders are correctly identified
7. **Add context** - Supplement with manual edits where needed

## License

Internal Microsoft tool. Not for external distribution.
