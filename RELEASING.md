The EPP Release Process
=======================

An online editable version of this document is on [hackmd.io](https://hackmd.io/@jonahgraham/eclipse-epp-release-process), updates should be copied to [Eclipse's git repo](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/RELEASING.md). The Eclipse version is the official one.

This guide contains the step-by-step process to complete an EPP release. 

EPP releases happen for each milestone and release candidate according to the [Eclipse Simultaneous Release Plan](https://wiki.eclipse.org/Simultaneous_Release).

Steps for Milestones and RCs:

- [ ] Ensure that the [CI build](https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/) is green. Resolving non-green builds will require tracking down problems and incompatibilities across all Eclipse participating projects. [cross-project-issues-dev](https://accounts.eclipse.org/mailing-list/cross-project-issues-dev) mailing list is a good place to start when tracking such problems.
- [ ] Update splash screen (once per release cycle, hopefully done before M1). See detailed [instructions](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/packages/org.eclipse.epp.package.common/splash/INSTRUCTIONS.md).
- [ ] Update the build qualifiers to ensure that packages are all updated. Run [setGitDate](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/releng/org.eclipse.epp.config/tools/setGitDate) script to do that.
- [ ] Update name of the release in strings with a "smart" global find&replace. See this [gerrit](https://git.eclipse.org/r/#/c/157267/) for an example. In particular, check:
    - [ ] `packages/*/epp.website.xml` for `product name=` line
    - [ ] Variables in parent pom `releng/org.eclipse.epp.config/parent/pom.xml`
    - [ ] On M1, whole version string is updated, including platform version (e.g. `4.14` -> `4.15`); this is a large change including pom.xml, feature.xml, MANIFEST.MF, epp.website.xml, and epp.product
- [ ] When the year changes, e.g. between 2019-12 and 2020-03 releases, an update of the copyright year is required with a very smart search&replace.
- [ ] Wait for announcment that the staging repo is ready on [cross-project-issues-dev](https://accounts.eclipse.org/mailing-list/cross-project-issues-dev). An [example announcement](https://www.eclipse.org/lists/cross-project-issues-dev/msg17420.html).
- [ ] Run a [CI build](https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/) that includes the above changes
- [ ] Sanity check the build for the following:
    - [ ] Download a package from the build's artifacts `artifact/org.eclipse.epp.packages/archive/`
    - [ ] Made sure filenames contain expected build name and milestone, e.g. `2020-03-M2`
    - [ ] Splash screen says expected release name (with no milestone), e.g. 2020-03
    - [ ] Help -> About says expected build name and milestone, e.g. `2020-03-M2`
    - [ ] `org.eclipse.epp.packages.*` features and bundles have the timestamp of the forced qualifier update
- [ ] For a release build, the additional parameters (see parent pom) should be set in the Jenkins build job to a meaningful time/date:
```
maven.build.timestamp=20191212-1212
eclipse.simultaneous.release.build=20191212-1212
build=20191212-1212
```
- [ ] **TO BE AUTOMATED** Notarize the Mac DMG files. There is a [manual job today](https://ci.eclipse.org/packaging/job/macos-notarization/) that can be automated as part of the build. The automated part can be on every build, not just releases.
- [ ] **TO BE AUTOMATED** Prepare the p2 repository
  *These easy steps were done in the past from the command line because they are just easy commands but it takes a long time to put them into a Jenkins job or a similar script.* 
    - [ ] In `/home/data/httpd/download.eclipse.org/technology/epp/packages/` there is a dedicated sub-directory for every Simultaneous Release, e.g. `2020-03/`. The _next_ release sub-directory needs to be created immediately _after_ a release, i.e. when 2019-12 was released, a directory 2020-03 had been created with an empty p2 composite repository pointing to 2019-12 until M1. On M1 release day this changes to a composite p2 repository with M1 content.
    - [ ] ZIP the packages p2 repository from the Jenkins build job in `archive/repository/` and
        - [ ] copy it to the download server into the above directory; in the past we've been using a name like `epp.m2.854.zip` for a M2 build and build job number 854 on Jenkins.
        - [ ] unzip the p2 repository on the download server, e.g. into a directory `M2/`
        - [ ] On release day: Add this p2 repository to the composite p2 repository
        - [ ] For the final release, this composite p2 repository is being transformed into a flat p2 repository.
- [ ] **TO BE AUTOMATED** Prepare the packages on the download server
  *These easy steps were done in the past from the command line because they are just easy commands but it takes a long time to put them into a Jenkins job or a similar script.* 
  - [ ] Create the new directory for the release in `/home/data/httpd/download.eclipse.org/technology/epp/downloads/release`, e.g. `2020-03`
  - [ ] On release day, update [release.xml](https://download.eclipse.org/technology/epp/downloads/release/release.xml) which basically lists the relative locations of past, present, and future package releases. This will allow the webmasters to publish the new packages on the main Eclipse download page.
  - [ ] Copy the packages to their final destination on the download server, rename the files, create MD5, SHA1, SHA256 files for all downloads, checkout the epp.website.xml files and put them next to the packages.
