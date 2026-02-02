# Generate-Spec Skill

Automatically generate comprehensive specification documents following Microsoft standards by gathering information from WorkIQ (or creating structured templates when WorkIQ is unavailable).

## Description

This skill automates the creation of detailed technical specifications by:
1. Gathering information from WorkIQ (emails, meetings, documents, Teams conversations)
2. Generating a Microsoft-standard specification document with all required sections
3. Converting to a professionally formatted Word document

**Time Savings:** Reduces 8-12 hours of manual work to ~5 minutes.

## Usage

```bash
/generate-spec <topic>
```

### Parameters

- **topic** (required): The feature or topic to research and create a specification for
- **output_format** (optional): Output format - `md`, `docx`, or `both` (default: `docx`)

### Examples

```bash
# Generate a spec for folder affinity feature
/generate-spec folder affinity

# Generate a spec for voicemail support
/generate-spec voicemail support

# Generate a spec for shared mailbox search
/generate-spec shared mailbox search
```

## Output

The skill generates two files in your current directory:

- `<Topic> - Specification.md` - Markdown source document
- `<Topic> - Specification.docx` - Professionally formatted Word document

## What's Included

Every specification contains:

### Problem Statement
- Customer escalations and evidence
- IcM incidents
- User asks with stakeholder names
- Impact analysis

### Solution Design
- North Star vision
- Architecture diagrams
- Scope (in/out of scope)
- Technical approach

### Requirements
- Functional requirements (P0/P1/P2 prioritized)
- Non-functional requirements
- Sample scenarios and utterances
- Acceptance criteria

### Evaluation Criteria
- Query test sets
- Success metrics
- Test scenarios with assertions

### Project Plan
- Phased breakdown
- Task tables with DRIs and ETAs
- Dependencies and risks
- Open questions

## How It Works

### Automatic Mode (With WorkIQ)
1. Queries WorkIQ for all relevant information about the topic
2. Synthesizes findings into a comprehensive specification
3. Formats according to Microsoft standards
4. Converts to Word with professionally formatted diagrams

### Template Mode (Without WorkIQ)
1. Creates a structured template with all required sections
2. Includes example tables and placeholder markers `[TO BE FILLED]`
3. Provides inline guidance for manual completion
4. Still saves 6-8 hours vs. starting from scratch

## Prerequisites

- Windows with PowerShell 5.1+
- Claude Code CLI installed
- Microsoft Word (for .docx generation)
- WorkIQ access (optional - template mode available without it)

## Notes

- Files are created in your **current working directory**
- Navigate to your desired folder before running the skill
- The skill **never fails** - creates templates when information is unavailable
- Diagrams in the Word document are automatically formatted in professional bordered boxes
- All sections follow Microsoft specification writing standards

## Customization

The skill can be customized by editing:
- `instructions.md` - Modify document structure and sections
- `convert-to-word.ps1` - Adjust Word formatting styles and diagram appearance

## Troubleshooting

**WorkIQ not available?**
No problem! The skill automatically creates a structured template with all required sections marked with `[TO BE FILLED]` for manual completion.

**Word conversion fails?**
Verify Microsoft Word is installed and PowerShell execution policy allows script execution.

**No information found?**
Try variations of the topic name or use more specific phrases. The skill will create a template if no data is found.

## Author

Created by Saurabh Agarwal (sauagarwal@microsoft.com)

## Version

1.8.1

## License

MIT
