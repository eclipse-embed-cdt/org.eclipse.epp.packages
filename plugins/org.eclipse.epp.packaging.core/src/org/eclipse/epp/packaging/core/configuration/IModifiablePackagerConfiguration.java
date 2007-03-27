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

import java.net.MalformedURLException;

/**
 * A packager configuration that allows to modify its settings.
 */
public interface IModifiablePackagerConfiguration
  extends IPackagerConfiguration
{

  /**Adds an update site to the configuration.
   * 
   * @param string A string containing the URL of the site.
   * @throws MalformedURLException if the URL is invalid.
   */
  public void addUpdateSite( final String string ) throws MalformedURLException;

  /**Adds the feature [id] with the given version to the list of required features.*/
  public void addRequiredFeature( final String id, final String version );

  /**Sets the designated folder containing the PDE packager config files.*/
  public void setPackagerConfigurationFolder( final String folder );

  /**Sets the extension site's name in the target folder.*/
  public void setExtensionSiteRelative( final String relativeFolder );

  /**Adds a new target platform.*/
  public Platform addTargetPlatform( final String os,
                                     final String ws,
                                     final String arch );

  /**Sets the RCP version to use.*/
  public void setRcpVersion( final String version );

  /**Sets the folder containing the RCP root files.*/
  public void setRootFileFolder( final String folderName );

  /**Sets the config.ini file to use.*/
  public void setConfigIni( final String fileName );

  /**Sets the product name to use for the final result.*/
  public void setProductName( final String name );

  /**Sets the folder containing the configuration files for the installer.*/
  public void setInstallerConfigurationFolder( final String folder );
}