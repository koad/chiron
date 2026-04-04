# command: juno revenue status

**Status:** planned  
**Owner:** juno  
**Priority:** high

## Purpose
Report current revenue state: MRR by stream, sponsor breakdown, trend vs. prior period.

## Usage
```
juno revenue status
```

## Expected Output
- Current MRR total
- Breakdown by stream (sponsors, entity sales, community)
- Month-over-month trend
- Next milestone and gap

## Implementation Plan
- Aggregate GitHub Sponsors data
- Log entity-as-product sales when they occur
- Calculate MRR and growth rate
- Reference BUSINESS_MODEL.md tiers for context

## Dependencies
- GitHub Sponsors API
- BUSINESS_MODEL.md
