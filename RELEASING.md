The EPP Release Process
=======================

An online editable version of this document is on [hackmd.io](https://hackmd.io/@jonahgraham/eclipse-epp-release-process), updates should be copied to [Eclipse's git repo](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/RELEASING.md). The Eclipse version is the official one.

This guide contains the step-by-step process to complete an EPP release.

EPP releases happen for each milestone and release candidate according to the [Eclipse Simultaneous Release Plan](https://wiki.eclipse.org/Simultaneous_Release).

**Steps for M1:**

- [ ] Update splash screen (once per release cycle, hopefully done before M1). See detailed [instructions](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/packages/org.eclipse.epp.package.common/splash/INSTRUCTIONS.md).
- [ ] When the year changes, e.g. between 2019-12 and 2020-03 releases, an update of the copyright year is required with a very smart search&replace.
- [ ] In addition to the "Update Name" step on every M and RC, the whole version string is updated, including platform version (e.g. `4.14` -> `4.15`); this is a large change including pom.xml, feature.xml, MANIFEST.MF, epp.website.xml, and epp.product 
- [ ] rsync the downloads area to archive.eclipse.org and remove non-R downloads.
    - [ ] Remove the old M and RC builds with https://ci.eclipse.org/packaging/job/releng-delete-old-M-RC-downloads
    - [ ] rsync the last release to the archives with https://ci.eclipse.org/packaging/job/releng-rsync-epp-downloads-to-archive
    - [ ] Remove releases from download.eclipse.org by listing releases to delete and then running https://ci.eclipse.org/packaging/job/releng-remove-old-downloads (TODO create this job)

**Steps for all Milestones and RCs:**

- [ ] Ensure that the [CI build](https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/) is green. Resolving non-green builds will require tracking down problems and incompatibilities across all Eclipse participating projects. [cross-project-issues-dev](https://accounts.eclipse.org/mailing-list/cross-project-issues-dev) mailing list is a good place to start when tracking such problems.
- [ ] Check that packages containing incubating projects have that information reflected in Help -> About dialog. See near the end of build output for report of check-incubating.sh script.
    - `-incubation` and ` (includes Incubating components)` are not used in packageMetaData anymore (See [Bug 564214](https://bugs.eclipse.org/bugs/show_bug.cgi?id=564214))
- [ ] Update the "new and noteworthy" version numbers: (Normally only done on M3 and RCs)
    - [ ] Search for ` url=` (notice the blank before url) in `epp.website.xml` to see which ones are contained in the different packages.
    - [ ] Use global search and replace to update the version numbers at the end of the URLs.
    - [ ] Remember that some of the features will release new versions together with the new Eclipse release. Therefore using the _currently_ released version number may be wrong. Instead lookup the feature version [to be released with the release train](https://projects.eclipse.org/releases/2020-03).
- [ ] Update name of the release in strings with a "smart" global find&replace. *Be careful on M3 that the replace did not match the Eclipse project name M2E!* See this [gerrit](https://git.eclipse.org/r/#/c/158509/) for an example. Use commit message like `Update strings for 2020-09 M2`. In particular, check:
    - [ ] `packages/*/epp.website.xml` for `product name=` line
    - [ ] Variables in parent pom `releng/org.eclipse.epp.config/parent/pom.xml`
    - [ ] release.xml template in releng/org.eclipse.epp.config/tools/promote-a-build.sh
- [ ] Update the build qualifiers to ensure that packages are all updated. See this [gerrit](https://git.eclipse.org/r/#/c/161075/) for an example. To do this run [`releng/org.eclipse.epp.config/tools/setGitDate`](https://git.eclipse.org/c/epp/org.eclipse.epp.packages.git/tree/releng/org.eclipse.epp.config/tools/setGitDate) script. This script will make a local commit you need to push.
- [ ] Wait for announcement that the staging repo is ready on [cross-project-issues-dev](https://accounts.eclipse.org/mailing-list/cross-project-issues-dev). An [example announcement](https://www.eclipse.org/lists/cross-project-issues-dev/msg17420.html).
- [ ] Run a [CI build](https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/) that includes the above changes.
- [ ] Sanity check the build for the following:
    - [ ] Download a package from the build's artifacts `artifact/org.eclipse.epp.packages/archive/`
    - [ ] Made sure filenames contain expected build name and milestone, e.g. `2020-03-M2`
    - [ ] Splash screen says expected release name (with no milestone), e.g. `2020-03`
    - [ ] Help -> About says expected build name and milestone, e.g. `2020-03-M2`
    - [ ] `org.eclipse.epp.package.*` features and bundles have the timestamp of the forced qualifier update or later
- [ ] Edit the Jenkins build
    - [ ] Mark build as Keep forever
    - [ ] Edit Jenkins Build Information and name it (e.g. `2020-03 M3`)
- [ ] For a release build, the additional parameters (see parent pom) should be set in the Jenkins build job to a meaningful time/date:
```
maven.build.timestamp=20191212-1212
eclipse.simultaneous.release.build=20191212-1212
build=20191212-1212
```
- [ ] Run the [Promote a Build](https://ci.eclipse.org/packaging/job/promote-a-build/) CI job to prepare build artifacts and copy them to download.eclipse.org
    - [ ] Run the build once in `DRY_RUN` mode to ensure that the output is correct before it is copied to download.eclipse.org.
- [ ] Run the [Notarize MacOSX Downloads](https://ci.eclipse.org/packaging/job/notarize-downloads/) CI job to notarize DMG packages on download.eclipse.org
- [ ] Send email to epp-dev to request package maintainers test it.
- [ ] **On M1-RC1 release day** approximately 9:30am check:
    - [ ] copy the composite\*RC1.jar files over the composite\*.jar files in https://download.eclipse.org/technology/epp/packages/2020-03/ - this is done automatically with the https://ci.eclipse.org/packaging/view/Packages/job/epp-makeVisible/ which is automatically triggered by simrel's https://ci.eclipse.org/simrel/view/All/job/simrel.releng.makeVisible/
- [ ] **TO BE AUTOMATED**
    - [ ] **On final release day** approximately 9:30am (TBD when should these operaions happen - it needs time to be mirrored still!) :
        - [ ] flatten the published RC2 (or respun RC2) P2 repository as https://download.eclipse.org/technology/epp/packages/2020-03/
        - [ ] Include the p2.index file update
        - [ ] Ensure that there is no unexpected caching of removed composite files. E.g. `curl -O http://download.eclipse.org/technology/epp/packages/2020-09/compositeContent.jar` and `curl -I http://download.eclipse.org/technology/epp/packages/2020-09/compositeContent.jar` **must** return 404.
        - [ ] rename the provisional release milestone to final directory (E.g. [2020-03/RC2](https://download.eclipse.org/technology/epp/downloads/release/2020-03/RC2) -> [2020-03/R](https://download.eclipse.org/technology/epp/downloads/release/2020-03/R)
    - [ ] When automated this can/should be triggered by the https://ci.eclipse.org/simrel/view/All/job/simrel.releng.makeVisible/ job - in the past this worked which meant that SimRel and EPP would synchronize their releases.
    - [ ] These are the expected commands that need to be automated on M2-RC1 release days.
    ```
    CHECKPOINT=RC1
    REPO_ROOT=/home/data/httpd/download.eclipse.org/technology/epp/packages
    rsync --group --verbose ${REPO_ROOT}/compositeArtifacts${CHECKPOINT}.jar ${REPO_ROOT}/compositeArtifacts.jar
    rsync --group --verbose ${REPO_ROOT}/compositeContent${CHECKPOINT}.jar ${REPO_ROOT}/compositeContent.jar
    ```
- [ ] Tag the release, e.g. with 2020-03_R. Example command line: `git tag -s -a 2020-03_R -m"2020-03 Release" 1b7a1c1af156e3ac57768b87be258cd22b49456b`
- [ ] The _next_ release sub-directory needs to be created immediately _after_ a release, i.e. when 2019-12 was released, a directory 2020-03 had been created with an empty p2 composite repository pointing to 2019-12 until M1. (Use Job https://ci.eclipse.org/packaging/view/Packages/job/epp-createNextRelease/) On M1 release day this changes to a composite p2 repository with M1 content. On other release days, add the new releases as children.
