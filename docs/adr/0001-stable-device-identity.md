# Device identity is derived from the machine, not the installation

`iCloudSyncDeviceID` was a random UUID minted into `UserDefaults` on first launch, so a
reinstall produced a new identity and left the previous Device Record and its Usage Snapshots
in CloudKit with nothing alive to refresh them (issue #3234). Device identity is now derived
from a hashed `kern.uuid`, which survives reinstalls, so one Mac stays one Device.

## Considered Options

The new derivation applies **only when no identifier is already persisted**. Existing installs
keep the random UUID they have.

Migrating every install to the hashed identifier was rejected: it would strand a Device Record
for every current sync user at once, inflicting the reported bug on all of them to fix it for
the few who reinstall.

## Consequences

A Mac that already reinstalled before this change carries a random UUID and still shows one
legacy duplicate. That duplicate must be removed by hand, once; subsequent reinstalls no
longer create one.
