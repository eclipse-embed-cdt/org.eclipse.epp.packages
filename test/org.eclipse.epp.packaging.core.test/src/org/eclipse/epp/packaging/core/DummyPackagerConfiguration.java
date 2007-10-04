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
package org.eclipse.epp.packaging.core;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.update.core.VersionedIdentifier;

/** Test class */
public class DummyPackagerConfiguration implements IPackagerConfiguration {

  private URL siteUrl;
  private IPlatform[] platforms;
  private File baseDir;
  private List<VersionedIdentifier> identifiers = new ArrayList<VersionedIdentifier>();

  public File getExtensionSite() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

  public File getTargetFolder() {
    return baseDir;
  }

  public File getPackagerConfigurationFolder() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

  public void addRequiredFeature( final VersionedIdentifier identifier ) {
    identifiers.add( identifier );
  }

  public VersionedIdentifier[] getRequiredFeatures() {
    return identifiers.toArray( new VersionedIdentifier[ identifiers.size() ] );
  }

  public IPlatform[] getTargetPlatforms() {
    return platforms;
  }

  public String getRootFileBaseName() {
    return "Rootfile"; //$NON-NLS-1$
  }

  public URL[] getUpdateSites() {
    return new URL[]{
      siteUrl
    };
  }

  public void setUpdateSite( final String site ) throws MalformedURLException {
    this.siteUrl = new URL( site );
  }

  public void setTargetPlatforms( final IPlatform[] platformArray ) {
    this.platforms = platformArray;
  }

  public void setBaseFolder( final String baseFolder ) {
    this.baseDir = new File( baseFolder );
  }

  public File getRootFileFolder() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

  public String getProductName() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

  public String getEclipseProductId() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

  public String getInitialPerspectiveId() {
    throw new UnsupportedOperationException( "Not yet implemented." ); //$NON-NLS-1$
  }

}