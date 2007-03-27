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
package org.eclipse.epp.packaging.core.io;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Capsules creation of archives in ZIP format. Begin with constructor, add
 * content, finally end creation with close().
 */
public class Zip {

  private final ZipOutputStream zipOutputStream;

  /**
   * Opens a new zip archive in the location denoted by file and readies it for
   * writing.
   * 
   * @param file the zip archive file that is used for writing
   * @throws FileNotFoundException
   */
  public Zip( final File file ) throws FileNotFoundException {
    this.zipOutputStream = new ZipOutputStream( new FileOutputStream( file ) );
  }

  public Zip( final File sourceFolder, final String fileName )
    throws FileNotFoundException
  {
    this( new File( sourceFolder, fileName ) );
  }

  /**
   * Adds a file to the zip archive.
   * 
   * @param relativePath The relative path to the file to add.
   */
  public void addFile( final String relativePath ) throws IOException {
    File file = new File( relativePath );
    addFileAs( file, relativePath );
  }

  /**
   * Adds the contents of a folder to the zip archive.
   * 
   * @param folder The folder to add. If the file is not a folder, nothing
   *            happens.
   */
  public void addFolder( final File folder ) throws IOException {
    if( folder.isDirectory() ) {
      addDirectoryContents( folder, folder );
    }
  }

  /**
   * Adds a file or folder to the archive. *
   * 
   * @param file The file or folder to add.
   * @param rootContainer The parent directory. All files' paths are made
   *            relative to this folder.
   */
  private void addFile( final File file, final File rootContainer )
    throws IOException
  {
    if( file.isDirectory() ) {
      addDirectoryContents( file, rootContainer );
    } else {
      String path = file.getCanonicalPath();
      String entryName 
        = path.replace( rootContainer.getCanonicalPath(), "." );//$NON-NLS-1$
      addFileAs( file, entryName );
    }
  }

  /**
   * Adds the given file to the archive.
   * 
   * @param file The file to add.
   * @param entryName The path under which to store the file.
   */
  public void addFileAs( final File file, final String entryName )
    throws IOException, FileNotFoundException
  {
    String name = entryName;
    if( entryName.startsWith( "./" ) ) {//$NON-NLS-1$
      name = name.replaceFirst( "./", "" );//$NON-NLS-1$//$NON-NLS-2$
    }
    if( entryName.startsWith( ".\\" ) ) {//$NON-NLS-1$
      name = name.replaceFirst( ".\\\\", "" );//$NON-NLS-1$//$NON-NLS-2$
    }
    this.zipOutputStream.putNextEntry( new ZipEntry( name ) );
    writeFileToZip( new FileInputStream( file ) );
    this.zipOutputStream.closeEntry();
  }

  /**
   * Closes the zip file. No further additions are possible.
   * 
   * @throws IOException if the file couldn't be closed
   */
  public void close() throws IOException {
    this.zipOutputStream.close();
  }

  /**
   * Adds all subfiles of the given directory to the archive. Paths are made
   * relative to rootContainer.
   * 
   * @param file The directory to add.
   * @param rootContainer The parent directory. All files' paths are made
   *            relative to this folder.
   */
  private void addDirectoryContents( final File file, final File rootContainer )
    throws IOException
  {
    for( File subFile : file.listFiles() ) {
      addFile( subFile, rootContainer );
    }
  }

  /**
   * Writes the given InputStream to the ZipOutputStream
   */
  private void writeFileToZip( final InputStream inStream ) throws IOException {
    byte[] buffer = new byte[ 512 ];
    int lengthRead = 0;
    while( ( lengthRead = inStream.read( buffer ) ) != -1 ) {
      this.zipOutputStream.write( buffer, 0, lengthRead );
    }
    inStream.close();
  }
}