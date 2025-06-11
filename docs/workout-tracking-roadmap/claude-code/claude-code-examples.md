[Implements the fix with code changes][Implements the fix with code changes]# Claude Code Implementation Examples

## Real Examples for Common Task Patterns

### Pattern 1: Bug Fix Task (Equipment Selection)

```
Human: Let's fix TASK-001. The equipment selection resets when users navigate between cycles. Can you investigate why this happens?

Claude: I'll investigate the equipment selection issue. Let me first check how the current implementation handles equipment state.

[Reviews code and identifies that equipment is passed via params but not properly maintained in all forms]

The issue is that equipment selection is only preserved in some forms but not others. When users click on different cycles, the cycle form doesn't include hidden fields for equipment selection. Let me fix this by:

1. Ensuring session storage of equipment preferences
2. Adding hidden fields to ALL forms
3. Making the controller consistently read from session with param override

[Implements the fix with code changes]