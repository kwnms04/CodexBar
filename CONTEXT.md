# CodexBar

Menu bar app that reports AI provider usage and credits. This glossary covers terms whose
meaning is specific to CodexBar and easy to confuse with a neighbouring concept.

## Language

### iCloud Sync

**Device**:
One physical Mac in the user's fleet. A Device outlives reinstalls of CodexBar: reinstalling
does not produce a second Device.
_Avoid_: Machine, installation, node, client

**Device Record**:
The CloudKit record that represents a Device. One per Device.
_Avoid_: Mac record, host record

**Fleet**:
The set of Devices syncing under a single iCloud account.
_Avoid_: Cluster, group, network

**Usage Snapshot**:
A point-in-time usage reading for one provider account, taken on one Device. Snapshots are
per-Device: two Devices reporting the same account hold separate Snapshots.
_Avoid_: Usage record, sample, reading

**Stale Device**:
A Device Record that no live Mac will ever refresh, because the installation that created it
is gone. Its Usage Snapshots keep being projected into the menu even though nothing updates
them.
_Avoid_: Orphan, ghost, dead device, duplicate
