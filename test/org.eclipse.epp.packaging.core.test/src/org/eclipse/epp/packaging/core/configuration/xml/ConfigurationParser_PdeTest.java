/*******************************************************************************
 * Copyright (c) 2007 Innoopract Informationssysteme GmbH
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Innoopract - initial API and implementation
 *******************************************************************************/
package org.eclipse.epp.packaging.core.configuration.xml;

import java.io.File;
import junit.framework.Assert;
import junit.framework.TestCase;

import org.eclipse.epp.packaging.core.configuration.ArchiveFormat;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.epp.packaging.core.configuration.Platform;
import org.eclipse.epp.packaging.core.configuration.xml.ConfigurationParser;
import org.eclipse.update.core.VersionedIdentifier;

/** Test class */
public class ConfigurationParser_PdeTest extends TestCase {

  private final static String xml = "<configuration>" //$NON-NLS-1$
                                    + "<rcp version=\"3.2\"/>" //$NON-NLS-1$
                                    + "<product name=\"EPPBuild\"" //$NON-NLS-1$
                                    + "         eclipseProductId=\"org.eclipse.platform.ide\"" //$NON-NLS-1$
                                    + "         initialPerspectiveId=\"org.eclipse.cdt.ui.CPerspective\" />" //$NON-NLS-1$
                                    + "<updateSites>" //$NON-NLS-1$
                                    + "  <updateSite url=\"http://update.eclipse.org/updates/3.2/\"/>" //$NON-NLS-1$
                                    + "</updateSites>" //$NON-NLS-1$
                                    + "<requiredFeatures>" //$NON-NLS-1$
                                    + "  <feature id=\"org.eclipse.rcp\" version=\"3.1.1\"/>" //$NON-NLS-1$
                                    + "</requiredFeatures>" //$NON-NLS-1$                                    
                                    + "<rootFileFolder folder=\"/home/root\"/>" //$NON-NLS-1$
                                    + "<extensionSite relativeFolder=\"site\"/>" //$NON-NLS-1$
                                    + "<targetPlatforms>" //$NON-NLS-1$
                                    + "  <platform os=\"linux\" ws=\"gtk\" arch=\"x86\">" //$NON-NLS-1$
                                    + "    <eclipseIniFileContent path=\"/eclipse/\">Content" //$NON-NLS-1$
                                    + "of first eclipse.ini</eclipseIniFileContent>" //$NON-NLS-1$
                                    + "  </platform>" //$NON-NLS-1$
                                    + "  <platform os=\"win32\" ws=\"win32\" arch=\"x86\">" //$NON-NLS-1$
                                    + "    <archiveFormat format=\"tar\"/>" //$NON-NLS-1$
                                    + "    <eclipseIniFileContent path=\"/eclipse/\">Content" //$NON-NLS-1$
                                    + "of second eclipse.ini</eclipseIniFileContent>" //$NON-NLS-1$
                                    + "  </platform>" //$NON-NLS-1$
                                    + "</targetPlatforms>" //$NON-NLS-1$
                                    + "</configuration>"; //$NON-NLS-1$

  public void testParseUpdateSites() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    Assert.assertEquals( "http://update.eclipse.org/updates/3.2/", //$NON-NLS-1$
                         config.getUpdateSites()[ 0 ].toExternalForm() );
  }

  public void testParseFeatures() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    Assert.assertEquals( new VersionedIdentifier( "org.eclipse.rcp", "3.1.1" ), //$NON-NLS-1$ //$NON-NLS-2$
                         config.getRequiredFeatures()[ 0 ] );
  }

  public void testParseRelativeExtensionSite() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    Assert.assertEquals( new File( org.eclipse.core.runtime.Platform.getLocation()
                                     .toFile(),
                                   "site" ), //$NON-NLS-1$
                         config.getExtensionSite() );
  }

  public void testParseTargetPlatformWithoutFormat() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    IPlatform platform = config.getTargetPlatforms()[ 0 ];
    Assert.assertEquals( new Platform( "linux", "gtk", "x86", null, null ), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                         platform );
    Assert.assertEquals( ArchiveFormat.antZip, platform.getArchiveFormat() );
  }

  public void testParsePlatformWithFormat() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    IPlatform platform = config.getTargetPlatforms()[ 1 ];
    Assert.assertEquals( new Platform( "win32", "win32", "x86", null, null ), platform ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Assert.assertEquals( ArchiveFormat.tar, platform.getArchiveFormat() );
  }

  public void testParseRcpVersion() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    String basename = config.getRootFileBaseName();
    Assert.assertEquals( "eclipse-platform-3.2-", basename ); //$NON-NLS-1$
  }

  public void testParseRootFiles() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    File folder = config.getRootFileFolder();
    Assert.assertEquals( new File( "/home/root" ), folder ); //$NON-NLS-1$
  }

  public void testParseProductName() throws Exception {
    IPackagerConfiguration config = new ConfigurationParser( null ).parseConfiguration( xml );
    Assert.assertEquals( "EPPBuild", config.getProductName() ); //$NON-NLS-1$    
  }
}