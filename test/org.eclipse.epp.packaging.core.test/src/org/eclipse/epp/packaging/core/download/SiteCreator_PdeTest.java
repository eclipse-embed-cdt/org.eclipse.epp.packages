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
package org.eclipse.epp.packaging.core.download;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import junit.framework.Assert;
import junit.framework.TestCase;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.download.SiteCreator;
import org.eclipse.update.configuration.IConfiguredSite;
import org.eclipse.update.core.SiteManager;

/** Test class */
public class SiteCreator_PdeTest extends TestCase {

  private static final String SITE = "./site"; //$NON-NLS-1$

  public void testFilesAreCreated() throws IOException, CoreException {
    SiteCreator.createInstallationSite( new File( SITE ) );
    Assert.assertTrue( new File( SITE ).exists() );
  }

  public void testExtensionSiteIsCreated() throws IOException, CoreException {
    IConfiguredSite site = SiteCreator.createInstallationSite( new File( SITE ) );
    Assert.assertTrue( site.isExtensionSite() );
    Assert.assertTrue( site.isEnabled() );
    Assert.assertTrue( site.isUpdatable() );
  }

  public void testClearExtensionSite() throws CoreException, IOException {
    SiteCreator.createInstallationSite( new File( SITE ) );
    SiteCreator.removeInstallationSite( SITE );
    IConfiguredSite[] configuredSites = SiteManager.getLocalSite()
      .getCurrentConfiguration()
      .getConfiguredSites();
    File file = new File( SITE );
    String fileUrl = file.toURL().toExternalForm() + "eclipse/"; //$NON-NLS-1$
    for( IConfiguredSite site : configuredSites ) {
      Assert.assertFalse( site.getSite()
        .getURL()
        .toExternalForm()
        .equals( fileUrl ) );
    }
    Assert.assertFalse( file.exists() );
  }

  @Override
  public void tearDown() throws CoreException, MalformedURLException
  {
    SiteCreator.removeInstallationSite( SITE );
  }
}
