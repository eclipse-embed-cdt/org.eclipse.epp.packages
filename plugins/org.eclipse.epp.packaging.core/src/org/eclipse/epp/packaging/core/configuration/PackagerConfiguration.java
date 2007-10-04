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
package org.eclipse.epp.packaging.core.configuration;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.update.core.VersionedIdentifier;

/**
 * A configurable IPackagerConfiguration. All data is handed in as String, then
 * converted to the proper objects.
 */
public class PackagerConfiguration implements IModifiablePackagerConfiguration {

  private static final String ECLIPSE_PLATTFORM = "eclipse-platform-"; //$NON-NLS-1$
  
  private final List<URL> updateSites = new ArrayList<URL>();
  private final List<VersionedIdentifier> requiredFeatures = new ArrayList<VersionedIdentifier>();
  private final List<Platform> targetPlatforms = new ArrayList<Platform>();
  private File packagerConfigurationFolder;
  private File baseFolder;
  private File extensionSite;
  private String rcpVersion;
  private File rootFolder;
  private String productName;
  private String eclipseProductId;
  private String initialPerspectiveId;

  public PackagerConfiguration() {
    this.baseFolder = org.eclipse.core.runtime.Platform.getLocation().toFile();
  }

  public URL[] getUpdateSites() {
    return this.updateSites.toArray( new URL[ this.updateSites.size() ] );
  }

  public void addUpdateSite( final String string ) throws MalformedURLException
  {
    this.updateSites.add( new URL( string ) );
  }

  public VersionedIdentifier[] getRequiredFeatures() {
    return this.requiredFeatures.toArray( new VersionedIdentifier[ requiredFeatures.size() ] );
  }

  public void addRequiredFeature( final String id, final String version ) {
    this.requiredFeatures.add( new VersionedIdentifier( id, version ) );
  }

  public File getPackagerConfigurationFolder() {
    return this.packagerConfigurationFolder;
  }

  public void setPackagerConfigurationFolder( final String folder ) {
    this.packagerConfigurationFolder = new File( folder );
  }

  public File getTargetFolder() {
    return this.baseFolder;
  }

  public void setExtensionSiteRelative( final String relativeFolder ) {
    this.extensionSite = new File( this.baseFolder, relativeFolder );
  }

  public File getExtensionSite() {
    return this.extensionSite;
  }

  public Platform addTargetPlatform( final String os,
                                     final String ws,
                                     final String arch,
                                     final String eclipseIniFileContent, 
                                     final String eclipseIniFilePath )
  {
    Platform platform = new Platform( os, ws, arch, eclipseIniFileContent, eclipseIniFilePath );
    this.targetPlatforms.add( platform );
    return platform;
  }

  public IPlatform[] getTargetPlatforms() {
    return this.targetPlatforms.toArray( new IPlatform[ targetPlatforms.size() ] );
  }

  public String getRootFileBaseName() {
    return ECLIPSE_PLATTFORM + this.rcpVersion + '-';
  }

  public File getRootFileFolder() {
    return this.rootFolder;
  }

  public void setRcpVersion( final String version ) {
    this.rcpVersion = version;
  }

  public void setRootFileFolder( final String folderName ) {
    this.rootFolder = new File( folderName );
  }

  public void setProductName( final String name ) {
    this.productName = name;
  }

  public String getProductName() {
    return this.productName;
  }

  public void setEclipseProductId( final String eclipseProductId ) {
    this.eclipseProductId = eclipseProductId;
  }

  public String getEclipseProductId() {
    return this.eclipseProductId;
  }

  public void setInitialPerspectiveId( final String initialPerspectiveId ) {
    this.initialPerspectiveId = initialPerspectiveId;
  }
  
  public String getInitialPerspectiveId() {
    return this.initialPerspectiveId;
  }
}