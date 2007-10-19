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
import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.io.FileUtils;
import org.eclipse.update.configuration.IConfiguredSite;
import org.eclipse.update.configuration.IInstallConfiguration;
import org.eclipse.update.configuration.ILocalSite;
import org.eclipse.update.core.SiteManager;

/**
 * Responsible for creating and deleting extension sites.
 */
public class SiteCreator {

  /**
   * Adds a new extension site to the system and configures it to be able to
   * update.
   */
  public static IConfiguredSite createInstallationSite( final File folder )
    throws IOException, CoreException
  {
    if( !folder.exists() ) {
      folder.mkdir();
    }
    IInstallConfiguration config = SiteManager.getLocalSite()
      .getCurrentConfiguration();
    IConfiguredSite site = config.createConfiguredSite( folder );
    site.verifyUpdatableStatus();
    config.addConfiguredSite( site );
    return site;
  }

  /**
   * Removes an extension site from the system, deleting its content.
   */
  public static void removeInstallationSite( final String siteString )
    throws CoreException, MalformedURLException
  {
    ILocalSite localSite = SiteManager.getLocalSite();
    IInstallConfiguration configuration = localSite.getCurrentConfiguration();
    IConfiguredSite[] sites = configuration.getConfiguredSites();
    File file = new File( siteString );
    String fileUrl = file.toURL().toExternalForm() + "eclipse/";//$NON-NLS-1$
    for( IConfiguredSite site : sites ) {
      if( site.getSite().getURL().toExternalForm().equals( fileUrl ) ) {
        configuration.removeConfiguredSite( site );
        FileUtils.deleteFile( file );
      }
    }
  }
}