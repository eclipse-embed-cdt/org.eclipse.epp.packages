The EPP Build
=============

The [Eclipse Packaging Project (EPP)](http://www.eclipse.org/epp/) provides 
the download packages based on the content of the yearly Simultaneous Release. 
The download packages are provided from 
[www.eclipse.org/downloads/](http://www.eclipse.org/downloads/).

Build a Package Locally
-----------------------

It's *easy* to run the build locally! All you need is Maven and then you need 
to tell Maven which package(s) to build via profile. As an example, the following 
command from the root of the Git repository builds the RCP/RAP package against 
the Simultaneous Release staging p2 repository:

    mvn clean verify -Pepp.package.rcp

This build creates output in two places:

1. tar.gz/zip archives with the packages in `packages/org.eclipse.epp.package.rcp.product/target/products/` and
2. a p2 repository with the EPP artifacts in `repository/`.

Windows users
------------- 

If you are running the build on Windows, the last build step will currently fail. 
This failure can be circumvented by skipping the last step which aggregates the 
filtered EPP artifacts from the packages into a new p2 repository. For further 
details see [bug 426416](https://bugs.eclipse.org/bugs/show_bug.cgi?id=426416).
At the moment it is advised to run the build command on Windows with `package` 
only:

    mvn clean package -Pepp.package.rcp

Available Profiles
------------------

Each package uses its own profile:

- epp.package.automotive
- epp.package.cpp
- epp.package.dsl
- epp.package.java
- epp.package.jee
- epp.package.modeling
- epp.package.parallel
- epp.package.php
- epp.package.rcp
- epp.package.reporting
- epp.package.scout
- epp.package.standard
- epp.package.testing

With the signing profile enabled, the build artifacts (bundles, features) and the
Windows and Mac OSX executables are signed. This is done by using the Eclipse Foundation 
internal signing service and can be activated only if the build is running there.

- eclipse-sign

