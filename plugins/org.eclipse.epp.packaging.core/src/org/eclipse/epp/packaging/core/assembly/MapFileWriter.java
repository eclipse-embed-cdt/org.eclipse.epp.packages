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
import java.io.PrintWriter;

import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;

/**
 * Creates a packager map file in the workspace.
 */
public class MapFileWriter {

  private final static String MAP_FILE_LINE_END = " | | sdk | eclipse\n"; //$NON-NLS-1$
  private final IPackagerConfiguration configuration;
  private final PrintWriter writer;

  /**
   * TODO mknauer missing doc
   * @param configuration
   * @throws IOException
   */
  public MapFileWriter( final IPackagerConfiguration configuration )
    throws IOException
  {
    this.configuration = configuration;
    File parent = new File( configuration.getTargetFolder(), "toPackage" ); //$NON-NLS-1$
    parent.mkdir();
    this.writer = new PrintWriter( new File( parent, "PackagerMap.map" ) ); //$NON-NLS-1$
  }

  /**
   * TODO mknauer missing doc
   * @param platform
   */
  public void addRootFileForPlatform( final IPlatform platform ) {
    String rootFileFolder = this.configuration.getRootFileFolder().toURI().toString();
    String rootFileName = platform.getRootFileName( this.configuration );
    this.writer.append( rootFileName + "=" //$NON-NLS-1$
                        + rootFileFolder
                        + " | " //$NON-NLS-1$
                        + platform.toString()
                        + MAP_FILE_LINE_END );
  }

  /**
   * Adds the given file name to the map. The file is expected to reside in the
   * 'src' folder in the workspace. It is designated as valid for all configured
   * platforms.
   * 
   * TODO mknauer missing doc
   * 
   * @param filename 
   */
  public void addCustomFileForAllPlatforms( final String filename ) {
    File targetFolder = this.configuration.getTargetFolder();
    String sourceFolder = new File( targetFolder, "src" ).toURI().toString(); //$NON-NLS-1$
    this.writer.append( filename 
                        + "=" //$NON-NLS-1$
                        + sourceFolder
                        + " | "  //$NON-NLS-1$
                        + getAllPlatformsString() 
                        + MAP_FILE_LINE_END );
  }
  
  /**
   * TODO mknauer missing doc
   */
  public void close() {
    this.writer.close();
  }

  private String getAllPlatformsString() {
    StringBuilder builder = new StringBuilder();
    IPlatform[] platforms = this.configuration.getTargetPlatforms();
    for( int index = 0; index < platforms.length; index++ ) {
      builder.append( platforms[ index ].toString() );
      if( index < platforms.length - 1 ) {
        builder.append( '&' );
      }
    }
    return builder.toString();
  }
}