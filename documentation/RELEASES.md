**Introduction**

Release notes, also commonly known as product changelog, are important to understanding what has changed in a product. We use the channel to convey upcoming features, product changes, improvements, and bug fixes to enhance user experience and increase transparency.

**_Importance of Release Notes_**

- Providing an overview of what has changed in a release
- Ensuring transparency and communication to stakeholders
- Making it easier to identify what new features have been added or removed from the product

**_Template of a good release note_**

Release notes should be written in simple language that should be easy to understand by users.

The following points are essential to include in release notes:

- Release version and release date
- Brief summary of all the necessary product updates
- Explain all the new features released, any notable changes in using the product, and all the enhancements and improvements.
- Highlight all the critical bugs fixed in the release
- Focus on any updates or upgrades the end user requires.

**Examples**

- Slack (<https://slack.com/intl/en-in/release-notes/ios>)
- Twitter (<https://twitter.com/i/release_notes>)
- Intercom (<https://www.intercom.com/changes/en>)
- Notion (<https://www.notion.so/releases>)

**What we want/should see in CAWE Release Notes**

- Release Version and Date
- Introduction
- What's new (Breaking Changes)
- Features
- Bugfixes
- Respective Jira Tickets and Commits associated with any change
- What I need to do

**Semantic Version (What is it, and should we adopt)**

1.  MAJOR version when you make incompatible API changes
2.  MINOR version when you add functionality in a backwards compatible manner
3.  PATCH version when you make backwards compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

Choosing a SemVer approach depends on us really,

When should release notes be created

1.  We need to define the frequency of releases? Will it be everyday, weekly, or manually

**Automating Release Note Creation**

To achieve an automatic way of creating release we need to adhere to some

1.  Conventional/Standard Commits - <https://www.conventionalcommits.org/en/v1.0.0/>
    1.  `fix:` which represents bug fixes, and correlates to a [SemVer](https://semver.org/) patch.
    2.  `feat:` which represents a new feature, and correlates to a SemVer minor.
    3.  `feat!:`, or `fix!:`, `refactor!:`, etc., which represent a breaking change (indicated by the `!`) and will result in a SemVer major.
2.  When should it be created? On Merge to Main (for Minor Releases) and Manually (for Major Releases)
3.  Tools we can use to achieve automatic release note creation
    1.  Release Please (<https://github.com/googleapis/release-please>). Also has a github action
    2.  Github Automatic Releases (<https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes>)
    3.  Semantic Releases (<https://github.com/semantic-release/semantic-release>)

[](https://atc.bmwgroup.net/confluence/display/CICD/CAWE+%7C+Release+Notes)
