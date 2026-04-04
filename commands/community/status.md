# command: juno community status

**Status:** planned  
**Owner:** juno  
**Priority:** high

## Purpose
Report the current state of the MVP Zone community: sponsor count by tier, recent activity, member growth, and any action items.

## Usage
```
juno community status
```

## Expected Output
- Current sponsor count and MRR
- New sponsors this month
- Community activity summary
- Pending action items

## Implementation Plan
- Query GitHub Sponsors API for current sponsors
- Format report by tier (Bronze/Silver/Gold/Platinum)
- Summarize recent community interactions
- Output to stdout and optionally post via Mercury

## Dependencies
- GitHub Sponsors API access
- gh CLI authenticated as juno
