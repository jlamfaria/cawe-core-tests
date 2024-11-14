## How the Release Note Works

Release Please automates CHANGELOG generation, the creation of GitHub releases, and version bumps for your projects.
It does so by parsing your git history, looking for Conventional Commit messages, and creating release PRs.
It does not handle publication to package managers or handle complex branch management.

Rather than continuously releasing what's landed to your default branch,
release-please maintains Release PRs.

These Release PRs are kept up-to-date as additional work is merged. When you're
ready to tag a release, simply merge the release PR. Both squash-merge and
merge commits work with Release PRs.

When the Release PR is merged, release-please takes the following steps:

1. Updates your changelog file (for example `CHANGELOG.md`), along with other language specific files (for example `package.json`).
2. Tags the commit with the version number
3. Creates a GitHub Release based on the tag

You can tell where the Release PR is in its lifecycle by the status label on the
PR itself:

- `autorelease: pending` is the initial state of the Release PR before it is merged
- `autorelease: tagged` means that the Release PR has been merged and the release has been tagged in GitHub
- `autorelease: snapshot` is a special state for snapshot version bumps
- `autorelease: published` means that a GitHub release has been published based on the Release PR (_release-please does not automatically add this tag, but we recommend it as a convention for publication tooling_).

## How should I write my commits?

Release Please assumes you are using [Conventional Commit messages](https://www.conventionalcommits.org/).

The most important prefixes you should have in mind are:

- `fix:` which represents bug fixes, and correlates to a [SemVer](https://semver.org/)
  patch.
- `feat:` which represents a new feature, and correlates to a SemVer minor.
- `feat!:`, or `fix!:`, `refactor!:`, etc., which represent a breaking change
  (indicated by the `!`) and will result in a SemVer major.

## Releases in CAWE

Different Phases

1. Beginning of the Sprint: First PR triggers the pipeline that creates the ReleasePR
2. ReleasePR is updated throughout the lifecycle of the sprint
3. At the end of the Sprint or a Specified period, the ReleasePR is merged to main
4. This triggers the pipeline to create the new Release and the notification to teams
