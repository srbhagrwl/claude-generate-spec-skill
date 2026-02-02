# Generate-Spec Skill - Quick Start Guide

## 1. Basic Usage

Simply invoke the skill with your topic:

```
/generate-spec <your topic>
```

## 2. Real Examples

### Example 1: Folder Affinity (Already Done)
```
/generate-spec folder affinity
```

**Result:**
- 742-line specification document
- 23 tables with requirements and plans
- 2 professional diagrams
- 12 stakeholders identified
- Ready for review in < 5 minutes

### Example 2: Voicemail Support
```
/generate-spec voicemail support
```

**What happens:**
1. **7 Sequential Queries**: Searches emails → meetings → docs → Teams → incidents → plans → artifacts (one at a time)
2. **UltraThink Analysis**: Cross-references all sources to identify patterns and decisions
3. **Identifies Stakeholders**: Finds Viktoria, Shubha, and other key people with roles
4. **Creates Spec**: Generates complete specification with problem statement and CY26H1 planning
5. **Outputs Word Doc**: Professional .docx file ready to share

### Example 3: Shared Mailbox Search
```
/generate-spec shared mailbox search
```

**What happens:**
1. Finds all discussions about shared mailboxes
2. Extracts customer escalations and IcMs
3. Creates spec with evaluation criteria
4. Includes competing solutions (Gmail, etc.)

## 3. How It Works (Behind the Scenes)

The skill uses a powerful **UltraThink Mode** that:

1. **Makes 7 Sequential Queries** (not 1 combined query):
   - Query 1: Emails only
   - Query 2: Meetings only
   - Query 3: Documents only
   - Query 4: Teams conversations only
   - Query 5: Customer incidents only
   - Query 6: Project plans only
   - Query 7: Related artifacts only

2. **Analyzes Each Result** before moving to the next query

3. **Cross-References Everything** to find patterns, contradictions, and key decisions

4. **Synthesizes** into a comprehensive specification document

**Why 7 separate queries?** Prevents cascading failures and ensures complete data collection even if some queries fail.

## 4. What You Get

Two files in your **current directory**:

```
📄 <Topic> - Specification.md       ← Markdown source
📄 <Topic> - Specification.docx     ← Polished Word doc
```

**Tip:** Navigate to where you want the files before running the command!

## 5. What's Inside

Every spec includes:

| Section | What's In It |
|---------|--------------|
| **Problem Details** | Customer names, IcMs, escalations |
| **Solution** | Architecture diagrams, North Star vision |
| **Requirements** | P0/P1/P2 tables with DRIs |
| **Evaluation** | Query sets, success metrics |
| **Project Plan** | Phased timeline with ETAs |
| **Open Questions** | What needs clarification |
| **Appendix** | Technical deep-dives |

## 6. Review Checklist

After generation, quickly check:

- [ ] Key stakeholders listed correctly
- [ ] Open questions make sense
- [ ] Dates and timelines are current
- [ ] Customer names are accurate
- [ ] DRIs assigned correctly
- [ ] Diagrams are clear
- [ ] Tables are complete

## 7. Common Follow-Ups

After generating a spec, you might want to:

### Share with stakeholders
```
Just share the .docx file - it's ready!
```

### Update with new information
```
/generate-spec <topic>
```
*Re-runs and incorporates latest data*

### Convert existing doc to markdown
```
Ask Claude: "Convert <doc> to markdown following FORMATTING-GUIDELINES.md"
```

### Extract just the project plan
```
Ask Claude: "Extract project plan from <spec> as a table"
```

## 8. Pro Tips

✅ **DO:**
- Use specific topic names ("folder affinity" not "emails")
- Review Open Questions section carefully
- Share the Word doc directly with stakeholders
- Re-run periodically as new info emerges

❌ **DON'T:**
- Use very broad topics ("features" is too vague)
- Skip reviewing before sharing
- Edit the Word doc before reviewing markdown
- Forget to follow up on Open Questions

## 9. Troubleshooting

### "WorkIQ not available"
→ **No problem!** Skill creates a structured template automatically
→ Fill in `[TO BE FILLED]` markers with your information
→ Re-run if WorkIQ becomes available later

### "No information found"
→ Try variations: "voicemail", "voicemail support", "voicemail copilot"
→ If still nothing, you'll get a template to fill manually

### "Some sections are sparse"
→ Normal! Check Open Questions for what's missing
→ Sections with insufficient data are marked clearly

### "Need to add custom content"
→ Edit the markdown, then re-convert to Word

## 10. Time Savings

| Manual Process | With Skill |
|---------------|------------|
| Research: 2-3 hours | 1 minute |
| Writing: 4-6 hours | 2 minutes |
| Formatting: 1-2 hours | 1 minute |
| Diagram creation: 1 hour | 30 seconds |
| **Total: ~8-12 hours** | **~5 minutes** |

## 11. Next Steps

1. Try it now:
   ```
   /generate-spec <pick a topic>
   ```

2. Review the output

3. Share with stakeholders

4. Update FORMATTING-GUIDELINES.md if you want different formatting

That's it! 🚀
