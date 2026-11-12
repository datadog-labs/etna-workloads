# Rationale
Re-introduced the "only remove FINALIZED files" lifecycle (reverse of the fix), all under src/src/:
- copy_output_lifecycle.hpp: restored CopyOutputPublicationState enum, FileEntry::publication, RegisterFile returning idx_t, MarkFileFinalized (header hunks of the fix).
- copy_output_lifecycle.cpp Cleanup(): remove only REMOVE_ON_FAILURE files that are FINALIZED (hunk 1); RegisterFile/MarkFileFinalized restored (hunk 2).
- physical_batch_copy_to_file.cpp: lifecycle_file_index member, stored from RegisterFile in Initialize, MarkFileFinalized after copy_to_finalize in FinalFlush.
- physical_copy_to_file.cpp: GlobalFileState carries lifecycle_file_index; InitializeFileState passes it; FinalizeLifecycleFileState takes output_lifecycle and marks finalized; the scheduling lambda/fallback pass output_lifecycle_ref.
Effect: files open/unfinalized when a COPY fails are left on disk instead of removed.

## etna-check result

FAIL     cpp:test/api/test_copy_output_lifecycle.cpp::COPY output lifecycle removes owned files after failure
1 of 9 oracle units fail
