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
package org.eclipse.epp.packaging.core.assembly;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.ant.core.AntRunner;
import org.eclipse.core.runtime.CoreException;

/**
 * An IPackager based on the PDE Build packager. Locates, configures and
 * executes the package.xml ant script
 */
public class PackagerRunner implements IPackager {

  private static final String ARGUMENT_ARCHIVE_FORMATS = "archivesFormat"; //$NON-NLS-1$
  private static final String ARGUMENT_BASE_DIRECTORY = "baseDirectory";//$NON-NLS-1$
  private static final String ARGUMENT_CONFIGURATION_FOLDER = "packagingInfo";//$NON-NLS-1$
  private static final String ARGUMENT_FEATURE_LIST = "featureList";//$NON-NLS-1$
  private static final String ARGUMENT_PLATFORM_LIST = "config";//$NON-NLS-1$
  private static final String PDE_BUILD_PLUGIN_ID = "org.eclipse.pde.build";//$NON-NLS-1$
  private final List<String> features = new ArrayList<String>();
  private final List<String> platforms = new ArrayList<String>();
  private final List<String> formats = new ArrayList<String>();

  public void packApplication() throws CoreException, IOException {
    AntRunner runner = new AntRunner();
    String scriptLocation = PluginUtils.getPluginPath( PDE_BUILD_PLUGIN_ID )
                            + "/scripts/package.xml";//$NON-NLS-1$
    runner.setBuildFileLocation( scriptLocation );
    addFeatureListToArguments();
    addPlatformListToArguments();
    addFormatListToArguments();
    runner.run();
  }

  /**
   * Prior to running the packager, convert the list of archive formats to an
   * argument string and add it to the list of arguments.
   */
  private void addFormatListToArguments() {
    addListToArguments( this.formats, '&', ARGUMENT_ARCHIVE_FORMATS );
  }

  /**
   * Prior to running the packager, convert the list of platforms to an argument
   * string and add it to the list of arguments.
   */
  private void addPlatformListToArguments() {
    addListToArguments( this.platforms, '&', ARGUMENT_PLATFORM_LIST );
  }

  /**
   * Prior to running the packager, convert the list of features to an argument
   * string and add it to the list of arguments.
   */
  private void addFeatureListToArguments() {
    addListToArguments( this.features, ',', ARGUMENT_FEATURE_LIST );
  }

  /**
   * Converts the source list to a string with the entries separated by
   * separator, then sets the result as a value for the argument.
   */
  private void addListToArguments( final List<String> sourceList,
                                   final char separator,
                                   final String argumentName )
  {
    StringBuilder builder = new StringBuilder();
    for( String feature : sourceList ) {
      builder.append( feature );
      builder.append( separator );
    }
    setArgument( argumentName, builder.toString() );
  }

  /**
   * Sets the configuration folder for the PDE packager. The folder must contain
   * packager.properties, packaging.properties and customTargets.xml.
   * 
   * @param folder directory name
   */
  public void setConfigurationFolder( final String folder ) {
    setArgument( ARGUMENT_CONFIGURATION_FOLDER, folder );
  }

  /** Sets the working directory for the PDE packager. 
   * @param folder directory name of the base directory
   */
  public void setBaseDirectory( final String folder ) {
    setArgument( ARGUMENT_BASE_DIRECTORY, folder );
  }

  /**
   * Adds a feature to the configured application.
   * 
   * @param identifier The feature id.
   */
  public void addFeature( final String identifier ) {
    this.features.add( identifier );
  }

  /** Sets an argument for the AntRunner to use. */
  private void setArgument( final String key, final String value ) {
    System.setProperty( key, value );
  }

  /**
   * Adds a new target platform to the configuration.
   * 
   * @param platform A comma-separated platform description (os,ws,arch).
   */
  public void addPlatform( final String platform ) {
    this.platforms.add( platform );
  }

  /**
   * Sets a platform's archive format.
   * 
   * @param platform A comma-separated platform description - os,ws,arch.
   * @param format An archive format. Supported values are antZip, antTar, tar.
   */
  public void setArchiveFormat( final String platform, final String format ) {
    this.formats.add( platform + '-' + format );
  }
}