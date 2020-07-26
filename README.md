The EPP Build
=============

The [Eclipse Packaging Project (EPP)](http://www.eclipse.org/epp/) provides 
the download packages based on the content of the yearly Simultaneous Release. 
The download packages are provided from 
[www.eclipse.org/downloads/eclipse-packages/](https://www.eclipse.org/downloads/eclipse-packages/).

Creating and releasing packages
-------------------------------

Please see [RELEASING.md](RELEASING.md) in this repo for instructions on the release process for the EPP project.

Build a Package Locally
-----------------------

It's *easy* to run the build locally! All you need is Maven and then you need 
to tell Maven which package(s) to build via profile. As an example, the following 
command from the root of the Git repository builds the RCP/RAP package against 
the Simultaneous Release staging p2 repository:

    mvn clean verify -Pepp.package.rcp

This build creates output in two places:

1. tar.gz/zip/dmg archives with the packages in `archive/` and
2. a p2 repository with the EPP artifacts in `archive/repository/`.

Windows users
------------- 

If you are running the build on Windows, the last build step will currently fail. 
This failure can be circumvented by skipping the last step which aggregates the 
filtered EPP artifacts from the packages into a new p2 repository. For further 
details see [bug 426416](https://bugs.eclipse.org/bugs/show_bug.cgi?id=426416).
At the moment it is advised to run the build command on Windows with `package` 
only:

    mvn clean package -Pepp.package.rcp

In addition to that it is not possible to create zip and tar.gz archives on 
Windows due to missing Bash scripting capabilities. On Windows, the output of the
build is the `eclipse` directory that contains the usual content from the zip
archive. This directory can be found below (e.g. RCP package) 
`packages/org.eclipse.epp.package.rcp.product/target/products/`.

Available Profiles
------------------

Each package uses its own profile:

- epp.package.committers
- epp.package.cpp
- epp.package.dsl
- epp.package.embedcdt
- epp.package.java
- epp.package.javascript
- epp.package.jee
- epp.package.modeling
- epp.package.parallel
- epp.package.php
- epp.package.rcp
- epp.package.rust
- epp.package.scout
- epp.package.testing

With the signing profiles enabled, the build artifacts (bundles, features) and the
Windows and macOS executables are signed. This is done by using the Eclipse Foundation 
internal signing service and can be activated only if the build is running there.

- eclipse-sign-jar profile enables signing of the EPP bundles and jar files
- eclipse-sign-mac profile enables usage of macOS signing service
- eclipse-sign-dmg profile enables signing of the DMG files for the macOS platform
- eclipse-sign-windows profile enables usage of Windows signing service

Additional Configuration Possibilities
--------------------------------------

By default, the EPP build uses the content of the Eclipse Simultaneous Release *Staging*
repository at <http://download.eclipse.org/staging/2020-03/> as input. Sometimes it is
desired to build against another release (e.g. a different milestone), or against a local
mirror of this repository. This can be achieved by setting the Java property
`eclipse.simultaneous.release.repository`to another URL. As an example, by adding the
following argument to the Maven command line, the EPP build will read its input from the
composite Eclipse 2020-03 repository:

    -Declipse.simultaneous.release.repository="http://download.eclipse.org/releases/2020-03"
