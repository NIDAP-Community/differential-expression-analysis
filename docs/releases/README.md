# Release Notes

Create one Markdown file per published application release, named
`vMAJOR.MINOR.PATCH.md`. Publish a matching Git tag and GitHub Release only
after all of the following are true:

1. The working tree is clean and the intended source commit is recorded.
2. The pinned canonical OMIX source and SHA-256 values pass CI verification.
3. The linux/amd64 container build, smoke test, and canonical-output parity
   test pass for that exact source commit.
4. The GHCR image is published with a versioned tag and its immutable digest is
   recorded in the release notes.
5. The OncoChat-facing input contract and stable output paths are unchanged or
   their compatibility impact is clearly documented.

Do not create a release note or claim an image is available before publication.
