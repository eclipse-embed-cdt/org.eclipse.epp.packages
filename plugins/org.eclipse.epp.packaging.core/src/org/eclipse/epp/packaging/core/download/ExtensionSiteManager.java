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

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.epp.packaging.core.logging.MessageLogger;
import org.eclipse.update.configuration.IConfiguredSite;
import org.eclipse.update.core.IFeature;

/**
 * Responsible for creating the extension site and installing the features
 * provided by an UpdateSiteManager
 */
public class ExtensionSiteManager {

  private final IPackagerConfiguration configuration;

  public ExtensionSiteManager( final IPackagerConfiguration configuration ) {
    this.configuration = configuration;
  }

  public void installFeatures( final IUpdateSiteManager manager )
    throws IOException, CoreException
  {
    File localSiteFolder = this.configuration.getExtensionSite();
    MessageLogger.getInstance().log( "ExtensionSiteManager.SiteCreated",  //$NON-NLS-1$
                                     localSiteFolder );
    IConfiguredSite site = SiteCreator.createInstallationSite( localSiteFolder );
    for( IPlatform platform : this.configuration.getTargetPlatforms() ) {
      MessageLogger.getInstance().logBeginProcess( "ExtensionSiteManager.InstallPlatform", //$NON-NLS-1$
                                                   platform );
      platform.configureSite();
      for( IFeature feature : manager.getFeatures() ) {
        String identifier = feature.getVersionedIdentifier().getIdentifier();
        MessageLogger.getInstance().logBeginProcess( "ExtensionSiteManager.Installing",  //$NON-NLS-1$
                                                     identifier );
        site.install( feature, null, new NullProgressMonitor() );
        MessageLogger.getInstance().logEndProcess();
      }
      MessageLogger.getInstance().logEndProcess();
    }
  }
}