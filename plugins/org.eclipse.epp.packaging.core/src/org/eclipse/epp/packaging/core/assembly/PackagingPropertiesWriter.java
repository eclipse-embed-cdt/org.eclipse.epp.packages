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
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.net.URL;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.epp.packaging.core.Activator;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.io.FileUtils;
import org.osgi.framework.Bundle;

/**
 * Completes the packaging.properties file by adding the unzipOrder property.
 */
public class PackagingPropertiesWriter {

  private static final String SKELETONS_PACKAGING_PROPERTIES = "skeletons/packagingStub.properties"; //$NON-NLS-1$
  private static final String UNZIP_ORDER_PROPERTY = "unzipOrder"; //$NON-NLS-1$
  private static final String PACKAGING_PROPERTIES_FILENAME = "packaging.properties"; //$NON-NLS-1$
  private final PrintWriter writer;
  private boolean firstName = true;

  /**
   * @param configuration
   * @param baseFile
   * @throws IOException
   * @throws URISyntaxException 
   */
  public PackagingPropertiesWriter( final IPackagerConfiguration configuration,
                                    final String baseFile )
    throws IOException, URISyntaxException
  {
    IPath path = new Path( SKELETONS_PACKAGING_PROPERTIES );
    Bundle bundle = Activator.getDefault().getBundle();
    URL url = FileLocator.find( bundle, path, null );
    URL fileURL = FileLocator.toFileURL( url );
    File stubFile = new File( fileURL.toURI() );

    File packagingFile = new File( configuration.getPackagerConfigurationFolder(),
                                   PACKAGING_PROPERTIES_FILENAME );
    FileUtils.copy( stubFile, packagingFile );
    FileOutputStream stream = new FileOutputStream( packagingFile, true );
    this.writer = new PrintWriter( stream );
    this.writer.append( UNZIP_ORDER_PROPERTY + '=' );
  }

  /**
   * @param fileName
   */
  public void addFileToOrder( final String fileName ) {
    if( !this.firstName ) {
      this.writer.append( ',' );
    } else {
      this.firstName = false;
    }
    this.writer.append( fileName );
  }

  /**
   */
  public void close() {
    this.writer.close();
  }
}