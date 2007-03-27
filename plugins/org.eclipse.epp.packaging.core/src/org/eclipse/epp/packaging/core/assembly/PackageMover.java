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
import java.io.FileFilter;
import java.io.IOException;

import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.epp.packaging.core.io.FileUtils;
import org.eclipse.epp.packaging.core.logging.MessageLogger;

/**
 * Moves the created packages from the packager's work directory to the main
 * folder specified in the configuration.
 */
public class PackageMover {

  private final IPackagerConfiguration configuration;

  /**
   * TODO mknauer missing doc
   * @param configuration
   */
  public PackageMover( final IPackagerConfiguration configuration ) {
    this.configuration = configuration;
  }

  /**
   * TODO mknauer missing doc
   * Moves the created packages to their final location.
   * @throws IOException 
   */
  public void moveFiles() throws IOException {
    MessageLogger.getInstance().logBeginProcess( "PackageMover.MovingFiles" ); //$NON-NLS-1$
    File packageLocation = new File( this.configuration.getTargetFolder(),
                                     "workingPlace/I.EclipsePackagerBuild" ); //$NON-NLS-1$
    for( IPlatform platform : this.configuration.getTargetPlatforms() ) {
      File applicationFile = findPlatformFile( packageLocation, platform );
      FileUtils.copy( applicationFile,
                      new File( this.configuration.getTargetFolder(),
                                applicationFile.getName() ) );
    }
    MessageLogger.getInstance().logEndProcess();
  }

  /** Returns the created package for the given platform. */
  private File findPlatformFile( final File packageLocation,
                                 final IPlatform platform )
  {
    final String name = platform.getTargetFileName( this.configuration )
                        + platform.getArchiveFormat().getExtension();
    File[] files = packageLocation.listFiles( new FileFilter() {

      public boolean accept( final File file ) {
        return file.getName().equals( name );
      }
    } );
    if( files.length != 1 ) {
      throw new IllegalStateException( files.length
                                       + " packages found for "  //$NON-NLS-1$
                                       + platform 
                                       + ". There should be one, and only one." //$NON-NLS-1$
      );
    }
    return files[ 0 ];
  }
}