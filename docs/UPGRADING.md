# Upgrade and restore

0.3.0 reads records written by 0.1.0, 0.2.0, 0.3.0-rc.1, and 0.3.0 under
contract 1.0.0. Compatibility does not rewrite old records, their IDs, metadata,
creation events, checksums, configuration, or bound artifacts. New records use
the current version. An old executable may reject newer-version records.

1. Stop writers. With the currently installed version, validate existing records
   and save its version/runtime information. For RC installations, run `audit`
   and independently retain a checkpoint before the upgrade.
2. Back up the entire state directory, including metadata, history, locks and
   transaction intents, plus external configuration and referenced artifacts.
   Keep this backup untouched. The 0.2.0 release predates checkpoint commands;
   do not fabricate an old checkpoint or claim missing audit evidence exists.
3. Download the new archive and its checksum. Verify SHA-256, extract alongside
   the previous installation, and retain its complete directory structure.
   Point the new launcher at your existing state/configuration explicitly.
4. Run `doctor`, `validate`, and `audit`. Within the supported complete-audit
   envelope, create and independently retain a checkpoint. Any incompatible,
   corrupt, incomplete or conflicting evidence requires investigation before
   resuming writes; never clear locks merely because they are old.
5. After a process interruption, inspect `transaction --id ID`. Recover using
   the persisted owner token with `recover --id ID --owner TOKEN`. Recovery
   publishes only the original intent bytes and never overwrites a conflict.
6. To roll back, stop writers and restore the untouched backup to a separate
   location, with its matching configuration/artifacts and prior executable.
   Verify record hashes/audit and any independently retained checkpoint before
   switching back. Do not run an older executable over mixed-version live state
   and assume it understands new records.

The release gate uses frozen state produced by the actual tagged 0.2.0 and RC
applications, with source revisions and byte checksums under `fixtures/upgrades`.
It verifies mixed-version operation, old-byte preservation, configured reviewer
identity, backup restoration at another path, rejection of immutable ID reuse,
and exact recovery of an unfinished RC intent. Existing crash tests additionally
kill writers after intent, record and event publication. These are process-crash
checks, not simulated disk/controller power-loss tests.
