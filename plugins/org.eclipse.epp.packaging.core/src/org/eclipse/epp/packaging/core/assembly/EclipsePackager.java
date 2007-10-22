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

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.epp.packaging.core.Activator;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.epp.packaging.core.io.FileUtils;
import org.eclipse.epp.packaging.core.io.Zip;
import org.eclipse.epp.packaging.core.logging.MessageLogger;
import org.eclipse.update.core.VersionedIdentifier;
import org.osgi.framework.Bundle;

/**
 * An IPackager using the main configuration as its argument.
 */
public class EclipsePackager implements IPackager {

  private static final String PACKAGER_SKELETON_DIR 
    = "skeletons/"; //$NON-NLS-1$
  private static final String PACKAGER_PROPERTIES_FILE 
    = "packager.properties"; //$NON-NLS-1$
  private static final String CONFIGURED_FEATURES_ZIP 
    = "ConfiguredFeatures.zip"; //$NON-NLS-1$
  private final PackagerRunner runner;

  /**
   * TODO mknauer missing doc
   * @param configuration
   * @throws IOException
   * @throws URISyntaxException 
   */
  public EclipsePackager( final IPackagerConfiguration configuration )
    throws IOException, URISyntaxException
  {
    this.runner = new PackagerRunner();
    setFolders( configuration );
    setFeatures( configuration );
    configurePlatforms( configuration );
    prepareWorkingArea( configuration );
  }

  /**
   * Creates the map file in the workspace and clears the existing work area.
   * 
   * @throws URISyntaxException
   */
  private void prepareWorkingArea( final IPackagerConfiguration configuration )
    throws IOException, URISyntaxException
  {
    FileUtils.deleteFile( new File( configuration.getTargetFolder(),
                                    "workingPlace" ) ); //$NON-NLS-1$
    MapFileWriter mapWriter = new MapFileWriter( configuration );
    PackagingPropertiesWriter propertiesWriter 
      = new PackagingPropertiesWriter( configuration, "packagingStub.properties" ); //$NON-NLS-1$
    CustomTargetsWriter customTargetsWriter 
      = new CustomTargetsWriter( configuration, "customTargetsStub.xml" ); //$NON-NLS-1$
    
    for( IPlatform platform : configuration.getTargetPlatforms() ) {
      mapWriter.addRootFileForPlatform( platform );
      propertiesWriter.addFileToOrder( platform.getRootFileName( configuration ) );
      customTargetsWriter.addTargetFileForPlatform( platform );
    }
    
    File sourceFolder = new File( configuration.getTargetFolder(), "src" ); //$NON-NLS-1$
    sourceFolder.mkdir();
    zipFeatures( sourceFolder, configuration );
    writeDataForCustomFile( CONFIGURED_FEATURES_ZIP,
                            mapWriter,
                            propertiesWriter );
    mapWriter.close();
    propertiesWriter.close();
    customTargetsWriter.close();

    IPath path = new Path( PACKAGER_SKELETON_DIR + PACKAGER_PROPERTIES_FILE );
    Bundle bundle = Activator.getDefault().getBundle();
    URL url = FileLocator.find( bundle, path, null );
    URL fileURL = FileLocator.toFileURL( url );
    File packagerPropertiesFile = new File( fileURL.toURI() );
    File destinationPPFile = new File( configuration.getPackagerConfigurationFolder(),
                                       PACKAGER_PROPERTIES_FILE );
    FileUtils.copy( packagerPropertiesFile, destinationPPFile );
  }

  private void writeDataForCustomFile( final String filename,
                                       final MapFileWriter mapWriter,
                                       final PackagingPropertiesWriter propertiesWriter )
  {
    mapWriter.addCustomFileForAllPlatforms( filename );
    propertiesWriter.addFileToOrder( filename );
  }

  /**
   * Zips the requested features from the extension location into a single file.
   */
  private void zipFeatures( final File parentFolder,
                            final IPackagerConfiguration configuration )
    throws IOException
  {
    MessageLogger.getInstance().logBeginProcess( "Application.Packing" ); //$NON-NLS-1$
    Zip zip = new Zip( parentFolder, CONFIGURED_FEATURES_ZIP );
    zip.addFolder( configuration.getExtensionSite() );
    zip.close();
    MessageLogger.getInstance().logEndProcess();
  }

  /** Sets the required folder info. */
  private void setFolders( final IPackagerConfiguration configuration )
    throws IOException
  {
    String packagerConfiguration 
      = configuration.getPackagerConfigurationFolder().getCanonicalPath();
    MessageLogger logger = MessageLogger.getInstance();

    logger.log( "EclipsePackager.ConfigurationFolder", packagerConfiguration ); //$NON-NLS-1$
    this.runner.setConfigurationFolder( packagerConfiguration );

    String targetFolder = configuration.getTargetFolder().getCanonicalPath();
    logger.log( "EclipsePackager.TargetFolder", targetFolder ); //$NON-NLS-1$
    this.runner.setBaseDirectory( targetFolder );
  }

  /** Sets the features to be included. */
  private void setFeatures( final IPackagerConfiguration configuration ) {
    for( VersionedIdentifier identifier : configuration.getRequiredFeatures() )
    {
      this.runner.addFeature( identifier.getIdentifier() );
    }
  }

  /** Configures the runner with platform information from configuration. */
  private void configurePlatforms( final IPackagerConfiguration configuration )
  {
    for( IPlatform platform : configuration.getTargetPlatforms() ) {
      String platformString = platform.toString();
      this.runner.addPlatform( platformString );
      String archiveFormatName = platform.getArchiveFormat().name();
      this.runner.setArchiveFormat( platformString, archiveFormatName );
    }
  }

  public void packApplication() throws CoreException, IOException {
    MessageLogger.getInstance().logBeginProcess( "EclipsePackager.Running" ); //$NON-NLS-1$
    this.runner.packApplication();
    MessageLogger.getInstance().logEndProcess();
  }
}